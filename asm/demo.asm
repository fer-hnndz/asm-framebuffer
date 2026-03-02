.global main

.text

main:
    ; Start game Engine
    li $v0, 100
    syscall
    

    ; Reserve space for position x, y, player color and $ra (16 bytes)

    addi $sp, $sp, -16

    li $t0, 0xFFFF0000

    sw $t0, 0($sp) ; save color here to make it accesible to draw_rectangle function
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $ra, 12($sp)

    
    li $s0, 12 ; $s0 -> x
    li $s1, 9 ; $s1 -> y

    input_loop:
        #show $v0 decimal

        li $v0, 104
        syscall
        
        li $t0, 5
        beq $v0, $t0, end

        li $t0, 0
        beq $t0, $v0, input_loop

        li $t0, 1 
        beq $v0, $t0, up

        li $t0, 2
        beq $v0, $t0, down

        li $t0, 3
        beq $v0, $t0, left
        
        li $t0, 4
        beq $v0, $t0, right

        update: 
        ; Clear screen to white
        li $v0, 103
        li $a0, 0xFFFFFFFF
        syscall

        ; Draw player
        ; draw_rectangle(x, y, w, h, color)
        move $a0, $s0
        move $a1, $s1
        li $a2, 4
        li $a3, 4
        ; Color is read from 0($sp)

        jal draw_rectangle
        j input_loop
    
    up:
        beq $s1, $zero, input_loop
        addi $s1, $s1, -1
        j update

    down:
        li $t0, 124 ; 128 - 4 = 124 to draw complete rect on screen and avoid clipping
        beq $t0, $s1, input_loop

        addi $s1, $s1, 1
        j update

    left:
        slt $t0, $zero, $s0 ;0 < x
        beqz $t0, input_loop

        addi $s0, $s0, -1
        j update

    
    right:
        li $t0, 252 ; same as down check.
        beq $t0, $s0, input_loop

        addi $s0, $s0, 1
        j update


    end: 
        li $v0, 105
        syscall

        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $ra, 12($sp)

        addi $sp, $sp, 16 ; balance stack

        jr $ra