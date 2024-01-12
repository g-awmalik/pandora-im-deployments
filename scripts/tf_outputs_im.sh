#!/bin/bash
# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


ROOT="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
region="us-central1"

if [[ "$#" -lt 1  ]]; then
  cat >&2 <<"EOF"
tf_outputs_im.sh expects a directory as a parameter to set terraform outputs
for the next stage.
USAGE:
  tf_outputs_im.sh [directory]
EOF
  exit 1
fi

json_data=$(gcloud infra-manager revisions list \
  --project=${TF_VAR_seed_project_id} \
  --location ${region} \
  --deployment pdr-${1} \
  --format="json(name, createTime, applyResults.outputs)")
outputs=$(echo "$json_data" | jq -r '. | max_by(.createTime) | .applyResults.outputs')
envs=$(jq -r 'to_entries | .[] | "TF_VAR_\(.key)=\(.value.value)"' <<< ${outputs})
echo "${envs}" > "${ROOT}/.env/.${1}"
while IFS='=' read -r key value; do
    export "$key"="$value"
done < "${ROOT}/.env/.${1}"