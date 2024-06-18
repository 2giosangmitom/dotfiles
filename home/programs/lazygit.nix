{
  programs.lazygit = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      gui = {
        windowSize = "normal";
        sidePanelWidth = 0.25;
        language = "en";
        showRandomTip = false;
        showBottomLine = false;
      };
      os = {
        editPreset = "nvim";
      };
    };
  };
}
