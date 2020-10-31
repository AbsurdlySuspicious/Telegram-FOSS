#!/bin/bash
set -e

export NINJA_PATH=$(which ninja)
export NDK=$(rg 'ndk.dir=(.+)$' -or '$1' local.properties)

git submodule deinit --all -f
git submodule update --recursive --init -f

pushd toolchain
./build_toolchain.sh
export TOOLCHAIN_BASE=`pwd`

popd
pushd TMessagesProj/jni
./build_ffmpeg_clang.sh
./patch_ffmpeg.sh
./patch_boringssl.sh
./build_boringssl.sh

popd
./gradlew assembleAfatRelease && ./gradlew --stop

