{pkgs, ...}: {
  gtk = {
    enable = true;

    cursorTheme = {
      package = pkgs.vimix-cursor-theme;
      name = "Vimix-Cursors";
      size = 24;
    };

    font = {
      name = "Roboto";
      size = 12;
    };

    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela-dark";
    };
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      size = 24;
      package = pkgs.vimix-cursor-theme;
      name = "Vimix-Cursors";
    };
  };
}
