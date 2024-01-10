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

resource "google_folder" "common" {
  display_name = "pdr-common"
  parent       = "folders/${var.folder_id}"
}

module "project-secrets" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.4"

  random_project_id = true
  name              = "pdr-c-secrets"
  org_id            = var.org_id
  folder_id         = google_folder.common.id
  billing_account   = var.billing_account

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "secretmanager.googleapis.com",
  ]
}

module "project-logging" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.4"

  random_project_id = true
  name              = "pdr-c-logging"
  org_id            = var.org_id
  folder_id         = google_folder.common.id
  billing_account   = var.billing_account

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "logging.googleapis.com",
  ]
}

resource "google_folder" "networking" {
  display_name = "networking"
  parent       = "folders/${var.folder_id}"
}

module "project-shared-vpc-dev" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.4"

  random_project_id = true
  name              = "pdr-net-dev-shared-vpc"
  org_id            = var.org_id
  folder_id         = google_folder.networking.id
  billing_account   = var.billing_account

  activate_apis = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

module "project-shared-vpc-prod" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.4"

  random_project_id = true
  name              = "pdr-net-prod-shared-vpc"
  org_id            = var.org_id
  folder_id         = google_folder.networking.id
  billing_account   = var.billing_account

  activate_apis = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

resource "google_folder" "development" {
  display_name = "development"
  parent       = "folders/${var.folder_id}"
}

resource "google_folder" "production" {
  display_name = "production"
  parent       = "folders/${var.folder_id}"
}

resource "google_service_account" "im_seed_sas" {
  account_id   = "pdr-im-seed-sas"
  display_name = "Pandora IM seed service accounts setup service account"
  project      = var.seed_project_id
}

module "im_seed_sas_config_project_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  projects = [var.seed_project_id]
  mode     = "authoritative"
  bindings = {
    "roles/config.agent" = [
      "serviceAccount:${google_service_account.im_seed_sas.email}",
    ]

    "roles/iam.serviceAccountCreator" = [
      "serviceAccount:${google_service_account.im_seed_sas.email}",
    ]

    "roles/resourcemanager.projectIamAdmin" = [
      "serviceAccount:${google_service_account.im_seed_sas.email}",
    ]
  }
}

module "im_seed_sas_project_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.7"
  projects = [
    module.project-secrets.project_id,
    module.project-logging.project_id,
    module.project-shared-vpc-dev.project_id,
    module.project-shared-vpc-prod.project_id,
  ]
  mode = "authoritative"
  bindings = {
    "roles/resourcemanager.projectIamAdmin" = [
      "serviceAccount:${google_service_account.im_seed_sas.email}",
    ]
  }
}

module "im_seed_sas_folder_bindings" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.7"
  folders = [
    google_folder.common.id,
    google_folder.development.id,
    google_folder.production.id,
    google_folder.networking.id,
  ]
  mode = "authoritative"
  bindings = {
    "roles/resourcemanager.folderIamAdmin" = [
      "serviceAccount:${google_service_account.im_seed_sas.email}",
    ]
  }
}
