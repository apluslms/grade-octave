FROM apluslms/grading-base:2.7

# TODO: avoid installing graphical user interface components.
# Creating images, such as PNGs, is required.
RUN apt_install \
  gnuplot \
  ghostscript \
  octave \
  octave-statistics \
  octave-image
