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

module "vpc-dev" {
  source  = "terraform-google-modules/network/google//modules/vpc"
  version = "~> 9.0"

  project_id   = vpc.dev_vpc_project_id
  network_name = "pdr-net-dev-host"

  shared_vpc_host = true
}

module "vpc-prod" {
  source  = "terraform-google-modules/network/google//modules/vpc"
  version = "~> 9.0"

  project_id   = vpc.prod_vpc_project_id
  network_name = "pdr-net-prod-host"

  shared_vpc_host = true
}
