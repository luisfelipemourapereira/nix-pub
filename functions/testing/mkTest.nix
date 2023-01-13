################################################################################
# common wrapper for the tests found inside this directory
################################################################################
test:
let
  # centralize where we test the make-test-python function
  mktestPython = import "${<nixpkgs>}/nixos/tests/make-test-python.nix";
in
mktestPython test
