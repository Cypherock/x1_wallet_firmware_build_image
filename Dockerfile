# ******** Final image *********
FROM alpine:3.14

# Add dependencies
RUN apk add --no-cache gcc-arm-none-eabi newlib-arm-none-eabi ninja cmake bash git python3 py-pip protoc g++ python3-dev linux-headers

ENV PYTHONUNBUFFERED=1

RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python && python3 -m ensurepip
RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir protobuf grpcio-tools

RUN apk del g++
