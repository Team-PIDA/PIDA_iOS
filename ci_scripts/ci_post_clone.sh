#!/bin/sh

# Xcode Cloud Post-Clone Script for Tuist Project
# Reference: https://docs.tuist.dev/ko/guides/integrations/continuous-integration#xcode-cloud

# Install Mise
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

# Install and activate Tuist
mise install tuist@4.97.2
mise use --global tuist@4.97.2

# ===== 캐시 정리 =====
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf ~/Library/org.swift.swiftpm
mise exec tuist@4.97.2 -- tuist clean --path ../
# ====================

cat > ../Config/Debug-Secrets.xcconfig << EOF
NM_CLIENT_ID = ${NM_CLIENT_ID}
BASE_URL = ${BASE_URL}
BASE_URL_V2 = ${BASE_URL_V2}
MIXPANEL_TOKEN = ${MIXPANEL_TOKEN}
FACEBOOK_APP_ID = ${FACEBOOK_APP_ID}
FACEBOOK_CLIENT_TOKEN = ${FACEBOOK_CLIENT_TOKEN}
EOF

cat > ../Config/Release-Secrets.xcconfig << EOF
NM_CLIENT_ID = ${NM_CLIENT_ID}
BASE_URL = ${BASE_URL}
BASE_URL_V2 = ${BASE_URL_V2}
MIXPANEL_TOKEN = ${MIXPANEL_TOKEN}
FACEBOOK_APP_ID = ${FACEBOOK_APP_ID}
FACEBOOK_CLIENT_TOKEN = ${FACEBOOK_CLIENT_TOKEN}
EOF

# Install dependencies and generate workspace
mise exec tuist@4.97.2 -- tuist install --path ../
mise exec tuist@4.97.2 -- tuist generate --path ../ --no-open
