{
  pkgs,
  lib,
  config,
  ...
}:
with builtins; {
  home.packages = with pkgs; [swaylock-effects];

  programs.swaylock = {
    settings = {
      image = "/home/interfiber/.df/hosts/celeste/modules/swaylock_image.png";
      clock = true;
      color = "00000000";
      font = "JetBrainsMono Nerd Font Mono";
      show-failed-attempts = false;
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 20;
      line-color = "#181825";
      ring-color = "#1e1e2e";
      inside-color = "#181825";
      key-hl-color = "#cba6f7";
      separator-color = "00000000";
      text-color = "#cdd6f4";
      text-caps-lock-color = "";
      line-ver-color = "#cba6f7";
      ring-ver-color = "#cba6f7";
      inside-ver-color = "#181825";
      text-ver-color = "#cdd6f4";
      ring-wrong-color = "#f38ba8";
      text-wrong-color = "#f38ba8";
      inside-wrong-color = "#181825";
      inside-clear-color = "#181825";
      text-clear-color = "#cdd6f4";
      ring-clear-color = "#cba6f7";
      line-clear-color = "#181825";
      line-wrong-color = "#181825";
      bs-hl-color = "#f38ba8";
      line-uses-ring = false;
      datestr = "%d.%m";
      ignore-empty-password = true;
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
    ];

    timeouts = [
      {
        timeout = 60;
        command = "${pkgs.libnotify}/bin/notify-send \"Locking screen in 20 seconds!\"";
      }
      {
        timeout = 80;
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
      {
        timeout = 100;
        command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
      }
    ];
  };

  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
}
