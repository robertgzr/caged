containerized compositor
========================

this repo contains scripts, service files and dockerfiles to run a full wayland desktop running inside a container
(albeit one with a lot of holes)

## what's inside

#### `Dockerfile`, `entrypoint.sh`, `startcage.sh` and `startmpv.sh`

a multi-stage image that has all steps to a container with [wlroots][wlroots], [cage][cage] and [mpv][mpv] inside.
To get any of the in-between targets, run:
```
$ podman build -t wlroots:dev --target wlroots-dev .
```

The scripts are heavily inspired by an [issue on the dockerx11 repo by mviereck][dockerx11].


#### `io.mpv.service` and `io.mpv.socket`

systemd files to run a container with mpv as a [socket activated service][socketact]

**Note**: to get sound over HDMI to work on my Intel NUC I had to add the following lines to `/etc/asound.conf`:
```
defaults.pcm.card = 0
defaults.pcm.device = 3
defaults.ctl.card = 0
```


#### `wlrun.sh`

I was using this script to testrun the container as there are quite a few arguments that need to be set for this to
work ;)


[wlroots]: https://github.com/swaywm/wlroots
[cage]: https://github.com/Hjdskes/cage
[mpv]: https://github.com/mpv-player/mpv
[dockerx11]: https://github.com/mviereck/x11docker/issues/40#issuecomment-381445560
[socketact]: http://0pointer.de/blog/projects/socket-activation.html
