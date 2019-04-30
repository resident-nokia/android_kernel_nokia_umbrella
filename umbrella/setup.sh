#!/bin/sh

# Setup build configuration
export ARCH="arm64"
export SUBARCH="arm64"

# Fetch the toolchain
if [ ! -d prebuilt/gcc-linaro-4.9 ]; then
    wget -O gcc-linaro-4.9.tar.xz https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/aarch64-linux-gnu/gcc-linaro-4.9.4-2017.01-x86_64_aarch64-linux-gnu.tar.xz
    tar xJvf gcc-linaro-4.9.tar.xz    
    if [ ! -d prebuilt ]; then
        mkdir prebuilt
    fi
    mv gcc-linaro-4.9.4-2017.01-x86_64_aarch64-linux-gnu prebuilt/gcc-linaro-4.9
    rm gcc-linaro-4.9.tar.xz
fi
export CROSS_COMPILE="$(pwd)/prebuilt/gcc-linaro-4.9/bin/aarch64-linux-gnu-"

# Set the output directory
export KBUILD_OUTPUT="$(pwd)/out"

# Setup usernames to hide the real machine data
export KBUILD_BUILD_USER="user"
export KBUILD_BUILD_HOST="build"

# Create an alias for current commit hash and tag name
alias umbrella-commit='git rev-parse --verify --short HEAD'
alias umbrella-tag='git describe --exact-match --abbrev=0'

# Nice output
echo "Build Environment initialized:"
echo "  ARCH: $ARCH"
echo "  KBUILD_OUTPUT: $KBUILD_OUTPUT"
echo ""
echo "To configure the build for NB1, type"
echo "  make nb1_defconfig"
echo ""
echo "To configure the build for A1N, type"
echo "  make a1n_defconfig"
echo ""
echo "To compile the configured kernel, type"
echo "  make -j$(nproc --all) LOCALVERSION=-\$(umbrella-commit)"
