#
#
# experimental Makefile, feel free for comments
#
# use:
# to make: 	make 
# to clean: 	make clean

.PHONY: clean opt all

########################################

#riscv32-unknown-elf-as exampleAsm.S -o exampleAsm.o
#riscv32-unknown-elf-ld -o exampleAsm.elf -T asm.ld -m elf32lriscv -nostdlib --no-relax

# default
BASE = /usr/bin
NAME = riscv64-unknown-elf-

# or optional compiled
PASS = /opt/riscv/

ifneq ("$(wildcard $(PASS))", "")
	BASE =/opt/riscv/bin/
	NAME =riscv64-unknown-linux-gnu-
endif

PASS = ${BASE}/${NAME}

QEMU = ${BASE}/qemu-riscv64

QFLAGS = -nographic -smp 1 -machine virt -bios none

GCC = ${PASS}gcc

GCCFLAGS = -fpic -static -nostdlib -nostartfiles 

#-fverbose-asm

ASFLAGS = -Wa,-mlittle-endian -Wa,-aghlms=$@.lst -Wa,-o=$@.out

LDFLAGS = -Wl,-b=elf32-littleriscv -Wl,--stats -Wl,--strip-all -Wl,--build-id -Wl,-r 

STRIP = ${PASS}strip

OBJDUMP = ${PASS}objdump

MY = minimal
MY = sector-riscv

########################################

%: %.S

$(MY): $(SOURCES:.S=.o)

	$(GCC) $(GCCFLAGS) $(ASFLAGS) $(LDFLAGS) $@.S 2> err | tee out

	$(STRIP) a.out $@.out $@.elf

	$(OBJDUMP) $@.elf > $@.dmp

#	od --endian=little -A x -t x1z -v $@.elf > $@.hex

#	cp $@.s $@.asm

#	sort -k 2 < $@.lbl > $@.lbs

all: 
	
	$(MY)

clean:
	
	$(RM) $(MY).out $(MY).map $(MY).lst \
	      $(MY).lbl $(MY).lbs $(MY).lbf \
	      $(MY).hex err out

qemu: $(TARGET)
	@qemu-system-riscv32 -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	$(QEMU) $(QFLAGS) -kernel sector-riscv.elf

