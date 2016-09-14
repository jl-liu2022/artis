GIT_VERSION := $(shell git describe --dirty --always --tags)
GIT_HASH := $(shell git rev-parse HEAD)
GIT_BRANCH := $(shell git branch | sed -n '/\* /s///p')

  CC = clang
#  CC = clang-3.8
#  CC = clang-omp
#  CC = gcc-6
#  CC = mpicc
#  CC = icc
  INCLUDE = -I/usr/local/Cellar/gsl/2.2.1/include -I/usr/local/opt/libiomp/include/libiomp # -I/usr/local/opt/gperftools/include
  LIB = -L/usr/local/Cellar/gsl/2.2.1/lib -L/usr/local/opt/libiomp/lib # -L/usr/local/opt/gperftools/lib
  CFLAGS = -Winline -Wall -Wextra -Wredundant-decls -Wundef -Wstrict-prototypes -Wmissing-prototypes -Wunused-parameter -Wstrict-aliasing -ftree-vectorize -O3 -march=native -fstrict-aliasing -flto -std=c11 $(INCLUDE) -DHAVE_INLINE #-fopenmp=libomp 

#in GCC6, -Wmisleading-indentation will be useful
#also -fopenmp after -I$(INCLUDE)
#maybe  -fopt-info-vec-missed
#  -fwhole-program
#add -lprofiler for gperftools

  LDFLAGS = $(LIB) -lgsl -lgslcblas
#  sn3d: CFLAGS += -fopenmp
  exspec: CFLAGS += -DDO_EXSPEC
  exgamma: override CFLAGS =  -O3 $(INCLUDE) -DDO_EXSPEC

### Settings for the miner
ifeq ($(OSTYPE),linux)
  CC = cc
  INCLUDE = /home/ssim/gsl/include
  LIB = /home/ssim/gsl/lib
  CFLAGS = -O3 -g -I$(INCLUDE)
  LDFLAGS= -L$(LIB) -lgsl -lgslcblas -lm
  exspec: override CFLAGS =  -g -O3 -I$(INCLUDE) -DDO_EXSPEC
  exgamma: override CFLAGS =  -g -O3 -I$(INCLUDE) -DDO_EXSPEC
endif


### Settings for Coala
ifeq ($(OSTYPE),linux)
  CC = /pkg/linux/SS12/sunstudio12/bin/cc
#  CC = gcc
  INCLUDE = /home/ssim/gsl/include
  INCLUDE2 = /usr/local/openmpi/include
  LIB2 = /usr/local/openmpi/lib
  LIB = /home/ssim/gsl/lib
#  CFLAGS = -O3 -I$(INCLUDE) -I$(INCLUDE2) -fast -xtarget=nehalem -xipo=2 -xvector=simd -DMPI_ON
  CFLAGS = -O3 -I$(INCLUDE) -I$(INCLUDE2)  -pthread -DMPI_ON
#-fast -xtarget=nehalem -xipo=2 -xvector=simd -DMPI_ON
  LDFLAGS= -L$(LIB) -L$(LIB2) -R$(LIB2) -lgsl -lgslcblas -lm -pthread -L/usr/local/openmpi/lib -lmpi_cxx -lmpi -lopen-rte -lopen-pal -ldl -Wl,--export-dynamic -lnsl -lutil -lm -ldl
#  LDFLAGS= -L$(LIB) -L$(LIB2) -L$(LIB3) -lgsl -lgslcblas -lm -pthread
  exspec: override CFLAGS =  -g -O3 -I$(INCLUDE) -DDO_EXSPEC
  exgamma: override CFLAGS =  -g -O3 -I$(INCLUDE) -DDO_EXSPEC
endif


### Settings for mime
ifeq ($(HOST),mime)
  CC = mpicc
  CFLAGS = -O3 -m64 -DMPI_ON
  LDFLAGS= -L$(LIB) -lgsl -lgslcblas -lm -m64
#-pthread -lmpi_cxx -lmpi -lopen-rte -lopen-pal -ldl -Wl,--export-dynamic -lnsl -lutil -lm -ldl
  exspec: override CFLAGS =  -g -O3 -I$(INCLUDE) -DDO_EXSPEC
  exgamma: override CFLAGS =  -g -O3 -I$(INCLUDE) -DDO_EXSPEC
endif



### Settings for vayu
ifeq ($(USER),sas120)

