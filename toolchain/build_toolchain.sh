#!/bin/bash

function build_tc {
  TOOLCHAIN_PREFIX="${TOOLCHAIN_BASE}/${ARCH}-${API}"
  echo "Building for $ARCH android${API}"

  if [ "$PARAM" == clean ]; then
    rm -r "$TOOLCHAIN_PREFIX"
  elif [ -d "$TOOLCHAIN_PREFIX" ]; then
    echo "skip"
    return
  fi

  python $NDK/build/tools/make_standalone_toolchain.py \
    --arch ${ARCH} \
    --api ${API} \
    --stl libc++ \
    --install-dir=${TOOLCHAIN_PREFIX}
}

PARAM=$1
BASEDIR=`pwd`
TOOLCHAIN_BASE=${BASEDIR}/toolchain-android

API=21; ARCH=x86_64;
build_tc

API=21; ARCH=arm64;
build_tc

API=16; ARCH=arm;
build_tc

API=16; ARCH=x86;
build_tc

