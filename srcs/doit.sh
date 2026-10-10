#!/usr/bin/bash

# crude script

make clean

make

# system and application
QEMU=qemu-system-riscv64

# single application
QEMU=qemu-riscv32

${QEMU} sector.elf \
 -display none -bios none -serial mon:stdio -smp 1 -machine virt

