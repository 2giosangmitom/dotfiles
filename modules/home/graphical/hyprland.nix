{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ", preferred, auto, 1";
      env = [
        "XCURSOR_THEME,Vimix-Cursors"
        "HYPRCURSOR_THEME,Vimix-Cursors"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];
      general = {
        border_size = 2;
        gaps_in = 5;
        gaps_out = 10;
        gaps_workspaces = 0;
        "col.inactive_border" = "rgb(313244)";
        "col.active_border" = "rgb(94e2d5)";
        "col.nogroup_border" = "rgb(313244)";
        "col.nogroup_border_active" = "rgb(94e2d5)";
        layout = "dwindle";
        no_focus_fallback = true;
        resize_on_border = true;
      };
      group = {
        "col.border_active" = "rgb(94e2d5)";
        "col.border_inactive" = "rgb(313244)";
        "col.border_locked_active" = "rgb(94e2d5)";
        "col.border_locked_inactive" = "rgb(313244)";
      };
      decoration = {
        rounding = 1;
        shadow = {
          enabled = true;
        };
        blur = {
          enabled = false;
          xray = true;
          special = true;
          new_optimizations = true;
          size = 10;
          passes = 2;
          brightness = 1;
          noise = 0.01;
          contrast = 1;
          popups = true;
          popups_ignorealpha = 0.6;
        };
        dim_inactive = false;
      };
      input = {
        kb_layout = "us";
        numlock_by_default = true;
        scroll_method = "2fg";
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };
      };
      gestures = {
        workspace_swipe = false;
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master = {
        new_status = "slave";
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        font_family = "Roboto";
        force_default_wallpaper = 0;
        disable_autoreload = true;
      };
      cursor = {
        no_hardware_cursors = true;
        hide_on_key_press = false;
      };
      animations = {
        enabled = true;
        first_launch_animation = false;
        bezier = [
          "easein,0.1, 0, 0.5, 0"
          "easeinback,0.35, 0, 0.95, -0.3"
          "easeout,0.5, 1, 0.9, 1"
          "easeoutback,0.35, 1.35, 0.65, 1"
          "easeinout,0.45, 0, 0.55, 1"
        ];
        animation = [
          "fadeIn,1,2,easeout"
          "fadeLayersIn,1,3,easeoutback"
          "layersIn,1,3,easeoutback,slide"
          "windowsIn,1,3,easeoutback,slide"
          "fadeLayersOut,1,3,easeinback"
          "fadeOut,1,3,easein"
          "layersOut,1,3,easeinback,slide"
          "windowsOut,1,3,easeinback,slide"
          "border,1,3,easeout"
          "fadeDim,1,3,easeinout"
          "fadeShadow,1,3,easeinout"
          "fadeSwitch,1,3,easeinout"
          "windowsMove,1,3,easeoutback"
          "workspaces,1,2.6,easeoutback,slide"
        ];
      };
      "$mod" = "SUPER";
      bind = [
        # Useful binds
        "$mod,Return,exec,kitty"
        "$mod,Q,killactive"
        "$mod,Space,togglefloating"
        "$mod,P,pseudo"
        "$mod,J,togglesplit"
        "$mod SHIFT,C,exec,hyprctl reload"
        ", Print, exec, grimblast --notify copy output"
        "SHIFT,Print,exec,grimblast --notify --freeze copy area"

        # Move focus with mod + [hjkl]
        "$mod,h,movefocus,l"
        "$mod,l,movefocus,r"
        "$mod,k,movefocus,u"
        "$mod,j,movefocus,d"

        # Switch workspaces with mod + [0-9]
        "$mod,1,workspace,1"
        "$mod,2,workspace,2"
        "$mod,3,workspace,3"
        "$mod,4,workspace,4"
        "$mod,5,workspace,5"
        "$mod,6,workspace,6"
        "$mod,7,workspace,7"
        "$mod,8,workspace,8"
        "$mod,9,workspace,9"
        "$mod,0,workspace,10"

        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT,1,movetoworkspacesilent,1"
        "$mod SHIFT,2,movetoworkspacesilent,2"
        "$mod SHIFT,3,movetoworkspacesilent,3"
        "$mod SHIFT,4,movetoworkspacesilent,4"
        "$mod SHIFT,5,movetoworkspacesilent,5"
        "$mod SHIFT,6,movetoworkspacesilent,6"
        "$mod SHIFT,7,movetoworkspacesilent,7"
        "$mod SHIFT,8,movetoworkspacesilent,8"
        "$mod SHIFT,9,movetoworkspacesilent,9"
        "$mod SHIFT,0,movetoworkspacesilent,10"

        # Swap window with mod + SHIFT + [hjkl]
        "$mod SHIFT,l,swapwindow,r"
        "$mod SHIFT,h,swapwindow,l"
        "$mod SHIFT,j,swapwindow,d"
        "$mod SHIFT,k,swapwindow,u"

        # Special workspace (scratchpad)
        "$mod,S,togglespecialworkspace,magic"
        "$mod SHIFT,S,movetoworkspace,special:magic"
      ];
      bindel = [
        # Laptop function keys
        ",XF86MonBrightnessUp,exec,light -A 10"
        ",XF86MonBrightnessDown,exec,light -U 10"
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
      bindm = [
        # Move/resize windows with mod + LMB/RMB and dragging
        "$mod,mouse:272,movewindow"
        "$mod,mouse:273,resizewindow"
      ];
      windowrule = [
        "float,title:^(Open File)(.*)$"
        "float,title:^(Select a File)(.*)$"
        "float,title:^(File Upload)(.*)$"
        "center,title:^(Save As)(.*)$"
      ];
      windowrulev2 = [
        # Ignore maximize requests from apps
        "suppressevent maximize, class:.*"

        # Smart gaps
        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "rounding 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"
      ];
      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];
    };
  };
}
