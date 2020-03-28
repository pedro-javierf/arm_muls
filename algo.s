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

//1. Non-signed multiplication of mantissas
@get mantissa of A
mov r4, r0, lsl 9
lsr r4, 9

@get mantissa of B
mov r5, r1, lsl 9
lsr r5, 9

@multiply
@normalize before multiplication (add the left 1). The mantissa is now 24 bits
@0x00800000 is the equivalent of bit 24 set.
orr r4, 0x‭00800000‬
orr r5, 0x‭00800000‬

@the result is indeed 48 bits
UMULL r6,r7,r4,r5 

//2. Normalization of the result

//3. Addition of exponents

//4. Sign computation

mov r0, x
b end

zeroReturn:
mov r0, #0


end:  @epilogue
