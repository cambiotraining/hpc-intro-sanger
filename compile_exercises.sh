#!/bin/bash

# ===== Compile Exercises ===== #

echo '---
pagetitle: "Sanger HPC"
output:
  html_document:
    toc: false
---
' > 99-exercises.md

echo ":::note
This page contains all the same exercises found throughout the materials. They are compiled here for convenience.
:::" >> 99-exercises.md

cat 0*.md | sed -n '/^:::exercise/,/^:::/p' | sed 's/:::exercise/\n----\n\n:::exercise/g' >> 99-exercises.md
