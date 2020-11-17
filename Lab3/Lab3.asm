# File name: lab3.asm
# Author: Wendi Tan
# Purpose: As the user enter a height (number) greater than 0, the program will print out a pattern of numbers and asterisks
#          with corresponded height.
#------------------------------------------------------------------------------
#
# Pseudo code:
#
#  while True:
#      height = int(input("Enter the height of the pattern (must be greater than 0):    "))
#      if height > 0:
#          break
#      else:
#          print("Invalid Entry!")        
##  main-------------------------------
# 
#  n = 0
#  number = 1
#  tab = "	"
# 
#  for i in range(0,height):  
#     n+=1
#      tabs = height-n
#      t_s = 2*n-3
#      
#      for t in range(0, tabs):
#          print(tab,end='')
#      print(number)
#      number+=1
#
#      if n > 1:
#          for j in range(0, t_s): 
#              print(tab+'*',end=''),
#          print(tab),
#          print(number)
#          number+=1
#------------------------------------------------------------------------------------

.data
	prompt: .asciiz "Enter the height of the pattern (must be greater than 0):"
	invalid: .asciiz "Invalid Entry!"
	newline: .asciiz "\n"
.text
        greater_than_zero:
	#prompt the user to enter
	li $v0, 4
	la $a0, prompt
	syscall
	li $v0, 11
	la $a0, 9
	syscall
	#get the user's number
	li $v0, 5
	syscall
	#store the result in $s0
	move $s0, $v0                      # s0 = height
	blt $0, $s0, main
	
	li $v0, 4
	la $a0, invalid
	syscall
	li $v0, 4
        la $a0, newline
        syscall
	j greater_than_zero
	
	end_greater_than_zero:
	
    main:
    addi $s1, $0, 0                         # s1 = the nth row
    addi $s2, $0, 1                         # s2 = number printing on screen
    loop1: NOP                              # loop1 print rows
        addi $s1, $s1, 1                   
        blt $s0, $s1, end_loop1           
        sub $t4, $s0, $s1

       loop2: NOP                           # loop2 print tabs
           beq $t4, $0, end_loop2
           li $v0, 11
           la $a0, 9
           syscall
           sub $t4, $t4, 1
           j loop2
           NOP
       end_loop2:       
    
       li $v0, 1                            # print number
       la $a0, ($s2)
       syscall
       addi $s2, $s2, 1
   
       if: 
           beq $s0, 1, end_if
           mul $t5, $s1, 2
           sub $t5, $t5, 3
           beq $t5, -1, end_if
           
           loop3: NOP                       # loop3 printing tanbs and stars bewteen numbers
               beq $t5, $0, end_loop3
               li $v0, 11
               la $a0, 9
               syscall
               li $v0, 11
               la $a0, 42
               syscall
               sub $t5, $t5, 1
               j loop3
               NOP
           end_loop3:
    
       li $v0, 11
       la $a0, 9
       syscall
       li $v0, 1                            # print number 
       la $a0, ($s2)
       syscall
       addi $s2, $s2, 1
       end_if:
       
       li $v0, 4
       la $a0, newline
       syscall
       j loop1
       NOP
    end_loop1:
    
end_main:
li $v0, 10
syscall
