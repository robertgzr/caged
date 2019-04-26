#!/bin/sh

set -xe

run_app="$@"

case "$WAYLAND_DISPLAY" in
    "")
        [ -e "/dev/tty$XDG_VTNR" ] && [ -n "$XDG_VTNR" ] || {
            echo "error: No display and no tty found. XDG_VTNR is empty" >&2
            exit 1
        }
        exec agetty \
            --autologin="$(id -un)"  \
            --login-options="$run_app" \
            --login-program=/usr/local/bin/startcage \
            --noclear \
            tty$XDG_VTNR
        ;;

    *)
        exec /usr/local/bin/startcage $@
        ;;
esac
