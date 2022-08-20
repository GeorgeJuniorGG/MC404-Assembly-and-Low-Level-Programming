.globl _start
.text
.align 4

int_handler:
    ###### Tratador de interrupções e syscalls ######
    # <= Implemente o tratamento da sua syscall aqui =>

    # Identificando a syscall
    li t0, 10
    beq a7, t0, setMotor
    li t0, 11
    beq a7, t0, setHandBreak
    li t0, 12
    beq a7, t0, readSensors
    li t0, 13
    beq a7, t0, readSensorDistance
    li t0, 14
    beq a7, t0, getTime
    li t0, 15
    beq a7, t0, getPosition
    li t0, 16
    beq a7, t0, getRotation

setMotor:
  # a0 = vertical, a1 = horizontal
  li t0, 0xFFFF0121
  li t1, 0xFFFF0120
  sb a0, 0(t0)
  sb a1, 0(t1)

  j finalizar

setHandBreak:
  # a0 = byte
  li t0, 0xFFFF0122
  sb a0, 0(t0)

  j finalizar

readSensors:
  # a0 = endereco vetor 256 elementos
  li t0, 1
  li t1, 0xFFFF0101
  sb t0, 0(t1)
loop_5:              # Espera ocupada
  lb t0, 0(t1)
  bnez t0, loop_5
  li t1, 0xFFFF0124
  li a1, 0           # contador
loop_6:
  lbu t0, 0(t1)
  sb t0, 0(a0)
  addi t1, t1, 1
  addi a0, a0, 1
  addi a1, a1, 1
  li t0, 256
  bne t0, a1, loop_6

  j finalizar

readSensorDistance:
  # Nada
  li t0, 1
  li t1, 0xFFFF0102
  sb t0, 0(t1)
loop_4:              # Espera ocupada
  lb t0, 0(t1)
  bnez t0, loop_4
  li t0, 0xFFFF011C
  lw a0, 0(t0)       # Guarda a distancia em a0

  j finalizar

getTime:
  # Nada
  li t0, 1
  li t1, 0xFFFF0300
  sb t0, 0(t1)
loop_3:             # Espera ocupada
  lb t0, 0(t1)
  bnez t0, loop_3
  li t0, 0xFFFF0304
  lw a0, 0(t0)      # Guarda o tempo em a0

  j finalizar

getPosition:
  # a0 = &x, a1 = &y, a2 = &z
  li t0, 1
  li t1, 0xFFFF0100
  sb t0, 0(t1)
loop_1:             # Espera ocupada
  lb t0, 0(t1)
  bnez t0, loop_1
  li t0, 0xFFFF0110
  lw t1, 0(t0)
  sw t1, 0(a0)      # Guarda x
  li t0, 0xFFFF0114
  lw t1, 0(t0)
  sw t1, 0(a1)      # Guarda y
  li t0, 0xFFFF0118
  lw t1, 0(t0)
  sw t1, 0(a2)      # Guarda z

  j finalizar

getRotation:
  # a0 = &x, a1 = &y, a2 = &z
  li t0, 1
  li t1, 0xFFFF0100
  sb t0, 0(t1)
loop_2:             # Espera ocupada
  lb t0, 0(t1)
  bnez t0, loop_2
  li t0, 0xFFFF0104
  lw t1, 0(t0)
  sw t1, 0(a0)      # Guarda x
  li t0, 0xFFFF0108
  lw t1, 0(t0)
  sw t1, 0(a1)      # Guarda y
  li t0, 0xFFFF010C
  lw t1, 0(t0)
  sw t1, 0(a2)      # Guarda z

  j finalizar

finalizar:
    csrr t0, mepc  # carrega endereço de retorno (endereço da instrução que invocou a syscall)
    addi t0, t0, 4 # soma 4 no endereço de retorno (para retornar após a ecall)
    csrw mepc, t0  # armazena endereço de retorno de volta no mepc
    mret           # Recuperar o restante do contexto (pc <- mepc)



_start:
    la t0, int_handler  # Carregar o endereço da rotina que tratará as syscalls
    csrw mtvec, t0      # no registrador MTVEC


    # Aqui você deve mudar para modo usuário, ajustar a pilha do usuário para 0x7fffffc e saltar para o código de usuário (user_code)
    # Modo Usuario
    csrr t1, mstatus    # atualiza mstatus.MPP
    li t2, ~0x1800      # mascara (bits 11 and 12)
    and t1, t1, t2      # com 00 (U-mode)
    csrw mstatus, t1

    # Ajusta Pilha
    li sp, 0x7fffffc
    la t0, pilha_sistema
    csrw mscratch, t0

    # Codigo de Usuario
    la t0, user_code    # carrega o endereco do codigo de usuario
    csrw mepc, t0       # copia o endereco para mepc
    mret                # PC <= MEPC; mode <= MPP;


  loop_infinito:
    j loop_infinito

.common pilha_sistema, 20, 2