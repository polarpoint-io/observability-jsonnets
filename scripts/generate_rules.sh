#!/bin/bash

set -ue

main () {
  for file in $(find ${TEMPLATE_TYPE} -type f -name "*.jsonnet"); do
    #dir="$(dirname $file)"
    #last_dir="$(basename $dir)"
    file_name="$(basename -- $file .jsonnet)"
    #info "[INFO] Generating ${TEMPLATE_TYPE} for - ${last_dir}"
    info "[INFO] Generating ${TEMPLATE_TYPE} for - ${file}"
    info "[INFO] Generating ${TEMPLATE_TYPE} for - ${file_name}"
    jsonnet -S $file -o ${TEMPLATE_TYPE}/generated/${file_name}.yaml

    success "[INFO] Successfully generated ${TEMPLATE_TYPE} - ${file_name}"
  done
}

source "$(dirname "$0")/libs.sh"

main "$@"