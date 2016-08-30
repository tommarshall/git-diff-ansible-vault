# Git Diff Ansible Vault

[![Build Status](https://travis-ci.org/tommarshall/git-diff-ansible-vault.svg?branch=master)](https://travis-ci.org/tommarshall/git-diff-ansible-vault)

Running `git diff` on files encrypted with ansible vault results in some pretty unhelpful output.

`git-diff-ansible-vault` is custom git utility that detects files encrypted with ansible vault within the diff, and safely decrypts them to reveal the true changes.

![git-diff-ansible-vault animated demo](https://github.com/tommarshall/git-diff-ansible-vault/blob/master/img/demo.gif)

## Installation

```sh
$ git clone https://github.com/tommarshall/git-diff-ansible-vault.git
$ cd git-diff-ansible-vault
$ [sudo] make install
```

By default, `git-diff-ansible-vault` is installed under `/usr/local`. To install it at an alternate location, specify a `PREFIX` when calling make. See the [Makefile](./Makefile) for details.

## Usage

```sh
# diff uncommitted changes
$ git diff-ansible-vault

# specify a revision and restrict the diff to a path
$ git diff-ansible-vault -r master..some-branch -p path/to/dir

# specify a vault password file to avoid prompt (will look for .vault-pass by default)
$ git diff-ansible-vault --vault-password-file .vaultpass

# show full usage information and options
$ git diff-ansible-vault -h
```

### Options

```
    -r, --revision <revision>          show diff for git revision, e.g. master..some-branch
    -p, --path <path>                  restrict diff to path, e.g. support/config.yml
        --cached, --staged             show diff for staged changes
        --no-pager                     do not pipe output into a pager
        --vault-password-file <path>   vault password file path, defaults to .vault-pass
        --vault-only                   restrict diff to vault files only
        --color, --colour              turn on coloured output
        --no-color, --no-colour        turn off coloured diff
        --verbose                      display verbose output
    -v, --version                      output program version
    -h, --help                         output help information
```

## Dependencies

Ansible 1.8 or newer, as the scritpt relies on `ansible-vault view`.

You'll need [colordiff](http://www.colordiff.org/) if you want colored output.

`brew install colordiff` on OS X, `apt-get install colordiff` on Debian/Ubuntu.

## Credits

* [JonathonMA's `ansible-vault-git-diff` script](https://gist.github.com/JonathonMA/83cf96008c078d5f907a)
