.PHONY: clean-up reset status rebuild-cookbook pkg-deb pkg-rpm

clean-up:
	dpkg -r infisical && \
	rm -rf pkg && \
	./bin/omnibus clean infisical --purge

reset:
	dpkg -r infisical && \
	rm -rf pkg

status:
	systemctl status infisical

rebuild-cookbooks:
	yes | cp -rf ./files/infisical-cookbooks/* /opt/infisical/embedded/cookbooks

pkg-deb:
	docker build -f ./builder/Dockerfile_ubuntu_22.04 -t infisical-omnibus-ubuntu-builder .

pkg-rpm:
	docker build -f ./builder/Dockerfile_amazon_2 -t infisical-omnibus-rpm-builder .
