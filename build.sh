#!/bin/sh -x

. ~/build/config.sh

apt-get update -y

echo "$PRE_RUN" | bash -l

apt-get install $minimal_apt_get_args $RUN_PACKAGES

echo "$POST_RUN" | bash -l
