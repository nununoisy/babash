#!/bin/bash

# create readline binds here

# load cfg file
if [[ -z ~/.config/babash.cfg ]]; then
    echo "Config file does not exist or error reading."
    exit 1
fi

. ~/.config/babash.cfg

bind -f ./bacompleterc