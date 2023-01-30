#!/bin/bash

set -euo pipefail

check_file_extensions(){

  # Set RC switch as fine to begin
  RC_FLAG=0
  # Fetch main
  git fetch origin main:refs/remotes/origin/main

  # Look for files missing correct extension
  for file in $(git diff origin/main --name-only -- terraform/); do
    if [[ ${file} != *.tf  ]] && [[ ${file} != *.hcl ]]; then
      RC_FLAG=1
      echo "${file} does not have the correct .tf extension"
    fi
  done


  if [[ ${RC_FLAG} == 1 ]]; then
    exit 1
  fi
}

check_file_extensions