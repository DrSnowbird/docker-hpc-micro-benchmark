FROM openkbs/docker-hpc-base

MAINTAINER DrSnowbird "drsnowbird@openkbs.org"

## Somehow OSU_VERSION:-5.4.1 build has some missing files. back to 5.3.2
##

#ARG OSU_VERSION=${OSU_VERSION:-5.4.1}
#ARG OSU_VERSION=${OSU_VERSION:-5.3.2}
ARG OSU_VERSION=${OSU_VERSION}

RUN \
   wget --no-check-certificate http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${OSU_VERSION}.tar.gz && \
   tar xvzf osu-micro-benchmarks-${OSU_VERSION}.tar.gz && \
   rm -rf osu-micro-benchmarks-${OSU_VERSION}.tar.gz && \
   cd osu-micro-benchmarks-${OSU_VERSION} && \
   mkdir build.openmpi && \
   cd build.openmpi && \
   ../configure CC=mpicc --prefix=$(pwd) && \
   make && make install
   
## (other reference for the above build flags): 
##    https://ulhpc-tutorials.readthedocs.io/en/latest/advanced/OSU_MicroBenchmarks/
##
## ../src/osu-micro-benchmarks-5.4/configure CC=mpiicc CXX=mpiicpc CFLAGS=-I$(pwd)/../src/osu-micro-benchmarks-5.4/util --prefix=$(pwd)

RUN echo $HOME
   
#### ----------------------------
#### ----- Application Entry ----
#### ----------------------------
# dummy entrypoint.sh file is used below
# 
COPY entrypoint.sh /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]

#### ---- When ready, uncomment this line below ----
#CMD "${GAMESS_RUN_DIR}/gamess_dft-grad-b_1024.bat" "672" "28"
CMD ["/bin/bash"]
