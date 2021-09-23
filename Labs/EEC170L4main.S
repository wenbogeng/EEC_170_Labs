.data
  start:
    	  .asciiz "Sorted Roster:"
	arr:
        .asciiz "Bill"
        .space 11
        .asciiz "Art"
        .space 12
        .asciiz "Peter"
        .space 10
        .asciiz "Miller"
        .space 9
        .asciiz "Wells"
        .space 10
        .asciiz "Rahim"
        .space 10
        .asciiz "Thomas"
        .space 9
        .asciiz "Garcia"
        .space 9
        .asciiz "William"
        .space 8
        .asciiz "Janice"
        .space 9
        .asciiz "Emma"
        .space 11
        .asciiz "Susie"
        .space 10
        .asciiz "Katie"
        .space 10
        .asciiz "Gizelle"
        .space 8
        .asciiz "Marie"
        .space 10
        .asciiz "Powell"
        .space 9
        .asciiz "Marie"
        .space 10
        .asciiz "Hannah"
        .space 9
        .asciiz "Kristen"
        .space 8
        .asciiz "Jones"
        .space 10
.text
    .globl main
 printch: # Print a single character (ASCII loaded into a1)
          addi a0 zero 11   # Load environment code 11 into a0
          ecall             # Signal environment call
          jalr x0 x1 0      # Return
 printst: # Print a string (Location of char 0 loaded into a1)
          addi a0 zero 4    # Load environment code 4 into a0
          ecall             # Signal environment call
          jalr x0 x1 0      # Return
  strcmp: # Return 0 if str0 = str1 otherwise return difference
          lbu  t0 0(a0)     # Load byte of string a
          lbu  t1 0(a1)     # Load byte of string b
          beq  t0 zero EXL0 # If NULL is encountered branch
          beq  t1 zero EXL0 # If NULL is encountered branch
          bne  t0 t1 EXL0   # If bytes are equal branch
          addi a0 a0 1      # Else increment a
          addi a1 a1 1      #            and b
          jal  x0 strcmp    # Loop back
        EXL0:               # If any exit condition
          bne  t0 t1 EXT0   # If null, and equiv strings match
          addi a0 zero 0    #                      so return 0
          jalr x0, x1, 0    # Return
        EXT0:
          sub  a0 t0 t1     # Else return difference of last char
          jalr x0, x1, 0    # Return
   strcpy: # Copy string into other string location
          addi t0 a0 0      # Copy initial dest ptr val to temp
        WHL0:     
          lbu  t1 0(a1)     # Get byte from str source
          sb   t1 0(a0)     # Put it in str dest
          addi a1 a1 1      # Increment to next source byte
          addi a0 a0 1      # Increment to next dest byte
          beq  t1 zero EXT1 # Exit if null in source was reached
          jal  x0 WHL0      # Loop
        EXT1:
          addi a0 t0 0      # Move initial dest ptr to result
          jalr x0 x1 0      # Return
 sortstr: # Modified bubble sort array of strings
          addi sp sp -20    # Make space on the stack for temp str
          sw x1 16(sp)
          addi s0 a0 0      # Move argument0 to saved reg
          addi s1 a1 0      # Move argument1 to saved reg
          addi s2 sp 0      # Ptr to temp char arr to saved reg
          addi s3 zero 0    # Initialize j to zero
          addi s4 a1 -1     # Create n-1
        LOP0:
          bge  s3 s4 EXT3   # If outter loop is over exit
          addi s5 s3 1      # Initialize i to j + 1
        LOP1:
          bge  s5 s1 EXT4   # If inner loop is over exit to outter
          slli s6 s3 4      # Get  j*16
          slli s7 s5 4      # Get  i*16
          add  a0 s0 s6     # Get &arr[j] = (&arr[0])+16*j
          add  a1 s0 s7     # Get &arr[i] = (&arr[0])+16*i
          jal  x1 strcmp    # Determine if arr[i] > arr[j] 
          bge  zero a0 EXT5 # If strmp return is <= 0, no swap
          addi a0 s2 0      # Create temp as strcpy arg
          add  a1 s0 s6     # Create arr[j] as strcpy arg
          jal  x1 strcpy    # Copy arr[j] string into temp
          add  a0 s0 s6     # Create arr[j] as strcpy arg
          add  a1 s0 s7     # Create arr[i] as strcpy arg
          jal  x1 strcpy    # Copy arr[i] into arr[j]
          add  a0 s0 s7     # Create arr[i] as strcpy arg 
          addi a1 s2 0      # Create temp as strcpy arg
          jal  x1 strcpy    # Copy temp into arr[i]
        EXT5:  
          addi s5 s5 1      # Increment i
          jal  x0 LOP1      # Loop
        EXT4:  
          addi s3 s3 1      # Increment j
          jal  x0 LOP0      # Loop
        EXT3:
          lw x1 16(sp)      # Load return address from stack
          addi sp sp 20     # Pop items off stack
          jalr x0 x1 0      # Return
	  main:
    	    ####### Load all the names into the stack #######
          addi sp sp -324		# Make room on stack
          sw   ra 320(sp) 	# Save the return address
          addi t0 zero 0    # Initialize iterator
          addi t4 zero 304  # Place 320 into temp reg
          la   t1 arr		    # Load string array address
        LDST:
          blt  t4 t0 SRTS
          add  t2 sp t0		  # Make the string's first byte address
          lw   t3 0(t1)		  # Load 4 bytes of the string from static
          sw   t3 0(t2)	  	# Push 4 bytes of the string to stack
          lw   t3 4(t1)	  	# Load 4 bytes of the string from static
          sw   t3 4(t2)	  	# Push 4 bytes of the string to stack
          lw   t3 8(t1)	  	# Load 4 bytes of the string from static
          sw   t3 8(t2)	  	# Push 4 bytes of the string to stack
          lw   t3 12(t1)		# Load 4 bytes of the string from static
          sw   t3 12(t2)		# Push 4 bytes of the string to stack
          addi t0 t0 16		  # Get new stack pointer offset
          addi t1 t1 16		  # Increment the location on the stack
          jal  x0 LDST			# Loop back
        SRTS:
          ####### Call the string sort procedure ########
          addi a0 sp 0		  # Save pointer to string array 
          addi a1 zero 20	  # Create n argument for sortstr
          jal  x1 sortstr		# Jump to string sort
          addi s0 sp 0      # Copy stack pointer (pointing to sorted arr)
          la   a1 start     # Load start string address
          jal  x1 printst   # Print start string
          addi s1 zero 0    # Init print loop i
          addi s2 zero 20   # Make print loop constant
        PRNT:
          bge  s1 s2 EXIT   # If no more strings left, exit
          addi a1 zero 0x0A # Load new-line character into arg
          jal  x1 printch   # Print new-line character
          addi a1 s0 0      # Load ptr to string
          jal  x1 printst   # Print string
          addi s0 s0 16     # Increment to next string
          addi s1 s1 1      # Increment i
          jal  x0 PRNT      # Loop
        EXIT:
          ####### Load all the names into the stack #######
          lw   ra 320(sp) 	# Save the return address
          addi sp sp 324		# Make room on stack