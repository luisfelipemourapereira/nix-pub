{ hardware-configuration, blackmatter, ... }:
{
  imports = [
    hardware-configuration
    blackmatter
  ];

  edge.blackmatter.host = "rio";
  edge.blackmatter.enable = true;
  edge.blackmatter.boot.enable = true;
  edge.blackmatter.cli.enable = true;
  edge.blackmatter.ssh.enable = true;
  edge.blackmatter.dotfile.enable = true;
  edge.blackmatter.allowUnfree.enable = true;
  edge.blackmatter.vagrant.enable = false;
  edge.blackmatter.desktop.enable = false;
  edge.blackmatter.wireless.enable = false;
  edge.blackmatter.nix.enable = false;
  edge.blackmatter.hydra.enable = false;
  edge.blackmatter.virtualization.enable = false;
}
