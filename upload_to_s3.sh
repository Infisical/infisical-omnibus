cd pkg

for i in *.deb; do
    [ -f "$i" ] || break
    deb-s3 upload --bucket=$INFISICAL_BINARY_S3_BUCKET --prefix=deb --visibility=private --sign=$GPG_SIGNING_KEY_ID --preserve-versions  $i
done

for i in *.rpm; do
    [ -f "$i" ] || break

    # strip out .amazon2023 suffix if present
    new_name=$(echo "$i" | sed 's/.amazon2023//g')
    if [ "$i" != "$new_name" ]; then
        mv "$i" "$new_name"
    fi

    # sign the rpm package
    rpmsign --addsign --key-id="$GPG_SIGNING_KEY_ID" "$new_name"

    # upload signed package to S3
    aws s3 cp "$new_name" "s3://$INFISICAL_BINARY_S3_BUCKET/rpm/Packages/"
done

# regenerate RPM repository metadata with repogen
if ls *.rpm 1> /dev/null 2>&1; then
    REPO_VERSION="40"
    REPO_ARCH="x86_64"

    # map S3 flat repodata into the versioned structure repogen expects
    mkdir -p "repo/${REPO_VERSION}/${REPO_ARCH}/repodata"
    aws s3 sync "s3://$INFISICAL_BINARY_S3_BUCKET/rpm/repodata" "repo/${REPO_VERSION}/${REPO_ARCH}/repodata" --delete

    # export GPG private key for repogen
    GPG_KEY_FILE=$(mktemp)
    gpg --batch --pinentry-mode loopback --export-secret-keys --armor "$GPG_SIGNING_KEY_ID" > "$GPG_KEY_FILE"

    # generate repo metadata incrementally
    repogen generate \
        --input-dir . \
        --output-dir repo \
        --incremental \
        --gpg-key "$GPG_KEY_FILE" \
        --gpg-passphrase "$GPG_SIGNING_KEY_PASSPHRASE"

    rm -f "$GPG_KEY_FILE"

    # sync the generated repodata back to the flat S3 structure
    aws s3 sync "repo/${REPO_VERSION}/${REPO_ARCH}/repodata" "s3://$INFISICAL_BINARY_S3_BUCKET/rpm/repodata"
fi
