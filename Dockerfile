FROM python:3.10

# If using Makefile, create these in a .env file
ARG CDKTF_VERSION='0.20.1'
ENV CDKTF_VERSION=$CDKTF_VERSION
ARG TF_VERSION='1.7.4'
ENV TF_VERSION=$TF_VERSION

# User settings, Chagne as needed
ARG USER=pydeploy
ENV USER=$USER
ENV GROUPNAME=$USER
ARG UID=1000
ENV UID=$UID
ARG GID=1001
ENV GID=$GID
ENV PYENV_HOME=/home/$USER/.pyenv

# Admin settings
LABEL author="Icarus747"
LABEL maintainer="https://github.com/icarus747"
LABEL name="cdktf-cli"
LABEL version=${CDKTF_VERSION}

# Install needed programs/tools
RUN apt-get update && \
    apt-get install -y \
      npm \
      curl \
      unzip \
    && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    true

# Install pip, cdktf, pipenv, terraform
RUN pip install --upgrade pip
RUN npm install --global cdktf-cli@${CDKTF_VERSION}
RUN pip3 install --no-cache-dir -U pipenv \
        && curl -o terraform.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
        && unzip -o terraform.zip \
        && rm terraform.zip \
        && mv terraform /usr/local/bin/

# User add
RUN groupadd \
    --gid "$GID" \
    "$GROUPNAME" \
    --system \
&&  useradd \
    --create-home \
    --system \
    --shell "/bin/bash" \
    --gid "$GID" \
    --uid "$UID" \
    $USER

USER pydeploy
  
# Bash color
RUN echo "PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '" >> /home/pydeploy/.bashrc
  
# Chnage to where cdktf will run, modify .env file, and install pipenv dependancies
WORKDIR /home/pydeploy/neteng_aci_labs
COPY Pipfile* /home/pydeploy/neteng_aci_labs

# Uncomment if you want to run pipenv inside the project
# RUN echo "PIPENV_VENV_IN_PROJECT=1" >> /home/pydeploy/neteng_aci_labs/.env

# Installs the pip libraries in ~/.local/share/virtualenvs/...  if not using the line above. Else it will be in the project dir as .vevn
RUN pipenv install --dev --skip-lock

CMD ["bash"]

# To run cdktf as entrypoint, create different Dockerfile with FROM <This image> and 'ENTRYPOINT cdktf'

