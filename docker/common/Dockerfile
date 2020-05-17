FROM ubuntu:20.04

RUN groupadd -r dockworker && useradd -r -m -g dockworker dockworker

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        cmake \
        g++ \
        make \
        python3 \
        python3-dev \
        python3-pip \
    ; \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
