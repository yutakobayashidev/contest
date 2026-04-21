{
  description = "AtCoder Python workspace";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks.flakeModule
      ];

      perSystem =
        { system, config, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = import ./nix;
          };
          python = pkgs.python312;
        in
        {
          _module.args.pkgs = pkgs;

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              mdformat.enable = true;
              ruff-format.enable = true;
            };
            settings.global.excludes = [
              ".git/**"
              "*.lock"
            ];
          };

          pre-commit = {
            check.enable = false;
            settings.hooks = {
              treefmt = {
                enable = true;
                package = config.treefmt.build.wrapper;
              };
              git-secrets = {
                enable = true;
                entry = "${pkgs.git-secrets}/bin/git-secrets --pre_commit_hook";
                language = "system";
                stages = [ "pre-commit" ];
                excludes = [ "^\\.direnv/" ];
              };
            };
          };

          formatter = config.treefmt.build.wrapper;

          devShells.default = pkgs.mkShell {
            packages = [
              python
              config.treefmt.build.wrapper
              pkgs.coreutils
              pkgs.uv
              pkgs.ruff
              pkgs.ty
              pkgs.online-judge-tools
              pkgs.atcoder-cli
              pkgs.aclogin
            ];

            shellHook = ''
              ${config.pre-commit.installationScript}

              export PYTHONUTF8=1
              export PYTHONDONTWRITEBYTECODE=1
              export ROOT="$PWD"
              export UV_PROJECT_ENVIRONMENT="$PWD/.venv"

              if command -v acc >/dev/null && command -v oj >/dev/null; then
                acc_config_dir="$(acc config-dir)"
                [ -e "$acc_config_dir" ] && rm -rf "$acc_config_dir"
                ln -s "$ROOT/acc-config" "$acc_config_dir"
                acc config oj-path "$(command -v oj)" >/dev/null 2>&1 || true
              fi
            '';
          };
        };
    };
}
