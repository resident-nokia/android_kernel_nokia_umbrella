#!/bin/sh

# Setup build configuration
export ARCH="arm64"
export SUBARCH="arm64"

# Update submodules
git submodule update --recursive --init

# Detect the toolchain
TRIPLET=$(basename $(pwd)/toolchain/bin/*gcc | sed 's|gcc$||g')
export CROSS_COMPILE="$(pwd)/toolchain/bin/$TRIPLET"

# Set the output directory
export KBUILD_OUTPUT="$(pwd)/out"

# Setup usernames to hide the real machine data
export KBUILD_BUILD_USER="user"
export KBUILD_BUILD_HOST="build"

# Create an alias for current commit hash and tag name
alias umbrella-commit='git rev-parse --verify --short HEAD'
alias umbrella-tag='git describe --exact-match --abbrev=0'

# Nice output
$(pwd)/toolchain/bin/${TRIPLET}gcc --version

echo "To configure the build for NB1, type"
echo "  make -j$(nproc --all) nb1_defconfig"
echo ""
echo "To configure the build for A1N, type"
echo "  make -j$(nproc --all) a1n_defconfig"
echo ""
echo "To compile the configured kernel, type"
echo "  make -j$(nproc --all) LOCALVERSION=-\$(umbrella-commit)"
