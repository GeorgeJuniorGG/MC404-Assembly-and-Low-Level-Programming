.text
    .align 1
    .globl _start
# Ler xi e ' '
_start:
    li t2, 0                # xi montado em t2

laco:
    li t1, 32
    j leitura_byte
volta:
    la a2, rotulo_input
    lbu t0, 0(a2) # t0 = byte
    beq t0, t1, fim_xi  # sai se byte eh espaco
    li t1, 10
    mul t2, t2, t1
    addi t0, t0, -48    # t0 = int(byte)
    add t2, t2, t0      # t2 = 10*t2 + int(byte)
    j laco


leitura_byte:
    li a0, 0            # 0 = stdin
    la a1, rotulo_input # endereco onde sera guardado o byte
    li a2, 1            # sera lido 1 byte
    li a7, 63           # syscall read (63)
    ecall
    j volta

fim_xi:
    la a2, xi 
    sb t2, 0(a2)

# Ler yi
li a0, 0            # 0 = stdin
la a1, rotulo_input # endereco onde sera guardado o byte
li a2, 1            # sera lido 1 byte
li a7, 63           # syscall read (63)
ecall

la a2, rotulo_input
lbu t0, 0(a2)
addi t0, t0, -48
la a2, yi
sb t0, 0(a2)

#Ignorar \n
li a0, 0            # 0 = stdin
la a1, rotulo_input # endereco onde sera guardado o byte
li a2, 1            # sera lido 1 byte
li a7, 63           # syscall read (63)
ecall

# Ignorar linha
li a0, 0            # 0 = stdin
la a1, rotulo_input # endereco onde sera guardado o byte
li a2, 1            # sera lido 1 byte
li a7, 63           # syscall read (63)
ecall
li a0, 0            # 0 = stdin
la a1, rotulo_input # endereco onde sera guardado o byte
li a2, 1            # sera lido 1 byte
li a7, 63           # syscall read (63)
ecall
li a0, 0            # 0 = stdin
la a1, rotulo_input # endereco onde sera guardado o byte
li a2, 1            # sera lido 1 byte
li a7, 63           # syscall read (63)
ecall

# Ler C e ' '
li t2, 0                # C montado em t2

laco_2:
    li t1, 32
    j leitura_byte_2
volta_2:
    la a2, rotulo_input
    lbu t0, 0(a2)       # t0 = byte
    beq t0, t1, fim_C   # sai se byte eh espaco
    li t1, 10
    mul t2, t2, t1
    addi t0, t0, -48    # t0 = int(byte)
    add t2, t2, t0      # t2 = 10*t2 + int(byte)
    j laco_2


leitura_byte_2:
    li a0, 0            # 0 = stdin
    la a1, rotulo_input # endereco onde sera guardado o byte
    li a2, 1            # sera lido 1 byte
    li a7, 63           # syscall read (63)
    ecall
    j volta_2

fim_C:
    la a2, C
    sb t2, 0(a2)

# Ler L
li t2, 0                # L montado em t2

laco_3:
    li t1, 10
    j leitura_byte_3
volta_3:
    la a2, rotulo_input 
    lbu t0, 0(a2)       # t0 = byte
    beq t0, t1, fim_L   # sai se byte eh \n
    li t1, 10
    mul t2, t2, t1
    addi t0, t0, -48    # t0 = int(byte)
    add t2, t2, t0      #t2 = 10*t2 + int(byte)
    j laco_3

leitura_byte_3:
    li a0, 0            # 0 = stdin
    la a1, rotulo_input # endereco onde sera guardado o byte
    li a2, 1            # sera lido 1 byte
    li a7, 63           # syscall read (63)
    ecall
    j volta_3

fim_L:
    la a2, L
    sb t2, 0(a2)

# Ler CMAX
li t2, 0                # CMAX montado em t2

laco_5:
    li t1, 10
    j leitura_byte_5
volta_5:
    la a2, rotulo_input 
    lbu t0, 0(a2)       # t0 = byte
    beq t0, t1, fim_CMAX   # sai se byte eh \n
    li t1, 10
    mul t2, t2, t1
    addi t0, t0, -48    # t0 = int(byte)
    add t2, t2, t0      #t2 = 10*t2 + int(byte)
    j laco_5

leitura_byte_5:
    li a0, 0            # 0 = stdin
    la a1, rotulo_input # endereco onde sera guardado o byte
    li a2, 1            # sera lido 1 byte
    li a7, 63           # syscall read (63)
    ecall
    j volta_5

fim_CMAX:
    la a2, CMAX
    sb t2, 0(a2)

# Ignora a proxima linha
li t1, 10
laco_ignora_linha:
    j leitura_byte_4
volta_4:
    la a2, rotulo_input
    lbu t0, 0(a2)       # t0 = byte
    beq t0, t1, fim_ign # sai se byte eh \n
    j laco_ignora_linha

leitura_byte_4:
    li a0, 0            # 0 = stdin
    la a1, rotulo_input # endereco onde sera guardado o byte
    li a2, 1            # sera lido 1 byte
    li a7, 63           # syscall read (63)
    ecall
    j volta_4

fim_ign:

# Ler linhas adicionais e imprimir posicoes
la a3, L
lbu a3, 0(a3)
addi a3, a3, -1          # vai ate que y = L-1
la a2, parada
sb a3, 0(a2)

laco_principal:
    li t2, 0                # registrador onde sera montado o valor do elemento da matriz
    la a4, linha            # registrador que guarda o endereco do proximo elemento na linha atual

