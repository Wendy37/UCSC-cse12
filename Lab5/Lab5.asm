# Created by: Wendi Tan
# 	      wtan37
# 	      11 December 2020
# Assignment: Fall 2020 CSE12 Lab5 
# Description: This program will utilize function inside to perform some primitive graphics operations on a small simulated display. 
#	       These functions will clear the entire display to a color, display rectangular and diamond shapes 
#	       using a memory-mapped bitmap graphics display tool in MARS
# Note: This program is intended to be run from MARS IDE
#########################################################################


.data

# push(register){
#     $sp = $sp - 4
#     store register in $sp
# }
.macro push(%reg)
	subi $sp, $sp, 4
	sw %reg, 0($sp)
.end_macro 


# pop(register){
#     load register from $sp
#     $sp = $sp + 4
# }
.macro pop(%reg)
	lw %reg, 0($sp)
	addi $sp, $sp, 4	
.end_macro


# getCoordinates(input, x, y){
#     x = input shift logically to the right by 4
#     y = input shift logically to the left by 4 (so that the x coordinate will disappear)
#     y = y shift logically to the right by 4
# }
.macro getCoordinates(%input %x %y)
    srl %x, %input, 16          # X coordinate
    sll %y, %input, 16          # Y coordinate
    srl %y, %y, 16
.end_macro


# formatCoordinates(output, x, y){
#     x = x shift logically to the left by 4
#     output = x + y
# }
.macro formatCoordinates(%output %x %y)
    push(%x)
    sll %x, %x, 16
    li %output, 0
    or %output, %output, %y
    or %output, %output, %x
    pop(%x)
.end_macro 


# This is a function turning coordinate of pixel to array in memory
# coor_to_array(output, x, y){
#     x = x*4
#     y = y*4
#     output = y*128 + x
# }
.macro coor_to_array(%output %x %y)
    mul %x, %x, 4      
    mul %y, %y, 4      
    mul %output, %y, 128        # Y * row_size
    add %output, %output, %x    # get the location in array (Y * row_size)+X
.end_macro

.text
#------------------------------------------------------------------    
done: nop
	li $v0 10 
	syscall
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# clear_bitmap(x){  [x is the color]
#	space = 0x4000
#	counter = 0
#	address = 0xFFFF0000
#	loop{ 
#		stops when counter=space
#		place pixels in color x in address
#		address+=4
#		counter+=1
#	 }
# }
clear_bitmap: nop  
  push($ra)
  push($s0)
  push($s1)
  push($s2)   
  li $s0, 0x4000         
  add $s1, $0, $0	 
  li $s2, 0xFFFF0000
  place_pixels:
    beq $s1, $s0, end_place
    sw $a0, ($s2)
    addi $s2, $s2, 4
    addi $s1, $s1, 1
    b place_pixels 
  end_place:
  pop($s2)
  pop($s1)
  pop($s0)
  pop($ra)
jr $ra

#*****************************************************

# draw_pixel(coordinate, color){
#	originalAddress = 0xFFFF0000
#	getCoordinates(coordinate, x, y) 
#	coor_to_array(location, x, y)
#	location = location + originalAddress
#	draw pixel in color 'color'
#	}
draw_pixel: nop
  push($s0)
  push($s1)
  push($s2)
  push($s3)
  push($s4)
  li $s4, 0xFFFF0000
  getCoordinates($a0 $s0 $s1)
  coor_to_array($s2 $s0 $s1)
  add $s2, $s4, $s2 
  la $s3, ($s2)
  sw $a1, ($s3)        
  pop($s4)
  pop($s3)
  pop($s2)
  pop($s1)
  pop($s0)
	jr $ra
	
#*****************************************************

# get_pixel(coordinate, color){ [input:coordinate, output:color]
#	originalAddress = 0xFFFF0000
#	getCoordinates(coordinate, x, y) 
#	coor_to_array(location, x, y)
#	location = location + originalAddress
#	color = load word from address 'location'
# }
get_pixel: nop
  push($s0)
  push($s1)
  push($s2)
  push($s4)
  li $s4, 0xFFFF0000
  getCoordinates($a0 $s0 $s1) 
  coor_to_array($s2 $s0 $s1)
  add $s2, $s4, $s2
  lw $v0, ($s2)
  pop($s4)
  pop($s2)
  pop($s1)
  pop($s0)
	jr $ra

