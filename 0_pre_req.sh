#!/bin/bash

pushd pre-req
terraform init
terraform apply -auto-approve
popd
