#!/usr/bin/env bash

clear

# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
RED='\033[0;31m'
NC='\033[0m' # No Color

nixos_config_dir=/mnt/home/chanel/chanel-nixos
hostname=chanel

# Check if we are running as root
if [[ "$EUID" -ne 0 ]]; then
    printf "Please run as root\n"
    exit 1
fi

# User confirmation
printf "This script will setup a primary Btrfs partition and install Nix."
printf "${RED}All data in %s will be deleted!${NC}\n\n" "$target"
printf "Press \033[1mCtrl+C\033[0m now to abort this script, or wait 5s for the installation to continue.\n\n"
sleep 5

read -rp "Enter target disk (e.g. /dev/sda): " target

if [[ ! -b "$target" ]]; then
    printf "'%s' is not a valid block device, aborting\n" "$target"
    exit 1
fi

# Only accept disks
DEVICE_TYPE=$(lsblk -n -o TYPE "$target")

if [[ ! "$DEVICE_TYPE" =~ "disk" ]]; then
    printf "'%s' is not a disk, aborting\n" "$target"
    exit
fi

do_install() {
    set -euo pipefail

    # Script modified from https://gist.github.com/walkermalling/23cf138432aee9d36cf59ff5b63a2a58

    # Install commandline dependencies
    printf "Installing git...\n"
    nix-env -f '<nixpkgs>' -iA git >/dev/null

    # Clone git repo (required for boot key)
    mkdir -p /tmp/nixos-config
    git clone https://github.com/extrange/chanel-nixos /tmp/nixos-config

    # Create partition table
    parted -s "$target" -- mklabel gpt

    # Create boot partition
    # We leave 1MB of space at the start
    parted -s "$target" -- mkpart ESP fat32 1MiB 512MiB
    parted -s "$target" -- set 1 boot on

    # Create primary partition
    parted -s "$target" -- mkpart primary 512MiB 100%

    boot="${target}1"
    primary="${target}2"

    # Format disks
    mkfs.fat -F 32 -n boot "$boot"
    mkfs.btrfs -f -L nixos "$primary"

    # Create root Btrfs subvolume and mount for installation
    printf "Waiting 5s for /dev/disk/by-label/nixos to appear...\n"
    sleep 5 # wait for by-label to become populated
    mount /dev/disk/by-label/nixos /mnt
    btrfs subvolume create /mnt/root
    umount /mnt
    mount /dev/disk/by-label/nixos -o subvol=root /mnt

    # Mount boot
    mkdir -p /mnt/boot && mount /dev/disk/by-label/boot /mnt/boot

    # Pull latest config, will be preserved on install
    git clone https://github.com/extrange/chanel-nixos "$nixos_config_dir"
    chown -R 1000 "$nixos_config_dir"

    # Generate hardware config
    printf "Generating hardware-configuration.nix...\n"
    nixos-generate-config --root /mnt
    rm /mnt/etc/nixos/configuration.nix

    # Move hardware config
    mv /mnt/etc/nixos/hardware-configuration.nix "$nixos_config_dir"/hosts/"$hostname"

    clear
    lsblk
    printf "Partitioning complete."
    echo

    # +e Don't drop out of root shell on errors
    # +u: Allow unbound variables otherwise tab expansion will fail
    set +euo pipefail

    # Install
    nixos-install --no-root-passwd --flake path:"$nixos_config_dir#$hostname"

}

(
    do_install
)
