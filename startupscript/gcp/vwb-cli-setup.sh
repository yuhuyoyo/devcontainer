#!/bin/bash

# Install & configure the VWB CLI
emit "Installing the VWB CLI ..."

# Fetch the VWB CLI server environment from the metadata server to install appropriate CLI version
TERRA_SERVER="$(get_metadata_value "instance/attributes/terra-cli-server")"
if [[ -z "${TERRA_SERVER}" ]]; then
  TERRA_SERVER="verily"
fi
readonly TERRA_SERVER

# If the server environment is a verily server, use the verily download script.
if [[ "${TERRA_SERVER}" == *"verily"* ]]; then
  # Map the CLI server to appropriate AFS service path and fetch the CLI distribution path
  if ! versionJson="$(curl -s "https://${TERRA_SERVER/verily/terra}-axon.api.verily.com/version")"; then
    >&2 echo "ERROR: Failed to get version file from ${TERRA_SERVER}"
    exit 1
  fi
  cliDistributionPath="$(echo ${versionJson} | jq -r '.cliDistributionPath')"

  ${RUN_AS_LOGIN_USER} "curl -L https://storage.googleapis.com/${cliDistributionPath#gs://}/download-install.sh | TERRA_CLI_SERVER=${TERRA_SERVER} bash"
  cp terra "${TERRA_INSTALL_PATH}"
else
  >&2 echo "ERROR: ${TERRA_SERVER} is not a known VWB server"
  exit 1
fi

# Set browser manual login since that's the only login supported from a Vertex AI Notebook VM
${RUN_AS_LOGIN_USER} "terra config set browser MANUAL"

# Set the CLI terra server based on the terra server that created the VM.
${RUN_AS_LOGIN_USER} "terra server set --name=${TERRA_SERVER}"

# Log in with app-default-credentials
${RUN_AS_LOGIN_USER} "terra auth login --mode=APP_DEFAULT_CREDENTIALS"

# Generate the bash completion script
${RUN_AS_LOGIN_USER} "terra generate-completion > '${USER_BASH_COMPLETION_DIR}/terra'"


####################################
# Shell and notebook environment
####################################

# Set the CLI terra workspace id using the VM metadata, if set.
readonly TERRA_WORKSPACE="$(get_metadata_value "instance/attributes/terra-workspace-id")"
if [[ -n "${TERRA_WORKSPACE}" ]]; then
 ${RUN_AS_LOGIN_USER} "terra workspace set --id='${TERRA_WORKSPACE}'"
fi
