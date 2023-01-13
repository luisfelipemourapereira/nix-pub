################################################################################
# test: ./modules/role/blackmatter.nix
################################################################################
let
  mkTest = import ../../../../functions/testing/mkTest.nix;
  case_0 = {
    hostName = "bm";
  };
in
mkTest {
  name = "blackmatter";
  testScript = ''
    start_all()
    machine = ${case_0.hostName}

    machine.wait_for_unit("network-online.target")
    assert "${case_0.hostName}" == machine.succeed("hostname --fqdn").strip()
  '';

  nodes.machine =
    {
      imports = [ ../../../../modules/role/blackmatter.nix ];
      edge.blackmatter.enable = true;
      edge.blackmatter.host = case_0.hostName;
    };
}
