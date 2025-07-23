#
#
# experimental Makefile, feel free for comments
#
# use:
# to make: 	make 
# to clean: 	make clean

.PHONY: clean all

########################################

AS = /usr/bin/riscv64-unknown-elf-as

ASFLAGS = --fpic --warn -a -Z  

LD = /usr/bin/riscv64-unknown-elf-ld

LDFLAGS = -m elf32lriscv --nostdlib --no-relax \
--strip-all
#-ffunction-sections -fdata-sections -ffreestanding \

MY = sector-riscv

########################################

%: %.s

$(MY): $(SOURCES:.s=.o)

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


