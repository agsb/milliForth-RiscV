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

#PASS = /opt/riscv/bin
PASS = /usr/bin

QEMU = ${PASS}/qemu-riscv64

QFLAGS = -nographic -smp 4 -machine virt -bios none

AS = ${PASS}/riscv64-unknown-elf-as

ASFLAGS = -v -mlittle-endian --warn -fpic -g -Z   
	# --warn --info 
	# --statistics -Z

LD = ${PASS}/riscv64-unknown-elf-ld

LDFLAGS = -v -b elf64-littleriscv -static -nostdlib --stats --strip-all --build-id -r 
# -T this.ld

STRIP = ${PASS}/riscv64-unknown-elf-strip

OBJDUMP = riscv64-unknown-elf-objdump

MY = minimal
MY = sector-riscv

########################################

%: %.S

$(MY): $(SOURCES:.S=.o)

	$(AS) $(ASFLAGS) -aghlms=$@.lst -o $@.out $@.S 2> err | tee out

	$(LD) $(LDFLAGS) -o $@.elf $@.out 2>> err | tee -a out

	$(STRIP) $@.elf $@.out

#	od --endian=big -A x -t x1z -v $@.elf > $@.hex

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

