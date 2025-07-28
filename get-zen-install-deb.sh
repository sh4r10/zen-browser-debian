#!/bin/bash
#
# Time-stamp: <Tuesday 2025-07-29 08:40:45 +1000 Graham Williams>
#
# Download the current distribution of zen for Linux, create the .deb
# and then install the .deb.

set -euo pipefail

# Make a dated backup of any previously downloaded distribution file.

if [ -e zen.linux-x86_64.tar.xz ]; then
    mv zen.linux-x86_64.tar.xz zen.linux-x86_64.tar.xz.$(date +'%Y%m%d')
fi

# Download the latest release of zen.

wget --quiet --show-progress \
     https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz \
     -O zen.linux-x86_64.tar.xz

# Extract the version from the downloaded file.

VERSION=$(tar -xJf zen.linux-x86_64.tar.xz --to-stdout zen/application.ini | grep '^Version=' | cut -d'=' -f2)

# Create the .deb package.

bash create-zen-deb.sh

# Install the .deb package locally.

sudo dpkg -i zen-browser_${VERSION}.deb
