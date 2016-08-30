# !/usr/bin/env bash

PATH="${BATS_TEST_DIRNAME}/../bin:$PATH"
export PATH

# cd to fixture and move the git dir out of the shadows
setup() {
  cd "$BATS_TEST_DIRNAME/fixture/repo.git"
  mv "git" ".git"
}

# hide the git dir in the fixture, so we don't have to use submodules
teardown() {
  cd "$BATS_TEST_DIRNAME/fixture/repo.git"
  mv ".git" "git"
}
