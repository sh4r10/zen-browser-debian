#!/bin/bash
set -euo pipefail

# === CONFIG ===
PACKAGE_NAME="zen-browser"
VERSION="1.11.2b"
ARCH="amd64"
TARBALL="zen.linux-x86_64.tar.xz"
BUILD_DIR="${PACKAGE_NAME}_${VERSION}"
INSTALL_DIR="$BUILD_DIR/opt/zen"
BIN_DIR="$BUILD_DIR/usr/local/bin"
DESKTOP_DIR="$BUILD_DIR/usr/local/share/applications"

# === CLEAN UP OLD BUILDS ===
rm -rf "$BUILD_DIR"
mkdir -p "$INSTALL_DIR" "$BIN_DIR" "$DESKTOP_DIR"

# === EXTRACT THE TARBALL ===
echo "Extracting tarball..."
tar -xf "$TARBALL"
mv zen/* "$INSTALL_DIR"

# === CREATE EXECUTABLE WRAPPER ===
echo "Creating wrapper script..."
cat <<EOF > "$BIN_DIR/zen"
#!/bin/bash
/opt/zen/zen "\$@"
EOF
chmod +x "$BIN_DIR/zen"

# === CREATE .desktop FILE ===
echo "Creating .desktop file..."
cat <<EOF > "$DESKTOP_DIR/zen.desktop"
[Desktop Entry]
Name=Zen Browser
Comment=Experience tranquillity while browsing the web without people tracking you!
Keywords=web;browser;internet
Exec=/opt/zen/zen %u
Icon=zen
Terminal=false
StartupNotify=true
StartupWMClass=zen
NoDisplay=false
Type=Application
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
Categories=Network;WebBrowser;
Actions=new-window;new-private-window;profile-manager-window;

[Desktop Action new-window]
Name=Open a New Window
Exec=/opt/zen/zen --new-window %u

[Desktop Action new-private-window]
Name=Open a New Private Window
Exec=/opt/zen/zen --private-window %u

[Desktop Action profile-manager-window]
Name=Open the Profile Manager
Exec=/opt/zen/zen --ProfileManager
EOF

# === CREATE DEBIAN CONTROL FILE ===
echo "Creating control file..."
mkdir -p "$BUILD_DIR/DEBIAN"
cat <<EOF > "$BUILD_DIR/DEBIAN/control"
Package: $PACKAGE_NAME
Version: $VERSION
Section: web
Priority: optional
Architecture: $ARCH
Maintainer: Shariq Shahbaz <iamsh4r10@gmail.com>
Description: Zen Browser - A privacy-focused browser that helps you browse in peace.
EOF

# === BUILD THE DEB PACKAGE ===
echo "Building .deb package..."
dpkg-deb --build "$BUILD_DIR"

# === FINAL CLEANUP ===
echo "Final cleanup..."
rm -rf zen "$BUILD_DIR"

echo "Done! Output: ${BUILD_DIR}.deb"
