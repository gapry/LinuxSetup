{ pkgs, ... }:

let
  glances = pkgs.glances.overridePythonAttrs (old: {
    dependencies = builtins.filter
      (dep: (dep.pname or "") != "python-jose")
      old.dependencies;
    pythonRemoveDeps = (old.pythonRemoveDeps or [ ]) ++ [ "python-jose" ];
    doCheck = false;
  });
in
{
  home.packages = [
    glances
  ];
}
