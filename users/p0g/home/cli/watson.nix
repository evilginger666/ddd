{
  programs.watson = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      options = {
        confirm_new_project = true;
        confirm_new_tag = true;
        stop_on_start = true;
      };
    };
  };
}

