# File name: Lab4.asm
# Author: Wendi Tan
# Purpose: Users can enter up to 8 program arguments in HEX format. The numbers will range from 0x000 up to 0xFFF. 
#         These numbers will be converted to decimals. The maximum number will be printed on screen in decimal format.
#------------------------------------------------------------------------------

# Pseudo code:
# main: 
#	number_of_arguments = 0
#	print_hex:
#		print (“Program arguments: \n”)
#		offset = 0
#		while (number_of_arguments < $a0):
#			argument = offset($a1)
#			index = 0
#			while (argument(index) != null):
#				[store byte in stack]
#                         print (argument(index))
#				[convert byte to integer if it is not the first two byte of the argument]
#    				index += 1
#			[algorithm(neglect first two bytes): for example: dec(0x123) = 1*16^2+2*16^1+3*16^0 = 291]
#			[store decimal form of each argument in the array called “value”]
#   			[reset: set all byte stored in stack as null for a new round storing.]
#			number_of_arguments += 1
#			offset += 4
#	print newline
#
#	print_dec:
#		print (“Integer values: \n”)
#		[print numbers from value]
#		print newline
#
#	max:
#		int max = 0
#		loop = 0
#		index = 0
#		while (loop = $a0):
#			if (max < value[index]):
#				max = value[index]
#		print (“Maximum value: \n”)
#		print (max)
#		print newline
#
#------------------------------------------------------------------------------
.macro print
  li $v0, 4
  la $a0, ($sp)
  syscall
.end_macro 

.macro integer
  addi $t8, $0, 0x3A
  slt $t9, $t2, $t8    
  bne $t9, $0, end_letter 
  letter:
    addi $t2, $t2, -0x31
    j end_int
  end_letter:
  addi $t2, $t2, -0x30
  end_int:
 .end_macro
#########################################################
.text

