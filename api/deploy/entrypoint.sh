# shellcheck shell=bash

function stackhero_login {
  export STACKHERO_SERVICE_ID
  export STACKHERO_PASSWORD
  local tmp
  local stackhero_host="yuaaxr.stackhero-network.com"
  local certificates="https://docker:${STACKHERO_PASSWORD}@${stackhero_host}/stackhero/docker/certificates.tar"

  tmp=$(mktemp -d) \
    && pushd "${tmp}" \
    && curl -o certificates.tar "${certificates}" \
    && tar -xf certificates.tar \
    && (docker context rm -f ${stackhero_host} 2> /dev/null || true) \
    && docker context create ${stackhero_host} \
      --description "${STACKHERO_SERVICE_ID} (${stackhero_host})" \
      --docker "host=tcp://${stackhero_host}:2376,ca=ca.pem,cert=cert.pem,key=key.pem" \
    && popd \
    && docker context use "${stackhero_host}"
}

function stackhero_deploy {
  local file="${1}"
  local env="${2}"

  envsubst -no-unset -no-empty -i "${file}" \
    | docker-compose --tlsverify -f "${file}" -p "${env}" up -d
}

function main {
  export USER="${GITHUB_REPOSITORY_OWNER}"
  local env="makes-example-${USER}"

  pushd "__argApiDeploy__" \
    && stackhero_login \
    && stackhero_deploy "./compose.yaml" "${env}"
}

main "${@}"
