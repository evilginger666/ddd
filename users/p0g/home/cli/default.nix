{ pkgs, ... }: {
  imports = [
    ./nvim
    ./bat.nix
    ./fish.nix
    ./git.nix
    ./nix-index.nix
    ./shellcolor.nix
    ./ssh.nix
    ./starship.nix
    ./taskwarrior.nix
    ./watson.nix
  ];
  home.packages = with pkgs; [
    ncdu # TUI disk usage
    exa # Better ls
    nnn # File manager
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    jq # JSON pretty printer and manipulator

    rnix-lsp # Nix LSP
    nixfmt # Nix formatter
    deadnix # Nix dead code locator
    statix # Nix linter
  ];
}
