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
      inputs.nixpkgs.curl
      inputs.nixpkgs.docker
      inputs.nixpkgs.docker-compose
      inputs.nixpkgs.envsubst
      inputs.nixpkgs.gnutar
    ];
  };
  entrypoint = ./entrypoint.sh;
}
