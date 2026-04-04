
/*

How make a linked list in a macro ?

need just:

.set last, 0

.macro linked name, label, hash
.equ last_\@, last
link_\@\():
        .word last_\@
        .word \hash
        .ascii "name"
label:
.set last, link_\@
.endm

BUT DOES NOT WORK with GCC, 
        the last_\@ gets link_\@, 
        not in defitinion order
Need something like (%\@ - 1)
*/

#----------------------------------------------------------------------
.equ last, 0

.macro def_word name:req label:req hash:req link=last

.print " \name last \@ "

.equ last_\@, last
link_\@\():
        .word last_\@
        .word \hash
        .ascii "\name"
my_\label:
.set last, link_\@

.endm

def_word name0 label0 0x0 0x1000 

def_word name1 label1 0x1 

def_word name2 label2 0x2 
  
def_word name3 label3 0x3  
  
def_word name4 label4 0x4 
  
#----------------------------------------------------------------------
.text

_start:
        ret

.end
