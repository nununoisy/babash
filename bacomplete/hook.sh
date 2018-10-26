#!/bin/bash

# simple hook for `complete`

complete() {
    echo "babash debug - complete ${@}"
    eval "$(~/babash/chooser.sh hook $@)"
}