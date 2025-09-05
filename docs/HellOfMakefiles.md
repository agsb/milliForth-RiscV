# Hell of Makefiles

In Linus, I use the GCC gnu toolchain, for Intel x*86*, ARMs and RiscVs.
there are a defined namespace for each chain, so:

For linux systems, x86-64-linux-gnu, riscv64-linux-gnu, arm-linux-gnueabi 
and for embeded systems riscv64-unknown-elf, arm-linux-gnueabi, arm-none-eabi.

The QEMU uses qemu-system and qemu-user packs.

My common parameters are: xxxx is the ISA


        $(GCCFLAGS) = -nodefaultlibs -nostartfiles -static -Oz \
                      -march=xxxx -mabi=xxxx 

        $(ASFLAGS) = -Wa,-alms=$@.lst 

        $(LDFLAGS) = -Wl,--stats

        $(PASS)gcc $(GCCFLAGS) $(LDFLAGS) $(ASFLAGS) -o $@.elf $@.S 2> err | tee out

        $(PASS)objdump -hdta $@.elf > $@.dmp

        $(PASS)readelf -a $(MY).elf > $(MY).map

        $(PASS)objcopy --dump-section .text=$(MY).sec $(MY).elf
        
        $(PASS)objcopy $(MY).elf -O binary $(MY).bin

        od --endian=little -A x -t x1 -v $(MY).sec > $(MY).hex

