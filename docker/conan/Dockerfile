FROM cmake-template/common

USER dockworker

ENV PATH=/home/dockworker/.local/bin:$PATH \
    CMAKE_TOOLCHAIN_FILE=/home/dockworker/build/conan_paths.cmake \
    PACKAGE_MANAGER=conan

RUN python3 -m pip install --no-cache-dir --user pytest conan

ENTRYPOINT ["/entrypoint.sh"]
