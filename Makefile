.PHONY: clean-up reset status rebuild-cookbook

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