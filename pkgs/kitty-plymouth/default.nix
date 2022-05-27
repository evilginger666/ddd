{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "kitty-plymouth";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "jongbinjung";
    repo = "plymouth-theme-jijicat";
    rev = "19a1582596bc206147c9c1547789261e8a5e56c8";
    sha256 = "1p7r6wpf7prxjszw2ppdjh4qdpc1bpxdv8wf9yqlfscvvlqnlsd8";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
  mkdir -p $out/share/plymouth/themes/
  cp -r jijicat $out/share/plymouth/themes
  cat jijicat/jijicat.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/jijicat/jijicat.plymouth
  '';
}
