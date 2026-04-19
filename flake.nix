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
        { pkgs, config, ... }:
        let
          python = pkgs.python312;
          pyPkgs = python.pkgs;

          atcoder-cli = pkgs.buildNpmPackage {
            pname = "atcoder-cli";
            version = "2.2.0";
            nodejs = pkgs.nodejs_20;
            npmInstallFlags = [ "--omit=optional" ];
            npmPruneFlags = [ "--omit=optional" ];

            src = pkgs.fetchFromGitHub {
              owner = "Tatamo";
              repo = "atcoder-cli";
              rev = "f385e71ba270716f5a94e3ed9bd23a24f78799d0";
              hash = "sha256-7pbCTgWt+khKVyMV03HanvuOX2uAC0PL9OLmqly7IWE=";
            };

            npmDepsHash = "sha256-ufG7Fq5D2SOzUp8KYRYUB5tYJYoADuhK+2zDfG0a3ks=";
            npmPackFlags = [ "--ignore-scripts" ];
            NODE_OPTIONS = "--openssl-legacy-provider";
          };

          aclogin = pyPkgs.buildPythonApplication rec {
            pname = "aclogin";
            version = "0.0.1";
            format = "setuptools";

            src = pkgs.fetchFromGitHub {
              owner = "key-moon";
              repo = "aclogin";
              rev = "e461311c0326578b16d1488be84261f4b24f6134";
              hash = "sha256-kyU7KpFenFb7obwSrDp6dPfuE+36r0BGYerrJj3+EyA=";
            };

            propagatedBuildInputs = with pyPkgs; [
              appdirs
              requests
              setuptools
            ];
          };
        in
        {
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
              atcoder-cli
              aclogin
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
