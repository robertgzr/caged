FROM docker.io/library/fedora:30 AS build

RUN dnf -y install \
        gcc \
        curl \
        meson \
        wayland-devel \
        wayland-protocols-devel \
        libdrm-devel \
        mesa-libEGL-devel \
        mesa-libGLES-devel \
        mesa-libgbm-devel \
        libinput-devel \
        libxkbcommon-devel \
        pixman-devel \
        systemd-devel \
        libcap-devel \
        \
        libxcb-devel \
        libXcomposite-devel \
        libXfixes-devel \
        libXrender-devel \
    && dnf clean all


FROM build AS wlroots-dev

WORKDIR /src/wlroots
RUN curl -L https://github.com/swaywm/wlroots/archive/0.5.0.tar.gz | tar xzf - --strip-components=1
RUN meson --prefix=/usr -Drootston=false -Dexamples=false build && ninja -C build && ninja -C build install


FROM wlroots-dev AS cage-dev

WORKDIR /src/cage
RUN curl -L https://github.com/Hjdskes/cage/archive/v0.1.tar.gz | tar xzf - --strip-components=1
RUN meson --prefix=/usr -Dxwayland=true build && ninja -C build && ninja -C build install


FROM docker.io/library/debian:buster-slim AS wayland-run

RUN apt-get update && apt-get install -y --no-install-recommends \
            libcap2 \
            libegl1 \
            libgles2 \
            libinput10 \
            libpixman-1-0 \
            libwayland-server0 \
            libwayland-client0 \
            libwayland-egl1 \
            libx11-6 \
            libxcb-composite0 \
            libxcb-render0 \
            libxcb-xinput0 \
            libxkbcommon0 \
        && rm -rf /var/lib/apt/lists/*


FROM wayland-run AS wlroots-run

COPY --from=wlroots-dev \
    /usr/lib64/libwlroots.so* \
    /usr/lib/x86_64-linux-gnu/


FROM wlroots-run AS cage-run

VOLUME /run/cage
ENV XDG_RUNTIME_DIR=/run/cage 

COPY --from=cage-dev \
    /src/cage/build/cage \
    /usr/local/bin/

COPY ./entrypoint.sh /usr/local/bin/entrypoint
COPY ./startcage.sh /usr/local/bin/startcage

ENTRYPOINT ["/usr/local/bin/entrypoint"]

FROM cage-run AS mpv-run

RUN apt-get update && apt-get install -y --no-install-recommends \
            ca-certificates \
            mpv \ 
            python3 \
            wget \
        && rm -rf /var/lib/apt/lists/* \
        && wget -L https://yt-dl.org/downloads/latest/youtube-dl -O /usr/bin/youtube-dl \
        && chmod a+rx /usr/bin/youtube-dl \
        && apt-get purge -y --auto-remove wget

VOLUME /run/mpv

COPY ./startmpv.sh /usr/local/bin/startmpv
COPY ./wl.png /usr/share/mpv/wl.png

CMD ["/usr/local/bin/startmpv", "/usr/share/mpv/wl.png"]
