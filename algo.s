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
//    hi lo  A  B
UMULL r6,r7,r4,r5 

//2. Normalization of the result
@get the new mantissa
@Count leading zeros in first 32 bits of the register
clz r10,r6
@Shift that amount of zeros plus one
add r10,r10,#1
lsl r6,r10
@Final mantissa is the shifted part logical OR'ed with the low bits of the multiplication
orr r9, r6,r7


//3. Addition of exponents

@ Er = (Ea-127) + (Eb-127) + 127 = Ea + Eb – 127

@get exponent of A
mov r4, r0, lsr #23
and r4, r4, 0x000000FF @remove sign bit

@get exponent of B
mov r5, r0, lsr #23
and r5, r5, 0x000000FF @remove sign bit

@Ea + Eb – 127
add r10, r4, r5
sub r10, r10, 127

//4. Sign computation
mov r4, r0, lsr #31 @get bit of A
mov r5, r1, lsr #31 @get bit of B

eor r11, r4, r5

//5. Putting everything together

@mantissa in place
mov r0, r9 

@exponent in place
orr r0, r10, lsl 23

@sign bit in place
orr r0, r11, lsl 31

mov r0, x
b end

zeroReturn:
mov r0, #0


end:  @epilogue
