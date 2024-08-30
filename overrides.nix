# Overrides/patches. Should be kept to a minimum.
# To override home-manager modules, use home-manager.users.user.<attr>
# For more examples, see my guide:
# https://github.com/extrange/nixos-config/blob/main/useful-commands.md
{ lib, pkgs, ... }:
{
  # Logseq https://github.com/NixOS/nixpkgs/issues/321540
  # This tell nix that only for logseq version 0.10.9, allow the old version of electron
  # Once logseq updates this line will no longer apply
  nixpkgs.config.permittedInsecurePackages = lib.optional (pkgs.logseq.version == "0.10.9") "electron-27.3.11";
}
