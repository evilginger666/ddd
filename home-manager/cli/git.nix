{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    aliases = {
      graph = "log --decorate --oneline --graph";
    };
    userName = "Pierre-Olivier Gagne";
    userEmail = "p.olivier.gagne@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      url."https://github.com/".insteadOf = "git://github.com/";
    };
    lfs = { enable = true; };
    ignores = [ ".direnv" "result" ];
  };
  programs.gitui = {
    enable = true;
  };
}
