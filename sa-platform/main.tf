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
  sa_secrets_id    = "pdr-sa-secrets"
  sa_logging_id    = "pdr-sa-logging"
  sa_networking_id = "pdr-sa-networking"
  sa_app_dev_id    = "pdr-sa-app-dev"
  sa_app_prod_id   = "pdr-sa-prod-dev"
}

resource "google_service_account" "sa_secrets" {
  account_id   = local.sa_secrets_id
  display_name = "Pandora secrets service account"
  project      = var.seed_project_id
}

module "sa_secrets_config_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  projects = [var.seed_project_id]
  mode     = "additive"
  bindings = {
    "roles/config.agent" = [
      "serviceAccount:${local.sa_secrets_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

module "sa_secrets_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  projects = [var.secrets_project_id]
  mode     = "authoritative"
  bindings = {
    "roles/secretmanager.admin" = [
      "serviceAccount:${local.sa_secrets_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

resource "google_service_account" "sa_logging" {
  account_id   = local.sa_logging_id
  display_name = "Pandora logging service account"
  project      = var.seed_project_id
}

module "sa_logging_config_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  projects = [var.seed_project_id]
  mode     = "additive"
  bindings = {
    "roles/config.agent" = [
      "serviceAccount:${local.sa_logging_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

module "sa_logging_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  projects = [var.logging_project_id]
  mode     = "authoritative"
  bindings = {
    "roles/logging.admin" = [
      "serviceAccount:${local.sa_logging_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

resource "google_service_account" "sa_networking" {
  account_id   = local.sa_networking_id
  display_name = "Pandora networking service account"
  project      = var.seed_project_id
}

module "sa_networking_config_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  projects = [var.seed_project_id]
  mode     = "additive"
  bindings = {
    "roles/config.agent" = [
      "serviceAccount:${local.sa_networking_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

module "sa_networking_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.7"
  folders = [var.network_folder_id]
  mode    = "authoritative"
  bindings = {
    "roles/compute.networkAdmin" = [
      "serviceAccount:${local.sa_networking_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]

    "roles/compute.xpnAdmin" = [
      "serviceAccount:${local.sa_networking_id}@${var.seed_project_id}.iam.gserviceaccount.com",
      "serviceAccount:${local.sa_app_dev_id}@${var.seed_project_id}.iam.gserviceaccount.com",
      "serviceAccount:${local.sa_app_prod_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

resource "google_service_account" "sa_app_dev" {
  account_id   = local.sa_app_dev_id
  display_name = "Pandora development application project creator service account"
  project      = var.seed_project_id
}

module "sa_app_dev_config_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  projects = [var.seed_project_id]
  mode     = "additive"
  bindings = {
    "roles/config.agent" = [
      "serviceAccount:${local.sa_app_dev_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

module "sa_app_dev_network_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  projects = [var.dev_network_project_id]
  mode     = "additive"
  bindings = {
    "roles/resourcemanager.projectIamAdmin" = [
      "serviceAccount:${local.sa_app_dev_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

module "sa_app_dev_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.7"
  folders = [var.development_folder_id]
  mode    = "authoritative"
  bindings = {
    "roles/resourcemanager.projectCreator" = [
      "serviceAccount:${local.sa_app_dev_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]

    "roles/resourcemanager.projectDeleter" = [
      "serviceAccount:${local.sa_app_dev_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]

    "roles/compute.xpnAdmin" = [
      "serviceAccount:${local.sa_app_dev_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

resource "google_service_account" "sa_app_prod" {
  account_id   = local.sa_app_prod_id
  display_name = "Pandora production application project creator service account"
  project      = var.seed_project_id
}

module "sa_app_prod_config_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  projects = [var.seed_project_id]
  mode     = "additive"
  bindings = {
    "roles/config.agent" = [
      "serviceAccount:${local.sa_app_prod_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

module "sa_app_prod_network_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  projects = [var.prod_network_project_id]
  mode     = "additive"
  bindings = {
    "roles/resourcemanager.projectIamAdmin" = [
      "serviceAccount:${local.sa_app_prod_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}

module "sa_app_prod_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.7"
  folders = [var.production_folder_id]
  mode    = "authoritative"
  bindings = {
    "roles/resourcemanager.projectCreator" = [
      "serviceAccount:${local.sa_app_prod_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]

    "roles/resourcemanager.projectDeleter" = [
      "serviceAccount:${local.sa_app_prod_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]

    "roles/compute.xpnAdmin" = [
      "serviceAccount:${local.sa_app_prod_id}@${var.seed_project_id}.iam.gserviceaccount.com",
    ]
  }
}
