FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install build-essential curl -y
RUN cd /tmp && curl -L http://www.cmake.org/files/v3.15/cmake-3.15.3.tar.gz --output cmake-3.15.3.tar.gz && tar xf cmake-3.15.3.tar.gz && cd cmake-3.15.3 && ./configure && make && make install && rm -rf /tmp/cmake-3.15.3.tar.gz /tmp/cmake-3.15.3
RUN cd /tmp && curl -L https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-$(uname -m)-linux.tar.bz2 --output arm-gcc.tar.bz && tar -xf arm-gcc.tar.bz && mv gcc-arm-none-eabi-10.3-2021.10 /opt/arm-gcc && rm arm-gcc.tar.bz
RUN cd /tmp && curl -L https://github.com/ninja-build/ninja/archive/refs/tags/v1.11.1.tar.gz --output ninja.tar.gz && tar xf ninja.tar.gz && cd ninja-1.11.1 && cmake -Bbuild-cmake && cmake --build build-cmake && mv ./build-cmake/ninja /usr/bin/ninja && rm -rf ninja*
ENV PATH "$PATH:/opt/arm-gcc/build-tools:/opt/arm-gcc/bin"
RUN apt install git python3.10 python3-pip -y
