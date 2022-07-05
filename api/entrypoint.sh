# shellcheck shell=bash

function main {
  local port="${PORT:-8000}"

  pushd "__argApiSrc__" \
    && uvicorn main:app --reload --port "${port}"
}

main "${@}"
