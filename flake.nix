{
  description = "my own public nix things";
  # inputs.flake-utils.url = github:numtide/flake-utils;
  outputs = { self }:
    let
      localModules = import ./modules/top-level.nix;
    in
    { nixosModules = localModules; };
}
