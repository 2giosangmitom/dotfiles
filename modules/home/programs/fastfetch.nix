{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = ": ";
      };

      modules = [
        {
          type = "custom";
          format = "  Software";
          outputColor = "cyan";
        }
        {
          type = "custom";
          outputColor = "white";
          format = "┌───────────────────────────────────────────────────┐";
        }
        {
          type = "os";
          key = "   OS";
          keyColor = "red";
        }
        {
          type = "kernel";
          key = "   Kernel";
          keyColor = "red";
        }
        {
          type = "packages";
          key = "  󰏗 Packages";
          keyColor = "green";
        }
        {
          type = "wm";
          key = "   WM";
          keyColor = "yellow";
        }
        {
          type = "terminal";
          key = "   Terminal";
          keyColor = "yellow";
        }
        {
          type = "shell";
          key = "   Shell";
          keyColor = "cyan";
        }
        {
          type = "custom";
          outputColor = "white";
          format = "└───────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "  Hardware";
          outputColor = "cyan";
        }
        {
          type = "custom";
          outputColor = "white";
          format = "┌───────────────────────────────────────────────────┐";
        }
        {
          type = "host";
          key = "   Host";
          keyColor = "yellow";
        }
        {
          type = "cpu";
          format = "{1}";
          key = "   CPU";
          keyColor = "blue";
        }
        {
          type = "gpu";
          format = "{2}";
          key = "   GPU";
          keyColor = "blue";
        }
        {
          type = "memory";
          key = "   Memory";
          keyColor = "magenta";
        }
        {
          type = "disk";
          key = "   Storage";
          format = "{1} / {2} ({3})";
          keyColor = "magenta";
        }
        {
          type = "battery";
          key = "  󰁹 Battery";
          format = "{1} {2} {3} ({4} - {5})";
          keyColor = "yellow";
        }
        {
          type = "command";
          key = "  󱦟 OS Ages";
          keyColor = "cyan";
          text = ''
            birth_install=$(stat -c %W /)
            current=$(date +%s)
            time_progression=$((current - birth_install))
            days_difference=$((time_progression / 86400))
            echo $days_difference days
          '';
        }
        {
          type = "uptime";
          key = "  󱫐 Uptime";
          keyColor = "red";
        }
        {
          type = "custom";
          outputColor = "white";
          format = "└───────────────────────────────────────────────────┘";
        }
        {
          type = "colors";
          paddingLeft = 2;
          symbol = "circle";
        }
        "break"
      ];
    };
  };
}
