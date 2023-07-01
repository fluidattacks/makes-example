# shellcheck shell=bash

function compose {
  envsubst -no-unset -no-empty -i "${1}" \
    | docker-compose "${@:2}"
}

function stackhero_login {
  export STACKHERO_SERVICE_ID
  export STACKHERO_PASSWORD
  local tmp
  local stackhero_host="makes.fluidattacks.com"
  local certs="https://docker:${STACKHERO_PASSWORD}@${stackhero_host}/stackhero/docker/certificates.tar"
  export DOCKER_HOST="tcp://${stackhero_host}:2376"
  export DOCKER_TLS_VERIFY="0"
  export DOCKER_CERT_PATH

  tmp=$(mktemp -d) \
    && pushd "${tmp}" \
    && curl -o certs.tar "${certs}" \
    && tar -xf certs.tar \
    && DOCKER_CERT_PATH="${tmp}" \
    && popd \
    || return 1
}

function stackhero_deploy {
  local file="${1}"
  local env="${2}"
  local base_args=(
    --file "${file}"
    --project-name "${env}"
  )
  local kill_args=(
    kill
    app
  )
  local down_args=(
    down
    --remove-orphans
    --timeout 300
  )
  local up_args=(
    up
    --remove-orphans
    --timeout 300
    --detach
  )

  compose "${file}" "${base_args[@]}" "${kill_args[@]}" \
    && compose "${file}" "${base_args[@]}" "${down_args[@]}" \
    && compose "${file}" "${base_args[@]}" "${up_args[@]}"
}

function main {
  local env="${1-}"
  export BRANCH
  export PATH_PREFIX

  if [ "${env}" = "dev" ]; then
    BRANCH="${GITHUB_HEAD_REF}" \
      && PATH_PREFIX="/${BRANCH}"
  elif [ "${env}" = "prod" ]; then
    BRANCH="main" \
      && PATH_PREFIX="/"
  else
    error "You must pass either 'dev' or 'prod' as arguments."
  fi \
    && stackhero_login \
    && stackhero_deploy "__argApiCompose__" "makes-example-${BRANCH}"
}

main "${@}"
