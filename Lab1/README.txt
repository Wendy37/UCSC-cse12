Wendi Tan
wtan37
Fall 2020
Lab1: intro to logic simulation

 ----------------------------------------------------------------
Description:

By licking on 4 switches on page 1, and 2 switches on page 6, users can control six LED and one 7 segment LED. 

-

Part A: 

7 segment LED can display numbers and letters based on times the user pushing the top switch button on page 6.

-

Part B: 

By using sum of product, I got two functions 
('a' refers to in_3, 'b' refers to in_2, 'c' refers to in_1, 'd' refers to in_0):
  1. f(b_2) = a'b'c'd+a'b'cd'+a'bc'd+a'bcd'+ab'c'd+ab'cd'+abc'd+abcd'
  2. f(b_1) = a'b'c'd+a'b'cd+a'bc'd+a'bcd+ab'c'd+ab'cd+abc'd+abcd

These equations can be simplified by using logic minimization:
  1. f(b_2) = c'd+cd' = in_1'*in_0 + in_1*in_0'
  2. f(b_1) = c'd+cd  = in_1'*in_0 + in_1*in_0
Then I designed the circuit on page 4 based on equations above.
Since b_0 equals to 0 for all conditions, I connect it to ground.

-

Part C:

By using product of sum, I got the function
 ('a' refers to in_3, 'b' refers to in_2, 'c' refers to in_1, 'd' refers to in_0):

f(c_0) = b'd+bc'

After simplifying, the equation should be: 

f(c_0) = in_2'*in_0 + in_2*in_1'

And for the last two question of part C, the circuit is translated into NAND gate 
 and NOR gate to get outcomes c_1 and c_2 respectively.

 ----------------------------------------------------------------
FILES

- Lab1.lgi

This file contains circuits of Part A, B, and C, and need to be opened with software 'MultiMedia Logic.'

 ----------------------------------------------------------------
INSTRUCTIONS

Need to run the Lab.lgi file on MultiMedia Logic.

