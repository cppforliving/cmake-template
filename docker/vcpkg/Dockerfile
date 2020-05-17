FROM cmake-template/common

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        tar \
        unzip \
    ; \
    rm -rf /var/lib/apt/lists/*

USER dockworker

ENV PATH=/home/dockworker/.local/bin:$PATH \
    CMAKE_TOOLCHAIN_FILE=/home/dockworker/vcpkg/scripts/buildsystems/vcpkg.cmake \
    PACKAGE_MANAGER=vcpkg \
    VCPKG_ROOT=/home/dockworker/vcpkg

RUN python3 -m pip install --no-cache-dir --user pytest

RUN set -eux; \
    cd ~; \
    git clone --depth=1 https://github.com/Microsoft/vcpkg.git; \
    cd vcpkg; \
    ./bootstrap-vcpkg.sh -disableMetrics

ENTRYPOINT ["/entrypoint.sh"]
