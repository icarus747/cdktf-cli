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

Make sure `.venv` is not located in the project directory otherwise pipenv will use that as its library source and cause issues with project resources within terraform. If it exists, you can rename/delete the directory. The pipenv source in the container is under `~/.local/share/virtualenvs/...`. 

If pipenv is run natively (to use vscode on python files), ensure the following is added to your `.bashrc`. This will install pipenv outside of the project folder as to not conflict with the container. 
```
export PIPENV_VENV_IN_PROJECT=0
```
pwd is the location of the cdktf project directory. The following will let you enter the container. Append with `cdktf` to run cdktf within the container. 
```
docker run -it --rm -v $(pwd):/src -w '/src' --network=host cdktf-cli:latest
```

I recommend that you create an alias in `.bashrc` that will run the container with the cdktf command
```
alias cdktf="docker run --rm -it -v $(pwd):/src -w '/src' --network=host cdktf-cli:latest cdktf"
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
