PREFIX ?= /usr/local

install: bin/git-diff-ansible-vault
	@cp -p $< $(PREFIX)/$<

uninstall:
	@rm -f $(PREFIX)/bin/git-diff-ansible-vault

setup:
	@rm -rf vendor
	@mkdir -p vendor
	git clone --depth 1 git://github.com/sstephenson/bats.git vendor/bats

test:
	vendor/bats/bin/bats test

.PHONY: install uninstall setup test
