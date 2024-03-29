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

module "seed-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.4"

  random_project_id = true
  name              = "pdr-b-seed"
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "config.googleapis.com",
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
  ]
}

resource "google_service_account" "im_org_setup" {
  account_id   = "pdr-im-org-setup"
  display_name = "Pandora IM organization setup service account"
  project      = module.seed-project.project_id
}

resource "google_project_iam_member" "config_agent" {
  project = module.seed-project.project_id
  role    = "roles/config.agent"
  member  = "serviceAccount:${google_service_account.im_org_setup.email}"
}

resource "google_project_iam_member" "sa_admin" {
  project = module.seed-project.project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.im_org_setup.email}"
}

module "im_org_setup-folder-bindings" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.7"
  folders = [var.folder_id]
  mode    = "authoritative"
  bindings = {
    "roles/resourcemanager.folderAdmin" = [
      "serviceAccount:${google_service_account.im_org_setup.email}",
    ]

    "roles/resourcemanager.projectCreator" = [
      "serviceAccount:${google_service_account.im_org_setup.email}",
    ]

    "roles/resourcemanager.projectDeleter" = [
      "serviceAccount:${google_service_account.im_org_setup.email}",
    ]
  }
}
