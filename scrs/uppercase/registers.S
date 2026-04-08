/*
#---------------------------------------------------------------------
 
  Copyright 2025 Alvaro Gomes Sobral Barcellos <@agsb>
 
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
  (at your option) any later version.
 
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.
 
  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.

#----------------------------------------------------------------------
*/

#---------------------------------------------------------------------
# using pre-processor CPP (GNU GCC)
# for alias register names 
# beware about changes
# a0, a1, a2, a3, a7 are used by ecalls in _putc and _getc
# a4, a5, a6 are generics
#---------------------------------------------------------------------

# forth struct pointer, constant 
#define usr s0

# forth instruction pointer, preserved
#define ipt s1

# hash value
#define hsh a0

# link pointer
#define lnk a1

# word pointer
#define wrd a2

# generic
#define fst a3

# generic
#define snd a4

# index 
#define idx a5

# generic
#define trd a6

# generic
#define ops a7

