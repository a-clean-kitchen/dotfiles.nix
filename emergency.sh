#!/nix/store/9nw8b61s8lfdn8fkabxhbz0s775gjhbr-bash-5.2p37/bin/bash
set -e

DOTFILESPATH=/home/qm/wksp/repos/dotfiles

git -C $DOTFILESPATH add --intent-to-add --all

if ! nixos-rebuild build --show-trace --flake $DOTFILESPATH#junkr; then
    echo "Error: NixOS rebuild failed" >&2
    exit 1
fi

resultDir="$DOTFILESPATH/result"
pathToConfig=$(readlink -f $resultDir)
profile=/nix/var/nix/profiles/system

sudo nix-env -p "$profile" --set "$pathToConfig"

cmd=(
    "systemd-run"
    "-E" "LOCALE_ARCHIVE" # Will be set to new value early in switch-to-configuration script, but interpreter starts out with old value
    "-E" "NIXOS_INSTALL_BOOTLOADER="
    "--collect"
    "--no-ask-password"
    "--pipe"
    "--quiet"
    "--service-type=exec"
    "--unit=nixos-rebuild-switch-to-configuration"
    "--wait"
    "$pathToConfig/bin/switch-to-configuration"
    "switch"
)

if ! sudo "${cmd[@]}"; then
    # Switch failed
    exit 1
else
    # Switch succeeded
    echo "$pathToConfig"
fi 