#needs
#module load intel-cc/11.1.046
#module load openmpi/1.4.3
#module load gsl/1.12

  CC = mpicc
  CFLAGS = -O3 -DMPI_ON -DTIMED_RESTARTS
  LDFLAGS= -lgsl -lgslcblas -lm
  exspec: override CFLAGS =  -g -O3 -I$(INCLUDE) -DDO_EXSPEC
  exgamma: override CFLAGS =  -g -O3 -I$(INCLUDE) -DDO_EXSPEC
endif

### Settings for MACBOOK
ifeq ($(USER),lukesignorethis)

  CC = cc

  CFLAGS = -O0 -I/usr/local/opt/gsl/include/ -fsanitize=undefined-trap -fsanitize-undefined-trap-on-error -ftrap-function=abort -g
#-DMPI_ON
  LDFLAGS= -lgsl -lgslcblas -lm -L/usr/local/opt/gsl/lib/

  exspec: override CFLAGS =  -O3  -DDO_EXSPEC
  exspec_dd: override CFLAGS =  -O3  -DDO_EXSPEC
  exgamma: override CFLAGS =  -O3  -DDO_EXSPEC

endif




### Settings for MPA machines
ifeq ($(DOMAIN),MPA-Garching.MPG.DE)
  #CC = gcc
  CC    = /afs/rzg/@sys/bin/icc
  INCLUDE=/afs/mpa/project/artis/code/lib/gsl32/include/
  LIB=/afs/mpa/project/artis/code/lib/gsl32
  ifeq ($(MACHTYPE),x86_64)
    INCLUDE=/afs/mpa/project/artis/code/lib/gsl64/include/
    LIB=/afs/mpa/project/artis/code/lib/gsl64
  endif
  #CFLAGS =  -Wall -g -I$(INCLUDE)
  #CFLAGS =  -O3 -g -I$(INCLUDE)
  CFLAGS = -O3 -g -pg -I$(INCLUDE)
  #CFLAGS = -openmp  -g -I$(INCLUDE)
  #CFLAGS = -openmp -O3 -g -I$(INCLUDE)
  LDFLAGS= -L$(LIB) -lgsl -lgslcblas -lm
  exspec: override CFLAGS =  -g -O3 -I$(INCLUDE) -DDO_EXSPEC
  exgamma: override CFLAGS =  -g -O3 -I$(INCLUDE) -DDO_EXSPEC

  ### desktop MPI
  #CC    =  /opt/mpich2-1.0.3/bin/mpicc #/usr/common/pdsoft/appl/mpich-1.2.6/bin/mpicc #/usr/common/pdsoft/bin/mpicc
  #INCLUDE=/afs/mpa/common/pdsoft/include/
  #LIB=/afs/mpa/common/pdsoft/lib/
  #CFLAGS = -O3 -g -I$(INCLUDE)  -DMPI_ON
  #LDFLAGS= -L$(LIB) -lgsl -lgslcblas -lm
  #exspec: override CFLAGS =  -g -O3 -I$(INCLUDE) -DMPI_ON -DDO_EXSPEC
endif



### Settings for IBM Regatta
ifeq ($(OSTYPE),aix)
  #
  #ifeq ($(HOSTTYPE),rs6000)
  CC = mpcc_r
  #INCLUDE=/u/mkromer/lib/regatta64/include
  #LIB=/u/mkromer/lib/regatta64/lib
#  INCLUDE=/u/mkromer/lib/power6_xlc_32_o3/include
#  LIB=/u/mkromer/lib/power6_xlc_32_o3/lib
  #INCLUDE=/u/mkromer/lib/power6_xlcr_64_o3/include
  #LIB=/u/mkromer/lib/power6_xlcr_64_o3/lib
  INCLUDE=/u/mkromer/lib/test_64_r/include
  LIB=/u/mkromer/lib/test_64_r/lib
  #CFLAGS = -O4 -I$(INCLUDE) -qsmp -q64   -qcpluscmt -DMPI_ON
  CFLAGS = -O3 -g -I$(INCLUDE) -q64 -qstrict -qcpluscmt -DMPI_ON #-DPOWER6
  CFLAGS = -O3 -g -I$(INCLUDE) -qsmp -q64 -qstrict -qcpluscmt -DMPI_ON #-DPOWER6
