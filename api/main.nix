{
  inputs,
  makeScript,
  outputs,
  projectPath,
  ...
}:
makeScript {
  replace = {
    __argApiSrc__ = projectPath "/api/src";
  };
  name = "api";
  searchPaths = {
    bin = [inputs.nixpkgs.python39];
    source = [outputs."/api/env"];
  };
  entrypoint = ./entrypoint.sh;
}
