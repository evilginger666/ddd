{
  programs.taskwarrior = {
    enable = true;
    config = {
      confirmation = false;
      report.minimal.filter = "status:pending";
    };
  };
}
