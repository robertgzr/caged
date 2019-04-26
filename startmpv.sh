#!/bin/sh

set -xe

exec /usr/bin/mpv \
    --idle=yes \
    --keep-open=always \
    --input-ipc-server=/run/mpv/io.mpv \
    --log-file=/run/mpv/mpv.log \
    --gpu-context=wayland \
    --ao=alsa \
    $@
