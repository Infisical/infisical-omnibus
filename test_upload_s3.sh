cd pkg

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
    aws s3 cp "$new_name" "s3://$INFISICAL_BINARY_S3_BUCKET/dummy/rpm/Packages/"
done

# regenerate RPM repository metadata with repogen
if ls *.rpm 1> /dev/null 2>&1; then
    # sync existing repodata from S3 to local
    mkdir -p repo/repodata
    aws s3 sync "s3://$INFISICAL_BINARY_S3_BUCKET/dummy/rpm/repodata" repo/repodata --delete

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

    # sync metadata back to S3
    aws s3 sync repo/repodata "s3://$INFISICAL_BINARY_S3_BUCKET/dummy/rpm/repodata"
fi

