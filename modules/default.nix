{ config, pkgs, lib, ... }:
let
  username = "zero";
in {
  imports = [
    ./services.nix
    ./env.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home-manager.useGlobalPkgs = true;
  gtk.iconCache.enable = true;
  xdg.portal.enable = true;

  nix = {
    settings.auto-optimise-store = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  users = {
    defaultUserShell = pkgs.zsh;

    users.${username} = {
      isNormalUser = true;
      initialPassword = "nixfiles";
      home = "/home/${username}";
      useDefaultShell = true;
      extraGroups = [ "wheel" "audio" "input" "video" "networkmanager"];
    };
  };

  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
    updateDbusEnvironment = true;

    layout = "de";
    xkbOptions = "eurosign:e,caps:escape";

    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;

      mouse = {
        accelProfile = "flat";
        disableWhileTyping = true;
      };
    };

    displayManager = {
      defaultSession = "none+bspwm";

      lightdm = {
        enable = true;
        background = ../wallpaper/wallpaper.png;

        greeters.mini = {
          enable = true;
          user = "${username}";

          extraConfig = ''
            [greeter]
            password-alignment = left
            password-label-text = Passwort:
            invalid-password-text = Falsches Passwort

            [greeter-theme]
            font = Noto Sans Regular
            text-color = "#E5E9F0"
            error-color = "#BF616A"
            window-color = "#2E3440"
            border-color = "#81A1C1"
            password-color = "#E5E9F0"
          '';
        };
      };
    };
  };

  fonts = {
    fontDir.enable = true;

    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "BitstreamVeraSansMono"
          "NerdFontsSymbolsOnly"
        ];
      })
      iosevka
      jetbrains-mono
      noto-fonts
      sarasa-gothic
      source-code-pro
    ];
  };

  environment.systemPackages = with pkgs; [
    # Essential packages
    wget
    killall
    xclip
    xorg.xkill
    playerctl
    feh
    scrot
    betterlockscreen
    polkit_gnome
    gnome.zenity
    pamixer

    # Useful, but not essential
    easyeffects
    firefox
    xfce.thunar
    viewnior
    ranger
    gotop
  ];

  home-manager.users.${username} = { config, pkgs, lib, ... }: {
    imports = [
      ./home-manager/pkgs/alacritty.nix
      ./home-manager/pkgs/editor.nix
      ./home-manager/pkgs/git.nix
      ./home-manager/pkgs/rofi.nix
      ./home-manager/pkgs/zathura.nix
      ./home-manager/pkgs/starship.nix
      ./home-manager/home.nix
    ];
  };
}
