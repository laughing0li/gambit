FROM debian:buster-slim


ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
# These are the dependencies used by escript. Gmsh can be installed directly from the repository
RUN apt-get install -y python3-dev python3-numpy python3-pyproj python3-gdal python3-sympy  \
      python3-matplotlib python3-scipy libboost-python-dev libboost-random-dev libnetcdf-dev \
      libnetcdf-cxx-legacy-dev libnetcdf-c++4-dev libsuitesparse-dev cpio lsb-release \
      libmumps-dev libscotchparmetis-dev cmake gcc git gfortran make scons wget \
      libopenmpi-dev libmetis-dev \
      libsilo-dev libhdf5-openmpi-dev \
      gmsh
# Trilinos 
WORKDIR app
RUN wget https://github.com/trilinos/Trilinos/archive/refs/tags/trilinos-release-13-0-1.tar.gz
RUN tar zxvf trilinos-release-13-0-1.tar.gz
WORKDIR trilinos_build
RUN cmake \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_CXX_FLAGS=" " \
      -D CMAKE_C_FLAGS=" " \
      -D PYTHON_EXECUTABLE=/usr/bin/python3 \
      -D Trilinos_ENABLE_CXX11=ON \
      -D Trilinos_ENABLE_Fortran=ON \
      -D BUILD_SHARED_LIBS=ON \
      -D TPL_ENABLE_BLAS=ON \
      -D TPL_ENABLE_Boost=OFF \
      -D TPL_ENABLE_Cholmod=ON \
      -D TPL_ENABLE_LAPACK=ON \
      -D TPL_ENABLE_METIS=ON \
      -D TPL_ENABLE_SuperLU=OFF \
      -D TPL_ENABLE_UMFPACK=ON \
      -D TPL_BLAS_INCLUDE_DIRS=/usr/include/suitesparse \
      -D TPL_Cholmod_INCLUDE_DIRS=/usr/include/suitesparse \
      -D TPL_Cholmod_LIBRARIES='libcholmod.so;libamd.so;libcolamd.so' \
      -D TPL_UMFPACK_INCLUDE_DIRS=/usr/include/suitesparse \
      -D TPL_Boost_INCLUDE_DIRS=/usr/local/boost.1.74.0/include \
      -D TPL_Boost_LIBRARY_DIRS=/usr/local/boost.1.74.0/lib \
      -D Trilinos_ENABLE_Amesos=ON \
      -D Trilinos_ENABLE_Amesos2=ON \
      -D Trilinos_ENABLE_AztecOO=ON \
      -D Trilinos_ENABLE_Belos=ON \
      -D Trilinos_ENABLE_Ifpack=ON \
      -D Trilinos_ENABLE_Ifpack2=ON \
      -D Trilinos_ENABLE_Kokkos=ON \
      -D Trilinos_ENABLE_Komplex=ON \
      -D Trilinos_ENABLE_ML=ON \
      -D Trilinos_ENABLE_MueLu=ON \
      -D Trilinos_ENABLE_Teuchos=ON \
      -D Trilinos_ENABLE_Tpetra=ON \
      -D Trilinos_ENABLE_ALL_OPTIONAL_PACKAGES=ON \
      -D Trilinos_ENABLE_OpenMP=ON \
      -D Trilinos_ENABLE_MPI=OFF \
      -D Trilinos_ENABLE_EXPLICIT_INSTANTIATION=ON \
      -D Kokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
      -D Amesos2_ENABLE_Basker=ON \
      -D Tpetra_INST_SERIAL:BOOL=ON \
      -D Trilinos_ENABLE_TESTS=OFF \
      -D Tpetra_INST_INT_INT=ON \
      -D Teuchos_ENABLE_COMPLEX=ON \
      -D Trilinos_ENABLE_COMPLEX_DOUBLE=ON \
      /app/Trilinos-trilinos-release-13-0-1 && make -j`nproc` install
# Visit is installed using a tarball and an install script that is maintained by Lawrence Livermore National Laboratory
WORKDIR visit
RUN wget https://github.com/visit-dav/visit/releases/download/v3.3.0/visit3_3_0.linux-x86_64-debian11.tar.gz
RUN wget https://github.com/visit-dav/visit/releases/download/v3.3.0/visit-install3_3_0
RUN chmod +x visit-install3_3_0
RUN ./visit-install3_3_0 -c llnl_open 3.3.0 linux-x86_64-debian11 /usr/local
# esys-escript
WORKDIR /app/escript
RUN git clone https://github.com/esys-escript/esys-escript.github.io .
RUN scons options_file=scons/templates/stretch_py3_options.py \
      boost_libs=boost_python37 -j`nproc` werror=0 \
      paso=0 \
      cxx_extra="-fno-permissive -std=c++11" \
      trilinos=1 trilinos_prefix=/usr/local \
      prefix=/usr/local \
      silo=1\
      silo_prefix='/usr/' \
      netcdf=4 \
      build_full

# Sanity test
RUN run-escript /app/escript/scripts/release_sanity.py

# Cleanup
# WORKDIR /app
# RUN rm -rf *

RUN useradd -ms /bin/bash appuser
CMD ["/bin/bash"]