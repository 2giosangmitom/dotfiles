{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    grimblast
    swww
    wl-clipboard
    hyprpanel
    rofi-wayland
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
