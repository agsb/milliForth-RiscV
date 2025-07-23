Usage: riscv64-unknown-elf-as [option...] [asmfile...]
Options:
  -a[sub-option...]	  turn on listings
                      	  Sub-options [default hls]:
                      	  c      omit false conditionals
                      	  d      omit debugging directives
                      	  g      include general info
                      	  h      include high-level source
                      	  i      include ginsn and synthesized CFI info
                      	  l      include assembly
                      	  m      include macro expansions
                      	  n      omit forms processing
                      	  s      include symbols
                      	  =FILE  list to FILE (must be last sub-option)
  --alternate             initially turn on alternate macro syntax
  --compress-debug-sections[={none|zlib|zlib-gnu|zlib-gabi|zstd}]
                          compress DWARF debug sections
		            Default: none
  --nocompress-debug-sections
                          don't compress DWARF debug sections
  -D                      produce assembler debugging messages
  --dump-config           display how the assembler is configured and then exit
  --debug-prefix-map OLD=NEW
                          map OLD to NEW in debug information
  --defsym SYM=VAL        define symbol SYM to given value
  --execstack             require executable stack for this object
  --noexecstack           don't require executable stack for this object
  --size-check=[error|warning]
			  ELF .size directive check (default --size-check=error)
  --elf-stt-common=[no|yes] (default: no)
                          generate ELF common symbols with STT_COMMON type
  --sectname-subst        enable section name substitution sequences
  --generate-missing-build-notes=[no|yes] (default: no)
                          generate GNU Build notes if none are present in the input
  --gsframe               generate SFrame stack trace information
  -f                      skip whitespace and comment preprocessing
  -g --gen-debug          generate debugging information
  --gstabs                generate STABS debugging information
  --gstabs+               generate STABS debug info with GNU extensions
  --gdwarf-<N>            generate DWARF<N> debugging information. 2 <= <N> <= 5
  --gdwarf-cie-version=<N> generate version 1, 3 or 4 DWARF CIEs
  --gdwarf-sections       generate per-function section names for DWARF line information
  --hash-size=<N>         ignored
  --help                  show all assembler options
  --target-help           show target specific options
  -I DIR                  add DIR to search list for .include directives
  -J                      don't warn about signed overflow
  -K                      warn when differences altered for long displacements
  -L,--keep-locals        keep local symbols (e.g. starting with `L')
  -M,--mri                assemble in MRI compatibility mode
  --MD FILE               write dependency information in FILE (default none)
  --multibyte-handling=<method>
                          what to do with multibyte characters encountered in the input
  -nocpp                  ignored
  -no-pad-sections        do not pad the end of sections to alignment boundaries
  -o OBJFILE              name the object-file output OBJFILE (default a.out)
  -R                      fold data section into text section
  --reduce-memory-overheads ignored
  --statistics            print various measured statistics from execution
  --strip-local-absolute  strip local absolute symbols
  --traditional-format    Use same format as native assembler when possible
  --version               print assembler version number and exit
  -W  --no-warn           suppress warnings
  --warn                  don't suppress warnings
  --fatal-warnings        treat warnings as errors
  -w                      ignored
  -X                      ignored
  -Z                      generate object file even after errors
  --listing-lhs-width     set the width in words of the output data column of
                          the listing
  --listing-lhs-width2    set the width in words of the continuation lines
                          of the output data column; ignored if smaller than
                          the width of the first line
  --listing-rhs-width     set the max width in characters of the lines from
                          the source file
  --listing-cont-lines    set the maximum number of continuation lines used
                          for the output data column of the listing
  @FILE                   read options from FILE
RISC-V options:
  -fpic or -fPIC              generate position-independent code
  -fno-pic                    don't generate position-independent code (default)
  -march=ISA                  set the RISC-V architecture
  -misa-spec=ISAspec          set the RISC-V ISA spec (2.2, 20190608, 20191213)
  -mpriv-spec=PRIVspec        set the RISC-V privilege spec (1.9.1, 1.10, 1.11, 1.12)
  -mabi=ABI                   set the RISC-V ABI
  -mrelax                     enable relax (default)
  -mno-relax                  disable relax
  -march-attr                 generate RISC-V arch attribute
  -mno-arch-attr              don't generate RISC-V arch attribute
  -mcsr-check                 enable the csr ISA and privilege spec version checks
  -mno-csr-check              disable the csr ISA and privilege spec version checks (default)
  -mbig-endian                assemble for big-endian
  -mlittle-endian             assemble for little-endian

Report bugs to <https://sourceware.org/bugzilla/>
