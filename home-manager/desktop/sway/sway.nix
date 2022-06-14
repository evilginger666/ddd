{ lib, pkgs, config, ... }:

let
  # Programs
  grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
  kitty = "${config.programs.kitty.package}/bin/kitty";
  light = "${pkgs.light}/bin/light";
  makoctl = "${pkgs.mako}/bin/makoctl";
  nvim = "${pkgs.neovim}/bin/nvim";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  pass-wofi = "${pkgs.pass-wofi.override {pass = config.programs.password-store.package;}}/bin/pass-wofi";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  preferredplayer = "${pkgs.preferredplayer}/bin/preferredplayer";
  qutebrowser = "${pkgs.qutebrowser}/bin/qutebrowser";
  slurp = "${pkgs.slurp}/bin/slurp";
  swayfader = "${pkgs.swayfader}/bin/swayfader";
  swayidle = "${pkgs.swayidle}/bin/swayidle";
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  wofi = "${pkgs.wofi}/bin/wofi";
  zathura = "${pkgs.zathura}/bin/zathura";

  inherit (config.colorscheme) colors;
  modifier = "Mod1";
  terminal = kitty;
in {
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
    config = {
      inherit modifier terminal;
      menu = "${wofi} -S run";
      fonts = {
        names = [ config.fontProfiles.regular.family ];
        size = 12.0;
      };
      output = {
        "eDP-1" = {
          bg = "${config.wallpaper} fill";
          pos = "0 1200";
        };
        "DP-3" = {
          bg = "${config.wallpaper} fill";
          pos = "0 0";
        };

      };
      defaultWorkspace = "workspace number 1";
      input = {
        "*" = { xkb_options = "caps:swapescape"; };
      };
      gaps = {
        horizontal = 5;
        inner = 10;
      };
      floating.criteria = [
        { app_id = "zenity"; }
        { class = "net-runelite-launcher-Launcher"; }
      ];
      colors = {
        focused = {
          border = "${colors.base0C}";
          background = "${colors.base00}";
          text = "${colors.base05}";
          indicator = "${colors.base09}";
          childBorder = "${colors.base0C}";
        };
        focusedInactive = {
          border = "${colors.base03}";
          background = "${colors.base00}";
          text = "${colors.base04}";
          indicator = "${colors.base03}";
          childBorder = "${colors.base03}";
        };
        unfocused = {
          border = "${colors.base02}";
          background = "${colors.base00}";
          text = "${colors.base03}";
          indicator = "${colors.base02}";
          childBorder = "${colors.base02}";
        };
        urgent = {
          border = "${colors.base09}";
          background = "${colors.base00}";
          text = "${colors.base03}";
          indicator = "${colors.base09}";
          childBorder = "${colors.base09}";
        };
      };
      startup = [
        # Initial lock
        { command = "${swaylock} -i ${config.wallpaper}"; }
        # Start idle daemon
        { command = "${swayidle} -w"; }
        # Add transparency
        { command = "SWAYFADER_CON_INAC=0.90 ${swayfader}"; }
      ];
      bars = [ ];
      window = {
        border = 2;
        commands = [
          {
            command = "move scratchpad";
            criteria = { title = "Wine System Tray"; };
          }
          {
            command = "inhibit_idle fullscreen";
            criteria = { app_id = "__focused__"; };
          }
          {
            command = "move scratchpad";
            criteria = { title = "Firefox — Sharing Indicator"; };
          }
        ];
      };
      keybindings = lib.mkOptionDefault {
        # Focus parent or child
        "${modifier}+bracketleft" = "focus parent";
        "${modifier}+bracketright" = "focus child";

        # Layout types
        "${modifier}+s" = "layout stacking";
        "${modifier}+t" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        # Splits
        "${modifier}+minus" = "split v";
        "${modifier}+backslash" = "split h";

        # Scratchpad
        "${modifier}+u" = "scratchpad show";
        "${modifier}+Shift+u" = "move scratchpad";

        # Move entire workspace
        "${modifier}+Mod4+h" = "move workspace to output left";
        "${modifier}+Mod4+Left" = "move workspace to output left";
        "${modifier}+Mod4+l" = "move workspace to output right";
        "${modifier}+Mod4+Right" = "move workspace to output right";


        # Pass wofi menu
        "Scroll_Lock" = "exec ${pass-wofi}"; # fn+k
        "XF86Calculator" = "exec ${pass-wofi}"; # fn+f12

        # Lock screen
        "XF86Launch5" = "exec ${swaylock} -i ${config.wallpaper}"; # lock icon on k70
        "XF86Launch4" = "exec ${swaylock} -i ${config.wallpaper}"; # fn+q
        "${modifier}+p" = "exec ${swaylock} -i ${config.wallpaper}"; # fn+f7

        # Volume
        "XF86AudioRaiseVolume" =
          "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" =
          "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
        "Shift+XF86AudioMute" =
          "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86AudioMicMute" =
          "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";

        # Media
        "XF86AudioNext" =
          "exec player=$(${preferredplayer}) && ${playerctl} next --player $player";
        "XF86AudioPrev" =
          "exec player=$(${preferredplayer}) && ${playerctl} previous --player $player";
        "XF86AudioPlay" =
          "exec player=$(${preferredplayer}) && ${playerctl} play-pause --player $player";
        "XF86AudioStop" =
          "exec player=$(${preferredplayer}) && ${playerctl} stop --player $player";
        "Shift+XF86AudioPlay" =
          "exec player=$(${playerctl} -l | ${wofi} -S dmenu) && ${preferredplayer} $player";
        "Shift+XF86AudioStop" = "exec ${preferredplayer} none";

        # Notifications
        "${modifier}+w" = "exec ${makoctl} dismiss";
        "${modifier}+shift+w" = "exec ${makoctl} dismiss -a";
        "${modifier}+control+w" = "exec ${makoctl} invoke";

        # Programs
        "${modifier}+v" = "exec ${terminal} $SHELL -i -c ${nvim}";
        "${modifier}+b" = "exec ${qutebrowser}";
        "${modifier}+z" = "exec ${zathura}";

        # Screenshot
        "Print" = "exec ${grimshot} --notify copy output";
        "Shift+Print" = "exec ${grimshot} --notify copy active";
        "Control+Print" = "exec ${grimshot} --notify copy screen";
        "Mod4+Print" = "exec ${grimshot} --notify copy area";
        "${modifier}+Print" = "exec ${grimshot} --notify copy window";

        # Application menu
        "${modifier}+x" = "exec ${wofi} -S drun -x 10 -y 10 -W 25% -H 60%";

        # Full screen across monitors
        "${modifier}+shift+f" = "fullscreen toggle global";
      };
    };
    # https://github.com/NixOS/nixpkgs/issues/119445#issuecomment-820507505
    extraConfig = ''
      exec dbus-update-activation-environment WAYLAND_DISPLAY
      exec systemctl --user import-environment WAYLAND_DISPLAY
    '';
  };

  programs.zsh.loginExtra = lib.mkBefore ''
    if [[ "$(tty)" == /dev/tty1 ]]; then
      exec sway &> /dev/null
    fi
  '';
  programs.fish.loginShellInit = lib.mkBefore ''
    if test (tty) = /dev/tty1
      exec sway &> /dev/null
    end
  '';
  programs.bash.profileExtra = lib.mkBefore ''
    if [[ "$(tty)" == /dev/tty1 ]]; then
      exec sway &> /dev/null
    fi
  '';

  home.packages = [ primary-xwayland-pkg ];

}
