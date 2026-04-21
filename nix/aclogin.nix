final: prev:
let
  pyPkgs = final.python312.pkgs;
in
{
  aclogin = pyPkgs.buildPythonApplication rec {
    pname = "aclogin";
    version = "0.0.1";
    format = "setuptools";

    src = prev.fetchFromGitHub {
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
}
