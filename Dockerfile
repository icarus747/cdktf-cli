FROM python:3.10

ARG CDKTF_VERSION='0.20.1'
ENV CDKTF_VERSION=$CDKTF_VERSION
ARG TF_VERSION='1.7.4'
ENV TF_VERSION=$TF_VERSION
ARG NODE_JS_VERSION='v21.2.0'
ENV NODE_JS_VERSION=$NODE_JS_VERSION
ARG PYTHON_VERSION='3.10.14'
ENV PYTHON_VERSION=$PYTHON_VERSION
ENV PYENV_HOME=/home/pydeploy/.pyenv

LABEL author="Icarus747"
LABEL maintainer="https://github.com/icarus747"
LABEL name="cdktf-cli"
LABEL version=${CDKTF_VERSION}


ENV USER=pydeploy
ENV GROUPNAME=$USER
ENV UID=1000
ENV GID=1001

RUN groupadd \
    --gid "$GID" \
    "$GROUPNAME" \
    --system \
&&  useradd \
    --system \
    --shell "/bin/bash" \
    --gid "$GID" \
    --uid "$UID" \
    $USER

WORKDIR /home/pydeploy

# Install needed programs
RUN apt-get update && \
    apt-get install -y \
      git \
      npm \
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

# Create working directory for cdktf files and copy in library reference Pipfile
RUN mkdir -p /home/pydeploy/neteng_aci_labs
COPY Pipfile* /home/pydeploy/neteng_aci_labs

# Bash color
RUN echo "PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '" >> .bashrc

# Chnage to where cdktf will run, modify .env file, and install pipenv dependancies
WORKDIR /home/pydeploy/neteng_aci_labs
RUN echo "PIPENV_VENV_IN_PROJECT=1" >> /home/pydeploy/neteng_aci_labs/.env
RUN pipenv install --dev --skip-lock
RUN chown -R pydeploy:pydeploy /home/pydeploy

USER pydeploy

CMD ["bash"]

