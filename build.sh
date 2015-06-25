#!/bin/sh -x

. /build/config.sh

apt-get update -y

apt-get install $minimal_apt_get_args $BUILD_PACKAGES

# cleanup build
AUTO_ADDED_PACKAGES=`apt-mark showauto`
apt-get remove --purge -y $BUILD_PACKAGES $AUTO_ADDED_PACKAGES

