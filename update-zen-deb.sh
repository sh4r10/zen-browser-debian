#!/bin/bash
#
# Time-stamp: <Tuesday 2025-07-29 08:15:18 +1000 Graham Williams>
#
# Download the current distribution of zen for Linux and update the
# create-zen-deb.sh script with the new version, ready to create and
# then install a .deb.
#
# Author: Graham.Williams@togaware.com

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

# Update the VERSION line in create-zen-deb.sh.

sed -i "s/VERSION=\"[^\"]*\"/VERSION=\"$VERSION\"/" create-zen-deb.sh

echo
echo "You can now create zen-browser_${VERSION}.deb to install the package:"
echo
echo "./create-zen-deb.sh"
echo
echo "sudo dpkg -i zen-browser_${VERSION}.deb"
echo
