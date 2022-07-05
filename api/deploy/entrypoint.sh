# shellcheck shell=bash

function app_exists {
  local env="${1}"

  heroku apps --json | jq -rec ".[].name" | grep -q "${env}"
}

function create_app {
  local env="${1}"

  heroku apps:create "${env}" \
    && heroku stack:set --app "${env}" "container" \
    && heroku container:push --app "${env}" web
}

function main {
  local env="makes-example-${1}"

  pushd "__argApiDeploy__" \
    && heroku auth:whoami \
    && heroku container:login \
    && if ! app_exists "${env}"; then
      info "It seems like a Heroku app for ${env} does not exist. We will create it." \
        && create_app "${env}"
    fi \
    && heroku container:release --app "${env}" web
}

main "${@}"
