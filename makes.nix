{fetchNixpkgs, ...}: {
  cache = {
    readNixos = true;
    extra = {
      makes = {
        enable = true;
        pubKey = "makes.cachix.org-1:zO7UjWLTRR8Vfzkgsu1PESjmb6ymy1e4OE9YfMmCQR4=";
        token = "CACHIX_AUTH_TOKEN";
        type = "cachix";
        url = "https://makes.cachix.org";
        write = true;
      };
    };
  };
  formatBash = {
    enable = true;
    targets = ["/"];
  };
  formatMarkdown = {
    enable = true;
    doctocArgs = ["--title" "# Contents"];
    targets = ["/README.md"];
  };
  formatNix = {
    enable = true;
    targets = ["/"];
  };
  formatPython = {
    default = {
      targets = ["/"];
    };
  };
  formatYaml = {
    enable = true;
    targets = ["/"];
  };
  extendingMakesDirs = ["/"];
  imports = [
    ./api/makes.nix
  ];
  inputs = {
    nixpkgs = fetchNixpkgs {
      rev = "32c00dc37042934c79041116383e27f04ad84710";
      sha256 = "sha256-Pe7Wjyzzj+tyxvxlP4JXY1z/vkxIE9i2G4F25+Y0zR0=";
    };
  };
  lintBash = {
    enable = true;
    targets = ["/"];
  };
  lintGitCommitMsg = {
    enable = true;
    config = "/.lint-git-commit-msg/config.js";
    parser = "/.lint-git-commit-msg/parser.js";
  };
  lintGitMailMap = {
    enable = true;
  };
  lintMarkdown = {
    readme = {
      config = "/.lint-markdown/config.rb";
      targets = ["/"];
    };
  };
  lintNix = {
    enable = true;
    targets = ["/"];
  };
}
