#!/bin/bash
echo "Entrypoint call: at `pwd`"
echo $*
if [ $# -lt 1 ]; then
    echo "*** ERROR ***: missing arguments, OSU_MPI_DIR"
    echo "Usage: <MPI_CMD> <MPI_CORES> ... <more_args>"
    echo "collective/osu_reduce_scatter 10"
    ecit 1
fi
OSU_MPI_DIR=/osu-micro-benchmarks-5.3.2/build.openmpi/libexec/osu-micro-benchmarks/mpi
MPI_CMD=$1
shift
# /usr/bin/mpirun ${OSU_MPI_DIR}/collective/osu_reduce_scatter -np 10
# /usr/bin/mpirun ${OSU_MPI_DIR}/${MPI_CMD} -np ${MPI_CORES}
#echo "/usr/bin/mpirun ${OSU_MPI_DIR}/${MPI_CMD} -np $*"
#/usr/bin/mpirun ${OSU_MPI_DIR}/${MPI_CMD} -np $*
/usr/bin/mpirun ./${MPI_CMD} -np $*

