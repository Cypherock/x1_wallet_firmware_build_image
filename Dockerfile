# ******** Build stage *********
FROM ubuntu:22.04 as dep-build

RUN apt-get update && apt-get install -y build-essential cmake curl && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN cd /tmp && curl -L https://github.com/ninja-build/ninja/archive/refs/tags/v1.11.1.tar.gz --output ninja.tar.gz && tar xf ninja.tar.gz && cd ninja-1.11.1 && cmake -Bbuild-cmake && cmake --build build-cmake && mv ./build-cmake/ninja /usr/bin/ninja


# ******** Final image *********
FROM ubuntu:22.04

# Add dependencies
RUN apt-get update && apt-get install --no-install-recommends -y git python3.10 curl unzip lbzip2 g++ python3-pip && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN cd /tmp && curl -L https://github.com/Kitware/CMake/releases/download/v3.25.3/cmake-3.25.3-linux-$(uname -m).tar.gz --output cmake.tar.gz && tar -xf cmake.tar.gz && mv cmake-3.25.3-linux-$(uname -m) /opt/cmake && rm cmake.tar.gz
RUN cd /tmp && \
  ARCH_VAL=$(uname -m); if [ "$ARCH_VAL" = "aarch64" ] || [ "$ARCH_VAL" = "arm64" ]; then ARCH_VAL=aarch_64; fi && \
  curl -L https://github.com/protocolbuffers/protobuf/releases/download/v24.4/protoc-24.4-linux-${ARCH_VAL}.zip --output protoc.zip && \
  unzip -o protoc.zip -d /opt/protoc/ && rm protoc.zip
RUN cd /tmp && curl -L https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-$(uname -m)-linux.tar.bz2 --output arm-gcc.tar.bz && tar -xf arm-gcc.tar.bz && mv gcc-arm-none-eabi-10.3-2021.10 /opt/arm-gcc && rm arm-gcc.tar.bz

COPY --from=dep-build /usr/bin/ninja /usr/bin

ENV PATH="$PATH:/opt/arm-gcc/bin:/opt/cmake/bin:/opt/protoc/bin"
ENV PYTHONUNBUFFERED=1

RUN ln -sf python3.10 /usr/bin/python3 && ln -sf python3.10 /usr/bin/python
RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir protobuf grpcio-tools==1.47.0

RUN apt-get update && apt-get remove -y build-essential gcc lbzip2 curl unzip g++ && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*
