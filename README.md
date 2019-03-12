# grade-octave

Grading environment for Octave programs on the A+ and MOOC grader platforms.

The git branch `compileoctave` contains a Dockerfile that tries to compile the
latest Octave version from source code. It also avoids installing any graphical
user interface components since they are not needed in the container.
It basically works, but it still produces some warnings and the image seems to
be over 100MB larger than the image that simply installs Octave from precompiled
apt packages (from the Debian repository) even though the apt packages also
include the GUI.

During the image build, the compiler (make command) prints a warning that
the GraphicsMagick library is not found even though the package
libgraphicsmagick++1-dev is installed.

When the container is used to execute an Octave script, it prints warnings
like this (OpenGL was indeed supposed to be disabled):

```
warning: isdir is obsolete; use isfolder or dir_in_loadpath instead
warning: opengl_renderer::render_text: support for rendering text (FreeType) was unavailable or disabled when Octave was built
warning: called from
    axes at line 100 column 8
    subplot at line 287 column 18
    /exercise/draw.m at line 24 column 1
```
