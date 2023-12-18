#!/bin/bash

#
# bash_completion is installed on Vertex AI notebooks, but the installed
# completion scripts are *not* sourced from /etc/profile.
# If we need it system-wide, we can install it there, but otherwise, let's
# keep changes localized to the user.
#
emit "Configuring bash completion for the VM..."

cat << 'EOF' >> "${USER_BASHRC}"

# Prepend "/usr/bin" (if not already in the path)
if [[ "${PATH}:" != "/usr/bin:"* ]]; then
  export PATH=/usr/bin:${PATH}
fi
# Source available global bash tab completion scripts
if [[ -d /etc/bash_completion.d ]]; then
 for BASH_COMPLETION_SCRIPT in /etc/bash_completion.d/* ; do
   source "${BASH_COMPLETION_SCRIPT}"
 done
fi

# Source available user installed bash tab completion scripts
if [[ -d ~/.bash_completion.d ]]; then
 for BASH_COMPLETION_SCRIPT in ~/.bash_completion.d/* ; do
   source "${BASH_COMPLETION_SCRIPT}"
 done
fi
EOF

