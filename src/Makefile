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

PASS = /opt/riscv/bin

QEMU = ${PASS}/qemu-riscv32

QFLAGS = -nographic -smp 4 -machine virt -bios none

AS = ${PASS}/riscv64-unknown-elf-as

ASFLAGS = -mlittle-endian -fpic -mabi=ilp32 \
	-Z --warn --info 
	# --statistics -Z

LD = ${PASS}/riscv64-unknown-elf-ld

LDFLAGS = -m elf32lriscv -no-relax --strip-all \
-static -nostdlib -r --stats \
#-T this.ld

OBJDUMP = riscv64-unknown-elf-objdump

MY = sector-riscv

########################################

%: %.S

$(MY): $(SOURCES:.S=.o)

	$(AS) $(ASFLAGS) -alms=$@.lst -o $@.out $@.S 2> err | tee out

	$(LD) $(LDFLAGS) -o $@.elf $@.out 2>> err | tee -a out

	od --endian=big -A x -t x1z -v $@.elf > $@.hex

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

