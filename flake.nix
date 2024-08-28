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
    with nixpkgs.lib;
    {
      # This builds all derivations here on `nix flake check`.
      # https://github.com/NixOS/nix/issues/7165
      checks =
        let
          # Shape:
          # [
          #   {x86_64-linux: {name = desktop; value = desktopConfig;}}
          #   {x86_64-linux: {name = laptop; value = laptopConfig;}}
          #   ...
          # ]
          systems = mapAttrsToList
            (hostname: type:
              let
                config = self.nixosConfigurations.${hostname}.config.system.build.toplevel;
                system = config.system;
              in
              {
                ${system} = { name = hostname; value = config; };
              })
            (readDir ./hosts);
        in
        # Shape:
          # {x86_64-linux = {desktop = desktopConfig; laptop: laptopConfig;}}
        zipAttrsWith (system: listToAttrs) systems;

      nixosConfigurations =
        # Get hostnames by reading folder name in hosts/
        (
          mapAttrs # https://nixos.org/manual/nix/stable/language/builtins.html#builtins-mapAttrs
            (hostname: _: nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                ./system.nix
                ./hosts/${hostname}/hardware-configuration.nix
                ./overrides.nix

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
