#!/usr/bin/env bats

load test_helper

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

@test "without --revision or --path shows all work-in-progress changes" {
  run git diff-ansible-vault
  assert_success
  assert_output "$(cat <<EOF
diff --git a/public.yml b/public.yml
index 497da2b..bb68218 100644
--- a/public.yml
+++ b/public.yml
@@ -7,3 +7,4 @@ fruits:
   - Mango
   - Banana
   - Pineapple
+  - Peach
diff --git a/vault.yml b/vault.yml
index ff6110d..f5b9bd7 100644
--- a/vault.yml
+++ b/vault.yml
@@ -16,3 +16,4 @@
     - lisp
     - fortran
     - erlang
+    - bash
EOF
)"
}

@test "with --revision shows all changes for that revision only" {
  run git diff-ansible-vault -r b479719..c54076a
  assert_success
  assert_output "$(cat <<EOF
diff --git a/public.yml b/public.yml
index 970074c..1f613c2 100644
--- a/public.yml
+++ b/public.yml
@@ -5,3 +5,4 @@ fruits:
   - Orange
   - Strawberry
   - Mango
+  - Banana
diff --git a/vault.yml b/vault.yml
index 2e972c1..5fd6cf8 100644
--- a/vault.yml
+++ b/vault.yml
@@ -7,6 +7,7 @@
     - python
     - perl
     - pascal
+    - ruby
 - tabitha:
   name: Tabitha Bitumen
   job: Developer
EOF
)"
}

@test "with --path shows work-in-progress changes for that path only" {
  run git diff-ansible-vault -p vault.yml
  assert_success
  assert_output "$(cat <<EOF
diff --git a/vault.yml b/vault.yml
index ff6110d..f5b9bd7 100644
--- a/vault.yml
+++ b/vault.yml
@@ -16,3 +16,4 @@
     - lisp
     - fortran
     - erlang
+    - bash
EOF
)"
}

@test "with --revision and --path shows changes for that revision and path only" {
  run git diff-ansible-vault -r b479719..c54076a -p vault.yml
  assert_success
  assert_output "$(cat <<EOF
diff --git a/vault.yml b/vault.yml
index 2e972c1..5fd6cf8 100644
--- a/vault.yml
+++ b/vault.yml
@@ -7,6 +7,7 @@
     - python
     - perl
     - pascal
+    - ruby
 - tabitha:
   name: Tabitha Bitumen
   job: Developer
EOF
)"
}

@test "with --staged shows all staged changes" {
  run git diff-ansible-vault --staged
  assert_success
  assert_output "$(cat <<EOF
diff --git a/public.yml b/public.yml
index 1f613c2..497da2b 100644
--- a/public.yml
+++ b/public.yml
@@ -6,3 +6,4 @@ fruits:
   - Strawberry
   - Mango
   - Banana
+  - Pineapple
diff --git a/vault.yml b/vault.yml
index 5fd6cf8..ff6110d 100644
--- a/vault.yml
+++ b/vault.yml
@@ -8,6 +8,7 @@
     - perl
     - pascal
     - ruby
+    - go
 - tabitha:
   name: Tabitha Bitumen
   job: Developer
EOF
)"
}

@test "without a git repository exits with an error" {
  cd /tmp && touch .vault-pass
  run git diff-ansible-vault
  assert_failure "[ERROR] Not a git repository"
}

@test "--vault-password-file with specified path unlocks vault" {
  run git diff-ansible-vault --vault-password-file .alternate-vault-pass --verbose
  assert_success
  assert_line "[INFO] VAULT_PASSWORD_FILE: .alternate-vault-pass"
  assert_line "diff --git a/vault.yml b/vault.yml"
  assert_line "+    - bash"
}

@test "--vault-password-file with non-existant path exits with error" {
  run git diff-ansible-vault --vault-password-file .not-a-file
  assert_failure "[ERROR] --vault-password-file not found: .not-a-file"
}

@test "--vault-password-file with incorrect password shows warning" {
  run git diff-ansible-vault --vault-password-file .incorrect-vault-pass
  assert_success
  assert_line "[WARNING] Unable to open vault: vault.yml"
}

@test "--vault-only restricts diff to vault files only" {
  run git diff-ansible-vault --vault-only
  assert_success
  assert_output "$(cat <<EOF
diff --git a/vault.yml b/vault.yml
index ff6110d..f5b9bd7 100644
--- a/vault.yml
+++ b/vault.yml
@@ -16,3 +16,4 @@
     - lisp
     - fortran
     - erlang
+    - bash
EOF
)"
}

@test "--verbose displays logging output" {
  run git diff-ansible-vault --verbose
  assert_success
  assert_line "[INFO] REVISION: "
  assert_line "[INFO] PATH_SCOPE: "
  assert_line "[INFO] VAULT_PASSWORD_FILE: ./.vault-pass"
  assert_line "[INFO] VAULT_ONLY: 0"
}

@test "--version prints the version" {
  run git diff-ansible-vault --version
  assert_success
  [[ "$output" == "git-diff-ansible-vault "?.?.? ]]
}

@test "--help prints the usage" {
  run git-diff-ansible-vault --help
  assert_success
  assert_line "Usage: git-diff-ansible-vault [-r <revision>] [-p <path>] [options]"
}

@test "unrecognised option shows error and usage" {
  run git diff-ansible-vault --not-an-option
  assert_failure
  assert_line "Unrecognised argument: --not-an-option"
  assert_line "Usage: git-diff-ansible-vault [-r <revision>] [-p <path>] [options]"
}
