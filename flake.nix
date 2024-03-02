{
  description = "Chanel's NixOS Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, self, ... }:
    with builtins;
    {
      nixosConfigurations =
        # Get hostnames by reading folder name in hosts/
        (
          mapAttrs # https://nixos.org/manual/nix/stable/language/builtins.html#builtins-mapAttrs
            (hostname: _: nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                ./system.nix
                ./hosts/${hostname}/hardware-configuration.nix
                home-manager.nixosModules.home-manager
                { config._module.args = { inherit hostname self; }; }
                {
                  home-manager.users.chanel = import ./home.nix;
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                }
              ];
            })
            (readDir ./hosts) # https://nixos.org/manual/nix/stable/language/builtins.html#builtins-readDir
        );
    };
}
