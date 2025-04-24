.PHONY: clean-up reset status rebuild-cookbook pkg-deb pkg-rpm

clean-up:
	dpkg -r infisical-core && \
	rm -rf pkg && \
	./bin/omnibus clean infisical --purge

reset:
	dpkg -r infisical-core && \
	rm -rf pkg

status:
	systemctl status infisical-core

rebuild-cookbooks:
	yes | cp -rf ./files/infisical-cookbooks/* /opt/infisical-core/embedded/cookbooks

pkg-deb:
	docker build -f ./builder/Dockerfile_ubuntu_22.04 -t infisical-omnibus-debian-builder .

pkg-rpm:
	docker build -f ./builder/Dockerfile_amazon_2 -t infisical-omnibus-rpm-builder .
