{
  description = "Nix flake to for bun.sh. A fast NodeJS runtime";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [self.overlay];
      };
    in rec {
      # packages exported by the flake
      packages = rec {
        bun_1_0_12 = pkgs.callPackage ./default.nix {
          inherit pkgs;
          specialArgs = {
            version = "1.0.12";
            shas = {
              aarch64-darwin = "sha256-tGQQEEPBrMx3AuIsJbN0i/xoa7HSf4rNrE6km3NWjHQ=";
              aarch64-linux = "sha256-XWNixXRu+GwLHe3y67QUdZr3+nIq1TFzoKoT0mtwp+c=";
              x86_64-darwin = "sha256-nWh6///ZOHcpm5MGhYozP1fCzT8VqlEWi6plTNhm2rQ=";
              x86_64-linux = "sha256-+EWt1/YtGzJm/lRBPrf1RM5xdMVFMWurRNBQACALcSA=";
            };
          };
        };
        bun_1_0_11 = pkgs.callPackage ./default.nix {
          inherit pkgs;
          specialArgs = {
            version = "1.0.11";
            shas = {
              aarch64-darwin = "sha256-yZp/AFlOVRtZ60865utrtVv0zlerwFMhpqBh26WnfL8=";
              aarch64-linux = "sha256-gc8X6KgNBbbDgRHEdUfrYL0Ff+aIIrkRX+m+MuZcqPs=";
              x86_64-darwin = "sha256-wXF+agHGzFqvJ6rEM5tDPrIEGihYT2Ng1tyYX4s2aQ8=";
              x86_64-linux = "sha256-pT9+GchNC3vmeFgTF0GzzyLzWBrCQcR/DFRVK2CnHCw=";
            };
          };
        };
        bun_1_0_10 = pkgs.callPackage ./default.nix {
          inherit pkgs;
          specialArgs = {
            version = "1.0.10";
            shas = {
              aarch64-darwin = "sha256-xwKNDTlghNkq36wMAKSa+reROqGwMm4dZ/Hfos1zuP4=";
              aarch64-linux = "sha256-gaquYp4q22IJHV7Fx5GxZWVFvJzU30HOmL32lkxJeQ8=";
              x86_64-darwin = "sha256-DPVnTzdGprjZ16kme3Y6xBognjWHt+0N/zk0J3dm8jY=";
              x86_64-linux = "sha256-Er7QiWBhENTa9xhCIVqECCzexWejBwBC59u3CJKQiwc=";
            };
          };
        };
        default = bun_1_0_12;
      };

      # nix run
      apps = {
        bun = flake-utils.lib.mkApp {drv = packages.default;};
        default = apps.bun;
      };

      # nix fmt
      formatter = pkgs.alejandra;

      # nix develop -c $SHELL
      devShells.default = pkgs.mkShell {
        packages = [
          packages.default
        ];
      };
    });
  in
    outputs
    // {
      # Overlay that can be imported so you can access the packages
      # using bunpkgs.default
      overlay = final: prev: {
        bunpkgs = outputs.packages.${prev.system};
      };
    };
}
