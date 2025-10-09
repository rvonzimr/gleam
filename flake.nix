{
  description = "Gleam Environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
          }
        );
    in
    {
      overlays.default = final: prev: rec {
        erlang = final.beam.interpreters.erlang_27;
        pkgs-beam = final.beam.packagesWith erlang;

      };
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              gleam
              erlang
              nil
              nixd
              rebar3
              tailwindcss_4
              tailwindcss-language-server
              nil
              nixd
              nodejs_latest
              just
              overmind

            ];
          };
        }
      );
    };
}
