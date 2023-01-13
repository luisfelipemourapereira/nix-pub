{
  description = "my own public nix things";
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
        localPkgs = { };
        localModules = { };
      in
      rec {
        packages = flake-utils.lib.flattenTree localPkgs;
        nixosModules = flake-utils.lib.flattenTree localModules;
      }
    );
}
