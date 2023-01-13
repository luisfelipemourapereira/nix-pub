# @EXAMPLE@: relative nixpkgs import

################################################################################
# nixos test that evokes provisioning for a nixos node
################################################################################
import "${<nixpkgs>}/nixos/tests/make-test-python.nix" (
  { pkgs
  , ...
  }: {
    name = "provision";
    testScript = ''
      print("hi all")
    '';
    nodes.machine = {
      imports = [ ../../../../modules/edge/blackmatter.nix ];
    };
  }
)
