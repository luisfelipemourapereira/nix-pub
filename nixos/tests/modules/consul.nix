################################################################################
# test: ./modules/services/consul.nix
################################################################################
let
  mkTest = import ../../../functions/testing/mkTest.nix;
  case_0 = {
    hostName = "consul";
  };
in
mkTest {
  name = "consul";
  testScript = ''
    start_all()
    machine = ${case_0.hostName}

    machine.wait_for_unit("network-online.target")
    assert "${case_0.hostName}" == machine.succeed("hostname --fqdn").strip()
  '';

  nodes.machine =
    {
      imports = [ ../../../modules/services/consul.nix ];
      consul.enable = true;
    };
}
