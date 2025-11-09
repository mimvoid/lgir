{
  lgiUnstable =
    _final: prev:
    let
      overrideLuaPkgs =
        _k: v:
        v.override {
          packageOverrides = _luaFinal: luaPrev: {
            lgi-unstable = luaPrev.lgi.overrideAttrs (attrs: {
              version = "unstable-2024-10-26";

              src = prev.fetchFromGitHub {
                owner = "lgi-devs";
                repo = "lgi";
                rev = "a412921fad445bcfc05a21148722a92ecb93ad06";
                sha256 = "sha256-kZBpH5gcaCNU134Wn6JXAkFELzmiphc1PeCtmN9cagc=";
              };

              patches = [ ];
            });
          };
        };
    in
    builtins.mapAttrs overrideLuaPkgs {
      inherit (prev)
        luajit
        lua5_1
        lua5_2
        lua5_3
        lua5_4
        ;
    };
}
