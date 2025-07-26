#
#
# experimental Makefile, feel free for comments
#
# use:
# to make: 	make 
# to clean: 	make clean

.PHONY: clean all

########################################

#riscv32-unknown-elf-as exampleAsm.S -o exampleAsm.o
#riscv32-unknown-elf-ld -o exampleAsm.elf -T asm.ld -m elf32lriscv -nostdlib --no-relax

# as ubuntu 
BASE = /usr/bin
NAME = riscv64-unknown-elf-

# as default compiled
BASE = /opt/riscv/bin/
NAME = riscv64-unknown-linux-gnu-

PASS = /${BASE}/${NAME}

QEMU = ${BASE}/qemu-riscv64

QFLAGS = -nographic -smp 1 -machine virt -bios none

CPP = ${PAS}cpp

GCC = ${PASS}gcc

GCCFLAGS = -fpic -static -nostdlib -nostartfiles --save-temps 

#-fverbose-asm

AS = ${PASS}as

ASFLAGS = -mlittle-endian

LD = ${PASS}ld

LDFLAGS = -b=elf64-littleriscv --stats --strip-all --build-id -r 

STRIP = ${PASS}strip

OBJDUMP = ${PASS}objdump

MY = test

########################################

%: %.S

$(MY): $(SOURCES:.S=.o)

	$(CPP) $@.S > $@.s

#	$(GCC) $(GCCFLAGS) -S -fverbose-asm -g -O2 $@.S

	$(AS) $(ASFLAGS) -aghlms=$@.lst -o $@.out $@.s
	
	$(LD) $(LDFLAGS) -o $@.elf $@.s 

	$(STRIP) $@.out $@.elf

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

