{fetchNixpkgs, ...}: {
  cache = {
    readAndWrite = {
      enable = true;
      name = "makes";
      pubKey = "makes.cachix.org-1:zO7UjWLTRR8Vfzkgsu1PESjmb6ymy1e4OE9YfMmCQR4=";
    };
  };
  formatMarkdown = {
    enable = true;
    doctocArgs = ["--title" "## Contents"];
    targets = ["/README.md"];
  };
  formatNix = {
    enable = true;
    targets = ["/"];
  };
  formatPython = {
    enable = true;
    targets = ["/"];
  };
  extendingMakesDirs = ["/"];
  imports = [
    ./api/makes.nix
  ];
  inputs = {
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
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
