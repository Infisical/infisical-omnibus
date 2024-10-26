clean-up:
	dpkg -r test && \
	rm -rf pkg && \
	./bin/omnibus clean test --purge

build:
	./bin/omnibus build test -l=debug

status:
	systemctl status test