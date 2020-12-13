FROM conanio/clang11

RUN set -ex; \
    sudo apt-get update

RUN sudo apt-get install -y --no-install-recommends ccache

ENV PATH /home/conan/.local/bin:$PATH

RUN pip3 install --user pytest
