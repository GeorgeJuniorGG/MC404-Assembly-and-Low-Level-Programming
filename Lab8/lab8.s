.text
    .align 1
    .globl _start

_start:
    # syscall a7 = mover carro
    li a7, 2100

    # anda reto
    li a0, 500      # 0.5s
    li a1, 1        # para frente
    li a2, 0        # reto
    ecall

    # vira esquerda
    li a0, 743      # 0.743s
    li a1, 1        # para frente
    li a2, -512     # para esquerda 45 graus
    ecall

    # continua reto
    li a0, 4500     # 4.5s
    li a1, 1        # para frente
    li a2, 0        # reto
    ecall

    # anda para tras para desacelerar
    li a0, 500      # 0.5s
    li a1, -1       # para tras
    li a2, 0        # reto
    ecall

    # encerra
    li a0, 0
    li a7, 93
    ecall