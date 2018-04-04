FROM openkbs/docker-hpc-base

MAINTAINER DrSnowbird "drsnowbird@openkbs.org"

## Somehow OSU_VERSION:-5.4.1 build has some missing files. back to 5.3.2
##

#ARG OSU_VERSION=${OSU_VERSION:-5.4.1}
ARG OSU_VERSION=${OSU_VERSION:-5.3.2}
#ARG OSU_VERSION=${OSU_VERSION}

ARG OSU_TGZ=osu-micro-benchmarks-${OSU_VERSION}.tar.gz

RUN wget http://mvapich.cse.ohio-state.edu/download/mvapich/${OSU_TGZ} && \
   tar xvf ${OSU_TGZ} && \
   rm -rf ${OSU_TGZ} && \
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

#### ---- OSU Benchmark ----
#CMD "${GAMESS_RUN_DIR}/gamess_dft-grad-b_1024.bat" "672" "28"
## ENV OSU_MPI_DIR=/osu-micro-benchmarks-5.3.2/build.openmpi/libexec/osu-micro-benchmarks/mpi
ENV OSU_MPI_DIR=/osu-micro-benchmarks-${OSU_VERSION}/build.openmpi/libexec/osu-micro-benchmarks/mpi
# collective/osu_allgather
# collective/osu_allgatherv
# collective/osu_allreduce
# collective/osu_alltoall
# collective/osu_alltoallv
# collective/osu_barrier
# collective/osu_bcast
# collective/osu_gather
# collective/osu_gatherv
# collective/osu_iallgather
# collective/osu_iallgatherv
# collective/osu_ialltoall
# collective/osu_ialltoallv
# collective/osu_ialltoallw
# collective/osu_ibarrier
# collective/osu_ibcast
# collective/osu_igather
# collective/osu_igatherv
# collective/osu_iscatter
# collective/osu_iscatterv
# collective/osu_reduce
# collective/osu_reduce_scatter
# collective/osu_scatter
# collective/osu_scatterv
# one-sided/osu_acc_latency
# one-sided/osu_cas_latency
# one-sided/osu_fop_latency
# one-sided/osu_get_acc_latency
# one-sided/osu_get_bw
# one-sided/osu_get_latency
# one-sided/osu_put_bibw
# one-sided/osu_put_bw
# one-sided/osu_put_latency
# pt2pt/osu_bibw
# pt2pt/osu_bw
# pt2pt/osu_latency
# pt2pt/osu_latency_mt
# pt2pt/osu_mbw_mr
# pt2pt/osu_multi_lat
# startup/osu_hello
# startup/osu_init

####
#### ---- Usage ----
#### The command from host:
WORKDIR ${OSU_MPI_DIR}
####
# /usr/local/bin/singularity run ${INPUT_PATH}/${SINGULARITY_IMAGE_NAME} collective/osu_reduce_scatter 2 
#/usr/local/bin/singularity run ${INPUT_PATH}/${SINGULARITY_IMAGE_NAME} collective/osu_reduce_scatter 2 
#CMD ["/entrypoint.sh"] 
CMD ["/bin/bash"]
