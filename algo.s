//arm_muls: single point multiplication algorithm for ARM
//By: Pedro Javier Fernández


.global start
.extern _stack

.data
A: .word 0xC1180000 // -9.5
B: .word 0x‭BEC00000 // -0.375‬

.bss
RESULT:         .space 32			@ Single Point result (32 bits)

multiply: @prologue



//Check for any of the two operands to be zero
cmp r0, #0
beq zeroReturn

cmp r1, #0
beq zeroReturn

//Multiplication Algorithm



mov r0, x
b end

zeroReturn:
mov r0, #0


end:  @epilogue
