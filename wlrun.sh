#!/bin/sh

set -ex

podman run --privileged \
    --env=XDG_VTNR=$XDG_VTNR \
    --device=/dev/tty$XDG_VTNR --device=/dev/dri --device=/dev/input --dev=/dev/snd \
    --cap-add=SYS_TTY_CONFIG --cap-add=SYS_ADMIN \
    --volume=/run/udev/data:/run/udev/data:ro \
    --volume=/etc/asound.conf:/etc/asound.conf:ro \
    "${@}"

    # --volume=/tmp/wlrun/cage:/run/cage \
    # --volume=/tmp/wlrun/mpv:/run/mpv \

    # --volume=$PWD/entrypoint.sh:/usr/local/bin/entrypoint \
    # --volume=$PWD/startcage.sh:/usr/local/bin/startcage \
    # --volume=$PWD/startmpv.sh:/usr/local/bin/startmpv \
