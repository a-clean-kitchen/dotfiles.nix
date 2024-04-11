{ config, lib, pkgs, ... }:

{
  options = {
    passwordHash = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Password created with mkpasswd -m sha-512";
      default = null;
      # Test it by running: mkpasswd -m sha-512 --sal "PZYiMGmJIIHAepTM"
    };
  };

  config = {
    users.users.${config.user} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      hashedPassword = config.passwordHash;
    };
  };
}
