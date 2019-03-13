# grade-octave

Grading environment for Octave programs on the A+ and MOOC grader platforms.
This container has Octave version 4.0.3.


## Utility commands

The following utility commands are provided in the path
(in addition to the commands in the grading-base container).

* `octave path_to_script [args...]`

    Run Octave. The command includes by default some Octave arguments
    that disable the graphical user interface.

* `imageb64 path_to_png_file`

    Print feedback HTML to stdout that contains a Base64 encoded PNG image.
    The path to the image file must be given as the argument.
