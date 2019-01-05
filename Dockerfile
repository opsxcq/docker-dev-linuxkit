FROM debian:jessie

LABEL maintainer "opsxcq@strm.sh"

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential git wget curl \
    qemu qemu-system-arm qemu-system-x86 \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GO 1.11.4
ENV GOLANG_VERSION 1.11.4
ENV goRelArch linux-amd64
ENV goRelSha256 fb26c30e6a04ad937bbc657a1b5bba92f80096af1e8ee6da6430c045a8db3a5b

WORKDIR /usr/local
RUN url="https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz" && \
    wget -O go.tgz "$url" &&  \
    echo "${goRelSha256} *go.tgz" | sha256sum -c - && \
    tar -C /usr/local -xzf go.tgz && \
    rm go.tgz 

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && \
    chmod -R 777 "$GOPATH"


WORKDIR /bin
RUN go get -u github.com/moby/tool/cmd/moby && \
    go get -u github.com/linuxkit/linuxkit/src/cmd/linuxkit

# Install docker
RUN curl -fsSL https://get.docker.com/ | sh

VOLUME /src
WORKDIR /src


