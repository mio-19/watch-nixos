{
  mobile-nixos
, fetchFromGitHub
, ...
}:

# Fossil Gen 6 (hoki) ships a 4.14 downstream Qualcomm kernel.
# AsteroidOS builds it with GCC 8; their recipe notes that "gcc >= 13
# doesn't boot", so do not upgrade the compiler blindly.
#
# Patches 0001-0006 are vendored verbatim from AsteroidOS meta-smartwatch
# (meta-hoki/recipes-kernel/linux/files). 90_dtbs-install is ours: this tree
# has no ARM dtbs_install target.
mobile-nixos.kernel-builder {
  version = "4.14.206";
  configfile = ./config.armv7;

  src = fetchFromGitHub {
    owner = "fossil-engineering";
    repo = "kernel-msm-fossil-cw";
    rev = "c0b4c201f2d5a641defe19958a9b4c16f40d866b";
    sha256 = "sha256-uf5Vln2M64ksT9BC4/R9gLV2yo6zK0vQeolyCUj/u+o=";
  };

  patches = [
    ./0001-dts-Add-hoki-device-trees.patch
    ./0002-mmc-Fix-embedded_sdio_data-duplicate-definition.patch
    ./0003-video-fbdev-msm-Provide-mdss_dsi_switch_page.patch
    ./0004-usb-hcd-Handle-when-host-mode-isn-t-available.patch
    ./0005-initramfs-Don-t-skip-initramfs.patch
    ./0006-ARM-8933-1-replace-Sun-Solaris-style-flag-on-section.patch
    ./90_dtbs-install.patch
  ];

  isModular = false;

  # Set by CONFIG_BUILD_ARM_APPENDED_DTB_IMAGE in the defconfig.
  buildDTBs = true;
}
