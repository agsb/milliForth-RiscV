
# notes

## options


    _RISC-V Options_ (*note RISC-V Options::)
          -mbranch-cost=N-INSTRUCTION
          -mplt  -mno-plt
          -mabi=ABI-STRING
          -mfdiv  -mno-fdiv
          -mfence-tso  -mno-fence-tso
          -mdiv  -mno-div
          -misa-spec=ISA-SPEC-STRING
          -march=ISA-STRING
          -mtune=PROCESSOR-STRING
          -mpreferred-stack-boundary=NUM
          -msmall-data-limit=N-BYTES
          -msave-restore  -mno-save-restore
          -mshorten-memrefs  -mno-shorten-memrefs
          -mstrict-align  -mno-strict-align
          -mcmodel=medlow  -mcmodel=medany -mcmodel=large
          -mexplicit-relocs  -mno-explicit-relocs
          -mrelax  -mno-relax
          -mriscv-attribute  -mno-riscv-attribute
          -malign-data=TYPE
          -mbig-endian  -mlittle-endian
          -mstack-protector-guard=GUARD  -mstack-protector-guard-reg=REG
          -mstack-protector-guard-offset=OFFSET
          -mcsr-check -mno-csr-check
          -mmovcc  -mno-movcc
          -minline-atomics  -mno-inline-atomics
          -minline-strlen  -mno-inline-strlen
          -minline-strcmp  -mno-inline-strcmp
          -minline-strncmp  -mno-inline-strncmp
          -mtls-dialect=desc  -mtls-dialect=trad

 riscv specifics:

 https://gcc.gnu.org/onlinedocs/gcc-14.3.0/gcc/RISC-V-Options.html

## gcc-toolchain

    PATH=$PATH:/opt/riscv/

    ./configure \
        --prefix=/opt/riscv --enable-multilib \
        --enable-default-pie --with-languages=c,c++ \
        --enable-strip --with-isa-spec=20191213 \
        --enable-qemu-system --with-sim=qemu --with-model=medlow \
        --with-arch=rv32imac_zicsr_zifencei_zba_zbb_zbs_zbkb_zca_zcb \
        --with-abi=ilp32 \
        --with-multilib-generator=\
        "rv32ima_zicsr_zifencei_zba_zbb_zbs_zbkb_zca_zcb-ilp32--;  rv32imac_zicsr_zifencei_zba_zbb_zbs_zbkb-ilp32--; rv64ima_zicsr_zifencei_zba_zbb_zbs_zbkb_zca_zcb-ilp64--;  rv64imac_zicsr_zifencei_zba_zbb_zbs_zbkb-ilp64--"

    make linux

    make build-sim SIM=qemu

    make report-linux SIM=qemu

## 
