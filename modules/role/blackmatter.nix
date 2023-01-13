###############################################################################
# blackmatter.
# top-level for your personal linux environments
###############################################################################

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.role.blackmatter;
in
{
  #############################################################################
  # options
  # declare an options schema to control how the module is used
  #############################################################################

  options.role.blackmatter.enable = mkEnableOption "blackmatter";

  options.role.blackmatter.system.version = mkOption {
    type = types.str;
    default = "22.05";
    description = lib.mkDoc ''
      nixos version supported by the blackmatter module
    '';
  };

  # sites
  options.role.blackmatter.sites.tap.enable = mkOption {
    type = types.bool;
    default = false;
    description = lib.mkDoc ''
      enable tap site
    '';
  };

  # build system to cli level
  options.role.blackmatter.cli.enable = mkOption {
    type = types.bool;
    default = true;
    description = lib.mdDoc ''
      build cli level
    '';
  };

  options.role.blackmatter.cli.packages = mkOption {
    type = types.listOf types.package;
    default = with pkgs; [
      traceroute
      terraform
      # comes up as undefined
      # pkgconfig
      nix-index
      drm_info
      pciutils
      tfswitch
      dnsmasq
      ripgrep
      weechat
      gnumake
      awscli
      nixops
      nodejs
      # TODO: poetry is flagged as insecure
      # poetry
      bundix
      cargo
      unzip
      gnupg
      nomad
      vault
      ruby
      yarn2nix
      yarn
      xsel
      lshw
      htop
      nmap
      stow
      zlib
      wget
      curl
      gcc
      age
      git
      fzf
      dig
      vim
      vim
      git
    ];
    description = lib.mdDoc ''
      cli level packages
    '';
  };

  options.role.blackmatter.virtualization.enable = mkOption {
    type = types.bool;
    default = false;
    description = lib.mdDoc ''
      control virtualization
    '';
  };

  options.role.blackmatter.hydra.enable = mkOption {
    type = types.bool;
    default = false;
    description = lib.mdDoc ''
      enable a local hydra implementation
    '';
  };

  options.role.blackmatter.ssh.enable = mkOption {
    type = types.bool;
    default = true;
    description = lib.mdDoc ''
      control ssh
    '';
  };

  options.role.blackmatter.vagrant.enable = mkOption {
    type = types.bool;
    default = true;
    description = lib.mdDoc ''
      enable vagrant and vagrant requirements
    '';
  };

  options.role.blackmatter.desktop.enable = mkOption {
    type = types.bool;
    default = false;
    description = lib.mdDoc ''
      enable desktop and desktop packages
    '';
  };

  options.role.blackmatter.desktop.packages = mkOption {
    type = types.listOf types.package;
    default = with pkgs;[
      beekeeper-studio
      transmission-gtk
      _1password-gui
      transmission
      _1password
      librewolf
      fractal
      spotify
      zoom-us
      discord
      notion
      slack
      vlc
    ];
    description = lib.mdDoc ''
      desktop packages
    '';
  };

  options.role.blackmatter.boot.enable = mkOption {
    type = types.bool;
    default = true;
    description = lib.mdDoc ''
      enable boot
    '';
  };

  options.role.blackmatter.dotfile.enable = mkOption {
    type = types.bool;
    default = false;
    description = lib.mdDoc ''
      enable dotfiles
    '';
  };

  options.role.blackmatter.wireless.enable = mkOption {
    type = types.bool;
    default = false;
    description = lib.mdDoc ''
      enable wireless
    '';
  };

  options.role.blackmatter.nix.enable = mkOption {
    type = types.bool;
    default = true;
    description = lib.mdDoc ''
      enable nix
    '';
  };

  options.role.blackmatter.allowUnfree.enable = mkOption {
    type = types.bool;
    default = true;
    description = lib.mdDoc ''
      allow default unfree packages
    '';
  };

  # wireless interfaces
  options.role.blackmatter.wireless.interfaces = mkOption {
    type = types.listOf types.str;
    default = [ "wlp0s20f3" ];
  };

  # system hostname
  options.role.blackmatter.host = mkOption {
    type = types.str;
  };

  # grub boot devices
  options.role.blackmatter.grub.devices = mkOption {
    type = types.listOf types.str;
    default = [ "/dev/nvme0n1" ];
  };

  # groups assigned to dotfile users
  options.role.blackmatter.dotfile.userGroups = mkOption {
    type = types.listOf types.str;
    default = [
      # give user sudo
      "wheel"
      # access to docker daemon
      "docker"
      # access to to kvm2
      "libvirtd"
      # user can have audio devices
      "audio"
      # user can manage brightness
      "video"
    ];
  };

  ########################################################################### @

  config =
    mkMerge [
      #########################################################################
      # misc global settings
      #########################################################################

      (mkIf cfg.enable {
        system.stateVersion = cfg.system.version;
        services.hardware.bolt.enable = false;
        networking.hostName = cfg.host;
        i18n.defaultLocale = "en_US.UTF-8";
        console = { font = "Lat2-Terminus16"; keyMap = "us"; };
        time.timeZone = "US/Pacific";
        nixpkgs.config.permittedInsecurePackages = [
          "python2.7-pyjwt-1.7.1"
          "python-2.7.18.6"
          "python2.7-certifi-2021.10.8"
        ];
      })

      ####################################################################### @

      #########################################################################
      # explicit unfree packages we allow
      #########################################################################

      (mkIf cfg.allowUnfree.enable {
        # There are two strategies for dealing with unfree packages
        # You can either generally allow unfree packages or white-list
        # them.  I have chosen to white-list.
        nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "spotify-unwrapped"
          "nvidia-settings"
          "1password-cli"
          "nvidia-x11"
          "1password"
          "discord"
          "spotify"
          "slack"
          "zoom"
        ];
      })

      ####################################################################### @

      #########################################################################
      # hydra
      #########################################################################

      (mkIf cfg.allowUnfree.enable {
        services.hydra = {
          enable = false;
          hydraURL = "http://localhost:3000";
          notificationSender = "hydra@localhost";
          buildMachinesFiles = [ ];
          useSubstitutes = true;
        };
      })

      ####################################################################### @

      #########################################################################
      # nix settings
      #########################################################################

      (mkIf cfg.nix.enable {
        # TODO: fix nixFlakes is missing when run as test
        # nix = {
        #   # enable nix flakes commands to be run on nixos
        #   package = pkgs.nixFlakes;
        #   extraOptions = ''
        #     experimental-features = nix-command flakes
        #   '';
        # };
      })

      ####################################################################### @

      #########################################################################
      # boot
      #########################################################################

      (mkIf cfg.boot.enable {
        # extra packages supplying kernel modules
        boot.extraModulePackages = [ ];
        # enable virtualization inside of virtualization
        # https://nixos.wiki/wiki/Libvirt
        boot.extraModprobeConfig = "options kvm_intel nested=1";
        boot.crashDump.enable = false;
        boot.crashDump.kernelParams = [ "1" "boot.shell_on_fail" ];
        boot.crashDump.reservedMemory = "128M";
        boot.enableContainers = false;
        boot.binfmt.emulatedSystems = [ ];
        boot.binfmt.registrations = { };
        boot.extraSystemdUnitPaths = [ ];
        boot.growPartition = false;
        boot.hardwareScan = true;
        boot.cleanTmpDir = true;
        boot.devShmSize = "50%";
        boot.devSize = "5%";
        boot.initrd.enable = !config.boot.isContainer;
        boot.loader.grub.enable = true;
        boot.loader.grub.version = 2;
        boot.loader.grub.devices = cfg.grub.devices;
      })

      ####################################################################### @

      #########################################################################
      # virtualization
      #########################################################################

      (mkIf cfg.virtualization.enable {
        virtualisation.docker.enable = true;
        virtualisation.libvirtd.enable = true;
      })

      ####################################################################### @

      #########################################################################
      # cli system layer
      # non-desktop parts of the system installation
      #########################################################################

      (mkIf cfg.cli.enable {
        environment.systemPackages = cfg.cli.packages;
        services.printing.enable = false;
        services.xserver.libinput.enable = true;
        # sops.defaultSopsFile = ./secrets/example.yml;
        # sops-nix.defaultSopsFile = ./secrets/example.yml;
      })

      ####################################################################### @

      #########################################################################
      # ssh
      #########################################################################

      (mkIf cfg.ssh.enable {
        services.openssh.enable = true;
      })

      ####################################################################### @

      #########################################################################
      # wireless networking
      #########################################################################

      (mkIf cfg.wireless.enable {
        networking.wireless.enable = true;
        networking.wireless.interfaces = cfg.wireless.interfaces;
        networking.firewall.enable = false;
        networking.useDHCP = true;
      })

      ####################################################################### @

      #########################################################################
      # some customizations required for vagrant to work well
      #########################################################################

      (mkIf cfg.vagrant.enable {
        services.nfs.server.enable = false;
        networking.firewall.extraCommands = ''
          ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
        '';
      })

      ####################################################################### @

      #########################################################################
      # destkop environment
      #########################################################################

      (mkIf cfg.desktop.enable {

        environment.systemPackages = cfg.desktop.packages;

        # login
        services.greetd.enable = false;
        services.greetd.settings = {
          default_session = {
            command = "agreety --cmd /bin/sh";
            user = "greeter";
          };
        };
        environment.etc."greetd/sway-config".text = ''
          exec "wlgreet --command sway; swaymsg exit"

          bindsym Mod4+shift+e exec swaynag \
          	-t warning \
          	-m 'What do you want to do?' \
          	-b 'Poweroff' 'systemctl poweroff' \
          	-b 'Reboot' 'systemctl reboot'

          # include /etc/sway/config.d/*
        '';

        # monitors
        # kanshi is like autorandr but for wayland
        # https://github.com/emersion/kanshi
        systemd.user.services.kanshi = {
          description = "Kanshi output autoconfig ";
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          serviceConfig = {
            # kanshi doesn't have an option to specifiy config file yet, so it looks
            # at .config/kanshi/config
            ExecStart = ''
              ${pkgs.kanshi}/bin/kanshi
            '';
            RestartSec = 5;
            Restart = "always";
          };
        };

        programs.sway.enable = true;
        programs.sway.extraOptions = [ "--unsupported-gpu" ];
        programs.sway.wrapperFeatures.gtk = true;
        programs.sway.extraPackages = with pkgs; [
          i3-ratiosplit
          wl-clipboard
          wf-recorder
          flashfocus
          autotiling
          gammastep
          swaylock
          swayidle
          clipman
          waybar
          dmenu
          wofi
          mako
        ];
        # sway systemd integration
        # https://nixos.wiki/wiki/Sway
        systemd.user.targets.sway-session = {
          description = "Sway compositor session";
          documentation = [ "man:systemd.special(7)" ];
          bindsTo = [ "graphical-session.target" ];
          wants = [ "graphical-session-pre.target" ];
          after = [ "graphical-session-pre.target" ];
        };
        services.xserver.enable = true;
        services.xserver.layout = "us";
        services.xserver.xkbOptions = "caps:escape";
        services.xserver.displayManager.defaultSession = "sway";
        services.xserver.desktopManager.xterm.enable = false;
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.displayManager.gdm.wayland = true;
        services.xserver.desktopManager.gnome.enable = false;
        services.xserver.windowManager.i3.enable = false;
        services.xserver.windowManager.i3.extraPackages = with pkgs; [
          i3blocks
          i3status
          i3lock
          dmenu
        ];
        hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
        services.xserver.videoDrivers = [ "nvidia" "intel" ];

        hardware.nvidia.nvidiaPersistenced = false;

        hardware.nvidia.prime = {
          offload.enable = false;
          nvidiaBusId = "PCI:00:02:0";
          intelBusId = "PCI:01:00:0";
        };

        # if you start from desktop nixOS these will be installed by default
        # remove them if they exist.
        environment.gnome.excludePackages = [
          pkgs.gnome.gnome-characters
          pkgs.gnome.gnome-terminal
          pkgs.gnome.gnome-music
          pkgs.gnome.epiphany
          pkgs.gnome.evince
          pkgs.gnome.cheese
          pkgs.gnome-photos
          pkgs.gnome.hitori
          pkgs.gnome.atomix
          pkgs.gnome.gedit
          pkgs.gnome.totem
          pkgs.gnome.iagno
          pkgs.gnome.geary
          pkgs.gnome.tali
          pkgs.gnome-tour
        ];
        xdg = {
          portal = {
            enable = true;
            extraPortals = with pkgs; [
              xdg-desktop-portal-wlr
            ];
          };
        };
        appstream.enable = false;
        fonts.fonts = with pkgs;[
          fira-code
          fira-code-symbols
        ];
        hardware.bluetooth.enable = true;
        services.blueman.enable = true;
        programs.light.enable = true;
        services.printing.enable = false;
        services.xserver.libinput.enable = true;
        sound.enable = true;
        hardware.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
          media-session.config.bluez-monitor.rules = [
            {
              # Matches all cards
              matches = [{ "device.name" = "~bluez_card.*"; }];
              actions = {
                "update-props" = {
                  "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
                  # mSBC is not expected to work on all headset + adapter combinations.
                  "bluez5.msbc-support" = true;
                  # SBC-XQ is not expected to work on all headset + adapter combinations.
                  "bluez5.sbc-xq-support" = true;
                };
              };
            }
            {
              matches = [
                # Matches all sources
                { "node.name" = "~bluez_input.*"; }
                # Matches all outputs
                { "node.name" = "~bluez_output.*"; }
              ];
            }
          ];
          config.pipewire = {
            "link.max-buffers" = 64;
            "log.level" = 2;
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 8192;
          };
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
        };
      })

      ####################################################################### @
    ];
}