main:
  la $s6, ($a0)
  print_hex:
  li $v0, 4
  la $a0, prompt1
  syscall
  
  addi $s5, $0, 0            # array index
  
  loop:                      # loop of each word(argument)
  beq $a1, 32, end_loop
  lw $t1, ($a1)              # load word
  beqz $t1, end_printHex
  # word length
  addi $s3, $0, 0            # length counter
  length:
  lb $t2, ($t1)
  beqz $t2, length_end
  addi $s3, $s3, 1
  lb $t2, 1($t1)
  beqz $t2, length_end
  addi $s3, $s3, 1
  lb $t2, 2($t1)
  beqz $t2, length_end
  addi $s3, $s3, 1
  lb $t2, 3($t1)
  beqz $t2, length_end
  addi $s3, $s3, 1
  lb $t2, 4($t1)
  beqz $t2, length_end
  addi $s3, $s3, 1
  length_end:
  
  addi $a1, $a1, 4
  addi $s2, $0, 0            # sum (integer)
  addi $sp, $0, -8
  addi $s3, $s3, -3
  jal load_byte              # loop of each byte
  j loop
  end_loop:
  
  j end_printHex             # adjust not end system
  
  load_byte:
  addi $t7, $0, 1
  addi $t5, $0, 3 
  addi $t2, $0, 0
  loop2:
  lb $t2, ($t1)              # load byte
  beqz $t2, end_loop2 
  addi $s4, $0, 1        
  sb $t2, ($sp)
  print                      # print hex byte
  lb $t2, ($sp)
  slt $t6, $t7, $t5
  bne $t6, $0, end_algorithm 
  check_integer:
    integer
    
    # conversion
    addi $t8, $0, 0x00
    bne $t2, $t8, zero_end
    zero:
      li $a2, 0
      j end_check_integer
    zero_end:
    
    addi $t8, $0, 0x01
    bne $t2, $t8, one_end
    one:
      li $a2, 1
      j end_check_integer
    one_end:
    
    addi $t8, $0, 0x02
    bne $t2, $t8, two_end
    two:
      li $a2, 2
      j end_check_integer
    two_end:
    
    addi $t8, $0, 0x03
    bne $t2, $t8, three_end
    three:
      li $a2, 3
      j end_check_integer
    three_end:
    
    addi $t8, $0, 0x04
    bne $t2, $t8, four_end
    four:
      li $a2, 4
      j end_check_integer
    four_end:
    
    addi $t8, $0, 0x05
    bne $t2, $t8, five_end
    five:
      li $a2, 5
      j end_check_integer
    five_end:
    
    addi $t8, $0, 0x06
    bne $t2, $t8, six_end
    six:
      li $a2, 6
      j end_check_integer
    six_end:
    
    addi $t8, $0, 0x07
    bne $t2, $t8, seven_end
    seven:
      li $a2, 7
      j end_check_integer
    seven_end:
    
    addi $t8, $0, 0x08
    bne $t2, $t8, eight_end
    eight:
      li $a2, 8
      j end_check_integer
    eight_end:
    
    addi $t8, $0, 0x09
    bne $t2, $t8, nine_end
    nine:
      li $a2, 9
      j end_check_integer
    nine_end:
    
    addi $t8, $0, 0x10
    bne $t2, $t8, a_end
    a:
      li $a2, 10
      j end_check_integer
    a_end:
    
    addi $t8, $0, 0x11
    bne $t2, $t8, b_end
    b_:
      li $a2, 11
      j end_check_integer
    b_end:
    
    addi $t8, $0, 0x12
    bne $t2, $t8, c_end
    c:
      li $a2, 12
      j end_check_integer
    c_end:
    
    addi $t8, $0, 0x13
    bne $t2, $t8, d_end
    d:
      li $a2, 13
      j end_check_integer
    d_end:
    
    addi $t8, $0, 0x14
    bne $t2, $t8, e_end
    e:
      li $a2, 14
      j end_check_integer
    e_end:
    
    addi $t8, $0, 0x15
    bne $t2, $t8, f_end
    f:
      li $a2, 15
      j end_check_integer
    f_end:
    
  end_check_integer:
  
  algorithm:
    addi $t9, $s3, 0   
    power_loop:
      beq $t9, $0, end_power_loop
      mul $s4, $s4, 16
      addi $t9, $t9, -1
      j power_loop
    end_power_loop:
    mul $s4, $s4, $a2
    add $s2, $s2, $s4 
    addi $s3, $s3, -1
    sw $s2, value($s5)       # array
  end_algorithm:
  
  addi $sp, $sp, 1
  addi $t7, $t7, 1
  addi $t1, $t1, 1
  j loop2 
  end_loop2:
  
  end_load_byte:
  la $s0, 0
  sb $s0, ($sp)
  addi $sp, $sp, 1
  sub $sp, $sp, $t7
  addi $s5, $s5, 4
  li $v0, 11 
  la $a0, 32
  syscall
  
  addi $t7, $t0, 0
  addi $sp, $0, -8
  reset:
  beq $t7, 5, end_reset
  la $s0, 0
  sb $s0, ($sp)
  addi $t7, $t7, 1
  addi $sp, $sp, 1
  j reset
  end_reset:
  jr $ra
  end_printHex:
  li $v0, 4
  la $a0, newline
  syscall
  li $v0, 4
  la $a0, newline
  syscall
  #####################################################################
  print_dec:
    li $v0, 4
    la $a0, newline
    li $v0, 4
    la $a0, prompt2
    syscall
    addi $t0, $0, 0
    addi $t1, $0, 0
    mul $s6, $s6, 4
    loop_dec:
      beq $t1, $s6, end_loop_dec
      lw $t0, value($t1)
      li $v0, 1
      la $a0, ($t0)
      syscall
      li $v0, 11
      la $a0, 32
      syscall
      addi $t1, $t1, 4
      j loop_dec
    end_loop_dec:
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 4
    la $a0, newline
    syscall
  end_print_dec:
  ###############################################################
  max:
    addi $t0, $0, 0  
    addi $a1, $0, 0      # max value
    addi $a2, $0, 0
    loop_max:
      beq $t0, $s6, end_loop_max
      lw $t1, value($t0)
      move $a2, $t1
      slt $t2, $a1, $a2
      beq $t2, $0, end_move
      move:
        move $a1, $a2
      end_move:
      addi $t0, $t0, 4
      j loop_max
    end_loop_max:
    li $v0, 4
    la $a0, prompt3
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 1
    la $a0, ($a1)
    syscall
    li $v0, 4
    la $a0, newline
    syscall
  end_max:
  addi $v0, $0, 10
  syscall
  
.data
  null: .asciiz "\0"
  prompt1: .asciiz "Program arguments: \n"
  prompt2: .asciiz "Integer values: \n"
  prompt3: .asciiz "Maximum value: "
  newline: .asciiz "\n"
  
  value: .align 2
         .space 32
  
