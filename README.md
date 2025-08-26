![Build and Push docker image](https://github.com/denstorti/cdktf-cli/workflows/Build%20and%20Push%20docker%20image/badge.svg?branch=master&event=push)

# Docker Image for cdktf-cli (Terraform CDK)

In order to use cdktf, you'll need Terraform, Node.js, and Yarn. So this docker image intends to make developer's life easier just wrapping cdktf-cli.

Check https://3musketeers.io/.

Image contains:
- Terraform CLI
- cdktf-cli

# Distributions

- DockerHub: https://hub.docker.com/repository/docker/denstorti/cdktf

# Example: init a cdktf workdir

Run the container:

```
docker run -it --rm -v $(pwd):/src -w '/src' cdktf-cli:latest sh
```

Initialise cdktf:

```
cdktf init --template python
```

# Test the pipeline locally (GH Actions)

> https://github.com/nektos/act

Test locally using `act`:

```
act -P ubuntu-latest=nektos/act-environments-ubuntu:18.04 -j check_cdktf_releases
```

# Building it

Build:
```
make build
```

Test:
```
make run
```

Push:
```
make push
```
# Check for updates
New versions:
```
curl -sl https://api.github.com/repos/hashicorp/terraform-cdk/releases/latest | jq -r '.tag_name' | tr -d "v"
curl -sl https://api.github.com/repos/CiscoDevNet/terraform-provider-mso/releases/latest | jq -r '.tag_name' | tr -d "v"
curl -sl https://api.github.com/repos/CiscoDevNet/terraform-provider-aci/releases/latest | jq -r '.tag_name' | tr -d "v"
curl -sl https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name' | tr -d "v"
```