#  CFLAGS = -O3 -g -I$(INCLUDE) -qstrict -qcpluscmt -bmaxdata:0x80000000 -DMPI_ON #-DPOWER6
  #CFLAGS = -O3 -g -I$(INCLUDE) -qsmp -q64 -qstrict -qcpluscmt
  #CFLAGS = -O3 -g -I$(INCLUDE) -q64 -qstrict -qcpluscmt -bmaxdata:0x160000000 -bmaxstack:0x160000000
  LDFLAGS= -L$(LIB) -lgsl -lgslcblas -lm
  exspec: override CFLAGS = -O3 -g -q64 -I$(INCLUDE) -qstrict -qcpluscmt -DMPI_ON -DDO_EXSPEC
  exgamma: override CFLAGS = -O3 -g -q64 -I$(INCLUDE) -qstrict -qcpluscmt -DMPI_ON -DDO_EXSPEC
endif



### Settings for the OPA cluster
ifeq ($(DOMAIN),opt.rzg.mpg.de)
  CC    = mpiicc
  #this requires a
  #  module load intel
  #  module load impi
  #  module load gsl
  #check available module with module avail
  #Read gsl now from system wide installation
  #INCLUDE=/afs/ipp-garching.mpg.de/home/m/mkromer/lib/opa/include/
  #LIB=/afs/ipp-garching.mpg.de/home/m/mkromer/lib/opa/lib
  #INCLUDE=/afs/ipp-garching.mpg.de/home/s/ssim/gsl-opa/include/
  #LIB=/afs/ipp-garching.mpg.de/home/s/ssim/gsl-opa/lib
  #CFLAGS = -O2 -openmp -I$(INCLUDE)
  #CFLAGS = -m64 -O2 -mcmodel medium -shared-intel -I$(INCLUDE) -DMPI_ON
  CFLAGS = -m64 -O2 -mcmodel medium -shared-intel $(GSL_CFLAGS) -DMPI_ON
  #"-mcmodel medium -shared-intel" are needed to hold > 2GB static data
  #in memory http://software.intel.com/en-us/forums/showthread.php?t=43717#18089
  #LDFLAGS= -L$(LIB) -lgsl -lgslcblas -lm
  LDFLAGS= $(GSL_LDFLAGS) -lgsl -lgslcblas -lm
  exspec: override CFLAGS = -m64 -O2 -mcmodel medium -shared-intel $(GSL_CFLAGS) -DDO_EXSPEC
  exgamma: override CFLAGS = -m64 -O2 -mcmodel medium -shared-intel $(GSL_CFLAGS) -DDO_EXSPEC
endif



### Settings for the RZG BlueGene
ifeq ($(HOSTNAME),genius1.rzg.mpg.de)
  CC     = mpixlc_r
  INCLUDE= /u/mkromer/lib/BG/include
  LIB    = /u/mkromer/lib/BG/lib
  CFLAGS = -g -O3 -I$(INCLUDE) -qstrict -qcpluscmt -DMPI_ON
  CFLAGS = -g -O3 -I$(INCLUDE) -qsmp -qstrict -qcpluscmt -DMPI_ON
  ##try qsmp=omp the higher optimisation levels up to O5 and no -qstrict, arch
  LDFLAGS= -L$(LIB) -lgsl -lgslcblas -lm
endif



### Settings for the Juelich BlueGene
ifeq ($(findstring jugene,$(HOSTNAME)), jugene)
  #this requires a
  #  module load gsl
  #check available module with module avail
  CC     = mpixlc_r
  CFLAGS = -g -O3 -I$(GSL_INCLUDE) -qarch=450 -qtune=450 -qsmp -qstrict -qcpluscmt -DMPI_ON
  ##try qsmp=omp the higher optimisation levels up to O5 and no -qstrict, arch
  LDFLAGS= -L$(GSL_LIB) -lgsl -lgslcblas -lm
endif



### Settings for JUROPA
ifeq ($(WORK),/lustre/jwork1)
  #this requires a
  #  module load gsl
  #check available module with module avail
  CC     = mpicc
  CFLAGS = -O3 -I$(GSL_ROOT) -mcmodel medium -shared-intel -openmp -DMPI_ON
  CFLAGS = -O3 -I$(GSL_ROOT) -openmp -DMPI_ON
  LDFLAGS= -L$(GSL_ROOT) -lgsl -lgslcblas -lm
  exspec: override CFLAGS = -O3 -I$(GSL_ROOT) -mcmodel medium -shared-intel -DDO_EXSPEC
  exgamma: override CFLAGS = -O3 -I$(GSL_ROOT) -mcmodel medium -shared-intel -DDO_EXSPEC
