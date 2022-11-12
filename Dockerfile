########################################
# --------------- BASE --------------- #
########################################
FROM python:3.9.14-slim-bullseye AS base

ENV POETRY_VIRTUALENVS_CREATE=false \
    POETRY_VERSION=1.1.13 \
    POETRY_HOME=/usr/local \
    AWS_CLI_VERSION=2.8.2

RUN apt-get update \
    && apt-get install -y git curl vim jq unzip sudo \
    && apt-get clean

RUN curl -sSL https://install.python-poetry.org | python -

# Installs the AWS CLI v2, which is not available via PyPi
RUN ARCH=$([ "$(uname -m)" = "x86_64" ] && echo "x86_64" || echo "aarch64") \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" \
    && unzip -q awscliv2.zip \
    && sudo ./aws/install

WORKDIR /code/

COPY ["poetry.lock", "pyproject.toml", "/code/"]
RUN poetry install --no-interaction --without dev

##########################
# --------- DEV -------- #
##########################
FROM base AS dev_container
# Used in VS Code development Container. Enables "Docker from Docker" ie.
# building and running containers on the host (laptop) within the VS Code
# Development Container See for more details: https://bit.ly/3yIRcWA

# .devcontainer/.arch contains either 'amd64' or 'arm64' depending on the
# architecture of the host machine (eg. Apple M1 = 'arm64') and is used
# to ensure the correct the debian installation of the Docker CLI is fetched
# from the linux package registry.
COPY [".devcontainer/.arch", "/code/"]

RUN apt-get update \
    && apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release \
    && ARCH=$(cat /code/.arch) \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && echo "deb [arch=$ARCH] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli

COPY --from=base ["/usr", "/usr"]

######################
# ------- PROD ----- #
######################
FROM base as prod
# Used for runs in pipelines and jobs.

COPY --from=base ["/usr/local/bin", "/usr/local/bin"]

COPY ["dbt", "/code/dbt/"]

WORKDIR /code/dbt/
