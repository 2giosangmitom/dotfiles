{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./common/user.nix
    ./common/networking.nix
    ./common/boot.nix
    ./common/fonts.nix
    ./common/locale.nix
    ./common/sound.nix

    ./programs/docker.nix

    ./graphical/hyprland.nix
  ];

  environment.systemPackages = with pkgs; [
    # softwares I'm using
    brave
    obs-studio
    bleachbit
    yazi
    lazygit
    gh
    vscode-fhs
    git
    kitty
    neovide

    # utilities
    pavucontrol
    fastfetch
    bottom
    bat
    eza
    ripgrep
    tokei
    unzip
    zoxide
    zip
    nix-index
    du-dust
    wget
    xdg-utils
    fd
    curl
    yazi
    starship
    jq
    pciutils

    # libraries
    vips # image processing library
    poppler # pdf rendering library
    ffmpeg

    # dev tools
    cargo
    deno
    bun
    rustc
    go
    nodejs_22
    jdk
    gradle
    clang
    python3
    lua
    gnumake
    just
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.hyprpanel.overlay
  ];
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = true;
      warn-dirty = false;
    };
    package = pkgs.nixVersions.latest;
  };

  programs.git = {
    enable = true;
  };

  system.stateVersion = "24.11";
}
