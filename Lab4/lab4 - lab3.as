.org 0x000
comeco:
    LOAD M(0x3FD)
    SUB M(um)
    STOR M(n)
laco:
    LOAD M(i)
    ADD M(0x3FE)
    STA M(0x004,28:39)
    LOAD M(i)
    ADD M(0x3FF)
    STA M(0x005,28:39)
    LOAD M(0x3FF)
    STOR M(temp)
    LOAD MQ, M(0x3FE)
    MUL M(temp)
    LOAD MQ
    ADD M(soma)
    STOR M(soma)
    LOAD M(i)
    ADD M(um)
    STOR M(i)
    LOAD M(n)
    SUB M(i)
    JUMP+ M(laco)
fim:
    LOAD M(soma)
    JUMP M(0x400)
    
.org 0x0FB
i:
    .word 0000000000
temp:
    .skip 0x001
n:
    .skip 0x001
um:
    .word 0000000001
soma:
    .skip 0x001