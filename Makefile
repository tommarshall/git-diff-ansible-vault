PREFIX ?= /usr/local

install: bin/git-diff-ansible-vault
	@cp -p $< $(PREFIX)/$<
	@cp -p man/git-diff-ansible-vault.1 $(PREFIX)/share/man/man1/

uninstall:
	@rm -f $(PREFIX)/bin/git-diff-ansible-vault
	@rm -f $(PREFIX)/share/man/man1/git-diff-ansible-vault.1

setup:
	@rm -rf vendor
	@mkdir -p vendor
	git clone --depth 1 git://github.com/sstephenson/bats.git vendor/bats

test:
	vendor/bats/bin/bats test

man: man/git-diff-ansible-vault.1.ronn
	ronn -r --style=80c $<

.PHONY: install uninstall setup test man
