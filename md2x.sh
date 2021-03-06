#/bin/bash
set -e
DIR="$( dirname "$(readlink -f "$0")" )"
CUR="$( pwd )"
cd "$DIR" && node main.js "$CUR"/"$1"
cd build && pdflatex Thesis.tex
bibtex Thesis.aux
pdflatex Thesis.tex
cp Thesis.pdf "$CUR"
open Thesis.pdf
