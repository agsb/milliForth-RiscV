/*
#---------------------------------------------------------------------
 
  Copyright 2025 Alvaro Gomes Sobral Barcellos <@agsb>
 
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
  (at your option) any later version.
 
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.
 
  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.

#----------------------------------------------------------------------
*/

#---------------------------------------------------------------------
#
# Note: system ecalls do not use ra 
#

#---------------------------------------------------------------------
# linux ecall stuff, 29/07/2025, vide:
# https://github.com/riscv-software-src/riscv-pk/blob/master/pk/syscall.h

.equ _ZERO,      0
.equ _ONE,       1
.equ _STDIN,     0
.equ _STDOUT,    1

.equ _SBRK,     45
.equ _FCNT,     55
.equ _GETC,     63
.equ _PUTC,     64
.equ _EXIT,     93
.equ _MMAP,     192

#---------------------------------------------------------------------
.section .data
_char:
        .word   0x0

#---------------------------------------------------------------------
.section .text

# load system call for exit
_exit:
        addi a7, zero, _EXIT
        addi a0, zero, _ZERO
        ecall

# load system call for init
_init:
        
        ret

# linux ecall for getc
_getc:
        li a7, _GETC
        li a0, _STDIN
        la a1, _char
        la a2, _ONE
        ecall
        lb a3, 0 (a1)
        
        #EOF?

        beq a0, zero, _exit

.ifdef debug
        j _putc
.endif
        ret

# linux ecall for putc
_putc:
        li a7, _PUTC
        li a0, _STDOUT
        la a1, _char
        la a2, _ONE
        sb a3, 0 (a1)

_rets:
        ecall
        ret

/*
#---------------------------------------------------------------------
_sbrk:
        li a7, _SBRK
        li a0, 0x0
        j _rets

        # this is where here is
        mov a3, a0

        # add memory 
        li a7, _SBRK
        add a0, a0, a2

        j _rets

#---------------------------------------------------------------------
_fcntl: # fd, cdm, arg
        li a7, _FNCT
        li a0, a3
        li a1, a4
        li a2, a5
        j _rets
        
*/

/*

.section .data
tty_name: .asciz "/dev/tty"

.section .text
.globl _start

_start:
    # 1. Open /dev/tty
    # sys_openat
    li a7, 56           
    li a0, -100         # AT_FDCWD (ignore dirfd)
    la a1, tty_name     # Filename
    li a2, 0            # O_RDONLY
    ecall
    mv a3, a0           # Save new FD

    # 2. dup2(new_fd, 0)
    # sys_dup2
    li a7, 24           
    mv a0, a3           # oldfd: new FD from openat
    li a1, 0            # newfd: 0 (stdin)
    ecall

    # 3. Close the temporary FD
    # sys_close
    li a7, 57           
    mv a0, a3
    ecall

    # Now stdin is restored to /dev/tty
    # ... program code ...

    # Exit
    li a7, 93
    li a0, 0
    ecall

*/
