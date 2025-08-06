# Hell of Makefiles

I use the GCC gnu toolchain, for Intel x*86*, ARMs and RiscVs.
there are a defined namespace for each chain, so:

For linux systems, x86-64-linux-gnu, riscv64-linux-gnu, arm-linux-gnueabi and for embeded systems riscv64-unknown-elf, arm-linux-gnueabi, arm-none-eabi.

Common parameters are: 


        $(GCCFLAGS) = -nodefaultlibs -nostartfiles -stattic -Os 
        $(ASFLAGS) = -Wa,-alms=$@.lst 
        $(LDFLAGS) = -Wl,--stats

        $(PASS)gcc $(GCCFLAGS) $(LDFLAGS) $(ASFLAGS) -o $@.elf $@.S 2> err | tee out

        $(PASS)objdump -hdta $@.elf > $@.dmp

        $(PASS)readelf -a $(MY).elf > $(MY).map

        $(PASS)objcopy --dump-section .text=$(MY).sec $(MY).elf
        
        $(PASS)objcopy $(MY).elf -O binary $(MY).bin



  
