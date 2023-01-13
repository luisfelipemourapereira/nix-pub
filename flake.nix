{
  description = "my own public nix things";
  outputs = { self }:
    let
      localModules = import ./modules/top-level.nix;
    in
    { nixosModules = localModules; };
}
