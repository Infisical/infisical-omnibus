clean-up:
	dpkg -r infisical && \
	rm -rf pkg && \
	./bin/omnibus clean infisical --purge

reset:
	dpkg -r infisical && \
	rm -rf pkg

build:
	unset MAKELEVEL && unset MAKEFLAGS && unset MFLAGS && \
			./bin/omnibus build infisical -l=debug

status:
	systemctl status infisical