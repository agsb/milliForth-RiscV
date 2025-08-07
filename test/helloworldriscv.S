
# https://gist.github.com/Frank-Buss/aa6aa7d4907335e4a529e8cf3e82f47e

.section .data
msg:    .asciz "Hello, World!\n"

.section .text
.globl _start
_start:
    # set up the arguments for write syscall
    li a7, 64         # system call number for write
    li a0, 1          # file descriptor 1 is stdout
    la a1, msg        # pointer to message
    li a2, 14         # length of message string

    # make the system call
    ecall

    # set up the arguments for exit syscall
    li a7, 93         # system call number for exit
    li a0, 0          # exit status code

    # make the system call
    ecall


