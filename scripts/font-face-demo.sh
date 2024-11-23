#!/usr/bin/env bash

set -euo pipefail

underline() {
    printf "\e[4m%s\e[24m" "$@"
}

section() {
    HEADER="$1"; shift
    printf "%s\n" "$(underline "$HEADER")"

    while [ "$#" -gt 0 ] ; do
        echo -n  "$1  "; shift
    done

    echo ''
}

section 'Arithmetic' '++' '--' '/=' '&&' '||' '||='
section 'Arrows' '-->' '->-' '=>=' '<--' '>>=|=<<'
section 'Common Variants' 'a' 'g' 'i' 'r' 'l' '0' '3' '@' '$' '%' '&'
section 'Comparison' '<=' '>=' '<=>'
section 'Letter Pairs' 'Fltl' 'fifj'
section 'Punctuation' 'A:E' 'a:e' '*EQ' '*eq'
section 'Similar Characters' '0O' 'iIlL'

# from https://stackoverflow.com/posts/16509364/revisions
fast_chr() {
    local __octal
    local __char
    printf -v __octal '%03o' $1
    printf -v __char \\$__octal
    REPLY=$__char
}

function unicode_character {
    local c=$1    # Ordinal of char
    local l=0    # Byte ctr
    local o=63    # Ceiling
    local p=128    # Accum. bits
    local s=''    # Output string

    (( c < 0x80 )) && { fast_chr "$c"; echo -n "$REPLY"; return; }

    while (( c > o )); do
        fast_chr $(( t = 0x80 | c & 0x3f ))
        s="$REPLY$s"
        (( c >>= 6, l++, p += o+1, o>>=1 ))
    done

    fast_chr $(( t = p | c ))
    echo -n "$REPLY$s"
}

printf "%s\n" "$(underline "Unicode Block Elements")"
for (( i = 0x2580; i < 0x259F + 1; i++ )); do
    unicode_character $i
    printf ' '
    if ! (( (i + 1 ) % 8 )); then
        printf '\n'
    fi
done

section 'Misc Emoji' \
    "$(unicode_character 0x1F996)" \
    "$(unicode_character 0x1F995)"
