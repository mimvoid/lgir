{
  description = "Flake for lgir";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      allSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
      toSystems = passPkgs: allSystems (system: passPkgs (import nixpkgs { inherit system; }));

      overlays = import ./nix/overlays.nix;
    in
    {
      inherit overlays;

      devShells = toSystems (pkgs: {
        default =
          let
            inherit (overlays.lgiUnstable { } pkgs) luajit;
            luaEnv = luajit.withPackages (
              ps: with ps; [
                xml2lua
                inspect # for debugging
                lgi-unstable
              ]
            );
          in
          pkgs.mkShell {
            name = "lgir";

            nativeBuildInputs = [ pkgs.pkg-config ];
            packages = builtins.attrValues {
              inherit (pkgs) glib gobject-introspection lua-language-server;
              inherit luaEnv;
            };

            shellHook = ''
              export LUA_LS_PATH='${luaEnv}/share/lua/5.1'

              # For whatever reason, lua doesn't include relative directories by default
              export LUA_PATH="./?/init.lua;;"
            '';
          };
      });
    };
}
