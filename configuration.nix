# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, zen-browser, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

#virtualization
virtualisation.libvirtd.enable = true;
networking.nftables.enable = true;
virtualisation.spiceUSBRedirection.enable = true;
programs.virt-manager.enable = true;
zramSwap.enable = true;

  #showing password feedback 
  security.sudo = { 
  enable = true;
  extraConfig = ''
      Defaults pwfeedback
    '';
  };

#tailscale ssh thing 
services.tailscale.enable = true; 
networking.firewall.checkReversePath = "loose";
#niri download 
programs.niri.enable = true;
  #allow libvirt networking 
  networking.firewall = { 
    enable = true; 
    trustedInterfaces = [ "virbr0" ];
  };

  networking.nat = { 
    enable = true;
    internalInterfaces = [ "virbr0" ];
  };
#specialzations for my nixos 
specialisation.lqx.configuration = {
    system.nixos.tags = [ "lqx" ];

    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_lqx;
  };

#darkmode
# Add this block to your configuration.nix
programs.dconf.enable = true;  # You already have this

# Force GTK apps to use dark theme
environment.sessionVariables = {
  GTK_THEME = "Adwaita:dark";
   XCURSOR_THEME = "Adwaita";
XCURSOR_SIZE = "27";
};

# Set dark theme via dconf (this is what was missing)
programs.dconf.profiles.user.databases = [{
  settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };
}];

#new kernels
boot.kernelPackages = pkgs.linuxPackages_latest;

boot.loader.systemd-boot.enable = false;

boot.loader.efi = {
  canTouchEfiVariables = true;
  efiSysMountPoint = "/boot/efi";
};

boot.loader.grub = {
  enable = true;
  efiSupport = true;
  device = "nodev";
  useOSProber = true;
};

programs.nix-ld.enable = true;
programs.nix-ld.libraries = with pkgs;
[
stdenv.cc.cc
  zlib
  openssl
  glib
  gtk3
  xorg.libX11
  xorg.libXcursor
  xorg.libXrandr
  xorg.libXinerama
  xorg.libXcomposite
  xorg.libXdamage
  xorg.libXfixes
  xorg.libXtst
  alsa-lib
  pulseaudio
  wayland
  mesa
];

#laptop stuff
services.logind.settings.Login = {
  HandleLidSwitch = "ignore";
  HandleLidSwitchExternalPower = "ignore";
};

programs.zsh = {
  enable = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;
  enableCompletion = true;
};

environment.shells = with pkgs; [ pkgs.zsh ];

users.users.robin = {
  shell = pkgs.zsh;
};


  #virtualization podman 
  virtualisation.podman = { 
    enable = true; 
    dockerCompat = true;   #creates docker alias for podman 
    defaultNetwork.settings.dns_enabled = true;
  };


#dbus-thing-block
services.dbus.enable = true;

environment.variables = {
  XDG_DATA_DIRS = [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    "/usr/share"
    "${pkgs.glib}/share"
  ];
  EDITOR = "nvim";
  VISUAL = "nvim";
};

#app-image support don't forget
programs.appimage.enable = true;
programs.appimage.binfmt = true;


# xdg-desktop-portal (correct option name)
  xdg.portal = { 
    enable = true;
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-hyprland 
      xdg-desktop-portal-gtk
    ];
  };

services.openssh = {
  enable = true;

  settings = {
    # Core security
    PermitRootLogin = "no";
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    ChallengeResponseAuthentication = false;
  };

  # Optional but recommended
};

  services.fail2ban.enable = true;

boot.kernelParams = [
"console=tty50"
"i915.enable_psr=0"
];



#flakes-setting
nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "doc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

hardware.intel-gpu-tools.enable = true;

#flatpak-apps
services.flatpak.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.robin = {
    isNormalUser = true;
    description = "robin";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "kvm" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

git
steam-run
python3
distrobox
lldb
ffmpegthumbnailer
lm_sensors
libnotify
wineWowPackages.stable 
winetricks
nerd-fonts.iosevka
zen-browser.packages.${pkgs.system}.default
bc
cliphist
glib
gsettings-desktop-schemas
neovim
gcc 
clang
clang-tools
gnumake
cmake
gdb
vim
curl 
wget 
unzip 
curl
adwaita-icon-theme
docker
tmux
wl-clipboard
brightnessctl
networkmanagerapplet
aria2
  ];

#fonts
fonts = {
packages = with pkgs; [
 nerd-fonts.jetbrains-mono
 cantarell-fonts 
 jetbrains-mono
 nerd-fonts.fira-code
 nerd-fonts.iosevka
 ];
 fontconfig = {
 enable = true;
 defaultFonts = {
        monospace = [ "JetBrains Mono" ];
        sansSerif = [ "Cantarell" ];
        serif = [ "Noto Serif" ];
   };
   };
   };

   
#powersaving tlp
services.tlp.enable = true;


#acpi-thing-block
services.acpid.enable = true;


#keyd-program-block
services.keyd = {
  enable = true;

  keyboards.default = {
    ids = [ "*" ];
    settings = {
      main = {
        rightalt = "leftmeta";
	};
	};
	};
	};


#bluetooth-block
hardware.bluetooth.enable = true;
services.blueman.enable = true;


  #docker-block
virtualisation.docker.rootless = {
enable = true;
setSocketVariable = true;
};




#audio-stack(don't forget)
services.pipewire = {
enable = true;
alsa.enable = true;
alsa.support32Bit = true;
pulse.enable = true;
jack.enable = true;
};

security.rtkit.enable = true;

#allow ports for different stuff 
networking.firewall.allowedTCPPorts = [ 4000 ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  system.stateVersion = "25.11";
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
}
