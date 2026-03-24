cd pkg

# for i in *.deb; do
#     [ -f "$i" ] || break
#     deb-s3 upload --bucket=$INFISICAL_BINARY_S3_BUCKET --prefix=deb --visibility=private --sign=$GPG_SIGNING_KEY_ID --preserve-versions  $i
# done

for i in *.rpm; do
    [ -f "$i" ] || break
    
    # strip out .amazon2023 suffix if present
    new_name=$(echo "$i" | sed 's/.amazon2023//g')
    if [ "$i" != "$new_name" ]; then
        mv "$i" "$new_name"
    fi
    
    #sign the rpm package
    rpmsign --addsign --key-id="$GPG_SIGNING_KEY_ID" "$new_name"

    aws s3 cp "$new_name" "s3://$INFISICAL_BINARY_S3_BUCKET/dummy/rpm/Packages/"
done


# regenerate RPM repository metadata with rpmrepo-update
if ls *.rpm 1> /dev/null 2>&1; then
    rpmrepo-update --backend s3 --repo-root s3://$INFISICAL_BINARY_S3_BUCKET/dummy/rpm --s3-region us-east-1 --sign-repodata --gpg-key "$GPG_SIGNING_KEY_ID" add *.rpm --dest-prefix /Packages --replace-existing
fi

