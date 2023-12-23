{ config, pkgs, lib, nnn, ... }:

{
  # General settings
  home.username = "chanel";
  home.homeDirectory = "/home/chanel";
  fonts.fontconfig.enable = true;

  # .config files
  home.file = {

    ".config/background" = {
      source = ./background;
      force = true;
    };

    # ".config/whatsapp-for-linux/settings.conf" = {
    #   source = ./.config/whatsapp-for-linux/settings.conf;
    #   force = true;
    # };

  };


  home.packages = with pkgs;
    [
      # Desktop programs
      calibre
      firefox
      gimp
      gnome-extension-manager
      jellyfin-media-player
      libreoffice
      logseq
      moonlight-qt
      obs-studio
      syncthing
      telegram-desktop
      ungoogled-chromium
      vlc
      whatsapp-for-linux
      zoom-us

      # Gnome Extensions
      gnomeExtensions.blur-my-shell
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.fullscreen-avoider
      gnomeExtensions.gsconnect
      gnomeExtensions.tailscale-status
      gnomeExtensions.vitals

      # Fonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
      open-sans
      source-sans
      jetbrains-mono # has ligatures

      # Command line
      age
      bat
      btop
      btrfs-progs
      ffmpeg
      file
      fzf
      gh
      git
      hunspell # libreoffice spellcheck
      hunspellDicts.en-us
      libheif
      libsecret # for github auth
      libva-utils # vaainfo, check on VAAPI (hw acceleration)
      lm_sensors # for `sensors` command
      lsd # ls replacement with icons
      lsof
      lsscsi
      ltrace # library call monitoring
      mtr # ping + tracert TUI
      neofetch
      nil # Nix language server for vscode
      nixpkgs-fmt # Nix formatter
      nmap
      p7zip
      parted
      pciutils # lspci
      ripgrep # recursively searches directories for a regex pattern
      smartmontools
      socat
      ssh-to-age
      sops
      strace # system call monitoring
      sysstat
      tree
      unzip
      usbutils # lsusb
      which
      xz
      yt-dlp
      zip
      zstd
    ];

  # Application-specific config
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ls = "lsd";
        grep = "grep --color=auto";
      };
    };

    home-manager.enable = true;

    # git = {
    #   enable = true;
    #   userEmail = "29305375+extrange@users.noreply.github.com";
    #   userName = "extrange";
    # };

    # Prettier shell prompt
    starship.enable = true;

    # ssh = {
    #   enable = true;
    #   # ~.ssh/config
    #   matchBlocks = let hostname = "ssh.nicholaslyz.com"; in {
    #     server = {
    #       host = "server ${hostname}";
    #       inherit hostname;
    #       port = 39483;
    #       user = "user";
    #     };
    #     chanel = let hostname = "chanel-server.tail14cd7.ts.net"; in {
    #       host = "chanel ${hostname}";
    #       inherit hostname;
    #       user = "chanel";
    #     };
    #   };
    # };
  };

  # Gnome settings
  # Run `dconf watch /` and change a setting to find its path
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/mutter" = {
      # Snap windows to top/horizontal edges
      edge-tiling = true;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = mkUint32 1700;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    # Set Alt-Tab to switch between windows, instead of applications
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = "@as []";
      switch-windows = [ "<alt>Tab" ];
    };

    # Open terminal with Ctrl + Alt + T
    # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
    #   binding = "<Control><Alt>t";
    #   command = "kgx";
    #   name = "Launch terminal";
    # };
    # "org/gnome/settings-daemon/plugins/media-keys" = {
    #   custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    # };

    # Show thumbnails on SSH drives
    "org/gnome/nautilus/preferences" = {
      show-image-thumbnails = "always";
    };

    "org/gnome/shell" = {
      # Setup dash shortcuts
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "com.logseq.Logseq.desktop"
        "code.desktop"
        "org.telegram.desktop.desktop"
        "org.gnome.Console.desktop"
      ];

      # Enable extensions
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
        "fullscreen-avoider@noobsai.github.com"
        "gsconnect@andyholmes.github.io"
        "tailscale-status@maxgallup.github.com"
        "Vitals@CoreCoding.com"
      ];

    };

    # Background
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/user/.config/background";
      picture-uri-dark = "file:///home/user/.config/background";
      picture-options = "zoom";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      show-trash = false;
    };

    "org/gnome/Console" = {
      use-system-font = false;
      custom-font = "JetBrainsMonoNL Nerd Font 12";
    };
  };

  # Run as user, ivo possible permission issues if run as system
  services.syncthing.enable = true;

  home.stateVersion = "24.05";
}
