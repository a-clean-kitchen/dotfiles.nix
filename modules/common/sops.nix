{ config, lib, inputs, pkgs, ... }:

let
  cfg = config.secrets.sops;
  
  inherit (lib) mkIf mkOption types;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.sops-nix.nixosModules.sops
  ];

  options.secrets.sops = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable secrets encryption using sops";
    };

    sopsFolder = mkOption {
      type = types.string;
      default = builtins.toString inputs.my-secrets + "/sops";
    };
  };


  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = "${cfg.sopsFolder}/${config.networking.hostName}.host.yaml";
      age = {
        # automatically import host SSH keys as age keys
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };
      secrets = {
        "keys/private" = {
          owner = "root";
          group = "root";
          path = "/etc/ssh/ssh_host_ed25519_key";
        };
        "keys/age" = {
          sopsFile = "${cfg.sopsFolder}/${config.user}.user.yaml";
          owner = config.users.users.${config.user}.name;
          inherit (config.users.users.${config.user}) group;
          # We need to ensure the entire directory structure is that of the user...
          path = "${config.homePath}/.config/sops/age/keys.txt";
        };
        # extract password/username to /run/secrets-for-users/ so it can be used to create the user
        "passwords/${config.user}" = {
          sopsFile = "${cfg.sopsFolder}/${config.user}.user.yaml";
          neededForUsers = true;
        };

      };
    };
    # The containing folders are created as root and if this is the first ~/.config/ entry,
    # the ownership is busted and home-manager can't target because it can't write into .config...
    # FIXME(sops): We might not need this depending on how https://github.com/Mic92/sops-nix/issues/381 is fixed
    system.activationScripts.sopsSetAgeKeyOwnership =
      let
        ageFolder = "${config.homePath}/.config/sops/age";
        user = config.users.users.${config.user}.name;
        group = config.users.users.${config.user}.group;
      in
      ''
        mkdir -p ${ageFolder} || true
        chown -R ${user}:${group} ${config.homePath}/.config
      '';
  };
}
