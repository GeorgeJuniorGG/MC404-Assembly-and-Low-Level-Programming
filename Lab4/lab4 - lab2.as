.org 0x000
comeco:
    LOAD MQ, M(g)
    MUL M(0x110)
    LOAD MQ
    STOR M(y)
    DIV M(dois)
    LOAD MQ
    STOR M(k)
laco:
    LOAD M(contador)
    SUB M(um)
    STOR M(contador)
    LOAD M(y)
    DIV M(k)
    LOAD MQ
    ADD M(k)
    DIV M(dois)
    LOAD MQ
    STOR M(k)
    LOAD M(contador)
    JUMP+ M(0x004,0:19)
fim:
    LOAD M(k)
    JUMP M(0x400,0:19)
.org 0x060
g:
    .word 0000000010
um:
    .word 0000000001
dois:
    .word 0000000002
y:
    .skip 0x001
k:
    .skip 0x001
contador:
    .word 0000000009