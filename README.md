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

- [Add your SSH key to Github][ssh-key].
  - Subsequently, clone packages with ssh, not https. E.g. `git clone git@github.com:extrange/chanel-nixos.git`
- `git push` changes to `hardware-configuration.nix` for the respective host
- Pull Firefox profile
- Setup logins (these can't be declaratively set)
  - Tailscale (Auth Key max expiry is 90 days)
  - Telegram
  - Whatsapp
- Syncthing: configure folders, add device to server
- GSConnect pairing
- VSCode settings sync (note: due to [automatic login], the keyring is not unlocked. However, it is possible to use a insecure storage and disable the [password].)

## Configuring

Edit `home.nix` and `system.nix` as necessary. Don't edit `hardware-configuration.nix`.

After that:

- To test (without modifying the default boot config): `sudo nixos-rebuild test --flake path:.#chanel`
- To switch (write to boot record, will become default): `sudo nixos-rebuild switch --flake path:.#chanel`
- To update the lockfile: `nix flake update`
- To test in a VM: `sudo nixos-rebuild build-vm --flake path:.#chanel`

## References

To find packages/option names, head to <https://search.nixos.org>.

To learn about the Nix language, check out <https://nix.dev/tutorials/nix-language.html>.

To learn more about Nix in general, see <https://nixos.org/manual/nix/stable>.

[ssh-key]: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
[installer]: https://channels.nixos.org/nixos-23.11/latest-nixos-minimal-x86_64-linux.iso