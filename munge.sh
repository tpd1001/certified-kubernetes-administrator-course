#!/usr/bin/env bash
# https://stackoverflow.com/questions/27489170/assign-number-value-to-alphabet-in-shell-bash
string2code() {
    # $1 is string to be converted
    # return variable is string2code_ret
    # $1 should consist of alphabetic ascii characters, otherwise return 1
    # Each character is converted to its position in alphabet:
    # a=01, b=02, ..., z=26
    # case is ignored
    local string=$1
    [[ $string = +([[:ascii:]]) ]] || return 1
    [[ $string = +([[:alpha:]]) ]] || return 1
    string2code_ret=
    while [[ $string ]]; do
        printf -v string2code_ret '%s%02d' "$string2code_ret" "$((36#${string::1}-9))"
        string=${string:1}
    done
}
string2code $(echo ${PWD##*/}|cut -c1)  # returns $string2code_ret
gsed -i "
# node
/NODE_PREFIX =/s|[a-z][a-z]*|${PWD##*/}|
# port
/PORT_PREFIX =/s|[0-9][0-9]*|$[string2code_ret+10]|
# use an available image
/config.vm.box/s|ubuntu/bionic64|hashicorp/bionic64|
# tweak vm internal interface
s/enp0s8/eth0/
" Vagrantfile
