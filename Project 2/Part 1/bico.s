.globl set_motor
.globl set_handbreak
.globl read_sensors
.globl read_sensor_distance
.globl get_time
.globl get_position
.globl get_rotation

# Implemente aqui as funções da API_CAR.
# As funções devem checar os parametros e fazer as chamadas de sistema que serão
#   tratadas na camada SoCa

set_motor:
    # Checando os parametros

    # Vertical
    li t1, 0
    bltu a0, t1, erro_parametros_1
    li t1, 0xff
    beq a0, t1, continue
    li t1, 2
    bge a0, t1, erro_parametros_1

continue:
    # Horizontal
    li t1, 0
    bltu a1, t1, erro_parametros_1
    li t1, 0xff81
    bgeu a1, t1, erro_parametros_1

    # Fazendo as chamadas de sistema
    addi sp, sp, -16    # Aloca o quadro de pilha
    sw ra, 0(sp)        # Salva ra
    li a7, 10           # Código da syscall: 10 == set_motor
    ecall               # Invoca o sistema operacional
    lw ra, 0(sp)        # Restaura ra
    addi sp, sp, 16     # Desaloca o quadro de pilha

    li a0, 0            # Sucesso
    ret

erro_parametros_1:
    li a0, -1            # Parametros fora do intervalo
    ret

set_handbreak:
    # Checando os parametros
    li t1, 0
    blt a0, t1, erro_parametros_2
    li t1, 2
    bge a0, t1, erro_parametros_2

    # Fazendo as chamadas de sistema
    addi sp, sp, -16    # Aloca o quadro de pilha
    sw ra, 0(sp)        # Salva ra
    li a7, 11           # Código da syscall: 11 == set_handbreak
    ecall               # Invoca o sistema operacional
    lw ra, 0(sp)        # Restaura ra
    addi sp, sp, 16     # Desaloca o quadro de pilha

    li a0, 0            # Sucesso
    ret

erro_parametros_2:
    li a0, -1            # Parametros fora do intervalo
    ret

read_sensors:
    # Fazendo as chamadas de sistema
    addi sp, sp, -16    # Aloca o quadro de pilha
    sw ra, 0(sp)        # Salva ra
    li a7, 12           # Código da syscall: 12 == read_sensors
    ecall               # Invoca o sistema operacional
    lw ra, 0(sp)        # Restaura ra
    addi sp, sp, 16     # Desaloca o quadro de pilha

    ret

read_sensor_distance:
    # Fazendo as chamadas de sistema
    addi sp, sp, -16    # Aloca o quadro de pilha
    sw ra, 0(sp)        # Salva ra
    li a7, 13           # Código da syscall: 13 == read_sensor_distance
    ecall               # Invoca o sistema operacional
    lw ra, 0(sp)        # Restaura ra
    addi sp, sp, 16     # Desaloca o quadro de pilha

    ret

get_position:
    # Fazendo as chamadas de sistema
    addi sp, sp, -16    # Aloca o quadro de pilha
    sw ra, 0(sp)        # Salva ra
    li a7, 15           # Código da syscall: 15 == get_position
    ecall               # Invoca o sistema operacional
    lw ra, 0(sp)        # Restaura ra
    addi sp, sp, 16     # Desaloca o quadro de pilha

    ret

get_rotation:
    # Fazendo as chamadas de sistema
    addi sp, sp, -16    # Aloca o quadro de pilha
    sw ra, 0(sp)        # Salva ra
    li a7, 16           # Código da syscall: 16 == get_rotation
    ecall               # Invoca o sistema operacional
    lw ra, 0(sp)        # Restaura ra
    addi sp, sp, 16     # Desaloca o quadro de pilha

    ret

get_time:
    # Fazendo as chamadas de sistema
    addi sp, sp, -16    # Aloca o quadro de pilha
    sw ra, 0(sp)        # Salva ra
    li a7, 14           # Código da syscall: 14 == get_time
    ecall               # Invoca o sistema operacional
    lw ra, 0(sp)        # Restaura ra
    addi sp, sp, 16     # Desaloca o quadro de pilha

    ret
