{
  programs.bash = {
    enable = true;
    historySize = 1000;
    historyControl = ["ignoreboth"];
    historyIgnore = ["ls"];
    shellAliases = {
      cat = "bat";
    };
  };

  programs.bat = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    enableBashIntegration = true;
    extraOptions = [
      "--group"
      "--group-directories-first"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}
