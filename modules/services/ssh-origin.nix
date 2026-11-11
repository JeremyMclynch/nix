{ config, ... }:
{
  # Client: send this machine's hostname with every outgoing SSH connection.
  programs.ssh.extraConfig = ''
    Host *
      SetEnv SSH_CLIENT_HOSTNAME=${config.networking.hostName}
  '';

  # Server: accept it, so sessions on this machine see who connected.
  services.openssh.settings.AcceptEnv = [ "SSH_CLIENT_HOSTNAME" ];
}
