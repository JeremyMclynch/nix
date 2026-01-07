
{ pkgs, ... }:
{
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
    networkmanager-openconnect
    ];
  };

  networking.networkmanager.ensureProfiles = {
  profiles.myVpn = {
    connection = {
      id = "NJIT_VPN";
      type = "vpn";
    };
    vpn = rec {
      gateway = "vpn.njit.edu";
      remote = gateway;
      username = "jmm277@njit.edu";
      service-type = "org.freedesktop.NetworkManager.openconnect";
      protocol = "anyconnect";
      useragent = "AnyConnect"; # Or other user-agent if required
      authtype = "password";

      # Optionally, add settings for cookies if needed for web-based prompts
      # cookie = "some_cookie_value";
    };
  };
};


  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
  ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    dnsovertls = "true";
  };
}
