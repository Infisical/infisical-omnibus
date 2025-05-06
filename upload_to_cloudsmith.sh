cd pkg


for i in *.deb; do
    [ -f "$i" ] || break
    cloudsmith push deb --republish infisical/infisical-core/any-distro/any-version $i
done

for i in *.rpm; do
    [ -f "$i" ] || break
    # stripe of amazon2023
    new_name=$(echo "$i" | sed 's/.amazon2023//g')
    # rename
    if [ "$i" != "$new_name" ]; then
        mv "$i" "$new_name"
    fi

    cloudsmith push rpm --republish infisical/infisical-core/any-distro/any-version "$new_name"
done