ler_linha:
    j leitura_byte_linha
volta_linha:
    li t1, 10
    la a2, rotulo_input
    lbu t0, 0(a2)       # t0 = byte
    beq t0, t1, decidir # sai se byte eh \n
    li t1, 32
    beq t0, t1, ler_linha   # sai se byte eh espaco
    li t2, 0
    j mini_laco
mini_laco:
    li t1, 10
    mul t2, t2, t1
    addi t0, t0, -48    # t0 = int(byte)
    add t2, t2, t0      # t2 = 10*t2 + int(byte)
    j leitura_byte_linha_2
volta_mini:
    li t1, 32
    la a2, rotulo_input
    lbu t0, 0(a2)
    beq t0, t1, fim_elem    # sai se byte eh espaco
    li t1, 10
    beq t0, t1, fim_elem_2  # sai se byte eh \n
    j mini_laco

leitura_byte_linha:
    li a0, 0            # 0 = stdin
    la a1, rotulo_input # endereco onde sera guardado o byte
    li a2, 1            # sera lido 1 byte
    li a7, 63           # syscall read (63)
    ecall
    j volta_linha

leitura_byte_linha_2:
    li a0, 0            # 0 = stdin
    la a1, rotulo_input # endereco onde sera guardado o byte
    li a2, 1            # sera lido 1 byte
    li a7, 63           # syscall read (63)
    ecall
    j volta_mini

fim_elem:
    sb t2, 0(a4)
    addi a4, a4, 1
    j ler_linha

fim_elem_2:
    sb t2, 0(a4)
    addi a4, a4, 1
    j decidir

decidir:
    la a2, xi
    lbu a2, 0(a2)               # a2 = xi
    la a3, linha
    add a3, a3, a2              # a3 = &linha[xi]
    lbu a4, 0(a3)               # a4 = linha[xi]
    li t1, 0                    # t1 = distancia esquerda
    li t2, 0                    # t2 = distancia direita
    li t0, 100
    j distancia_esquerda
volta_decidir:
    li a6, 0
    beq t1, t2, incrementar     # esta no meio da pista
    bltu t2, t1, menos          # precisa ir para a esquerda
    addi a6, a6, 1              # vai para a direita
    j incrementar

distancia_esquerda:
    la a5, linha                
    add a5, a5, a2              # a5 = &linha[xi]
laco_esquerda:
    addi t1, t1, 1              # distancia esquerda ++
    addi a5, a5, -1
teste:
    lbu a7, 0(a5)
    bltu a7, t0, laco_esquerda
    j distancia_direita

distancia_direita:
    la a5, linha
    add a5, a5, a2              # a5 = &linha[xi]
laco_direita:
    addi t2, t2, 1              # distancia direita ++
    addi a5, a5, 1
    lbu a7, 0(a5)
    bltu a7, t0, laco_direita
    j volta_decidir

menos:
    addi a6, a6, -1
    j incrementar

incrementar:
    la a5, yi
    lbu a4, 0(a5)
    addi a4, a4, 1
    sb a4, 0(a5)        # y = y+1
    la a5, xi
    lbu a4, 0(a5)
    add a4, a4, a6
    sb a4, 0(a5)        # x = x+decidir

organiza_print:
    la a0, string
    la a1, xi
    lbu a1, 0(a1)
    li a4, 10
    bltu a1, a4, um_digito_x
    j dois_digitos_x
um_digito_x:
    li a2, 48
    addi a3, a1, 48
    j continua_x
dois_digitos_x:
    li t1, 10
    div a2, a1, t1
    addi a2, a2, 48
    rem a3, a1, t1
    addi a3, a3, 48
    j continua_x
continua_x:
    sb a2, 7(a0)
    sb a3, 8(a0)
    la a1, yi
    lbu a1, 0(a1)
    li a4, 10
    bltu a1, a4, um_digito_y
    li a4, 100
    bltu a1, a4, dois_digitos_y
    j tres_digitos_y
um_digito_y:
    li a2, 48
    li a3, 48
    addi a4, a1, 48
    j continua_y
dois_digitos_y:
    li a2, 48
    li t1, 10
    div a3, a1, t1
    addi a3, a3, 48
    rem a4, a1, t1
    addi a4, a4, 48
    j continua_y
tres_digitos_y:
    li t1, 10
    div a2, a1, t1
    addi a2, a2, 48
    rem t2, a1, t1
    div a3, t2, t1
    addi a3, a3, 48
    rem a4, t2, t1
    addi a4, a4, 48
    j continua_y
continua_y:
    sb a2, 11(a0)
    sb a3, 12(a0)
    sb a4, 13(a0)

faz_print:
    li a0, 1 # file descriptor = 1 (stdout)
    la a1, string #  buffer
    li a2, 15 # size
    li a7, 64 # syscall write (64)
    ecall

cond_parada:
    la a4, yi
    lbu a4, 0(a4)
    la a5, parada
    lbu a5, 0(a5)
    beq a4, a5, fim
    j laco_principal

fim:
    li a0, 0 # exit code
    li a7, 93 # syscall exit
    ecall


# Alocando variaveis
.common xi, 1, 2
.common yi, 1, 2
.common C, 1, 2
.common L, 1, 2
.common CMAX, 1, 2
.common rotulo_input, 1, 2
.common parada, 1, 2
.common linha, 64, 2

.data
    string: .asciz "POS: 0000 0000\n" # size = 15