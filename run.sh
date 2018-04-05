#!/bin/bash

MY_DIR=$(dirname "$(readlink -f "$0")")

if [ $# -lt 1 ]; then
    echo "Usage: "
    echo " - Two usages: "
    echo "   1.) No command line arguments for Full OSU Benchmark Tests including pt2pt/* one-sided/* collective/* "
    echo "   2.) Test specific OSU test case, e.g. pt2pt/osu_bw, collective/osu_reduce_scatter, ..."
    echo "Syntax: "
    echo "  ${0}  <MPI_CMD> [<MPI_CORES>]"
    echo "  note: MPI_CORES not needed since default np=2 cores"
    echo "e.g.: "
    echo "  ${0} "
    echo "  ${0} pt2pt/osu_bw"
    echo "  ${0} collective/osu_reduce_scatter"
    echo "Full list of OSU Benchmarks test commands:"
    echo "  collective/osu_allgather"
    echo "  collective/osu_allgatherv"
    echo "  collective/osu_allreduce"
    echo "  collective/osu_alltoall"
    echo "  collective/osu_alltoallv"
    echo "  collective/osu_barrier"
    echo "  collective/osu_bcast"
    echo "  collective/osu_gather"
    echo "  collective/osu_gatherv"
    echo "  collective/osu_iallgather"
    echo "  collective/osu_iallgatherv"
    echo "  collective/osu_ialltoall"
    echo "  collective/osu_ialltoallv"
    echo "  collective/osu_ialltoallw"
    echo "  collective/osu_ibarrier"
    echo "  collective/osu_ibcast"
    echo "  collective/osu_igather"
    echo "  collective/osu_igatherv"
    echo "  collective/osu_iscatter"
    echo "  collective/osu_iscatterv"
    echo "  collective/osu_reduce"
    echo "  collective/osu_reduce_scatter"
    echo "  collective/osu_scatter"
    echo "  collective/osu_scatterv"
    echo "  one-sided/osu_acc_latency"
    echo "  one-sided/osu_cas_latency"
    echo "  one-sided/osu_fop_latency"
    echo "  one-sided/osu_get_acc_latency"
    echo "  one-sided/osu_get_bw"
    echo "  one-sided/osu_get_latency"
    echo "  one-sided/osu_put_bibw"
    echo "  one-sided/osu_put_bw"
    echo "  one-sided/osu_put_latency"
    echo "  pt2pt/osu_bibw"
    echo "  pt2pt/osu_bw"
    echo "  pt2pt/osu_latency"
    echo "  pt2pt/osu_latency_mt"
    echo "  pt2pt/osu_mbw_mr"
    echo "  pt2pt/osu_multi_lat"
    echo "  startup/osu_hello"
    echo "  startup/osu_init"
fi

###################################################
#### ---- Change this only to use your own ----
###################################################
ORGANIZATION=openkbs
baseDataFolder="$HOME/data-docker"

###################################################
#### **** Container package information ****
###################################################
MY_IP=`ip route get 1|awk '{print$NF;exit;}'`
DOCKER_IMAGE_REPO=`echo $(basename $PWD)|tr '[:upper:]' '[:lower:]'|tr "/: " "_" `
imageTag="${ORGANIZATION}/${DOCKER_IMAGE_REPO}"
#PACKAGE=`echo ${imageTag##*/}|tr "/\-: " "_"`
PACKAGE="${imageTag##*/}"

###################################################
#### ---- (DEPRECATED but still supported)    -----
#### ---- Volumes to be mapped (change this!) -----
###################################################
# (examples)
# IDEA_PRODUCT_NAME="IdeaIC2017"
# IDEA_PRODUCT_VERSION="3"
# IDEA_INSTALL_DIR="${IDEA_PRODUCT_NAME}.${IDEA_PRODUCT_VERSION}"
# IDEA_CONFIG_DIR=".${IDEA_PRODUCT_NAME}.${IDEA_PRODUCT_VERSION}"
# IDEA_PROJECT_DIR="IdeaProjects"
# VOLUMES_LIST="${IDEA_CONFIG_DIR} ${IDEA_PROJECT_DIR}"

# ---------------------------
# Variable: VOLUMES_LIST
# (NEW: use docker.env with "#VOLUMES_LIST=data workspace" to define entries)
# ---------------------------
## -- If you defined locally here, 
##    then the definitions of volumes map in "docker.env" will be ignored.
# VOLUMES_LIST="data workspace"

# ---------------------------
# OPTIONAL Variable: PORT PAIR
# (NEW: use docker.env with "#PORTS=18000:8000 17200:7200" to define entries)
# ---------------------------
## -- If you defined locally here, 
##    then the definitions of ports map in "docker.env" will be ignored.
#### Input: PORT - list of PORT to be mapped
# (examples)
#PORTS_LIST="18000:8000"
#PORTS_LIST=

#########################################################################################################
######################## DON'T CHANGE LINES STARTING BELOW (unless you need to) #########################
#########################################################################################################
LOCAL_VOLUME_DIR="${baseDataFolder}/${PACKAGE}"
## -- Container's internal Volume base DIR
DOCKER_VOLUME_DIR="/home/developer"

###################################################
#### ---- Function: Generate volume mappings  ----
####      (Don't change!)
###################################################
VOLUME_MAP=""
#### Input: VOLUMES - list of volumes to be mapped
hasPattern=0
function hasPattern() {
    detect=`echo $1|grep "$2"`
    if [ "${detect}" != "" ]; then
        hasPattern=1
    else
        hasPattern=0
    fi
}

function generateVolumeMapping() {
    if [ "$VOLUMES_LIST" == "" ]; then
        ## -- If locally defined in this file, then respect that first.
        ## -- Otherwise, go lookup the docker.env as ride-along source for volume definitions
        VOLUMES_LIST=`cat docker.env|grep "^#VOLUMES_LIST= *"|sed "s/[#\"]//g"|cut -d'=' -f2-`
    fi
    for vol in $VOLUMES_LIST; do
        echo "$vol"
        hasColon=`echo $vol|grep ":"`
        ## -- allowing change local volume directories --
        if [ "$hasColon" != "" ]; then
            left=`echo $vol|cut -d':' -f1`
            right=`echo $vol|cut -d':' -f2`
            leftHasDot=`echo $left|grep "\./"`
            if [ "$leftHasDot" != "" ]; then
                ## has "./data" on the left
                if [[ ${right} == "/"* ]]; then
                    ## -- pattern like: "./data:/containerPath/data"
                    echo "-- pattern like ./data:/data --"
                    VOLUME_MAP="${VOLUME_MAP} -v `pwd`/${left}:${right}"
                else
                    ## -- pattern like: "./data:data"
                    echo "-- pattern like ./data:data --"
                    VOLUME_MAP="${VOLUME_MAP} -v `pwd`/${left}:${DOCKER_VOLUME_DIR}/${right}"
                fi
                mkdir -p `pwd`/${left}
                ls -al `pwd`/${left}
            else
                ## No "./data" on the left
                if [[ ${right} == "/"* ]]; then
                    ## -- pattern like: "data:/containerPath/data"
                    echo "-- pattern like ./data:/data --"
                    VOLUME_MAP="${VOLUME_MAP} -v ${LOCAL_VOLUME_DIR}/${left}:${right}"
                else
                    ## -- pattern like: "data:data"
                    echo "-- pattern like data:data --"
                    VOLUME_MAP="${VOLUME_MAP} -v ${LOCAL_VOLUME_DIR}/${left}:${DOCKER_VOLUME_DIR}/${right}"
                fi
                mkdir -p ${LOCAL_VOLUME_DIR}/${left}
                ls -al ${LOCAL_VOLUME_DIR}/${left}
            fi
        else
            ## -- pattern like: "data"
            echo "-- default sub-directory (without prefix absolute path) --"
            VOLUME_MAP="${VOLUME_MAP} -v ${LOCAL_VOLUME_DIR}/$vol:${DOCKER_VOLUME_DIR}/$vol"
            mkdir -p ${LOCAL_VOLUME_DIR}/$vol
            ls -al ${LOCAL_VOLUME_DIR}/$vol
        fi
    done
}
#### ---- Generate Volumes Mapping ----
generateVolumeMapping
echo ${VOLUME_MAP}

###################################################
#### ---- Function: Generate port mappings  ----
####      (Don't change!)
###################################################
PORT_MAP=""
function generatePortMapping() {
    if [ "$PORTS" == "" ]; then
        ## -- If locally defined in this file, then respect that first.
        ## -- Otherwise, go lookup the docker.env as ride-along source for volume definitions
        PORTS_LIST=`cat docker.env|grep "^#PORTS_LIST= *"|sed "s/[#\"]//g"|cut -d'=' -f2-`
    fi
    for pp in ${PORTS_LIST}; do
        #echo "$pp"
        port_pair=`echo $pp |  tr -d ' ' `
        if [ ! "$port_pair" == "" ]; then
            # -p ${local_dockerPort1}:${dockerPort1} 
            host_port=`echo $port_pair | tr -d ' ' | cut -d':' -f1`
            docker_port=`echo $port_pair | tr -d ' ' | cut -d':' -f2`
            PORT_MAP="${PORT_MAP} -p ${host_port}:${docker_port}"
        fi
    done
}
#### ---- Generate Port Mapping ----
generatePortMapping
echo ${PORT_MAP}

###################################################
#### ---- Function: Generate privilege String  ----
####      (Don't change!)
###################################################
privilegedString=""
function generatePrivilegedString() {
    OS_VER=`which yum`
    if [ "$OS_VER" == "" ]; then
        # Ubuntu
        echo "Ubuntu ... not SE-Lunix ... no privileged needed"
    else
        # CentOS/RHEL
        privilegedString="--privileged"
    fi
}
generatePrivilegedString
echo ${privilegedString}

###################################################
#### ---- Mostly, you don't need change below ----
###################################################
function cleanup() {
    if [ ! "`docker ps -a|grep ${instanceName}`" == "" ]; then
         docker rm -f ${instanceName}
    fi
}

## -- transform '-' and space to '_' 
#instanceName=`echo $(basename ${imageTag})|tr '[:upper:]' '[:lower:]'|tr "/\-: " "_"`
instanceName=`echo $(basename ${imageTag})|tr '[:upper:]' '[:lower:]'|tr "/: " "_"`

echo "---------------------------------------------"
echo "---- Starting a Container for ${imageTag}"
echo "---------------------------------------------"

cleanup

docker run -it \
    --name=${instanceName} \
    --restart=always \
    ${privilegedString} \
    ${VOLUME_MAP} \
    ${PORT_MAP} \
    ${imageTag} $*

cleanup

