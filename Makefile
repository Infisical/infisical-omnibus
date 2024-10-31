.PHONY: clean-up reset status

clean-up:
	dpkg -r infisical && \
	rm -rf pkg && \
	./bin/omnibus clean infisical --purge

reset:
	dpkg -r infisical && \
	rm -rf pkg

status:
	systemctl status infisical