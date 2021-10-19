#!/bin/sh

cd ~sergor/.cache

#mkdir -m 700 -p /tmp/.cache/chromium

if [[ "$1" == "save" ]]; then
        rm -f {chromium,iridium,firefox}-cache.tgz
        tar Pzcpf chromium-cache.tgz /tmp/.cache/chromium/*
        tar Pzcpf iridium-cache.tgz /tmp/.cache/iridium/*
        tar Pzcpf firefox-cache.tgz /tmp/.cache/mozilla/*
elif [[ "$1" == "restore" ]]; then
        rm -rf chromium iridium mozilla
        mkdir -m 700 -p /tmp/.cache/{chromium,iridium,mozilla} && \
        	chown sergor:sergor /tmp/.cache/{chromium,iridium,mozilla}
        tar Pzxpf chromium-cache.tgz && \
       		ln -s /tmp/.cache/chromium .
        tar Pzxpf iridium-cache.tgz && \
       		ln -s /tmp/.cache/iridium .
        tar Pzxpf firefox-cache.tgz && \
       		ln -s /tmp/.cache/mozilla .
fi
