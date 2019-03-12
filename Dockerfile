FROM apluslms/grading-base:2.8

ARG OCTAVE_VER=5.1.0
ARG OCTAVE_URL=https://ftp.acc.umu.se/mirror/gnu.org/gnu/octave/octave-$OCTAVE_VER.tar.gz

ARG BUILD_DEPS='gcc g++ gfortran make'

# Compile Octave from source code without GUI components.
RUN apt_install \
    $BUILD_DEPS \
    libblas-dev \
    liblapack-dev \
    libpcre3-dev \
    libarpack2-dev \
    libcurl4-gnutls-dev \
    libfftw3-dev \
    libglpk-dev \
    # gnuplot without X11 or Qt dependencies
    gnuplot-nox \
    libgraphicsmagick++1-dev \
    libhdf5-dev \
    llvm-dev \
    libqhull-dev \
    libqrupdate-dev \
    libsuitesparse-dev \
    zlib1g-dev \
    epstool \
    fig2dev \
  && cd /usr/local/src \
  && (curl -Ls $OCTAVE_URL | tar -xz) \
  && cd /usr/local/src/octave-$OCTAVE_VER \
  && ./configure \
    --prefix=/usr/local \
    --disable-readline \
    --disable-docs \
    --without-opengl \
    --disable-java \
    --without-portaudio \
    --without-qt \
    --disable-atomic-refcount \
    --without-fltk \
    --with-magick=GraphicsMagick \
    --with-hdf5-libdir=/usr/lib/x86_64-linux-gnu/hdf5/serial \
    --with-hdf5-includedir=/usr/include/hdf5/serial \
  # compile without debugging symbols
  && make CFLAGS=-O CXXFLAGS=-O LDFLAGS= \
  && make install \
  && make distclean \
  # install Octave packages io, statistics and image (downloaded from the Forge repository)
  && octave-cli --eval 'pkg install -forge io statistics image' \
  # uninstall development libraries
  && apt-get remove lib*-dev zlib*-dev $BUILD_DEPS \
  # remove the Octave source code
  && rm -rf /usr/local/src/octave-$OCTAVE_VER
