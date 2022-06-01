{makePythonPypiEnvironment, ...}:
makePythonPypiEnvironment {
  name = "api-env";
  sourcesYaml = ./pypi-sources.yaml;
}
