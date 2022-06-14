{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "$SHELL -l";
        user = "p0g";
      };
      default_session = initial_session;
    };
  };
}
