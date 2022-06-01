{outputs, ...}: {
  lintPython = {
    modules = {
      api = {
        searchPaths.source = [outputs."/api/env"];
        python = "3.9";
        src = "/api/src";
      };
    };
  };
}
