FROM ubuntu:16.04
LABEL maintainer="Atanu Barai"

# Install tools for development.
RUN apt-get update && apt-get install -y \
  python \
  python-pip \
  git \
  tmux \
  vim \
  cmake \
  wget \
  ack-grep

RUN pip install --upgrade pip

RUN mkdir -p /workspace
ENV LLVM_HOME /usr/local
ENV BOOST_ROOT /usr/include

ENV SHELL /bin/bash

# Build LLVM and Clang 3.5.2 from source.
WORKDIR /tmp
RUN wget -q https://releases.llvm.org/3.5.2/llvm-3.5.2.src.tar.xz && \
    tar -xf llvm-3.5.2.src.tar.xz && \
    wget -q https://releases.llvm.org/3.5.2/cfe-3.5.2.src.tar.xz && \
    tar -xf cfe-3.5.2.src.tar.xz && \
    mv cfe-3.5.2.src llvm-3.5.2.src/tools/clang && \
    wget -q https://releases.llvm.org/3.5.2/compiler-rt-3.5.2.src.tar.xz && \
    tar -xf compiler-rt-3.5.2.src.tar.xz && \
    mv compiler-rt-3.5.2.src llvm-3.5.2.src/projects/compiler-rt && \
    wget -q https://releases.llvm.org/3.5.2/clang-tools-extra-3.5.2.src.tar.xz && \
    tar -xf clang-tools-extra-3.5.2.src.tar.xz && \
    mv clang-tools-extra-3.5.2.src llvm-3.5.2.src/tools/clang/tools/extra && \
    wget -q https://releases.llvm.org/3.5.2/libcxx-3.5.2.src.tar.xz && \
    tar -xf libcxx-3.5.2.src.tar.xz && \
    mv libcxx-3.5.2.src llvm-3.5.2.src/projects/libcxx && \
    wget -q https://releases.llvm.org/3.5.2/libcxxabi-3.5.2.src.tar.xz && \
    tar -xf libcxxabi-3.5.2.src.tar.xz && \
    mv libcxxabi-3.5.2.src llvm-3.5.2.src/projects/libcxxabi && \
    wget -q https://releases.llvm.org/3.5.2/lld-3.5.2.src.tar.xz && \
    tar -xf lld-3.5.2.src.tar.xz && \
    mv lld-3.5.2.src llvm-3.5.2.src/tools/lld && \
    mkdir build && \
    cd build && \
    ../llvm-3.5.2.src/configure && \
    make -j8 && \
    make install
RUN rm -rf /tmp/llvm-3.5.2* && \
    rm -rf /tmp/cfe-3.5.2*

# Build and install Byfl
RUN wget -q https://github.com/lanl/Byfl/releases/download/v1.4-llvm-3.5.2/byfl-1.4-llvm-3.5.2.tar.gz
RUN tar -xf byfl-1.4-llvm-3.5.2.tar.gz
RUN ls
RUN cd byfl-1.4-llvm-3.5.2 && \
    mkdir build && \
    cd build && \
    ../configure && \
    make && \
    make install

WORKDIR /workspace
