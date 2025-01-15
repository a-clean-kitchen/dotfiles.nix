{ config, pkgs, lib, ... }: {

  config = lib.mkIf config.physical {

    networking = {
      useNetworkd = lib.mkForce true;
      networkmanager = {
        enable = true;
        # dhcp = "dhcpcd";
      };
    };

    systemd.services = {
      # NetworkManager-wait-online.enable = lib.mkForce false;
      systemd-networkd-wait-online.enable = lib.mkForce false;
    };

    # environment.systemPackages = with pkgs; [
    #   networkmanager
    # ];

    networking.firewall.allowPing = lib.mkIf config.server true;

    # DNS service discovery
    # services.avahi = {
    #   enable = true;
    #   domainName = "local";
    #   ipv6 = false; # Should work either way
    #   # Resolve local hostnames using Avahi DNS
    #   nssmdns4 = true;
    #   publish = {
    #     enable = true;
    #     addresses = true;
    #     domain = true;
    #     workstation = true;
    #   };
    # };
  };

}
