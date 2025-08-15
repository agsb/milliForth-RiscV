#
#
# experimental Makefile, feel free for comments
#
# use:
# to make: 	make 
# to clean: 	make clean

.PHONY: clean all

########################################

# default
BASE = /usr/bin/
# bare-metal ?
NAME = riscv64-unknown-elf-
# on linux ?
NAME = riscv64-linux-gnu-

# using local ?
# or optional compiled
# PASS = /opt/riscv/

#ifneq ("$(wildcard $(PASS))", "")
#	BASE = /opt/riscv/bin/
#	NAME = riscv32-unknown-linux-gnu-
#endif

PASS = ${BASE}${NAME}

GCC = ${PASS}gcc

GCCFLAGS = -nostartfiles -nodefaultlibs -static -Os \
	   -march=rv32ic -mabi=ilp32 -static -Os \
	   
# -march=rv64ic -mabi=lp64 -static -Os \
# -march=rv32ic -mabi=ilp32 -static -Os \

LDFLAGS = 

#-Wl,--stats
#-Wl,-build-id 

ASFLAGS = -Wa,-alms=$@.lst 

#-Wa,-mlittle-endian 

STRIP = ${PASS}strip

OBJDUMP = ${PASS}objdump

QEMU = ${BASE}qemu-system-riscv64
QEMU = ${BASE}qemu-system-riscv32

QEMU = ${BASE}qemu-riscv64
QEMU = ${BASE}qemu-riscv32

QFLAGS = -display none -bios none -serial mon:stdio -smp 1 -machine virt 

MY = minimal

MY = sector-riscv

########################################

%: %.S

$(MY): $(SOURCES:.S=.o)

	$(GCC) $(GCCFLAGS) $(LDFLAGS) $(ASFLAGS) -o $@.elf $@.S 2> err | tee out

	$(PASS)objdump -hdta $@.elf > $@.dmp

	$(PASS)readelf -a $(MY).elf > $(MY).map

	$(PASS)objcopy --dump-section .text=$(MY).sec $(MY).elf
	
	$(PASS)objcopy $(MY).elf -O binary $(MY).bin

#	od --endian=little -A x -t x1z -v $@.elf > $@.hex

all: 
	
	$(MY)

clean:
	
	$(RM) $(MY).out $(MY).map $(MY).lst \
	      $(MY).elf $(MY).dmp $(MY).bin \
	      $(MY).ord $(MY).sec \
	      err out

qemu: 
	#@echo "Press Ctrl-A and then X to exit QEMU"
	$(QEMU) $(QFLAGS) $(MY).elf

sort:
	# extract, order, count the instructions used
	cat $(MY).dmp | grep '   1' | \
	sed -e 's/          /:/'  | \
	sort -t: -k3 > $(MY).ord
	grep '    ......' $(MY).ord > $(MY).16b
	grep -v '    ......' $(MY).ord > $(MY).32b
	wc $(MY).*b

extras:

	$(PASS)strip -o $@.elfs $@.elf 

