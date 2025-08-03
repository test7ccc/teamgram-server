FROM golang:1.21.13 AS builder
WORKDIR /app
COPY . .
# 设置 Go 代理为七牛云，并设置私有仓库不走代理
RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN ./build.sh

FROM ubuntu:latest
RUN apt update -y && apt install -y ffmpeg && apt-get clean
WORKDIR /app
COPY --from=builder /app/teamgramd/ /app/
RUN chmod +x /app/docker/entrypoint.sh
ENTRYPOINT /app/docker/entrypoint.sh
