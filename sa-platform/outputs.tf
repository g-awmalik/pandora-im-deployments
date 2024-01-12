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

output "secret_sa_email" {
  value = google_service_account.sa_secrets.email
}

output "logging_sa_email" {
  value = google_service_account.sa_logging.email
}

output "networking_sa_email" {
  value = google_service_account.sa_networking.email
}

output "app_dev_sa_email" {
  value = google_service_account.sa_app_dev.email
}

output "app_prod_sa_email" {
  value = google_service_account.sa_app_prod.email
}
