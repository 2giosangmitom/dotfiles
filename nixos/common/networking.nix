{ config, ... }:
{
  networking.hostName = config.dotfiles.hostName;
  networking.proxy.noProxy = "127.0.0.1,localhost";
  networking.nameservers = [
    "8.8.8.8"
    "8.8.4.4"
  ];
}
