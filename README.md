# bun-nix

Nix flake to for [bun.sh](https://bun.sh). A fast NodeJS runtime

## Usage

This `bun` `nix` flake assumes you have already [installed nix](https://determinate.systems/posts/determinate-nix-installer)

### Option 1. Use the `bun` CLI within your own flake

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.bun.url = "github:rupurt/bun-nix";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    bun,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            bun.overlay
          ];
        };
      in rec
      {
        packages = {
          # to use a specific version tag
          # bun = pkgs.bun_1_1_11 {};
          #
          # to use a version not exported from this package
          # - get the sha256 for your host `nix hash to-sri --type sha256 $(nix-prefetch-url --unpack https://github.com/oven-sh/bun/releases/download/bun-v1.0.9/bun-linux-x64.zip)`
          # - pass the specialArgs overrides
          # bun = pkgs.bun {
          #   specialArgs = {
          #     version = "1.0.9";
          #     shas = {
          #       x86_64-linux = "sha256-R3l30NssWzt18cRZAidLLsBBBtV3NaCUm8dl4kMvIck="
          #     };
          #   };
          # };
          bun = pkgs.bun {};
        };

        devShells.default = pkgs.mkShell {
          packages = [
            packages.bun
          ];
        };
      }
    );
}
```

The above config will add `bun` to your dev shell and also allow you to execute it
through the `nix` CLI utilities.

```sh
# run from devshell
nix develop -c $SHELL
bun --version
```

```sh
# run as application
nix run .#bun -- --version
```

### Option 2. Run the `bun` CLI directly with `nix run`

```nix
nix run github:rupurt/bun-nix -- --version
```

## Authors

- Alex Kwiatkowski - alex+git@fremantle.io

## License

`bun-nix` is released under the MIT license
