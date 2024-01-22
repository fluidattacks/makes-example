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
  searchPaths.source = [outputs."/api/env"];
  entrypoint = ./entrypoint.sh;
}
