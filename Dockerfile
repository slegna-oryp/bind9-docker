FROM ubuntu:focal
MAINTAINER BIND 9 Developers <bind9-dev@isc.org>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8

ARG DEB_VERSION=1:9.16.*

RUN apt-get -qqqy update \
    && apt-get -qqqy install apt-utils software-properties-common dctrl-tools \
    && add-apt-repository -y ppa:isc/bind \
    && apt-get -qqqy update && apt-get -qqqy dist-upgrade && apt-get -qqqy install bind9=$DEB_VERSION bind9-utils=$DEB_VERSION \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/bind && chown root:bind /etc/bind/ && chmod 755 /etc/bind \
    && mkdir -p /var/cache/bind && chown bind:bind /var/cache/bind && chmod 755 /var/cache/bind \
    && mkdir -p /var/lib/bind && chown bind:bind /var/lib/bind && chmod 755 /var/lib/bind \
    && mkdir -p /var/log/bind && chown bind:bind /var/log/bind && chmod 755 /var/log/bind \
    && mkdir -p /run/named && chown bind:bind /run/named && chmod 755 /run/named

VOLUME ["/etc/bind", "/var/cache/bind", "/var/lib/bind", "/var/log"]

EXPOSE 53/udp 53/tcp 953/tcp

CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
