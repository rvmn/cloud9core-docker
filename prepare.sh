#!/bin/sh -x

. /build/config.sh

apt-get update -y

apt-get install $minimal_apt_get_args $BUILD_PACKAGES
