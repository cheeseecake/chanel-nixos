# Overrides/patches. Should be kept to a minimum.
# To override home-manager modules, use home-manager.users.user.<attr>
# For more examples, see my guide:
# https://github.com/extrange/nixos-config/blob/main/useful-commands.md
{ lib, pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      # https://github.com/NixOS/nixpkgs/issues/321540
      logseq = prev.logseq.override {
        electron = final.electron_29;
      };
    })
  ];
}
