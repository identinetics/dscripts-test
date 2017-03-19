#!/usr/bin/env bash
set -e -o pipefail

# settings for docker build, run and exec

main() {
    SCRIPTDIR=$(cd $(dirname $BASH_SOURCE[0]) && pwd)
    source $SCRIPTDIR/dscripts/conf_lib.sh  # load library functions
    # do_not_build $@
    init_sudo
    set_volume_root
    set_image_and_container_name
    set_image_signature_args
    set_users
    set_buildargs
    set_run_args
    set_network
}


set_volume_root() {
    DOCKERVOL_SHORT='/dv'
    DOCKERLOG_SHORT='/dl'
    if [ "$TRAVIS" == "true" ]; then
        DOCKERVOL_SHORT='./dv';
        DOCKERLOG_SHORT='./dl';
    fi
    #DOCKER_VOLUME_ROOT='/var/lib/docker/volumes'  # hard coded - check for your config if applicable!
}


set_image_and_container_name() {
    # This IMGID qualifies image, container, user and IP adddress; this is helpful for managing
    # processes on the docker host etc.
    IMGID='99'  # range from 02 .. 99; must be unique per node (registered in github.com/identinetics/dscripts/templates/assigned-uids.adoc)
    PROJSHORT='dscripts-test'
    set_staging_env
    export IMAGENAME="rhoerbe/${PROJSHORT}"  # you may or may not want to have an image id and/or staging tag
    #export IMAGENAME="r2h2/${PROJSHORT}${IMGID}:${STAGING_ENV}"  # [a-z_0-9]
    export CONTAINERNAME="${IMGID}${PROJSHORT}"
    #export CONTAINERNAME="${IMGID}${PROJSHORT}-${STAGING_ENV}"
    export DOCKER_REGISTRY='index.docker.io'
}


set_image_signature_args() {
    export DIDI_SIGNER='tester@testinetics.at'  # PGP uid  - no verification if empty
    export GPG_SIGN_OPTIONS='--default-key B5341047'
}

set_users() {
    export CONTAINERUSER="$PROJSHORT${IMGID}"   # group and user to run container
    export CONTAINERUID="3430${IMGID}"     # gid and uid for CONTAINERUSER
    #export CONTAINERUSER=$(get_metadata uid)      # user/group defined in Dockerfile
    #export CONTAINERUID=$(get_metadata username)  # uid(gid defined in Dockerfile
    export START_AS_ROOT=      # 'True' (e.g. for apache to fall back to www user)
}


set_buildargs() {
    export BUILDARGS=""
}


set_run_args() {
    export ENVSETTINGS=""
    get_capabilities
    export STARTCMD=''  # unset or blank to use image default
}


set_network() {
    # The docker0 bridge has dynamic addresses, whereas a custom bridge allows predictable addresses
    NETWORK=dockernet
    set +e  # errexit off
    $sudo docker network ls | awk '{print $2}' | grep $NETWORK > /dev/null
    if (( $? == 1)); then
        $sudo docker network create --driver bridge --subnet=10.1.1.0/24 \
                  -o com.docker.network.bridge.name=br-$NETWORK $NETWORK
    fi
    export NETWORKSETTINGS="
        --net $NETWORK
        --ip 10.1.1.${IMGID}
    "
}




main $@
