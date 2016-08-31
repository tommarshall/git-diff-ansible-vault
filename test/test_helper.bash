# !/usr/bin/env bash

PATH="${BATS_TEST_DIRNAME}/../bin:$PATH"
export PATH

# Remember where the hook is
BASE_DIR=$(dirname $BATS_TEST_DIRNAME)
# Set up a directory for our git repo
TMP_DIRECTORY=$(mktemp -d)

setup() {
  # copy the test fixture and move the git dir out of the shadows
  cp -r "$BATS_TEST_DIRNAME/fixture/repo.git" "$TMP_DIRECTORY"
  mv "$TMP_DIRECTORY/repo.git/git" "$TMP_DIRECTORY/repo.git/.git"
  cd "$TMP_DIRECTORY/repo.git"
}

teardown() {
  if [ $BATS_TEST_COMPLETED ]; then
    echo "Deleting $TMP_DIRECTORY"
    rm -rf $TMP_DIRECTORY
  else
    echo "** Did not delete $TMP_DIRECTORY, as test failed **"
  fi

  cd $BATS_TEST_DIRNAME
}
