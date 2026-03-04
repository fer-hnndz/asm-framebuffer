.global draw_rectangle
.global draw_horizontal_line

.text

; Args: $a0 = x_inicial | $a1 = y_inicial | $a2 = ancho (width) | $a3 = alto (height)
; 0($sp) = color

draw_rectangle:
    ; Recover color from 0($sp)
    
    lw $t0, 0($sp)

    addiu $sp, $sp, -32
    sw $ra, 28($sp)
    sw $s0, 24($sp) ; $s0 -> x
    sw $s1, 20($sp) ; $s1 -> y
    sw $s2, 16($sp) ; $s2 - > x_end
    sw $s3, 12($sp) ; s3 -> y_end 
    sw $s4, 8($sp)  ; $s4 -> color

    move $s0, $a0
    move $s1, $a1
    addu $s2, $a0, $a2 ; x_end = x0 + w
    addiu $s2, $s2, -1
    addu $s3, $a1, $a3 ; y_end = y + h
    move $s4, $t0

    ; Draw top and bottom lines

    move $a0, $s0
    move $a1, $s2
    move $a2, $s1
    move $a3, $s4

    jal draw_horizontal_line

    ; change y paramter
    move $a0, $s0
    move $a1, $s2
    move $a2, $s3
    move $a3, $s4

    jal draw_horizontal_line

    ; Draw vertical line

    move $t0, $s0
    move $t1, $s1 ; current y

    left_vert_line_loop:
        slt $t3, $t1, $s3 ; s3 = y_end
        beqz $t3, left_vert_line_loop_end

        ; use set pixel
        move $a0, $t0
        move $a1, $t1
        move $a2, $s4
        
        li $v0, 101
        syscall

        addi $t1, $t1, 1
        j left_vert_line_loop

    left_vert_line_loop_end:
        move $t0, $s2 ; right side x-pos
        move $t1, $s1 ; current y

    right_vert_line_loop:
        slt $t3, $t1, $s3 ; s3 = y_end
        beqz $t3, end_draw_rect

        ; use set pixel
        move $a0, $t0
        move $a1, $t1
        move $a2, $s4
        
        li $v0, 101
        syscall

        addi $t1, $t1, 1
        j right_vert_line_loop

end_draw_rect:
    lw $s4, 8($sp)
    lw $s3, 12($sp)
    lw $s2, 16($sp)
    lw $s1, 20($sp)
    lw $s0, 24($sp)
    lw $ra, 28($sp)
    addiu $sp, $sp, 32
    jr $ra

; draw_horizontal_line(x1, x2, y, color)
; args: $a0 = x1, $a1 = x2, $a2 = y, $a3 = color
draw_horizontal_line:
    move $t0, $a0 ; $t0 -> x actual
    move $t1, $a1 ; $t1 -> x final
    move $t2, $a2 ; $t2 -> y fijo
    move $t3, $a3 ; $t3 -> color fijo

line_loop:
    ; (x_actual <= x_final) = !(x_final < x_actual)
    slt $t4, $t1, $t0       
    bne $t4, $zero, end_line

    move $a0, $t0
    move $a1, $t2
    move $a2, $t3
    
    li $v0, 101
    syscall

    addiu $t0, $t0, 1
    j line_loop
        
end_line:
    jr $ra