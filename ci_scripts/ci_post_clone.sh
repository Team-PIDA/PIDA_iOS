#!/bin/sh

# Xcode Cloud Post-Clone Script for Tuist Project
# Reference: https://docs.tuist.dev/ko/guides/integrations/continuous-integration#xcode-cloud

# Install Mise
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

# Install and activate Tuist
mise install tuist@4.97.2
mise use --global tuist@4.97.2

cat > ../Config/Debug-Secrets.xcconfig << EOF
NM_CLIENT_ID = ${NM_CLIENT_ID}
BASE_URL = ${BASE_URL}
EOF

cat > ../Config/Release-Secrets.xcconfig << EOF
NM_CLIENT_ID = ${NM_CLIENT_ID}
BASE_URL = ${BASE_URL}
EOF

# Install dependencies and generate workspace
mise exec tuist@4.97.2 -- tuist install --path ../
mise exec tuist@4.97.2 -- tuist generate --path ../ --no-open
