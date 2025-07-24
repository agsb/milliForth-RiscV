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

PASS=/opt/riscv/bin

AS = ${PASS}/riscv64-unknown-elf-as

ASFLAGS = -fpic --warn -a -Z  

LD = ${PASS}/riscv64-unknown-elf-ld

LDFLAGS = -m elf32lriscv --no-relax --strip-all \
-static -nostdlib -r -w -pie   

MY = sector-riscv

########################################

%: %.S

$(MY): $(SOURCES:.S=.o)

	$(AS) $(ASFLAGS) -o $@.out $@.s 2> err | tee out

	$(LD) $(LDFLAGS) -o $@.elf 2>> err | tee -a out

#	od --endian=big -A x -t x1z -v $@.out > $@.hex

#	cp $@.s $@.asm

#	sort -k 2 < $@.lbl > $@.lbs

all: 
	
	$(MY)

clean:
	
	$(RM) $(MY).out $(MY).map $(MY).lst \
	      $(MY).lbl $(MY).lbs $(MY).lbf \
	      $(MY).hex err out


