FROM alpine:latest

ARG CDKTF_VERSION='0.20.1'
ENV CDKTF_VERSION=$CDKTF_VERSION
ARG TF_VERSION='1.7.4'
ENV TF_VERSION=$TF_VERSION
ARG NODE_JS_VERSION='v21.2.0'
ENV NODE_JS_VERSION=$NODE_JS_VERSION
ARG PYTHON_VERSION='3.10.14'
ENV PYTHON_VERSION=$PYTHON_VERSION
ARG PYENV_HOME=/root/.pyenv

LABEL author="Denis Silva"
LABEL maintainer="https://github.com/denstorti"
LABEL name="cdktf-cli"
LABEL version=${CDKTF_VERSION}

RUN apk add --no-cache \
                        npm \
                        curl \
                        git \
                        bash \
                        libffi-dev \
                        openssl-dev \
                        bzip2-dev \
                        zlib-dev \
                        readline-dev \
                        sqlite-dev \
                        build-base \
                        && git clone --depth 1 https://github.com/pyenv/pyenv.git $PYENV_HOME && \
                                        rm -rfv $PYENV_HOME/.git \
                        && export PATH=$PYENV_HOME/shims:$PYENV_HOME/bin:$PATH \
                        && pyenv install $PYTHON_VERSION \
                        && pyenv global $PYTHON_VERSION \
                        && pip install --upgrade pip && pyenv rehash

ENV PATH $PYENV_HOME/shims:$PYENV_HOME/bin:$PATH

# Install CDKTF via npm
RUN npm install --global cdktf-cli@${CDKTF_VERSION}

# Install pip3, pipenv, and Terraform
RUN pip3 install --no-cache-dir -U pipenv \
        && curl -o terraform.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
        && unzip -o terraform.zip \
        && rm terraform.zip \
        && mv terraform /usr/local/bin/

#Create working directory for cdktf files and copy in library reference Pipfile        
WORKDIR /src
COPY Pipfile* /src
RUN pipenv install --dev --skip-lock 

CMD [ "cdktf" ] 
