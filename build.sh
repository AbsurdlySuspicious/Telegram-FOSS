#!/bin/bash
set -e

export NINJA_PATH=$(which ninja)
export NDK=$(rg 'ndk.dir=(.+)$' -or '$1' local.properties)

submodule_init() {
  git submodule deinit --all -f
  git submodule update --recursive --init -f
}

jni_build() {
  pushd TMessagesProj/jni
  ./build_libvpx_clang.sh
  ./build_ffmpeg_clang.sh
  ./patch_ffmpeg.sh
  ./patch_boringssl.sh
  ./build_boringssl.sh
  popd
}

gradle_build() {
  ./gradlew assembleAfatRelease && ./gradlew --stop
}

if [[ "$GRADLE_ONLY" != 1 ]]; then
  submodule_init
  jni_build
fi
gradle_build


