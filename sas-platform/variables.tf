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

variable "billing_account" {
  description = "The ID of the billing account to associate projects with"
  type        = string
}

variable "seed_project_id" {
  description = "The seed project for all platform service accounts and their bindings"
  type        = string
}

variable "secrets_project_id" {
  description = "The project for all platform level secrets"
  type        = string
}

variable "logging_project_id" {
  description = "The project for all platform level log sinks and destinations"
  type        = string
}

variable "network_folder_id" {
  description = "The folder for all networking resources such as shared VPCs"
  type        = string
}

variable "development_folder_id" {
  description = "The folder for all development application projects"
  type        = string
}

variable "production_folder_id" {
  description = "The folder for all production application projects"
  type        = string
}
