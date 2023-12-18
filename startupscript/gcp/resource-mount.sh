# Installs gcsfuse if it is not already installed.
if ! which gcsfuse >/dev/null 2>&1; then
  emit "Installing gcsfuse..."

  # Install based on gcloud docs here https://cloud.google.com/storage/docs/gcsfuse-install.
  export GCSFUSE_REPO="gcsfuse-$(lsb_release -c -s)" \
    && echo "deb https://packages.cloud.google.com/apt ${GCSFUSE_REPO} main" | tee /etc/apt/sources.list.d/gcsfuse.list \
    && curl "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | apt-key add -
  apt-get update \
    && apt-get install -y gcsfuse
else
  emit "gcsfuse already installed. Skipping installation."
fi

${RUN_AS_LOGIN_USER} "terra resource mount"
