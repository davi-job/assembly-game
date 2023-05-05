.data
    displayAddress: .word 0x10008000

.text
    lw $t0, displayAddress  # Load the base address for display

    li $t1, 0x00ffff  # Set the pixel color (cyan)
    li $t9, 0x00ff00  # Set the pixel color (green)

    # Calculate the starting memory address for the pixel at the center-left
    li $t2, 128  # Display height / 2
    li $t3, 256  # Display width in units
    mul $t2, $t2, $t3
    add $t0, $t0, $t2

    sw $t1, 0($t0)  # Draw the initial pixel

main_loop:
    # Check for keyboard input
    li $t4, 0xffff0000  # Keyboard status address
    li $t5, 0xffff0004  # Keyboard data address

    lw $t6, 0($t4)  # Load keyboard status
    beqz $t6, main_loop  # If no key pressed, continue the loop

    lw $t7, 0($t5)  # Load the pressed key

    # Move the pixel up if 'w' is pressed
    li $t8, 119  # ASCII value for 'w'
    beq $t7, $t8, move_up

    # Move the pixel down if 's' is pressed
    li $t8, 115  # ASCII value for 's'
    beq $t7, $t8, move_down

    # Draw green pixel to the right if 'd' is pressed
    li $t8, 100  # ASCII value for 'd'
    beq $t7, $t8, draw_green
    j main_loop

move_up:
    sw $zero, 0($t0)  # Clear the current pixel
    sub $t0, $t0, 64  # Move up by one unit
    sw $t1, 0($t0)  # Draw the pixel at the new position
    j main_loop

move_down:
    sw $zero, 0($t0)  # Clear the current pixel
    add $t0, $t0, 64  # Move down by one unit
    sw $t1, 0($t0)  # Draw the pixel at the new position
    j main_loop

draw_green:
    move $t1, $t0  # Store the current address (cyan pixel)
    add $t0, $t0, 4  # Move right by one unit
    sw $t9, 0($t0)  # Draw the green pixel
    move $t0, $t1  # Restore the address (cyan pixel)
    j main_loop

exit_program:
    li $v0, 10  # Terminate the program gracefully
    syscall
