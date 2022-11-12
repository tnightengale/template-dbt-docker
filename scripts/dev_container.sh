#!/bin/bash

get_host_architecture_for_debian_packages() {
  if [[ $(uname -m) == 'arm64' ]]; then
    echo arm64
  else
    echo amd64
  fi
}

initialize() {
  # Write .arch
  get_host_architecture_for_debian_packages > .devcontainer/.arch
}

post_attach() {
  # Used to apply secrets from the VS Code Remote Container to the SQLTool
  # extension settings. Unfortunately, the SQLTools extension does not support
  # reading using VS Code environment variables. See here for more details:
  # https://github.com/mtxr/vscode-sqltools/issues/452

  CONTAINER_SETTINGS_PATH=/root/.vscode-server/data/Machine/settings.json
  TEMP=$CONTAINER_SETTINGS_PATH.temp

  jq --arg var "$SNOWFLAKE_ACCOUNT" '."sqltools.connections"[0].server = $var' $CONTAINER_SETTINGS_PATH > $TEMP && mv $TEMP $CONTAINER_SETTINGS_PATH
  jq --arg var "$SNOWFLAKE_USER" '."sqltools.connections"[0].database = $var' $CONTAINER_SETTINGS_PATH > $TEMP && mv $TEMP $CONTAINER_SETTINGS_PATH
  jq --arg var "$SNOWFLAKE_DATABASE" '."sqltools.connections"[0].username = $var' $CONTAINER_SETTINGS_PATH > $TEMP && mv $TEMP $CONTAINER_SETTINGS_PATH
  jq --arg var "$SNOWFLAKE_PASSWORD" '."sqltools.connections"[0].password = $var' $CONTAINER_SETTINGS_PATH > $TEMP && mv $TEMP $CONTAINER_SETTINGS_PATH
  jq --arg var "$SNOWFLAKE_WAREHOUSE" '."sqltools.connections"[0].password = $var' $CONTAINER_SETTINGS_PATH > $TEMP && mv $TEMP $CONTAINER_SETTINGS_PATH
}

"$@"
