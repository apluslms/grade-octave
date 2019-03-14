#!/bin/bash

# Run the Octave script given as the first argument.
# The student's input(s) are given to the script as command-line arguments.
# The script is expected to write a plot into the file plot.png.

# The first argument is the path to the Octave script to execute.
# Additional arguments: file path(s) to the student's input
# This script reads the contents of the files and passes them to the Octave script
# as command-line arguments.
octavescript="$1"
shift
params=()
for filepath in "$@"
do
    if [ ! -f "$filepath" ]; then
        # The file does not exist. Is the exercise config.yaml container/cmd field
        # correct and have the input keys been given correctly?
        >&2 echo "$0 was called with invalid arguments. The path to the student's input file is invalid: \"$filepath\"."
        exit 1
    fi
    read param < "$filepath"
    params+=("$param")
done

if [ ! -f "$octavescript" ]; then
    # The Octave script was not found.
    >&2 echo "The script $octavescript does not exist."
    exit 1
fi

# Run the Octave script that produces the image file plot.png.
# Redirect stdout and stderr. The default values of capture are /feedback/out and
# /feedback/err. The Octave script should read the student's parameter(s) from its
# command-line arguments. It may print input validation errors to stdout and
# exit with error code 1 if there are errors.
capture -o /feedback/out -e /feedback/grading-script-errors octave "$octavescript" "${params[@]}"
# Check for errors.
exitval=$?
if [ "$exitval" -ne 0 ]; then
    read errormsg < /feedback/out
    echo "<div class=\"alert alert-danger\">$errormsg</div>" > /feedback/out
    grade 0/1
    exit 0
fi
# Clear the feedback file.
> /feedback/out
# Base64 encode the PNG image and make an img HTML element from the encoded string.
# Capture redirects stdout to /feedback/out (i.e., the HTML image with base64-encoded data).
capture imageb64 plot.png

# Send the feedback (base64-encoded image) to the grader platform.
grade 1/1

exit 0
