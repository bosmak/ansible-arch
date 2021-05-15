test: package
	packer build --force ./packer.json

package:
	tar --exclude 'packer*' \
		--exclude 'output-*' \
		--exclude 'archive.tar.gz'\
		-czf archive.tar.gz *

clean:
	rm -f archive.tar.gz
	rm -rf output-*

clean-all: clean
	rm -rf packer_cache
