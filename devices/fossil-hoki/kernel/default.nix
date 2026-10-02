{
  mobile-nixos
, fetchFromGitHub
, ...
}:

# Fossil Gen 6 (hoki) ships a 4.14 downstream Qualcomm kernel.
# AsteroidOS builds it with GCC 8; their recipe notes that "gcc >= 13
# doesn't boot", so do not upgrade the compiler blindly.
#
# The hoki device trees are not in this source. They are carried as patches
# by AsteroidOS in meta-smartwatch (meta-hoki/recipes-kernel/linux/files),
# and must be vendored here before a usable DTB can be produced.
mobile-nixos.kernel-builder {
  version = "4.14.206";
  configfile = ./config.armv7;

  src = fetchFromGitHub {
    owner = "fossil-engineering";
    repo = "kernel-msm-fossil-cw";
    rev = "c0b4c201f2d5a641defe19958a9b4c16f40d866b";
    sha256 = "sha256-uf5Vln2M64ksT9BC4/R9gLV2yo6zK0vQeolyCUj/u+o=";
  };

  isModular = false;

  # Set by CONFIG_BUILD_ARM_APPENDED_DTB_IMAGE in the defconfig.
  buildDTBs = true;
}
