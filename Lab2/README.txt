Wendi Tan
wtan37
Fall 2020
Lab2: Simple Data Path

 ----------------------------------------------------------------
Description: simple data path implementation by using register file, ALU, and 
  user inputs. 

 --------------

- Register 0/1/2/3 value: Using D flip-flop to transfer four keypad's values
  (inputs) to sixteen register senders(output) in total and then to register 
  receivers.

- Read Register 1/2 Address: Using 2:4 muxes,and sending register receivers' values
  to input 1/2 senders. Four different registers' values are controlled by 
  read register 1/2 address' switches.

- Write Register Address: Using demux to control one of four registers that is 
  about to receive the value from the keypad.   

- ALU Output: Showing four possible situations(unchange, shift leftward by
  one, shift leftward by two, and shift leftward by three) and transfer the
  values. Once the ALU input 1(how many times to shift the value from ALU
  input 2) is bigger than three, the ALU output will always be zero.

 ----------------------------------------------------------------
Files:

- Lab2.lgi
  
This file contains all the circuits surporting the correct results received by
the control panel. Thhis file need to be opened with software MultiMedia Logic.

 ----------------------------------------------------------------
Instructions:

From the user interface, the user will select the data source (source select)
 and the addresses of the read and write registers.
