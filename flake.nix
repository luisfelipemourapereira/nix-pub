{
  description = "my own public nix things";
  inputs.flake-utils.url = github:numtide/flake-utils;
  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        system = "x86_64-linux";
        localPkgs = import ./packages/top-level.nix;
        localModules = import ./modules/top-level.nix;
      in
      rec {
        packages = flake-utils.lib.flattenTree localPkgs;
        nixosModules = flake-utils.lib.flattenTree localModules;
      }
    );
}
