cd pkg

for i in *.deb; do
    [ -f "$i" ] || break
    deb-s3 upload --bucket=$INFISICAL_BINARY_S3_BUCKET --prefix=deb --visibility=private --sign=$GPG_SIGNING_KEY_ID --preserve-versions  $i
done

for i in *.rpm; do
    [ -f "$i" ] || break
    
    new_name=$(echo "$i" | sed 's/.amazon2023//g')
    if [ "$i" != "$new_name" ]; then
        mv "$i" "$new_name"
    fi
    
    aws s3 cp "$new_name" "s3://$INFISICAL_BINARY_S3_BUCKET/rpm/Packages/"
done

# regenerate RPM repository metadata with mkrepo
if ls *.rpm 1> /dev/null 2>&1; then
    export GPG_SIGN_KEY=$GPG_SIGNING_KEY_ID
    mkrepo s3://$INFISICAL_BINARY_S3_BUCKET/rpm --s3-access-key-id="$AWS_ACCESS_KEY_ID" --s3-secret-access-key="$AWS_SECRET_ACCESS_KEY" --s3-region="us-east-1" --sign
fi