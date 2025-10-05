cd pkg


# for i in *.deb; do
#     [ -f "$i" ] || break
#     cloudsmith push deb --republish infisical/infisical-core/any-distro/any-version $i
# done

for i in *.deb; do
    [ -f "$i" ] || break
    deb-s3 upload --bucket=$INFISICAL_BINARY_S3_BUCKET --prefix=deb --visibility=private --sign=$GPG_SIGNING_KEY_ID --preserve-versions  $i
done


# todo(daniel): uncomment and move to AWS
# for i in *.rpm; do
#     [ -f "$i" ] || break
#     # stripe of amazon2023
#     new_name=$(echo "$i" | sed 's/.amazon2023//g')
#     # rename
#     if [ "$i" != "$new_name" ]; then
#         mv "$i" "$new_name"
#     fi

#     cloudsmith push rpm --republish infisical/infisical-core/any-distro/any-version "$new_name"
# done
