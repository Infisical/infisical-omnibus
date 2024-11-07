cd pkg


for i in *.deb; do
    [ -f "$i" ] || break
    cloudsmith push deb --republish infisical/infisical-core/any-distro/any-version $i
done

for i in *.rpm; do
    [ -f "$i" ] || break
    cloudsmith push rpm --republish infisical/infisical-core/any-distro/any-version $i
done