endif




### use pg when you want to use gprof the profiler
#CFLAGS = -g -pg -Wall -I$(INCLUDE)
sn3d_files = sn3d.c atomic.c boundary.c compton.c emissivities.c gamma.c grey_emissivities.c grid_init.c input.c kpkt.c linelist.c ltepop.c macroatom.c move.c nltepop.c nonthermal.c packet_init.c packet_prop.c photo_electric.c polarization.c radfield.c ratecoeff.c rpkt.c thermalbalance.c time_init.c update_grid.c update_packets.c vectors.c vpkt.c

sn3d_objects = sn3d.o atomic.o boundary.o compton.o emissivities.o gamma.o grey_emissivities.o grid_init.o input.o kpkt.o linelist.o ltepop.o macroatom.o move.o nltepop.o nonthermal.o packet_init.o packet_prop.o photo_electric.o polarization.o radfield.o ratecoeff.o rpkt.o thermalbalance.o time_init.o update_grid.o update_packets.o vectors.o vpkt.o

sn3d: clean version
	$(CC) $(CFLAGS) $(sn3d_files) $(LDFLAGS) -o sn3d

sn3ddebug: clean version $(sn3d_objects)
	$(CC) -Wall -O0 -g -std=c11 $(INCLUDE) $(sn3d_objects) $(LDFLAGS) -o sn3d

exspec_files = exspec.c grid_init.c input.c vectors.c packet_init.c time_init.c update_grid.c update_packets.c gamma.c boundary.c move.c packet_prop.c compton.c macroatom.c rpkt.c kpkt.c photo_electric.c linelist.c emissivities.c grey_emissivities.c ltepop.c atomic.c ratecoeff.c thermalbalance.c light_curve.c gamma_light_curve.c spectrum.c polarization.c nltepop.c radfield.c

exspec: version
	$(CC) $(CFLAGS) $(exspec_files) $(LDFLAGS) -o exspec

exgamma_objects = exgamma.o grid_init.o input.o vectors.o packet_init.o time_init.o update_grid.o update_packets.o gamma.o boundary.o move.o packet_prop.o compton.o macroatom.o rpkt.o kpkt.o photo_electric.o linelist.o emissivities.o grey_emissivities.o ltepop.o atomic.o ratecoeff.o thermalbalance.o light_curve.o gamma_light_curve.o spectrum.o polarization.o nltepop.o radfield.o

exgamma: $(exgamma_objects)
	$(CC) $(CFLAGS) $(exgamma_objects) $(LDFLAGS) -o exgamma

sn3dsyn_objects = sn3dsyn.o grid_init.o input.o vectors.o packet_init.o time_init.o update_grid.o update_packets.o gamma.o boundary.o move.o spectrum.o packet_prop.o compton.o rpkt.o light_curve.o kpkt.o photo_electric.o linelist.o syn_gamma.o update_gamma_rays.o emissivities.o gamma_light_curve.o grey_emissivities.o syn_lc.o light_curve_res.o polarization.o nltepop.o radfield.o

sn3dsyn: $(sn3dsyn_objects)
	$(CC) $(CFLAGS) $(sn3dsyn_objects) $(LDFLAGS) -o sn3dsyn

sn3dlcsyn_objects = sn3dlcsyn.o grid_init.o input.o vectors.o packet_init.o time_init.o update_grid.o update_packets.o gamma.o boundary.o move.o spectrum.o packet_prop.o compton.o rpkt.o light_curve.o kpkt.o photo_electric.o linelist.o syn_gamma.o ray_prop.o update_gamma_rays.o emissivities.o gamma_light_curve.o grey_emissivities.o syn_lc.o light_curve_res.o polarization.o nltepop.o radfield.o

sn3dlcsyn: $(sn3dlcsyn_objects)
	$(CC) $(CFLAGS) $(sn3dlcsyn_objects) $(LDFLAGS) -o sn3dlcsyn


.PHONY: clean version

version:
	@echo "#define GIT_VERSION \"$(GIT_VERSION)\"" > version.h
	@echo "#define GIT_HASH \"$(GIT_HASH)\"" >> version.h
	@echo "#define GIT_BRANCH \"$(GIT_BRANCH)\"" >> version.h
	@echo "#define COMPILETIME \"`date`\"" >> version.h

clean:
	rm -f *.o version.h
