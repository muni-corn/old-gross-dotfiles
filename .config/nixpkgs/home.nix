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
      package = pkgs.inter;
      name = "Inter";
      size = 12;
    };
    iconTheme = {
      package = pkgs.flat-remix-icon-theme;
      name = "Flat-Remix-Violet-Dark";
    };
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    gtk2.extraConfig = "gtk-cursor-theme-name=Breeze_Obsidian";
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "Breeze_Obsidian";
    };
  };

  home.packages = with pkgs; [
    bemenu
    breeze-icons
    docker-compose
    fish
    fd
    gcc
    gnupg
    grim
    keepassxc
    kitty
    kodi
    mako
    neovim
    nodejs
    notify-desktop
    pamixer
    playerctl
    ranger
    rustup
    sd
    slack
    slurp
    spotify
    sway
    swaybg
    swayidle
    swaylock
    tree-sitter
    wl-clipboard
    wob
    wpgtk
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

  qt = {
    enable = true;
    style.package = pkgs.qtstyleplugin-kvantum;
    style.name = "kvantum-dark";
  };

  services = {
    gammastep = {
      enable = true;
      provider = "geoclue2";
      temperature = {
        night = 1500;
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
}