# dbt & VS Code Dev Containers <!-- omit in toc -->
A templated starting point for developing
[dbt](https://docs.getdbt.com/docs/introduction) projects, using
[poetry](https://python-poetry.org) to manage dependencies and
[docker](https://docs.docker.com/get-started/) for environment consistency.

## Table of Contents <!-- omit in toc -->
- [Overview](#overview)
- [Getting Started](#getting-started)
- [Configuring the Template](#configuring-the-template)
- [Contributions](#contributions)

## Overview
VS Code [dev containers](https://code.visualstudio.com/docs/remote/containers) provide an
immediate development environment for teams to manage their [dbt-Core](https://github.com/dbt-labs/dbt-core/pkgs/container/dbt-core) project.

A dockerized dbt environment allows for a consistent runtime across
contributors and orchestration tools.

Any changes to the environment can be codified in git and propagated to all
developers and tools by rebuilding the container.

## Getting Started
Complete the following steps to launch the dev container in VS Code:

1. Download [Docker Desktop](https://www.docker.com/products/docker-desktop/).
2. Download [VS Code](https://code.visualstudio.com/download).
3. Install the [VS Code Remote Containers Extension](https://code.visualstudio.com/docs/remote/containers-tutorial).
4. Open the project in VS Code and click "Repoen in Container" when prompted.

## Configuring the Template
The following features of this template repository can be configured to specific
use cases:

- The [dbt project](dbt/) can be replaced with an existing project.
    - Note that `dbt/profiles.yml` should be retained within the container.
       - Typically dbt uses profiles from `~/.dbt/profiles.yml`.
       - However this dbt project is designed to be run both locally and by pipelines/orchestration tools.
       - Thus, the profiles need to be included in the container.
       - The connection secrets in the profile should be provided to the
          container via the environment.
- Environment variables should be passed to the development container for local
   development via an `.env` file.
   - Any local `.env` files are ignored by git.
   - See `.example.env` for an example of passing connection details.
- Use [poetry](https://python-poetry.org) to install and manage new
   dependencies in the container.
- The [scripts/](scripts/) folder can be used to house build and pipeline
  scripts.
- The [.dev container.json](.dev container/dev container.json) contains
   recommended VS Code extensions for development.
   - These are cached by default
   in a docker volume for fast rebuilds of the environment.
    - The
     [SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)
     extension is setup with a Snowflake connection by default.
      - The connection uses params in `.example.env` which are injected by the
     `postAttachCommand` in the [.dev container.json](.dev container/dev container.json).
      - SQLTools connections allow viewing and querying data in the warehouse
        directly from the VS Code dev container.
      - dbt models can be created in the warehouse and the data viewed from within
        VS Code to accelerate development.

## Contributions
Please reach out and starta discussion if you are interested in enhancing this
template.

You can find the author in the [dbt
Slack](https://app.slack.com/team/USPDHN49M) or simply open an issue here. Cheers!
