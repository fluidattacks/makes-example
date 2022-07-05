# shellcheck shell=bash

function main {
  pushd "__argApiSrc__" \
    && uvicorn main:app --reload --host "0.0.0.0" --port "8080"
}

main "${@}"
