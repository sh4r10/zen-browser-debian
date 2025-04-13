# Zen Browser Debian
This is basically an attempt at reverse engineering the provided install script
for the zen browser, found here:
[https://updates.zen-browser.app/install.sh](https://updates.zen-browser.app/install.sh)

## Steps to recreate
1. Clone this repository and enter the folder
```bash 
git clone https://github.com/sh4r10/zen-browser-debian.git & cd zen-browser-debian
```

2. Get the latest tarball for the zen-browser
```bash
wget https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz
```

3. Look through the variables at the top of the create-zen-deb.sh script, you
   should only really need to change the version and possibly the tarball name
```bash
PACKAGE_NAME="zen-browser"
VERSION="1.11.2b"
ARCH="amd64"
TARBALL="zen.linux-x86_64.tar.xz"
BUILD_DIR="${PACKAGE_NAME}_${VERSION}"
INSTALL_DIR="$BUILD_DIR/opt/zen"
BIN_DIR="$BUILD_DIR/usr/local/bin"
DESKTOP_DIR="$BUILD_DIR/usr/local/share/applications"
```

4. Run the script
```bash
./create-zen-deb.sh
```
If everything goes to plan, you should now have .deb file in your folder. This
can then be installed with dpkg or uploaded to apt repo.

```
dpkg -i name-of-file.deb
```

You can also download an already built deb file from the releases section and
install it in the same way. 
