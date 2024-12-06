{pkgs, ...}: {
  virtualisation.docker.enable = true;
  users.users.chien.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
