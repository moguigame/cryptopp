#!/usr/bin/env bash

IS_LINUX=$(uname -s | grep -i -c linux)
IS_SOLARIS=$(uname -s | grep -i -c sunos)
IS_DARWIN=$(uname -s | grep -i -c darwin)
IS_CYGWIN=$(uname -s | grep -i -c cygwin)

rm -f rdrand-x86.o rdrand-x32.o rdrand-x64.o &>/dev/null

NASM=$(which nasm 2>&1)
if [[ ! -f "$NASM" ]]; then
    echo "Unable to locate Nasm"
    [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

if [[ "$IS_LINUX" -eq "1" ]]; then
    echo "Building rdrand and rdseed modules for Linux"
    nasm -f elf32 rdrand.S -DX86 -g -o rdrand-x86.o
    nasm -f elfx32 rdrand.S -DX32 -g -o rdrand-x32.o
    nasm -f elf64 rdrand.S -DX64 -g -o rdrand-x64.o
fi

if [[ "$IS_SOLARIS" -eq "1" ]]; then
    echo "Building rdrand and rdseed modules for Solaris"
    nasm -f elf32 rdrand.S -DX86 -o rdrand-x86.o
    nasm -f elfx32 rdrand.S -DX32 -o rdrand-x32.o
    nasm -f elf64 rdrand.S -DX64 -o rdrand-x64.o
fi

if [[ "$IS_DARWIN" -eq "1" ]]; then
    echo "Building rdrand and rdseed modules for Darwin"
    nasm -f macho32 rdrand.S -DDARWIN -DX86 -g -o rdrand-x86.o
    nasm -f macho64 rdrand.S -DDARWIN -DX64 -g -o rdrand-x64.o
fi

if [[ "$IS_CYGWIN" -eq "1" ]]; then
    echo "Building rdrand and rdseed modules for Cygwin"
    nasm -f win32 rdrand.S -DCYGWIN -DX86 -g -o rdrand-x86.o
    nasm -f win64 rdrand.S -DCYGWIN -DX64 -g -o rdrand-x64.o
fi

[ "$0" = "$BASH_SOURCE" ] && exit 0 || return 0