#*****************************************************

# draw_rect(coordinate_pixel, rect_width_height, color){
#	originalAddress = 0xFFFF0000
#	getCoordinates(coordinate_pixel, x, y)
#	getCoordinates(rect_width_height, width, height)
#	
#	coor_to_array(location, x, y)
#	location = location + originalAddress
#	height_counter = 0
#	loop1{
#		stop loop1 when height_counter = height
#		width_counter = 0
#		loop2{
#			stop loop2 when width_counter = width
#			load 'color' on 'location'
#			location+=4
#			width_counter+=1
#		 }
#		location = location - 4*width + 512  [start placing pixel from x coordinate on the next line]
#		height_counter+=1
#	 }
# }

draw_rect: nop
  push($s0)
  push($s1)
  push($s2)
  push($s4)
  li $s4, 0xFFFF0000
  getCoordinates($a0 $s0 $s1) # coordinate $s0=x, $s1=y
  getCoordinates($a1 $t7 $t8) # $t7 = width $t8=height
  mul $t9, $t8, 4 
  
  coor_to_array($s2 $s0 $s1)
  add $s2, $s4, $s2
  addi $t4, $0, 0             # counter for $s1 (height)
  loop1:
    beq $t4, $t8, end_loop1
    addi $t5, $0, 0           # counter for $s0 (width)
    loop2:
      beq $t5, $t7, end_loop2
      la $t6, ($s2)
      sw $a2, ($t6)
      addi $s2, $s2, 4
      addi $t5, $t5, 1
      j loop2
    end_loop2:
    sub $s2, $s2, $t9
    addi $s2, $s2, 512
    addi $t4, $t4, 1
    j loop1
  end_loop1: 
  pop($s4)
  pop($s2)
  pop($s1)
  pop($s0) 
jr $ra

#***************************************************

# Draw_diamond(height, base_point_x, base_point_y){
#	for (dy = 0; dy <= h; dy++){
#		y = base_point_y + dy
#	}
#		if dy <= h/2{
#			x_min = base_point_x - dy
#			x_max = base_point_x + dy
#		 }
#		else{
#			x_min = base_point_x - h + dy
#			x_max = base_point_x + h - dy
#		 }
#	 	for (x=x_min; x<=x_max; x++) {
#			draw_diamond_pixels(x, y)
#		}
# }
draw_diamond: nop
  push($s0)
  push($s1)
  push($s2)
  push($s4)
  li $s4, 0xFFFF0000
  getCoordinates($a0 $s0 $s1)  # s0=x, s1=y
  coor_to_array($s2 $s0 $s1)   
  add $s2, $s4, $s2
  div $s0, $s0, 4
  div $s1, $s1, 4
  addi $t3, $0, 0              # control
  div $t6, $a1, 2              # t6 = height/2 
  addi $t2, $a1, 1
  for:
    beq $t3, $t2, end_for
    la $t8, ($s2)
    sw $a2, ($t8)
    addi $t7, $0, 0             # if and else for loop counter
    addi $t4, $s2, 0            # x_min
    addi $t5, $s2, 0            # x_max
    sub $t0, $a1, $t3           # height - control
    if:
      slt $t1, $t6, $t3
      beq $t1, 1, else
      for_if:
        beq $t7, $t3, end_else
        sub $t4, $t4, 4
        la $t8, ($t4)
        sw $a2, ($t8)
        
        addi $t5, $t5, 4
        la $t9, ($t5)
        sw $a2, ($t9)
        addi $t7, $t7, 1
        j for_if
        
    else:
      beq $t7, $t0, end_else
      sub $t4, $t4, 4
      la $t8, ($t4)
      sw $a2, ($t8)
      
      addi $t5, $t5, 4
      la $t9, ($t5)
      sw $a2, ($t9)
      addi $t7, $t7, 1
      j else
    end_else:
    addi $s2, $s2, 512
    addi $t3, $t3, 1
    j for
  end_for:
  pop($s4)
  pop($s2)
  pop($s1)
  pop($s0)

	jr $ra
