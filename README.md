# 🦄 Makes Example

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Contents

- [Why](#why)
    - [Secure](#secure)
    - [Easy](#easy)
    - [Fast](#fast)
    - [Portable](#portable)
    - [Extensible](#extensible)
- [How](#how)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
    - [Running any CI/CD Job](#running-any-cicd-job)
    - [Running the API locally](#running-the-api-locally)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Why

The purpose of this example
is to show how [Makes](https://github.com/fluidattacks/makes)
is:

### Secure

Direct and indirect dependencies
for both applications and CI/CD pipelines
are cryptographically signed,
granting an immutable software supply chain.

### Easy

Can be installed with just one command
and has dozens of generic CI/CD builtins.

### Fast

Supports a distributed
and completely granular cache.

### Portable

Runs on Docker, VM’s,
and any linux-based OS.

### Extensible

Can be extended
to work with any technology.

## How

We will achieve this by implementing:

1. The [FastAPI example](https://fastapi.tiangolo.com/#example).
1. An isolated, cryptographically-signed environment
    for running our API.
1. Development infrastructure
   for testing our API.
1. Production infrastructure
   for deploying our API.
1. General purpose linters and formatters
   for ensuring code quality and security.
1. A distributed cache
   for high build performance.
1. A CI/CD workflow using GitHub actions
   for orchestrating all the previous items.

## Prerequisites

You just need to
[Install Makes](https://github.com/fluidattacks/makes#getting-started)

## Usage

### Running any CI/CD Job

```bash
m github:fluidattacks/makes-example@main
```

### Running the API locally

```bash
m github:fluidattacks/makes-example@main /api
```
