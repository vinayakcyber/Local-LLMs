FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt upgrade -y && \
    apt install -y --no-install-recommends \
    ca-certificates git build-essential cmake wget curl pkg-config\
    libcurl4-openssl-dev libopenblas-dev && \
    apt clean && rm -rf /var/lib/apt/lists/*
    
# download llama.cpp
WORKDIR /opt
RUN git clone https://github.com/ggerganov/llama.cpp
WORKDIR /opt/llama.cpp

# install
RUN cmake -B build && \
    cmake --build build --config Release -j$(nproc)

# Set working directory
WORKDIR /opt/llama.cpp/build/bin

# Entrypoint for llama-server (with WebUI enabled by default)
ENTRYPOINT ["./llama-server"]
