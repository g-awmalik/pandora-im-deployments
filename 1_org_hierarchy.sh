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


stage="org-hierarchy"
deployment_name="pdr-${stage}"
project_id=${TF_VAR_seed_project_id}
region="us-central1"
repo="https://github.com/g-awmalik/pandora-im-deployments.git"
directory="${stage}"
ref="main"
setup_sa=${TF_VAR_org_setup_service_account}

gcloud infra-manager deployments apply ${deployment_name} \
  --project ${project_id} \
  --location ${region} \
  --git-source-repo=${repo} \
  --git-source-directory=${directory} \
  --git-source-ref=${ref} \
  --input-values=org_id=${TF_VAR_org_id},folder_id=${TF_VAR_folder_id},billing_account=${TF_VAR_billing_account},seed_project_id=${TF_VAR_seed_project_id} \
  --service-account projects/${project_id}/serviceAccounts/${setup_sa}
