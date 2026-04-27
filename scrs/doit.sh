#!/usr/bin/bash

# crude script

make clean

make

qemu-system-riscv64 sector.elf -format=raw \
 -display none -bios none -serial mon:stdio -smp 1 -machine virt

