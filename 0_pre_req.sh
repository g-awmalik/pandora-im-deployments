#!/bin/bash

folder_id="$TF_VAR_folder_id"

# Check if folder_id parameter is provided
if [ -z "$1" ] && [ -z "$folder_id" ]; then
  echo "Please provide the folder_id parameter."
  exit 1
fi

if [ -n "$1" ]; then
  folder_id="$1"
fi

pushd pre-req
terraform init
terraform apply -auto-approve -var "folder_id=$folder_id"
popd
