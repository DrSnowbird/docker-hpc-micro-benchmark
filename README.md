# Docker HPC OSU Microbenchmarks
[![](https://images.microbadger.com/badges/image/openkbs/docker-hpc-micro-benchmark.svg)](https://microbadger.com/images/openkbs/docker-hpc-micro-benchmark "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/openkbs/docker-hpc-micro-benchmark.svg)](https://microbadger.com/images/openkbs/docker-hpc-micro-benchmark "Get your own version badge on microbadger.com")

## How to Use this hpc-micro-benchmark?
```
* Syntax: 
  ./run.sh  <MPI_CMD> [<MPI_CORES>]

  note: MPI_CORES not needed since default np=2 cores

* Usage: 
 - Two usages: 
   1.) Full OSU Benchmark Tests including pt2pt/* one-sided/* collective/* :
        ./run.sh  (this will run ALL the OSU Microbenchmark tests)
   2.) Test specific OSU test case, e.g. pt2pt/osu_bw, collective/osu_reduce_scatter, ...
        ./run.sh pt2pt/osu_bw
        ./run.sh collective/osu_reduce_scatter

* Output directory & files:
  $HOME/data/

* Full list of OSU Benchmarks test commands:
  collective/osu_allgather
  collective/osu_allgatherv
  collective/osu_allreduce
  collective/osu_alltoall
  collective/osu_alltoallv
  collective/osu_barrier
  collective/osu_bcast
  collective/osu_gather
  collective/osu_gatherv
  collective/osu_iallgather
  collective/osu_iallgatherv
  collective/osu_ialltoall
  collective/osu_ialltoallv
  collective/osu_ialltoallw
  collective/osu_ibarrier
  collective/osu_ibcast
  collective/osu_igather
  collective/osu_igatherv
  collective/osu_iscatter
  collective/osu_iscatterv
  collective/osu_reduce
  collective/osu_reduce_scatter
  collective/osu_scatter
  collective/osu_scatterv
  one-sided/osu_acc_latency
  one-sided/osu_cas_latency
  one-sided/osu_fop_latency
  one-sided/osu_get_acc_latency
  one-sided/osu_get_bw
  one-sided/osu_get_latency
  one-sided/osu_put_bibw
  one-sided/osu_put_bw
  one-sided/osu_put_latency
  pt2pt/osu_bibw
  pt2pt/osu_bw
  pt2pt/osu_latency
  pt2pt/osu_latency_mt
  pt2pt/osu_mbw_mr
  pt2pt/osu_multi_lat
  startup/osu_hello
  startup/osu_init

```
## Build (Warning: custom-built only!)
```
./build.sh
```

## Resources
1. [OSU Microbenchmarks](http://mvapich.cse.ohio-state.edu/benchmarks/)
2. [Singularity by Lawrence Berkeley Labs](https://singularity.lbl.gov/)
3. [OpenKBS Docker HUB](https://hub.docker.com/r/openkbs/) - for pulling the ready to use public Docker Images.
4. [OpenKBS GIT HUB](https://github.com/DrSnowbird/) - for users like to build and customize to your own flavor using our open source environments.
 

