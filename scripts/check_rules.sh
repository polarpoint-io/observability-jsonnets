#!/bin/bash

set -ue

main () {
      ./promtool check rules ${TEMPLATE_TYPE}/generated/*.yaml
}

source "$(dirname "$0")/libs.sh"

main "$@"