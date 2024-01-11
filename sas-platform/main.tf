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

resource "google_service_account" "sa_secrets" {
  account_id   = "pdr-sa-secrets"
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
      "serviceAccount:${google_service_account.sa_secrets.email}",
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
      "serviceAccount:${google_service_account.sa_secrets.email}",
    ]
  }
}

resource "google_service_account" "sa_logging" {
  account_id   = "pdr-sa-loggin"
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
      "serviceAccount:${google_service_account.sa_logging.email}",
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
      "serviceAccount:${google_service_account.sa_logging.email}",
    ]
  }
}

resource "google_service_account" "sa_networking" {
  account_id   = "pdr-sa-networking"
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
      "serviceAccount:${google_service_account.sa_networking.email}",
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
      "serviceAccount:${google_service_account.sa_networking.email}",
    ]

    "roles/compute.xpnAdmin" = [
      "serviceAccount:${google_service_account.sa_networking.email}",
    ]
  }
}

resource "google_service_account" "sa_app_dev" {
  account_id   = "pdr-sa-app-dev"
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
      "serviceAccount:${google_service_account.sa_app_dev.email}",
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
      "serviceAccount:${google_service_account.sa_app_dev.email}",
    ]

    "roles/resourcemanager.projectDeleter" = [
      "serviceAccount:${google_service_account.sa_app_dev.email}",
    ]
  }
}

resource "google_service_account" "sa_app_prod" {
  account_id   = "pdr-sa-app-prod"
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
      "serviceAccount:${google_service_account.sa_app_prod.email}",
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
      "serviceAccount:${google_service_account.sa_app_prod.email}",
    ]

    "roles/resourcemanager.projectDeleter" = [
      "serviceAccount:${google_service_account.sa_app_prod.email}",
    ]
  }
}
