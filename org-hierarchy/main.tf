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

locals {
  seed-sa-id = "pdr-im-seed-sa"
}

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
  display_name = "pdr-networking"
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
  display_name = "pdr-development"
  parent       = "folders/${var.folder_id}"
}

resource "google_folder" "production" {
  display_name = "pdr-production"
  parent       = "folders/${var.folder_id}"
}

resource "google_service_account" "im_seed_sas" {
  account_id   = local.seed-sa-id
  display_name = "Pandora IM seed service accounts setup service account"
  project      = var.seed_project_id
}

module "im_seed_sas_config_project_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  projects = [var.seed_project_id]
  mode     = "additive"
  bindings = {
    "roles/config.agent" = [
      "serviceAccount:${local.seed-sa-id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]

    "roles/iam.serviceAccountAdmin" = [
      "serviceAccount:${local.seed-sa-id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

module "im_seed_sas_folder_bindings" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.7"
  folders = [var.folder_id]
  mode    = "additive"
  bindings = {
    "roles/resourcemanager.folderIamAdmin" = [
      "serviceAccount:${local.seed-sa-id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}
