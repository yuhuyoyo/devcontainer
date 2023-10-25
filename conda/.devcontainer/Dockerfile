FROM mcr.microsoft.com/devcontainers/anaconda:0-3

USER root

ENV DEBIAN_FRONTEND=noninteractive

COPY requirements.txt apt.txt ./

RUN apt-get update && \
    xargs -a apt.txt apt-get install -y --no-install-recommends && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
