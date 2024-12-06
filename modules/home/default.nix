{
  imports = [
    ./programs/bash.nix
    ./programs/fastfetch.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/lazygit.nix
    ./programs/starship.nix
    ./programs/yazi.nix

    ./graphical/hyprland.nix
    ./theme.nix
  ];

  home.stateVersion = "24.11";
  home.file."Pictures/backgrounds" = {
    source = ../../backgrounds;
    recursive = true;
  };
  programs.home-manager.enable = true;
}
