#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

if [ $# -ne 3 ]; then
  echo "Usage: $0 user workDirectory gcp/aws"
  exit 1
fi

user="$1"
workDirectory="$2"
cloud="$3"
#######################################
# Emit a message with a timestamp
#######################################
function emit() {
 echo "$(date '+%Y-%m-%d %H:%M:%S') $*"
}
readonly -f emit

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source ${SCRIPT_DIR}/${cloud}/get_metadata_attributes.sh

readonly RUN_AS_LOGIN_USER="sudo -u ${user} bash -l -c"

readonly USER_BASH_COMPLETION_DIR="${workDirectory}/.bash_completion.d"
readonly USER_HOME_LOCAL_SHARE="${workDirectory}/.local/share"
readonly USER_TERRA_CONFIG_DIR="${workDirectory}/.terra"
readonly USER_SSH_DIR="${workDirectory}/.ssh"
readonly USER_BASHRC="${workDirectory}/.bashrc"
readonly USER_BASH_PROFILE="${workDirectory}/.bash_profile"
readonly POST_STARTUP_OUTPUT_FILE="${USER_TERRA_CONFIG_DIR}/post-startup-output.txt"

readonly JAVA_INSTALL_TMP="${USER_TERRA_CONFIG_DIR}/javatmp"

# Variables for Workbench-specific code installed on the VM
readonly TERRA_INSTALL_PATH="/usr/bin/terra"

readonly WORKBENCH_GIT_REPOS_DIR="${workDirectory}/repos"

# Move to the /tmp directory to let any artifacts left behind by this script can be removed.
cd /tmp || exit

# Send stdout and stderr from this script to a file for debugging.
# Make the .terra directory as the user so that they own it and have correct linux permissions.
${RUN_AS_LOGIN_USER} "mkdir -p '${USER_TERRA_CONFIG_DIR}'"
exec >> "${POST_STARTUP_OUTPUT_FILE}"
exec 2>&1

# The apt package index may not be clean when we run; resynchronize
apt-get update
apt install -y jq curl tar

# Create the target directories for installing into the HOME directory
${RUN_AS_LOGIN_USER} "mkdir -p '${USER_BASH_COMPLETION_DIR}'"
${RUN_AS_LOGIN_USER} "mkdir -p '${USER_HOME_LOCAL_SHARE}'"

# As described above, have the ~/.bash_profile source the ~/.bashrc
cat << EOF >> "${USER_BASH_PROFILE}"

if [[ -e ~/.bashrc ]]; then
 source ~/.bashrc
fi

EOF

######################
# Install java
######################
source ${SCRIPT_DIR}/install-java.sh

######################
# workbench CLI set up
######################
source ${SCRIPT_DIR}/${cloud}/vwb-cli-setup.sh

#################
# bash completion
#################
source ${SCRIPT_DIR}/bash-completion.sh

###############
# git setup
###############
source ${SCRIPT_DIR}/git-setup.sh

#############################
# Mount buckets
#############################
source ${SCRIPT_DIR}/${cloud}/resource-mount.sh
