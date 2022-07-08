# 🦄 Makes Example

This is the official hands-on example for [Makes][MAKES].

## Why

Being a framework designed
to simplify the development
of secure and high-quality applications,
[Makes][MAKES] comprises a wide range of functionalities
that may feel overwhelming
for those who are just starting
to learn how to use it.

That is why we created an example
that focuses on using the most basic
yet powerful builtins
[Makes][MAKES] has to offer.

This example simulates a
real application with
several deployments a day.

We will show how [Makes][MAKES] is:

### Secure

[<img src="https://img.shields.io/badge/attr-secure-brightgreen.svg" alt="secure">](#secure)

Direct and indirect dependencies
for both applications and CI/CD pipelines
are cryptographically signed,
granting an immutable software supply chain.

### Easy

[<img src="https://img.shields.io/badge/attr-easy-orange.svg" alt="easy">](#easy)

Can be installed with just one command
and has dozens of generic CI/CD builtins.

### Fast

[<img src="https://img.shields.io/badge/attr-fast-blueviolet.svg" alt="fast">](#fast)

Supports a distributed
and completely granular cache.

### Portable

[<img src="https://img.shields.io/badge/attr-portable-violet.svg" alt="portable">](#portable)

Runs on Docker, VM’s,
and any linux-based OS.
Such feature greatly simplifies
the task of running applications
and CI/CD jobs
on both local (developer machines)
and remote (dev, staging, prod) environments.

### Extensible

[<img src="https://img.shields.io/badge/attr-extensible-blue.svg" alt="extensible">](#extensible)

Can be extended
to work with any technology.

## How

We will achieve this by implementing:

1. The [FastAPI example](https://fastapi.tiangolo.com/#example).
1. An isolated, cryptographically-signed environment
   for running our API.
1. Development and production environments
   for our API using [Stackhero][STACKHERO]
   and [Docker Compose][DOCKER_COMPOSE].
1. General purpose linters and formatters
   for ensuring code quality and security.
1. A distributed cache
   for high build performance.
1. A CI/CD workflow using [GitHub Actions][GITHUB_ACTIONS]
   for orchestrating all the previous items.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Contents

- [Prerequisites](#prerequisites)
    - [Concepts](#concepts)
    - [Software](#software)
- [Backbone: Nix and Nixpkgs](#backbone-nix-and-nixpkgs)
- [Running any Makes job](#running-any-makes-job)
- [Running Makes on containers](#running-makes-on-containers)
- [The makes.nix file](#the-makesnix-file)
    - [Example builtin](#example-builtin)
    - [Working with a Nixpkgs version](#working-with-a-nixpkgs-version)
    - [Using imports](#using-imports)
    - [Configuring the cache](#configuring-the-cache)
- [The example API](#the-example-api)
    - [API Source Code](#api-source-code)
    - [API Environment](#api-environment)
    - [API makes.nix](#api-makesnix)
    - [API main.nix](#api-mainnix)
    - [API Deployments](#api-deployments)
- [References](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Prerequisites

## Concepts

Having a **basic** understanding of the following concepts
will probably make this example much easier to grasp.

1. Continuous Integration and Delivery
1. Containers
1. Application dependencies
1. Shell scripting
1. Linters and formatters

Additionally, we will be giving a **very brief** introduction to

1. [Nix][NIX]
1. [Nixpkgs][NIXPKGS]

as they are foundational components of [Makes][MAKES].

## Software

[<img src="https://img.shields.io/badge/attr-easy-orange.svg" alt="easy">](#easy)

You just need to either have
[Makes](https://github.com/fluidattacks/makes#getting-started)
or
[Docker][DOCKER]
installed on your system.

# Backbone: Nix and Nixpkgs

[<img src="https://img.shields.io/badge/attr-secure-brightgreen.svg" alt="secure">](#secure)
[<img src="https://img.shields.io/badge/attr-fast-blueviolet.svg" alt="fast">](#fast)
[<img src="https://img.shields.io/badge/attr-portable-violet.svg" alt="portable">](#portable)

[Makes][MAKES] relies on some core technology in order to work.

[Nix][NIX] is a package manager
that treats packages in a purely functional manner.
Packages are built by functions
that do not have secondary effects.
They never change once built.
It can be be installed on any linux-based OS.

[Makes][MAKES] relies on [Nix][NIX]
to build reproducible and immutable workflows
and environments. It also takes advantage of its
granular cache obtained by having isolated packages.

[Nixpkgs][NIXPKGS]
> is a collection of over 80,000 software packages
> that can be installed with the Nix package manager.
The main advantage of [Nixpkgs][NIXPKGS]
over other package repositories
is that packages are reproducible
and pinned to an exact commit version.
Compiled binaries for such pacakges
are also accesible through `cache.nixos.org`.

[Makes][MAKES] uses [Nixpkgs][NIXPKGS]
for provisioning OS dependencies.

# Running any Makes job

[<img src="https://img.shields.io/badge/attr-easy-orange.svg" alt="easy">](#easy)
[<img src="https://img.shields.io/badge/attr-portable-violet.svg" alt="portable">](#portable)

Makes has the ability
to fetch any repository that supports it,
so you won't have to clone this example.

Locally:

```bash
m github:fluidattacks/makes-example@main
```

Using [Docker][DOCKER]:

```bash
docker run ghcr.io/fluidattacks/makes:22.07 m github:fluidattacks/makes-example@main
```

# Running Makes on containers

[<img src="https://img.shields.io/badge/attr-easy-orange.svg" alt="easy">](#easy)
[<img src="https://img.shields.io/badge/attr-portable-violet.svg" alt="portable">](#portable)
[<img src="https://img.shields.io/badge/attr-extensible-blue.svg" alt="extensible">](#extensible)

As mentioned before,
[Makes][MAKES] also has a [Docker][DOCKER] container.
We can take advantage of this
on [CI/CD providers](https://github.com/fluidattacks/makes#configuring-cicd),
[Kubernetes][KUBERNETES],
[Nomad][NOMAD],
[Stackhero][STACKHERO],
and basically anything that runs containers.

In this example,
we have a development
and a production pipeline
using [GitHub Actions][GITHUB_ACTIONS].
Both of them can be found under `.github/workflows`.

Let's take a look at this job in `.github/workflows/dev.yml`:

```yaml
formatNix:
   runs-on: ubuntu-latest
   steps:
   - uses: actions/checkout@2541b1294d2704b0964813337f33b291d3f8596b
   - uses: docker://ghcr.io/fluidattacks/makes:22.07
      name: /formatNix
      with:
         set-safe-directory: "/github/workspace"
         args: m . /formatNix
```

By looking at this portion of code
we can see that we use the [Makes][MAKES] container to run the
`m . /formatNix` command.

Thanks to this feature
you can make your entire ecosystem reproducible
on any remote environment
that supports containers.

# The makes.nix file

You will find this file in the root of the repository.
According to the [documentation](https://github.com/fluidattacks/makes#makesnix-reference),
In this file you can specify any [builtin](https://github.com/fluidattacks/makes#makesnix-reference)
supported by [Makes][MAKES]
and configure it to run on your project.

## Example builtin

[<img src="https://img.shields.io/badge/attr-easy-orange.svg" alt="easy">](#easy)

Let's review one of the builtins used:

```nix
{
  formatPython = {
    enable = true;
    targets = ["/"];
  };
}
```

The [formatPython](https://github.com/fluidattacks/makes#formatpython) builtin
formats all files
with `.py` extension within the specified path `/`.

Let's try running it!

```bash
$ m github:fluidattacks/makes-example@main /formatPython

                              🦄 Makes
                            v22.07-linux

────────── Fetching github:fluidattacks/makes-example@main ──────────

Initialized empty Git repository in /tmp/makes-rbqvoewj/.git/
remote: Enumerating objects: 26, done.
remote: Counting objects: 100% (26/26), done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 26 (delta 1), reused 20 (delta 0), pack-reused 0
Unpacking objects: 100% (26/26), 9.05 KiB | 713.00 KiB/s, done.
From https://github.com/fluidattacks/makes-example
 * [new branch]      main       -> main
Switched to branch 'main'

────────────────── Building project configuration ───────────────────

/nix/store/2mnjjd4gkzrbyr7g97yl19n2y4zv0hi3-config.json

────────────────────── Building /formatPython ───────────────────────

/nix/store/sdxndxx6b2i7427m34x9b2jys748l6kv-format-python

────────────────────────────── Running ──────────────────────────────

All done! ✨ 🍰 ✨
2 files left unchanged.
Skipped 1 files

──────────────────────────── 🏄 Success! ────────────────────────────
```

It temporarily clones the provided repository
and then executes the job that exits within it.
While executing `/formatPython`,
it finds two files,
specifically the ones contained in `api/src`,
and validates if they are properly formatted.

## Working with a Nixpkgs version

[<img src="https://img.shields.io/badge/attr-secure-brightgreen.svg" alt="secure">](#secure)

We can also specify
what version of [Nixpkgs][NIXPKGS] we want to use
by using [fetchNixpkgs](https://github.com/fluidattacks/makes#fetchnixpkgs).

```nix
{
  inputs = {
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
  };
}
```

We can later reference
this version of nixpkgs
to install any package we want.

## Using imports

[<img src="https://img.shields.io/badge/attr-easy-orange.svg" alt="easy">](#easy)
[<img src="https://img.shields.io/badge/attr-extensible-blue.svg" alt="extensible">](#extensible)

Another important builtin is:

```nix
{
  imports = [
    ./api/makes.nix
  ];
}
```

The `imports` builtin serves a very simple purpose,
which is being able to specify other `makes.nix` files
for [Makes][MAKES] to import them.

Any supported builtin
can be configured by either
adding it to the main `makes.nix` file
or to an imported one.

## Configuring the cache

[<img src="https://img.shields.io/badge/attr-secure-brightgreen.svg" alt="secure">](#secure)
[<img src="https://img.shields.io/badge/attr-easy-orange.svg" alt="easy">](#easy)
[<img src="https://img.shields.io/badge/attr-fast-blueviolet.svg" alt="fast">](#fast)

A descentralized [cache](https://github.com/fluidattacks/makes#cache)
for speeding up builds
that relies on [Cachix][CACHIX]
can be configured

```nix
{
  cache = {
    readAndWrite = {
      enable = true;
      name = "makes";
      pubKey = "makes.cachix.org-1:zO7UjWLTRR8Vfzkgsu1PESjmb6ymy1e4OE9YfMmCQR4=";
    };
  };
}
```

This allows anyone running [Makes][MAKES]
to pull already-built [Nix derivations](https://nixos.org/manual/nix/stable/expressions/derivations.html)
so they don't have to build the same thing twice.
All derivations are cryptographically signed,
which helps avoiding cache tampering.

# The example API

In the `api` directory
you will find four relevant paths.
Such paths represent
the core components required
to make the API work.

## API Source Code

The path `api/src`
contains the source code
for the example API.

## API Environment

[<img src="https://img.shields.io/badge/attr-secure-brightgreen.svg" alt="secure">](#secure)
[<img src="https://img.shields.io/badge/attr-fast-blueviolet.svg" alt="fast">](#fast)
[<img src="https://img.shields.io/badge/attr-extensible-blue.svg" alt="extensible">](#extensible)

Under the path `api/env`,
you will find the implementation
of an isolated environment
for all the dependencies
required by the API to work.

- `pypi-deps.yaml` contains the dependencies
   required by the API.
- `pypi-source.yaml` contains a lockfile
   with the entire dependency tree
   required by the API.
   Each dependency is cryptographically signed
   and points to the exact url
   of the expected package.
   You can use [makePythonLock](https://github.com/fluidattacks/makes#makepythonlock)
   to generate a lockfile.
- `main.nix` This is the core file
   for implementing [custom workflows](https://github.com/fluidattacks/makes#mainnix-reference).
   For this specific example,
   it implements the [makepythonpypienvironment](https://github.com/fluidattacks/makes#makepythonpypienvironment)
   builtin that returns an isolated environment
   with the specified dependency tree.
   Such environment will be used later on by the API.

  Try running `m github:fluidattacks/makes-example@main /api/env`.
  This will build the API environment.
  If you run the job again,
  it will use a cached environment
  from the previous build.
  Try changing the `name` input in `main.nix`
  and running the job again.
  As one of the inputs changed,
  the previous cache is no longer valid
  and a new version of the environment will be built.

## API makes.nix

[<img src="https://img.shields.io/badge/attr-easy-orange.svg" alt="easy">](#easy)
[<img src="https://img.shields.io/badge/attr-extensible-blue.svg" alt="extensible">](#extensible)

This `makes.nix` file contains several linters
that run on the API source code.

An interesting job is:

```nix
{
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
```

Notice that it uses the `searchPaths.source`
for loading the API environment
previously described.
The linter needs this environment to
run some checks like static type checking.

## API main.nix

[<img src="https://img.shields.io/badge/attr-secure-brightgreen.svg" alt="secure">](#secure)
[<img src="https://img.shields.io/badge/attr-portable-violet.svg" alt="portable">](#portable)
[<img src="https://img.shields.io/badge/attr-extensible-blue.svg" alt="extensible">](#extensible)

This is where a big part of the magic happens.

```nix
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
  entrypoint = ''
    pushd "__argApiSrc__" \
      && uvicorn main:app --reload
  '';
}
```

This file uses [makeScript](https://github.com/fluidattacks/makes#makescript)
for serving the API.
Here is a detailed description for every parameter

- `replace` Allows to create placeholders
   that can later be replaced
   in the executed script.
   It uses [projectPath](https://github.com/fluidattacks/makes#projectpath),
   a builtin that allows to create
   an inmutable version of a path
   within a repository.
   By doing this,
   we will be able to reference
   the API source code
   in an semi-isolated environment.
- `name` just allows to specify
   the name of the job.
- `searchPaths` implements the [makeSearchPaths](https://github.com/fluidattacks/makes#makesearchpaths)
   builtin.
   It allows us to provide
   all required dependencies
   to our isolated environment.
   For the API to run properly,
   we will bring Python 3.9 from [Nixpkgs][NIXPKGS]
   and source the [API environment](#api-environment).
- `entrypoint` is the shell script
   that will be executed in the job.
   It basically switches to the API source code directory
   and runs a webserver for the API.

Let's run it!

```bash
$ m github:fluidattacks/makes-example@main /api

                                    🦄 Makes
                                  v22.07-linux

─────────────── Fetching github:fluidattacks/makes-example@main ────────────────

Initialized empty Git repository in /tmp/makes-tz6mczs4/.git/
Cached from /home/dsalazar/.makes/cache/sources/github-fluidattacks-makes-example-main
remote: Enumerating objects: 26, done.
remote: Counting objects: 100% (26/26), done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 26 (delta 1), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (26/26), 9.05 KiB | 2.26 MiB/s, done.
From /home/dsalazar/.makes/cache/sources/github-fluidattacks-makes-example-main
 * [new branch]      main       -> main
Switched to branch 'main'

──────────────────────── Building project configuration ────────────────────────

/nix/store/2mnjjd4gkzrbyr7g97yl19n2y4zv0hi3-config.json

──────────────────────────────── Building /api ─────────────────────────────────

/nix/store/sbi0rf8x3a5p9kyxhv8s0q2sxxmg8fsv-api

─────────────────────────────────── Running ────────────────────────────────────

/nix/store/aim1v9k173mrnsi8qdngj0q42miladdg-src /home/dsalazar/fluidattacks/makes-example
INFO:     Will watch for changes in these directories: ['/nix/store/aim1v9k173mrnsi8qdngj0q42miladdg-src']
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [58876] using statreload
INFO:     Started server process [58878]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

That's it!

Now you can get
a running environment of the example API
with just one command, anywhere.
The entire environment exists withing [Nix][NIX],
granting full portability and ensuring that
no dependencies are being directly installed on your system.
The entire dependency tree is fully pinned and
cryptographically signed.
If a component changes,
[Makes][MAKES] will rebuild
from there downwards,
reusing all caches that remain unchanged,
and making sure all signatures are correct.

## API Deployments

[<img src="https://img.shields.io/badge/attr-easy-orange.svg" alt="easy">](#easy)
[<img src="https://img.shields.io/badge/attr-portable-violet.svg" alt="portable">](#portable)
[<img src="https://img.shields.io/badge/attr-extensible-blue.svg" alt="extensible">](#extensible)

In the `api/deploy` path
we will find the job
for deploying the API.

The job takes one of these two parameters

- `dev` will deploy the API to
   `https://makes.fluidattacks.com/${GITHUB_HEAD_REF}`.
- `prod` will deploy the API to
   `https://makes.fluidattacks.com/`.

It requires these external variables to be exported

1. `STACKHERO_SERVICE_ID` (Required)
   For authenticating to [Stackhero][STACKHERO].
1. `STACKHERO_PASSWORD` (Required)
   For authenticating to [Stackhero][STACKHERO].
1. `GITHUB_HEAD_REF` (Required for `dev`)
   For setting the URL path.

Its relevant files are

- `compose.yaml` is the [Docker Compose][DOCKER_COMPOSE] file
   used for deploying
   an instance of the API.
   Many of its parameters
   contain placeholders
   that will be replaced
   by the job
   during execution time.
- `entrypoint.sh` contains the script for the deploy job.
  It basically logs in to [Stackhero][STACKHERO],
  replaces all required placeholders in `compose.yaml`
  and deploys a new version of the API.
- `main.nix` provides another
  [makeScript](https://github.com/fluidattacks/makes#makescript) job
  like the ones reviewed before.

Let's give it a try!

```bash
$ export STACKHERO_SERVICE_ID=XXXXXXXXXXX
$ export STACKHERO_PASSWORD=XXXXXXXXXXX
$ m github:fluidattacks/makes-example@main /api/deploy prod

                                    🦄 Makes
                                  v22.07-linux

─────────────── Fetching github:fluidattacks/makes-example@main ────────────────

Initialized empty Git repository in /tmp/makes-_molt5o0/.git/
From github:fluidattacks/makes-example@main
remote: Enumerating objects: 31, done.
remote: Counting objects: 100% (31/31), done.
remote: Compressing objects: 100% (27/27), done.
remote: Total 31 (delta 1), reused 20 (delta 0), pack-reused 0
Unpacking objects: 100% (31/31), 14.88 KiB | 476.00 KiB/s, done.
From https://github.com/fluidattacks/makes-example
 * [new branch]      main       -> main
Switched to branch 'main'

──────────────────────── Building project configuration ────────────────────────

/nix/store/5rdc529zr6rx9n2g56npbnif3z4xb6c7-config.json

───────────────────────────── Building /api/deploy ─────────────────────────────

these 2 derivations will be built:
  /nix/store/q0bhl11zsikf2a381lp9hmgg4wffpna6-make-template-for-api-deploy.drv
  /nix/store/pchwjz1z7qw7d8z6nvpvi3j109k8gch9-api-deploy.drv
building '/nix/store/q0bhl11zsikf2a381lp9hmgg4wffpna6-make-template-for-api-deploy.drv'...
building '/nix/store/pchwjz1z7qw7d8z6nvpvi3j109k8gch9-api-deploy.drv'...
[INFO] Copying files
/nix/store/v5nj2z092pm0xwhn30k5x3llfqkr78wq-api-deploy

─────────────────────────────────── Running ────────────────────────────────────

/nix/store/dby4nqrn19p065gh7vfyi7w0cmg328sx-deploy /home/dsalazar/fluidattacks/makes-example
/tmp/tmp.xSaQBmovKs /nix/store/dby4nqrn19p065gh7vfyi7w0cmg328sx-deploy /home/dsalazar/fluidattacks/makes-example
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 10240  100 10240    0     0   8258      0  0:00:01  0:00:01 --:--:--  8264
/nix/store/dby4nqrn19p065gh7vfyi7w0cmg328sx-deploy /home/dsalazar/fluidattacks/makes-example
Killing makes-example-main ... done
Removing makes-example-main ... done
Network app is external, skipping
Creating makes-example-main ... done

───────────────────────────────── 🍀 Success! ──────────────────────────────────
```

After a few minutes,
when going to https://makes.fluidattacks.com/docs,
we get the following:

![Production environment](/static/deploy.png "Production environment")

Deployment jobs for both development and production
are are supported using [GitHub Actions][GITHUB_ACTIONS].
Every time a developer opens a pull request,
a development environment for the API is created.
Similarly, once that pull request is merged,
a new version of the API is deployed to production.

# References

- [CACHIX]: https://www.cachix.org/
  [Cachix][CACHIX]
- [DOCKER]: https://www.docker.com/
  [Docker][DOCKER]
- [DOCKER_COMPOSE]: https://docs.docker.com/compose/
  [Docker Compose][DOCKER_COMPOSE]
- [FASTAPI]: https://fastapi.tiangolo.com/
  [FastAPI][FASTAPI]
- [GITHUB_ACTIONS]: https://docs.github.com/en/actions/
  [GitHub Actions][GITHUB_ACTIONS]
- [KUBERNETES]: https://kubernetes.io/
  [Kubernetes][KUBERNETES]
- [MAKES]: https://github.com/fluidattacks/makes/
  [Makes][MAKES]
- [NIX]: https://nixos.org/
  [Nix][NIX]
- [NIXPKGS]: https://github.com/NixOS/nixpkgs/
  [Nixpkgs][NIXPKGS]
- [NOMAD]: https://www.nomadproject.io/
  [Nomad][NOMAD]
- [STACKHERO]: https://www.stackhero.io/en/
  [Stackhero][STACKHERO]
