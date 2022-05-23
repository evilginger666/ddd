{ inputs, lib, config, hostname, graphical, ... }:
{
  imports = [
    ./cli
    ./rice
    ]
    ++ (if graphical then [ ./desktop-sway ] else [ ]);
}

