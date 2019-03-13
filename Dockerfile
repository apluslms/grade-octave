FROM apluslms/grading-base:2.8

# Install Octave from the package repository.
# There is no command-line only package, so this will also install
# unnecessary graphical user interface components.
RUN apt_install \
  gnuplot \
  epstool \
  fig2dev \
  pstoedit \
  octave \
  octave-statistics \
  octave-image \
  # Remove the octave binary because it will be replaced by a custom script.
  && rm /usr/bin/octave

COPY bin /usr/local/bin
