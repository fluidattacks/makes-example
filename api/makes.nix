{
  inputs,
  outputs,
  makePythonPyprojectPackage,
  projectPath,
  ...
}: {
  lintPython = {
    modules = {
      api = {
        searchPaths.source = [outputs."/api/env"];
        src = "/api/src";
      };
    };
  };
  lintWithLizard = {
    api = ["/api/src"];
  };
  securePythonWithBandit = {
    api.target = "/api/src";
  };
}
