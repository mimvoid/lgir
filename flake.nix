{
  description = "Flake for luals-gir";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      allSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
      toSystems = passPkgs: allSystems (system: passPkgs (import nixpkgs { inherit system; }));
    in
    {
      devShells = toSystems (pkgs: {
        default =
          let
            luaEnv = pkgs.luajit.withPackages (
              ps: with ps; [
                xml2lua
                inspect # for debugging
              ]
            );
          in
          pkgs.mkShell {
            name = "luals-gir";

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
