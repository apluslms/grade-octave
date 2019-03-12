#!/bin/bash

# Run an Octave script called draw.m (in the same directory).
# The student's input(s) are given to the draw.m script as command-line arguments.
# The draw.m script is expected to write a plot into the file plot.png.

# Parameters: file path(s) to the student's input
# run.sh reads the contents of the files and passes them to the draw.m script
# as command-line arguments.
params=()
for filepath in "$@"
do
    if [ ! -f "$filepath" ]; then
        # The file does not exist. Is the exercise config.yaml container/cmd field
        # correct and have the input keys been given correctly?
        >&2 echo "run.sh was called with invalid arguments. The path to the student's input file is invalid: \"$filepath\"."
        exit 1
    fi
    read param < "$filepath"
    params+=("$param")
done

if [ ! -f /exercise/draw.m ]; then
    # The draw.m script was not found. The mount parameter defined in the exercise config.yaml
    # under the container field may be incorrect.
    >&2 echo "The /exercise directory does not contain a draw.m file. Is the exercise mount correctly set?"
    exit 1
fi

# Run the Octave script that produces the image file plot.png.
# Redirect stdout and stderr. The default values of capture are /feedback/out and
# /feedback/err. The Octave script should read the student's parameter(s) from its
# command-line arguments. It may print input validation errors to stdout and
# exit with error code 1 if there are errors.
capture -o /feedback/out -e /feedback/grading-script-errors octave-cli --no-window-system --no-gui --quiet \
    /exercise/draw.m "${params[@]}"
# Check for errors.
drawexitval=$?
if [ "$drawexitval" -ne 0 ]; then
    read errormsg < /feedback/out
    echo "<div id=\"feedback\"><div class=\"alert alert-danger\">$errormsg</div></div>" > /feedback/out
    grade 0/1
    exit 0
fi
# Clear the feedback file.
> /feedback/out
# Base64 encode the PNG image and make an img HTML element from the encoded string.
# Capture redirects stdout to /feedback/out (i.e., the HTML image with base64-encoded data).
capture echo '<div id="feedback"><img src="data:image/png;base64, '$(base64 plot.png)'"/></div>'

# Send the feedback (base64-encoded image) to the grader platform.
grade 1/1

exit 0
