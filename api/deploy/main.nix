{
  inputs,
  makeScript,
  ...
}:
makeScript {
  name = "api-deploy";
  replace = {
    __argApiDeploy__ = ./.;
  };
  searchPaths = {
    bin = [
      inputs.nixpkgs.docker
      inputs.nixpkgs.git
      inputs.nixpkgs.gnugrep
      inputs.nixpkgs.heroku
      inputs.nixpkgs.jq
    ];
  };
  entrypoint = ./entrypoint.sh;
}
