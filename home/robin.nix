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
 
  #nvim 
  home.file.".config/nvim/init.lua".source = ../nvim/init.lua;

  #alacritty 
  home.file.".config/alacritty/alacritty.toml".source = ./alacritty/alacritty.toml;

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

#fish block 
programs.fish = {
  enable = true;
  
  shellInit = ''
    set -gx LIBVIRT_DEFAULT_URI "qemu:///system"
    fish_add_path $HOME/.local/bin
  '';
  
  shellAliases = {
    aria = "aria2c -x16 -s16";
    vid = "yt-dlp --cookies-from-browser chrome";
    nrs = "sudo nixos-rebuild switch --flake /home/robin/nixos#doc";
    nconf = "nvim /home/robin/nixos/configuration.nix";
    nfk = "nvim /home/robin/nixos/flake.nix";
    hrs = "home-manager switch --flake /home/robin/nixos#robin";
    hconf = "nvim /home/robin/nixos/home/robin.nix";
  };
  
  interactiveShellInit = ''
  set -g fish_prompt_pwd_dir_length 0
    fzf --fish | source

    zoxide init fish | source
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
    obs-studio 
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
    neovim
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
    rofi
    hyprpaper
    waybar
    openssl
    cloud-utils
  ];
}
