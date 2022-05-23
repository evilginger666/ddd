{ pkgs, ... }: {
  imports = [
    ./nvim
    ./amfora.nix
    ./bat.nix
    ./fish.nix
    ./git.nix
    ./neofetch.nix
    ./nix-index.nix
    ./ranger.nix
    ./screen.nix
    ./shellcolor.nix
    ./ssh.nix
    ./starship.nix
  ];
  home.packages = with pkgs; [
    bottom # System viewer
    ncdu # TUI disk usage
    exa # Better ls
    nnn # File manager
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    jq # JSON pretty printer and manipulator
    tidy-viewer # CSV/TSV pretty printer

    rnix-lsp # Nix LSP
    nixfmt # Nix formatter
    deadnix # Nix dead code locator
    statix # Nix linter
  ];
}
