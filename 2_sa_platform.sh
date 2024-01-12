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


stage="sa-platform"
deployment_name="pdr-${stage}"
project_id=${TF_VAR_seed_project_id}
region="us-central1"
repo="https://github.com/g-awmalik/pandora-im-deployments.git"
directory="${stage}"
ref="main"
setup_sa=${TF_VAR_seed_sas_service_account}

gcloud infra-manager deployments apply ${deployment_name} \
  --project ${project_id} \
  --location ${region} \
  --git-source-repo=${repo} \
  --git-source-directory=${directory} \
  --git-source-ref=${ref} \
  --input-values=seed_project_id=${TF_VAR_seed_project_id},secrets_project_id=${TF_VAR_project_secrets},logging_project_id=${TF_VAR_project_logging},network_folder_id=${TF_VAR_folder_networking},development_folder_id=${TF_VAR_folder_development},dev_network_project_id=${TF_VAR_project_shared_vpc_dev},production_folder_id=${TF_VAR_folder_production},prod_network_project_id=${TF_VAR_project_shared_vpc_prod} \
  --service-account projects/${project_id}/serviceAccounts/${setup_sa}
