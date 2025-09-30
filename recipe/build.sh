#!/bin/bash

declare -a CMAKE_PLATFORM_FLAGS
if [[ ${target_platform} == osx-64 ]]; then
  CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}")
fi

mkdir build || true
pushd build

  cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
        $CMAKE_ARGS \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=ON \
        -DTIFF_LIBRARY=$PREFIX/lib/libtiff${SHLIB_EXT} \
        -DTIFF_INCLUDE_DIR=$PREFIX/include \
        -DPNG_LIBRARY_RELEASE=$PREFIX/lib/libpng${SHLIB_EXT} \
        -DPNG_PNG_INCLUDE_DIR=$PREFIX/include \
        -DZLIB_LIBRARY=$PREFIX/lib/libz${SHLIB_EXT} \
        -DZLIB_INCLUDE_DIR=$PREFIX/include \
        "${CMAKE_PLATFORM_FLAGS[@]}" \
        ..

  make -j${CPU_COUNT} ${VERBOSE_CM}
  ctest -C Release -j${CPU_COUNT}
  make install -j${CPU_COUNT}

popd
