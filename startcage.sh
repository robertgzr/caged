#!/bin/sh

set -xe

# By default docker gives us 64MB of shared memory size but we need more for visuals
umount /dev/shm && mount -t tmpfs shm /dev/shm

# run the compositor
exec cage -- $@
