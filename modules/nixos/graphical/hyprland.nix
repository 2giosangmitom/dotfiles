{pkgs, ...}: {
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";

  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    grimblast
    swww
    wl-clipboard
  ];

  programs.light.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
  programs.xwayland.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland xdg-desktop-portal-gtk];
  };
}
