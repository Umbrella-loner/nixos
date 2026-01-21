{ config, pkgs, ...}:


{
home.username = "robin";
home.homeDirectory = "/home/robin";

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  #cursor-thing-dont-forget
  home.pointerCursor = {
    name = "Adwaita";
    size = 27;
    package = pkgs.adwaita-icon-theme;
    gtk.enable = true;
  };

#nix index 
programs.nix-index = { 
  enable = true;
  enableZshIntegration = true;
};
  #symlinks 
  #nirii 
  home.file.".config/niri/config.kdl".source = ../niri/config.kdl;
 
 home.file.".config/nvim/init.lua".source = ../nvim/init.lua;
#o

  #alacritty 
  home.file.".config/alacritty/alacritty.toml".source = ./alacritty/alacritty.toml;

home.file.".config/rofi" = { 
  source = ./rofi;
  recursive = true;
};
  #hyprland 
  home.file.".config/hypr" = {
    source = ./hypr; 
    recursive = true;
  };
  #waybar settins 
  home.file.".config/waybar" = {
    source = ./waybar;
    recursive = true;
  };
  #git settings 
programs.git = {
    enable = true; 

    settings.user.name = "robin";
    settings.user.email = "robinmogha@outlook.com";

    #core defaults 
    settings = {
      init.defaultBranch = "main"; 

      pull.rebase = true; 
      rebase.autosearch = true;

      fetch.prune = true;

      core.editor = "nvim";
      core.pager = "less -FRSX"; 

      color.ui = true;
    };
  };
    
  #direnv settings 
  programs.direnv = { 
    enable = true; 
    enableZshIntegration = true; 
    enableBashIntegration = true;
    nix-direnv.enable = true; 
  }; 

#starship block 
programs.starship = {
  enable = true;
  settings = {
    add_newline = false;

    format = "$directory$git_branch$git_status$character";

    directory = {
      style = "blue";
      truncation_length = 3;
    };

    git_branch = {
      symbol = " ";
      style = "purple";
    };

    git_status = {
      style = "red";
    };

    character = {
      success_symbol = "[❯](green)";
      error_symbol = "[❯](red)";
    };
  };
};

#zsh config
programs.zsh = {
  enable = true;

  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  history = {
    path = "$HOME/.zsh_history";
    size = 10000;
    save = 10000;
    ignoreDups = true;
    extended = true;
  };

  shellAliases = {
    aria = "aria2c -x16 -s16";
    vid  = "yt-dlp --cookies-from-browser chrome";
    ins = "yt-dlp --cookies ~/.cookies/instagram.txt";
    nrs   = "sudo nixos-rebuild switch --flake /home/robin/nix#transcendent";
    nconf = "nvim /home/robin/nix/configuration.nix";
    nfk   = "nvim /home/robin/nix/flake.nix";
    hrs   = "home-manager switch --flake /home/robin/nix#robin";
    hconf = "nvim /home/robin/nix/home/robin.nix";
  };

  initContent = ''
    bindkey -e


    export PATH="$HOME/.local/bin:$PATH"
    export LIBVIRT_DEFAULT_URI="qemu:///system"

  '';
};

  
  #tmux config
programs.tmux = {
  enable = true;

  # Make tmux respect true color + modern terminals
  terminal = "screen-256color";

  # Start window/pane indexing at 1
  baseIndex = 1;
  keyMode = "vi";
  mouse = true;
  historyLimit = 100000;

  extraConfig = ''
    # -----------------------------
    # Prefix key: Ctrl + a
    # -----------------------------
    unbind C-b
    set-option -g prefix C-a
    bind C-a send-prefix

    set -g pane-base-index 1
    set -g set-clipboard on
    set -g allow-passthrough on
    set -as terminal-features '*:clipboard'

    # -----------------------------
    # Vim-style pane movement
    # Ctrl+h/j/k/l
    # -----------------------------
    bind -n C-h select-pane -L
    bind -n C-j select-pane -D
    bind -n C-k select-pane -U
    bind -n C-l select-pane -R

    # -----------------------------
    # Splitting panes
    # -----------------------------
    bind | split-window -h
    bind - split-window -v

    # -----------------------------
    # Resize panes with Alt + h/j/k/l
    # -----------------------------
    bind -n M-h resize-pane -L 3
    bind -n M-j resize-pane -D 3
    bind -n M-k resize-pane -U 3
    bind -n M-l resize-pane -R 3

    # -----------------------------
    # Faster responsiveness
    # -----------------------------
    set-option -g escape-time 0

    # -----------------------------
    # Status bar
    # -----------------------------
    set -g status on
    set -g status-interval 5

    set -g status-style bg=#1e1e2e,fg=#cdd6f4

    set -g status-left-length 40
    set -g status-right-length 100

    set -g status-left "  #[bold]#S  "
    set -g status-right "  %Y-%m-%d %H:%M  "
  '';
};

home.packages = with pkgs; [
  fastfetch 
  direnv 
  nix-direnv
  yt-dlp
  obs-studio 
  rofi
  obs-studio-plugins.wlrobs
  obs-studio-plugins.obs-pipewire-audio-capture
  obs-studio-plugins.obs-vkcapture
  blender
  brave
  zip
  file
  tree
  less
  ripgrep
  fd
  bat
  eza
  gammastep
  swaynotificationcenter
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
  htop
  ncdu
  lsof
  strace
  yazi
  p7zip
  rar
  nmap
  netcat
  rsync
  jq
  openssh
  yq
  s-tui
  man-pages
  man-pages-posix
  fzf
  zoxide
  tldr
  google-chrome
  pkgs.thunar 
  pkgs.tumbler 
  evince 
  ps_mem
  vscode 
  mpv
  alacritty 
  protonvpn-gui
  grim 
  slurp 
  blueman 
  swayosd 
  ffmpegthumbnailer
  hyprpaper
  waybar
  openssl
  cloud-utils
  ];
}
