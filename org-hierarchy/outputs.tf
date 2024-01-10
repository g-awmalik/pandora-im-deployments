/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "project_secrets" {
  value = module.project-secrets.project_id
}

output "project_logging" {
  value = module.project-logging.project_id
}

output "project_shared_vpc_dev" {
  value = module.project-shared-vpc-dev.project_id
}

output "project_shared_vpc_prod" {
  value = module.project-shared-vpc-prod.project_id
}

output "folder_networking" {
  value = google_folder.networking.id
}

output "folder_development" {
  value = google_folder.development.id
}

output "folder_production" {
  value = google_folder.production.id
}

output "folder_common" {
  value = google_folder.common.id
}

output "seed_sas_service_account" {
  value = google_service_account.im_seed_sas.email
}
