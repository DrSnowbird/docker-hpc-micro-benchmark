#!/bin/bash

echo "Entrypoint call: at `pwd`"
echo $*

OUT_DIR=/home/developer/data
    
if [ $# -lt 1 ]; then
    echo "*** ERROR ***: missing arguments, OSU_MPI_DIR"
    echo "Usage: <MPI_CMD> <MPI_CORES> ... <more_args>"
    echo "collective/osu_reduce_scatter 10"
    echo "... No arguments provided, run bash shell instead ..."
    # /usr/bin/bash 
    test_set="`ls pt2pt/* one-sided/* collective/* `"
    for i in ${test_set}; do
        # mpirun --allow-run-as-root -np 2 pt2pt/osu_bibw 2>null | tee /home/developer/data/osu_bibw.out
        out_file=`echo $i|tr "/" "_"`
        mpirun --allow-run-as-root -np 2 $i 2>null | tee ${OUT_DIR}/${out_file}.out
    done
else
    MPI_CMD=$1
    MPI_CORES=${2:-2}
    shift
    if [ $# -gt 0 ]; then
        shift
    fi

    #OSU_MPI_DIR=/osu-micro-benchmarks-5.3.2/build.openmpi/libexec/osu-micro-benchmarks/mpi
    OSU_MPI_DIR=/osu-micro-benchmarks-*/build.openmpi/libexec/osu-micro-benchmarks/mpi

    cd ${OSU_MPI_DIR}
    echo "Change Entrypoint call: at `pwd`"

    # /usr/bin/mpirun ${OSU_MPI_DIR}/collective/osu_reduce_scatter -np 10
    # /usr/bin/mpirun ${OSU_MPI_DIR}/${MPI_CMD} -np ${MPI_CORES}
    #echo "/usr/bin/mpirun ${OSU_MPI_DIR}/${MPI_CMD} -np $*"
    #/usr/bin/mpirun ${OSU_MPI_DIR}/${MPI_CMD} -np $*
    # (Example) /usr/bin/mpirun -np 2 --allow-run-as-root pt2pt/osu_bw
    out_file=`echo ${MPI_CMD}|tr "/" "_"`
    /usr/bin/mpirun --allow-run-as-root -np ${MPI_CORES} ${MPI_CMD} 2>null | tee ${OUT_DIR}/${out_file}.out
fi

exit 0

