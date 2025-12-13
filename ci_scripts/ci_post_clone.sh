#!/bin/sh

# Xcode Cloud Post-Clone Script for Tuist Project
# This script runs after Xcode Cloud clones the repository
# It installs Tuist and generates the Xcode workspace

echo "🚀 Starting Xcode Cloud Post-Clone Script for Tuist"

# Exit on error
set -e

# Print commands for debugging
set -x

# Environment Information
echo "📍 Current Directory: $(pwd)"
echo "📦 Tuist Version Required: 4.43.2"
echo "🔧 Xcode Scheme: ${CI_XCODE_SCHEME:-Not Set}"
echo "🏗️ Build Action: ${CI_XCODEBUILD_ACTION:-Not Set}"

# Install Tuist using curl (recommended for CI)
echo "📥 Installing Tuist ..."
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

echo "✅ Verifying Mise installation..."
mise --version

# Install Tuist using Mise (reads from .mise.toml)
echo "📦 Installing Tuist from .mise.toml..."
mise install

# Clean any existing artifacts
echo "🧹 Cleaning existing artifacts..."
tuist clean

# Install dependencies
echo "📦 Installing dependencies..."
tuist install

# Generate Xcode workspace
echo "🔨 Generating Xcode workspace..."
tuist generate --no-open

# Verify workspace generation
if [ -f "PIDA.xcworkspace/contents.xcworkspacedata" ]; then
    echo "✅ Workspace generated successfully!"
    echo "📂 Workspace contents:"
    ls -la PIDA.xcworkspace/
else
    echo "❌ ERROR: Workspace generation failed!"
    echo "📂 Current directory contents:"
    ls -la
    exit 1
fi

# Turn off command printing
set +x

echo "🎉 Post-Clone Script completed successfully!"
