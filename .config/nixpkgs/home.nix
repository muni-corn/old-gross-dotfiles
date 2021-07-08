# vim: ts=2 sw=2 expandtab
{ config, pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      package = pkgs.inter-ui;
      name = "Inter";
      size = 12;
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    gtk2.extraConfig = ''
      gtk-cursor-theme-name="Bibata_Classic"
      gtk-cursor-theme-size=24
    '';
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "Bibata_Classic";
      gtk-cursor-theme-size = 24;
    };
  };

  home.packages = with pkgs; [
    # desktop environment
    bemenu
    bibata-cursors
    grim
    mako
    polkit_gnome
    slurp
    sway
    swaybg
    swayidle
    swaylock
    wl-clipboard
    wob
    wpgtk
    xdg-desktop-portal-wlr

    # terminal stuff
    fd
    fish
    gnupg
    kitty
    neovim
    neovim-remote
    notify-desktop
    pinentry
    pinentry-curses
    playerctl
    ranger
    ripgrep
    sd
    zip

    # programming
    docker-compose
    gcc
    nodejs
    rustup
    tree-sitter

    # sound
    pamixer

    # apps
    android-file-transfer
    awf
    element-desktop
    gimp
    keepassxc
    kodi
    mpv-with-scripts
    pavucontrol
    signal-desktop
    slack
    spotify
  ];

  manual.html.enable = true;

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    firefox.enable = true;
    skim = {
      enable = true;
      enableFishIntegration = true;
    };
    git = {
      enable = true;
      signing = {
        key = "4B21310A52B15162";
        signByDefault = true;
      };
      userEmail = "municorn@musicaloft.com";
      userName = "municorn";
    };
    gpg = {
      enable = true;
    };
    htop.enable = true;
    jq.enable = true;
    keychain = {
      enable = true;
      enableFishIntegration = true;
      agents = [ "gpg" "ssh" ];
      extraFlags = [ "-q" "--gpg2" ];
      keys = [ "id_rsa_github" "id_rsa_bitbucket" "id_ed25519" "4B21310A52B15162" ];
    };
    zathura.enable = true;
  };

  services = {
    gammastep = {
      enable = true;
      provider = "geoclue2";
      temperature = {
        night = 1500;
      };
      settings = {
        general = {
          adjustment-method = "wayland";
        };
      };
    };
    syncthing.enable = true;
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "municorn";
    homeDirectory = "/home/municorn";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.11";
  };

  xsession = {
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata_Classic";
      size = 24;
    };
  };
}
