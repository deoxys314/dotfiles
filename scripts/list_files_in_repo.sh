#!/usr/bin.env sh

# Lists all files in a git directory

find . -not -path '*/.git/*' -not -name '*git*' -not -name 'LICENSE' -type f
