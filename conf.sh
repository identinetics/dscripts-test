#!/usr/bin/env bash

main() {
    SCRIPTDIR=$(cd $(dirname $BASH_SOURCE[0]) && pwd)
    source $SCRIPTDIR/dscripts/conf_lib.sh  # load library functions
    configlib_version=2  # this conf.sh supports conf_lib.sh up to this version
    check_version $configlib_version
    # do_not_build $@
    init_sudo
    _set_volume_root
    _set_image_and_container_name
    #_set_image_signature_args
    _set_users
    _set_buildargs
    _set_run_args
    #enable_x11_client
    #enable_pkcs11
    #set_enable_sshd     # usually used only for debugging - requires installed sshd in image
}


_set_volume_root() {
    # container volumes mounted to host paths, or symlinks to docker volumes
    DOCKERVOL_SHORT='/dv'
    DOCKERLOG_SHORT='/dl'
    if [[ "$TRAVIS" == "true" ]] || [[ ! -z ${JENKINS_HOME+x} ]]; then
        DOCKERVOL_SHORT='./dv';
        DOCKERLOG_SHORT='./dl';
    fi
    mkdir -p $DOCKERVOL_SHORT $DOCKERLOG_SHORT
    #DOCKER_VOLUME_ROOT='/var/lib/docker/volumes'  # hard coded - check for your config if applicable!
}


_set_image_and_container_name() {
    # IMGID qualifies image, container, user and IP adddress; this is helpful for managing
    # processes on the docker host etc.
    IMGID='99'  # range from 02 .. 99; must be unique per node (registered in github.com/identinetics/dscripts/templates/assigned-uids.adoc)
    PROJSHORT='dscripts-test'
    SERVICEDESCRIPTION=service_name  # e.g. www.example.org or ldap://10.1.1.${IMGID}:8389"  (no blanks!)
    set_staging_env
    export IMAGENAME="rhoerbe/${PROJSHORT}"  # you may or may not want to have an image id and/or staging tag
    export CONTAINERNAME="${IMGID}${PROJSHORT}"
    export DOCKER_REGISTRY=''
}


#set_image_signature_args() {
#    export DIDI_SIGNER='tester@testinetics.at'  # PGP uid  - no verification if empty
#    export GPG_SIGN_OPTIONS='--default-key B5341047'
#}


_set_users() {
    export CONTAINERUSER="$PROJSHORT${IMGID}"   # group and user to run container
    export CONTAINERUID="3430${IMGID}"     # gid and uid for CONTAINERUSER
    #export CONTAINERUSER=$(get_metadata uid)      # user/group defined in Dockerfile
    #export CONTAINERUID=$(get_metadata username)  # uid(gid defined in Dockerfile
    export START_AS_ROOT=      # 'True' (e.g. for apache to fall back to www user)
}


_set_buildargs() {
    export BUILDARGS="
        --build-arg USERNAME=$CONTAINERUSER
        --build-arg UID=$CONTAINERUID
    "
}


_set_run_args() {
    export ENVSETTINGS="
        -e LOGDIR=/var/log
        -e LOGPURGEFILES='/var/log/httpd/* /var/log/shibboleth/*'
        -e LOGLEVEL=INFO
    "
    get_capabilities
    export STARTCMD=''  # unset or blank to use image default
}


create_intercontainer_network() {
    # Create a local network on the docker host. As the default docker0 bridge has dynamic
    # addresses, a custom bridge is created allowing predictable addresses.
    network='dockernet'
    set +e  # errexit off
    $sudo docker network ls | awk '{print $2}' | grep $network > /dev/null
    if (( $? == 1)); then
        $sudo docker network create --driver bridge --subnet=10.1.1.0/24 \
                  -o com.docker.network.bridge.name=br-$network $network
    fi
    export NETWORKSETTINGS="
        --net $network
        --ip 10.1.1.${IMGID}
    "
}


setup_vol_mapping() {
    # Create docker volume (-> map_docker_volume) or map host dir (-> map_host_directory)
    # In both cases create a shortcut in the shortcut directory (DOCKERVOL_SHORT, DOCKERLOG_SHORT)

    export VOLLIST=''
    export VOLMAPPING=''
    # create container user on docker host (optional - for better process visibility with host tools)
    create_user $CONTAINERUSER $CONTAINERUID

    # it is good practice to export each VOLUME in the Dockerfile
    map_docker_volume "${CONTAINERNAME}.var_db" '/var/db' 'Z' $DOCKERVOL_SHORT
    map_docker_volume "${CONTAINERNAME}.var_log" '/var/log' 'Z' $DOCKERLOG_SHORT
    if [[ ! $JENKINS_HOME ]]; then
        $sudo chown -R $CONTAINERUID:$CONTAINERUID $DOCKER_VOLUME_ROOT/$CONTAINERNAME.* 2>/dev/null || true
    fi

    #export VOLROOT="${DOCKERVOL_SHORT}/$CONTAINERNAME"  # container volumes on docker host
    #map_host_directory "$DOCKERLOG_SHORT/var/log/" '/var/log/' 'Z'

    export LOGFILES="
        $DOCKERLOG_SHORT/${CONTAINERNAME}.var_log/xyz.log
        $DOCKERLOG_SHORT/${CONTAINERNAME}.var_log/xyz.err
    "
}


_set_enable_sshd() {
    export SSHD_ROOTPW='changeit'
    map_docker_volume "${CONTAINERNAME}.ssh" "/etc/ssh" 'Z' $DOCKERLOG_SHORT
    export CAPABILITIES="$CAPABILITIES --cap-add=setuid --cap-add=setgid --cap-add=chown"
    enable_sshd
}


container_status() {
    $sudo docker ps | head -1
    $sudo docker ps --all | egrep $CONTAINERNAME\$
    $sudo docker exec -it $CONTAINERNAME /status.sh
}


logrotate() {
    find $DOCKERLOG_SHORT/${CONTAINERNAME}.var_log/ -mtime +5 -exec ls -ld {} \;
}


main $@
