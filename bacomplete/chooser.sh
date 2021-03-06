#!/bin/bash

# REMOVE THIS LATER
ARROW="\xEE\x82\xB1"
#ARROW=">" #gt

SLDARROW="\xEE\x82\xB0"
#SLDARROW="\xAB" #double arrow

LARROW="\xEE\x82\xB3"
#LARROW="<" #lt

LSLDARROW="\xEE\x82\xB2"
#LSLDARROW="\xBB" #left double arrow

echo "$@"
exit

# the actual code

# but first, function definitions!!
# nice function (thx Dennis Williamson)
cursorPosition() {
	exec < /dev/tty
	oldstty=$(stty -g)
	stty raw -echo min 0
	# on my system, the following line can be replaced by the line below it
	echo -en "\033[6n" > /dev/tty
	# tput u7 > /dev/tty    # when TERM=xterm (and relatives)
	IFS=';' read -r -d R -a pos
	stty $oldstty
	# change from one-based to zero based so they work with: tput cup $row $col
	row=$((${pos[0]:2} - 1))    # strip off the esc-[
	col=$((${pos[1]} - 1))
	echo "${row};${col}"
}

# what are we doing
if [[ $1 == "hook" ]]; then
    echo "hey"
fi

if [[ $1 == "chooser" ]]; then
    # inputs as envvars:
    # CMDSTRING : full string containing command
    # COMPOPTIONS () : -o args passed to complete
    # ACTIONS () : -A args passed or short args
    # COMMAND : command to generate completions delimited by \n
    # FUNCTION : eval "$FUNCTION" - returns completions in COMPREPLY ()
    # GFILEPATS () : file patterns expanded to return completions
    # PREFIX : appended to beginning
    # SUFFIX : appended to end
    # WORDS () : list of literal completions
    # FILTERPAT : complete filter pattern

    # we don't need 'chooser' anymore
    shift

    # todo add actual parser code here (should shift out args)
    COMPFINAL=()
    
    # init flags
    # -o flags
    fDIRNAMES=0
     fFILEFMT=0
     fNOQUOTE=0
      fNOSORT=0
     fNOSPACE=0
    fPLUSDIRS=0
    
    # COMPOPTIONS:
    # {,bash}default - handled in hook
    # dirnames - generate dirnames if no options
    # filenames - format filenames
    # noquote - do not quote filenames
    # nosort - do not alphebetize finished compspecs
    # nospace - do not add a trailing space
    # plusdirs - perform directory compspec at the end
    
    for oIndex in {0..$(( ${#COMPOPTIONS[@]} - 1 ))}; do
        c="${COMPOPTIONS[$oIndex]}"
        if [[ $c == "dirnames" ]]; then
            fDIRNAMES=1
        elif [[ $c == "filenames" ]]; then
            fFILEFMT=1
        elif [[ $c == "noquote" ]]; then
            fNOQUOTE=1
        elif [[ $c == "nosort" ]]; then
            fNOSORT=1
        elif [[ $c == "nospace" ]]; then
            fNOSPACE=1
        elif [[ $c == "plusdirs" ]]; then
            fPLUSDIRS=1
        fi
    done
    
    # ACTIONS:
    # alias | -a - alias names
    # arrayvar - array variables
    # binding - Readline keybind names
    # builtin | -b - shell builtins
    # command | -c - command names
    # directory | -d - directory names
    # disabled, enabled - %s shell builtins
    # export | -e - exported shell vars
    # file | -f - filenames
    # function - function names
    # group | -g - group names
    # helptopic - topics from `help` builtin
    # hostname - hostnames from $HOSTFILE
    # job | -j - job names if job control is active
    # keyword | -k - shell reserved keywords
    # running - running jobs if job control is active
    # service | -s - service names
    # setopt - -o options for `set`
    # shopt - options for `shopt`
    # signal - signal names
    # stopped - stopped jobs if job control is active
    
    # new idea - use compgen (especially since )
    

    COMPFINAL=( "1" "two" "333" "4four4" "fffffiiiiivvvvveeeee" )

    # chooser
    curpos="$(cursorPosition)"
    index=0
    while true; do
        printf "\e[${CURPOS}H\e[K\e[0m\e[38;5;240m${LSLDARROW}\e[48;5;240m\e[38;5;15m%s${ARROW}< >\e[0m\e[38;5;240m${SLDARROW}\e[0m" "${COMPFINAL[$index]}"
        read -n1 input
        echo "$input"
        if [[ $input == '.' ]]; then
            (( index++ ))
            index=$((index % ${#COMPFINAL[@]}))
        elif [[ $input == ',' ]]; then
            if (( $index == 0 )); then
                index=$(( ${#COMPFINAL[@]} - 1 ))
            else
                (( index-- ))
            fi
        elif [[ $input == '' ]]; then
            echo "${COMPFINAL[$index]}" | dd of="$@"
            exit
        fi
    done
fi