#!/bin/bash

emit "Installing Java JDK ..."

# Set up a known clean directory for downloading the TAR and unzipping it.
${RUN_AS_LOGIN_USER} "mkdir -p '${JAVA_INSTALL_TMP}'"
pushd "${JAVA_INSTALL_TMP}"

# Download the latest Java 17, untar it, and remove the TAR file
${RUN_AS_LOGIN_USER} "\
 curl -Os https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && \
 tar xfz jdk-17_linux-x64_bin.tar.gz && \
 rm jdk-17_linux-x64_bin.tar.gz"

# Get the name local directory that was untarred (something like "jdk-17.0.7")
JAVA_DIRNAME="$(ls)"

# Move it to ~/.local
${RUN_AS_LOGIN_USER} "mv '${JAVA_DIRNAME}' '${USER_HOME_LOCAL_SHARE}'"

# Create a soft link in /usr/bin to the java runtime
ln -sf "${USER_HOME_LOCAL_SHARE}/${JAVA_DIRNAME}/bin/java" "/usr/bin"
chown --no-dereference "${user}" "/usr/bin/java"

# Clean up
popd
rmdir "${JAVA_INSTALL_TMP}"
