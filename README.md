# Managing GCP resources using Infrastructure Manager

This repository contains Terraform code and shell scripts for provisioning and managing GCP resources
using GCP [Infrastructure Manager](https://cloud.google.com/infrastructure-manager/docs/overview).

## Prerequisites

Before you can use this Terraform code, ensure that you have the following prerequisites installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [gcloud CLI](https://cloud.google.com/sdk/gcloud)

## Getting Started

To get started with this proposal, follow these steps:

1. Clone the repository:

```shell
git clone https://github.com/g-awmalik/pandora-im-deployments.git
```

2. Setup environment variables:

Edit [env_setup.sh](scripts/env_setup.sh) and fill in values for:

1. Your organization ID
1. The folder ID under which you plan to create resources for this solution
1. The billing account you intended to use for creating new projects

```shell
source ./scripts/env_setup.sh
```

3. Setup bootstrap resources:

```shell
cd bootstrap
terraform init
terraform apply --auto-approve
cd ..
source ./scripts/tf_outputs.sh bootstrap
```

Note: Before proceeding give the `pdr-im-org-setup` service account `roles/billing.user`
on the billing account you plan to use.

4. Setup Org Hierarchy:

```shell
./1_org_hierarchy.sh
source ./scripts/tf_outputs_im.sh org-hierarchy
```

5. Setup Platform Service Accounts:

```shell
./2_sa_platform.sh
source ./scripts/tf_outputs_im.sh sa-platform
```

Note: Before proceeding give the `pdr-sa-app-dev` & `pdr-sa-app-prod` service accounts
`roles/billing.user` on the billing account you plan to use. These two service accounts
will be creating projects in the development and production folder respectively.

6. Setup Secrets:

```shell
./3_secrets.sh
```

7. Setup Shared VPC:

```shell
./5_shared_vpc.sh
```

8. Setup Development Application Projects:

```shell
./6_app_dev.sh
```

## License

This repository is licensed under the [Apache 2.0 License](LICENSE).
