#!/bin/sh

# Xcode Cloud Post-Clone Script for Tuist Project
# Reference: https://docs.tuist.dev/ko/guides/integrations/continuous-integration#xcode-cloud

# Install Mise
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

# Install and activate Tuist
mise install tuist@4.97.2
mise use --global tuist@4.97.2

# Install dependencies and generate workspace
mise exec tuist@4.97.2 -- tuist install --path ../
mise exec tuist@4.97.2 -- tuist generate --path ../ --no-open
