  	.data
    	fib_resulta:
    		.asciiz "Fibonnacci of "
        fib_resultb:
        	.asciiz ": "
    .text
    .globl main
    fib:        addi sp, sp, -12        # Make room on stack
                sw   ra, 8(sp)          # Push Ra
                sw   a0, 4(sp)          # Push n
                sw   s0, 0(sp)          # Push old n-1 result
                addi t0, x0, 2          # Const 2
                bge  a0, t0, recall     # If n >= 2 call fib again
                blt  a0, zero, recall   # If n < 0 call fib again
                addi a1, a0, 0          # Return n if 0 < n < 2
                jal  x0, exit           # Exit
 recall:        addi a0, a0, -1         # Create n-1
                jal  ra, fib            # Call fib again
                addi s0, a1, 0          # Put n-1 result in saved reg
                lw   a0, 4(sp)          # Load last n
                addi a0, a0, -2         # Create n-2
                jal  ra, fib            # Call fib on n-2
                add  a1, a1, s0         # Sum n-1 and n-2
   exit:        lw   ra, 8(sp)          # Restore last Ra 
                lw   a0, 4(sp)          # Restore last n
                lw   s0, 0(sp)          # Restore n-1 result
                addi sp, sp, 12         # Pop restored items
                jalr zero, ra, 0        # Return
   main: 		addi a0 zero 10			# Make n = 20
   				jal  x1 fib				# Call fib
                ######
                ###### The rest just prints result and exits
                ######
                add   s1 a0 zero		# Save n (ecalls will overwrite)
                add   s2 a1 zero		# Save result (ecalls will overwrite)
                la    a1 fib_resulta	# Load the address of string
                addi  a0 zero 4			# Signal to ecall to print string
                ecall
                add   a1 s1 zero		# Move n into a1
                addi  a0 zero 1			# Signal ecall to print int
                ecall
                la    a1 fib_resultb	# Load the address of string
                addi  a0 zero 4			# Signal ecall to print string
                ecall
                add   a1 s2 zero		# Move result into a1
                addi  a0 zero 1			# Signal ecall to print int
                ecall
                addi  a0 zero 10		# Signal ecall exit
                ecall					