# shellcheck shell=bash

function main {
  local args=(
    "--reload"
    "--host" "0.0.0.0"
    "--port" "8080"
    "--root-path" "${1:-}"
  )

  pushd "__argApiSrc__" \
    && uvicorn main:app "${args[@]}"
}

main "${@}"
