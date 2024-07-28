# Chanel's NixOS Configuration

## Installation

> [!IMPORTANT]
> Before installing anything, back up your existing configuration:
>
> - Firefox profiles
> - `/etc/fstab` (if applicable)
> - `nm-cli` connections (if applicable)

Boot into the NixOS [installer].

Then, run:

```text
$ sudo -i
# source <(curl -s https://raw.githubusercontent.com/extrange/chanel-nixos/main/setup.sh)
```

Once installation is completed successfully, reboot.

## Post Install

- Setup a password for your account: `su root`, then `passwd chanel`. This will enable `sudo`.
- [Add your SSH key to Github][ssh-key].
  - Subsequently, clone packages with ssh, not https. E.g. `git clone git@github.com:extrange/chanel-nixos.git`
- `git push` changes to `hardware-configuration.nix` for the respective host
- Copy over previous Firefox profile
- Setup logins (these can't be declaratively set)
  - Tailscale (Auth Key max expiry is 90 days)
  - Telegram
  - Whatsapp
- Syncthing: configure folders, add device to server
- GSConnect pairing
- VSCode settings sync (note: due to [automatic login], the keyring is not unlocked. However, it is possible to use a insecure storage and disable the [password].)
- Virtual Machine Manager: download Windows ISO to create Windows guest. Create and [share folder with windows guest].
- Calibre: install DeDRM plugin

## Configuring

Edit `home.nix` and `system.nix` as necessary. Don't edit `hardware-configuration.nix` - this was automatically generated for your machine, and is specific for it.

`home.nix` is where settings specific for the user are kept. This is actually managed by a separate NixOS module called [home-manager]. You can see options [here][home-manager-options].

After that:

- To test (this will not persist changes across boots): `sudo nixos-rebuild test --flake path:.#chanel`
- To switch (write to boot record, will persist across boots): `sudo nixos-rebuild switch --flake path:.#chanel`
- To update the lockfile: `nix flake update`
- To test in a VM: `sudo nixos-rebuild build-vm --flake path:.#chanel`
- 20240728: To allow install of insecure/ EOL pkgs (e.g. electron for logseq): `sudo NIXPKGS_ALLOW_INSECURE=1 nixos-rebuild switch --flake path:. --impure`


## References

To find packages/option names, head to <https://search.nixos.org>.

An explanation of common options (for the system, or `system.nix`) is [here][nixos-config].

To learn about the Nix language, check out <https://nix.dev/tutorials/nix-language.html>.

To learn more about Nix in general, see <https://nixos.org/manual/nix/stable>.

[ssh-key]: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
[installer]: https://channels.nixos.org/nixos-23.11/latest-nixos-minimal-x86_64-linux.iso
[automatic login]: https://askubuntu.com/questions/1352398/asking-for-password-when-i-open-vscode-for-the-first-time
[password]: https://askubuntu.com/questions/24770/gnome-keyring-keeps-asking-for-a-password-that-doesnt-exist/24773#24773
[share folder with windows guest]: https://www.debugpoint.com/kvm-share-folder-windows-guest/
[nixos-config]: https://nixos.org/manual/nixos/stable/#ch-configuration
[home-manager]: https://nix-community.github.io/home-manager/
[home-manager-options]: https://nix-community.github.io/home-manager/options.xhtml