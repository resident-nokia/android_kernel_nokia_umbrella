#!/bin/sh

# If you plan to release a kernel based on umbrella
# change the name here so it is reflected in the output
_NAME="Umbrella"

# Test for a compiled kernel
if [ ! -f out/arch/arm64/boot/Image.*-dtb ]; then
    echo "Please compile a kernel before attempting to package it!"
    exit 1
fi

# Try to autodetect the device the kernel was built for if it wasn't specified
KVERSION=$(make -s kernelrelease)
if [ "$KDEVICE" = "" ]; then
    if echo $KVERSION | grep -qi NB1; then
        KDEVICE="NB1"
    fi
    if echo $KVERSION | grep -qi A1N; then
        KDEVICE="A1N"
    fi
fi
if [ "$KNAME" = "" ]; then
    KNAME=$_NAME
fi

# Copy the template config
cp -r umbrella/template umbrella/.tmp

# Update the variables
echo "Version: $KVERSION" > umbrella/.tmp/version
sed -i "s/{DEVICE}/$KDEVICE/g" umbrella/.tmp/anykernel.sh
sed -i "s/{NAME}/$KNAME/g" umbrella/.tmp/anykernel.sh

# Copy the kernel
cp out/arch/arm64/boot/Image.*-dtb umbrella/.tmp

# Package the zip file
mkdir -p umbrella/out
cd umbrella/.tmp
zip -r ../out/$KNAME-$KVERSION.zip .
cd ../..

# Clean up
rm -r umbrella/.tmp
