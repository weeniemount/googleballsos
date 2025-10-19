#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux fastfetch htop
dnf5 remove -y firefox

dnf5 install -y feh ffplay pkill

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket


chmod +x /usr/job/job.sh
#cd /usr/
#mkdir local
#cd local
#mkdir bin
#sudo ln -s /usr/job/job.sh /usr/local/bin/vim
#sudo ln -s /usr/job/job.sh /usr/local/bin/vi
#sudo ln -s /usr/job/job.sh /usr/local/bin/nvim
#sudo ln -s /usr/job/job.sh /usr/local/bin/neovim

# image-info.sh

# taken from https://github.com/ublue-os/bazzite/blob/main/build_files/image-info and modified by me for google balls os

set -eoux pipefail

IMAGE_PRETTY_NAME="Google Balls OS"
IMAGE_LIKE="fedora"
HOME_URL="https://googleballs.com"
DOCUMENTATION_URL="https://googleballs.com"
SUPPORT_URL="https://discord.gg/54sNKkcmMf"
BUG_SUPPORT_URL="https://github.com/weeniemount/googleballsos/issues/"
LOGO_ICON="fedora-logo-icon"
LOGO_COLOR="0;38;2;138;43;226"
IMAGE_VENDOR="weeniemount"
IMAGE_NAME="googleballsos"

IMAGE_INFO="/usr/share/ublue-os/image-info.json"
IMAGE_REF="ostree-image-signed:docker://ghcr.io/$IMAGE_VENDOR/$IMAGE_NAME"
IMAGE_BRANCH_NORMALIZED=$IMAGE_BRANCH

if [[ $IMAGE_BRANCH_NORMALIZED == "main" ]]; then
  IMAGE_BRANCH_NORMALIZED="stable"
fi

case "$FEDORA_VERSION" in
  39|40|41)
    IMAGE_TAG="stable"
    ;;
  *)
    IMAGE_TAG="$FEDORA_VERSION"
    ;;
esac

# Image Info File
cat > $IMAGE_INFO <<EOF
{
  "image-name": "$IMAGE_NAME",
  "image-flavor": "$IMAGE_FLAVOR",
  "image-vendor": "$IMAGE_VENDOR",
  "image-ref": "$IMAGE_REF",
  "image-tag": "$IMAGE_TAG",
  "image-branch": "$IMAGE_BRANCH_NORMALIZED",
  "base-image-name": "$BASE_IMAGE_NAME",
  "fedora-version": "$FEDORA_VERSION",
  "version": "$VERSION_TAG",
  "version-pretty": "$VERSION_PRETTY"
}
EOF

# OS Release File
sed -i "s/^VARIANT_ID=.*/VARIANT_ID=$IMAGE_NAME/" /usr/lib/os-release
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"Bazzite\"/" /usr/lib/os-release
sed -i "s/^NAME=.*/NAME=\"$IMAGE_PRETTY_NAME\"/" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"$HOME_URL\"|" /usr/lib/os-release
sed -i "s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"$DOCUMENTATION_URL\"|" /usr/lib/os-release
sed -i "s|^SUPPORT_URL=.*|SUPPORT_URL=\"$SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"$BUG_SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s|^CPE_NAME=\"cpe:/o:fedoraproject:fedora|CPE_NAME=\"cpe:/o:universal-blue:${IMAGE_PRETTY_NAME,}|" /usr/lib/os-release
sed -i "s/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME=\"${IMAGE_PRETTY_NAME,}\"/" /usr/lib/os-release
sed -i "s/^ID=fedora/ID=${IMAGE_PRETTY_NAME,}\nID_LIKE=\"${IMAGE_LIKE}\"/" /usr/lib/os-release
sed -i "s/^LOGO=.*/LOGO=$LOGO_ICON/" /usr/lib/os-release
sed -i "s/^ANSI_COLOR=.*/ANSI_COLOR=\"$LOGO_COLOR\"/" /usr/lib/os-release
sed -i "/^REDHAT_BUGZILLA_PRODUCT=/d; /^REDHAT_BUGZILLA_PRODUCT_VERSION=/d; /^REDHAT_SUPPORT_PRODUCT=/d; /^REDHAT_SUPPORT_PRODUCT_VERSION=/d" /usr/lib/os-release
sed -i "s|^VERSION_CODENAME=.*|VERSION_CODENAME=\"${BASE_IMAGE_NAME^}\"|" /usr/lib/os-release

# Fix issues caused by ID no longer being fedora
sed -i "s/^EFIDIR=.*/EFIDIR=\"fedora\"/" /usr/sbin/grub2-switch-to-blscfg

echo "BUILD_ID=\"$VERSION_PRETTY\"" >> /usr/lib/os-release
echo "BOOTLOADER_NAME=\"$IMAGE_PRETTY_NAME $VERSION_PRETTY\"" >> /usr/lib/os-release

# IMAGE_ID is used to decide whether to load a hibernation image
# use a unique id to prevent loading stale hibernation images
# INITRAMFS NEEDS TO BE GENERATED AFTER THIS SCRIPT HAS RUN
echo "IMAGE_ID=\"$IMAGE_NAME-$VERSION_TAG\"" >> /usr/lib/os-release