ARG BASE_DOCKER_IMAGE

FROM $BASE_DOCKER_IMAGE

ARG PACKAGES_REPO 

COPY . /src

RUN apk add build-base bash wget curl git python3 py3-pip
RUN cd /src

# https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8
RUN curl -s https://api.github.com/repos/${PACKAGES_REPO}/releases/latest \
        | grep "browser_download_url.*pkg.tar.gz" \
        | cut -d : -f 2,3 \
        | tr -d \" \
        | wget -qi -

RUN psp-pacman -U --noconfirm *.pkg.tar.gz

# Second stage of Dockerfile
FROM alpine:latest

ENV PSPDEV /usr/local/pspdev
ENV PATH $PATH:${PSPDEV}/bin

COPY --from=0 ${PSPDEV} ${PSPDEV}