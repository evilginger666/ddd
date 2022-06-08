{ pkgs, config, ... }:

let
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  pgrep = "${pkgs.procps}/bin/pgrep";

  lockTime = 240;
  isLocked = "${pgrep} -x swaylock";
  actionLock = "${swaylock} -i ${config.wallpaper} --daemonize";
  actionDisplayOff = ''swaymsg "output * dpms off"'';
  actionDisplayOn = ''swaymsg "output * dpms on"'';
in
{
  # Lock after 10 (desktop) or 4 (laptop) minutes
  # After 10 seconds of locked, mute mic
  # After 20 seconds of locked, disable rgb lights and turn monitors off
  # If has PGP, lock it after lockTime/4
  # If has RGB, turn off 20 seconds after locked
  xdg.configFile."swayidle/config".text = ''
    timeout ${toString lockTime} '${actionLock}'

    timeout ${toString (lockTime + 20)} '${actionDisplayOff}' resume  '${actionDisplayOn}'
    timeout 20 '${isLocked} && ${actionDisplayOff}' resume  '${isLocked} && ${actionDisplayOn}'
  '';
}
