.text
  .align 1
  .globl _start

_start:  
  # Converte angulo inteiro para radianos e coloca em f0
  jal funcao_pegar_angulo
  # Utilizado para calcular a série
  jal funcao_calcula_serie
  # Transforma um PF para inteiro, onde a0 contem o sinal, a1 a parte inteira e a2 a parte fracionaria (truncada com 3 casas decimais)
  jal funcao_float_para_inteiro
  # Imprime o resultado de a0, a1 e a2 na tela
  jal funcao_imprime
  
  li a0, 0 # exit code
  li a7, 93 # syscall exit
  ecall
  
funcao_calcula_serie:
  addi sp, sp, -8
  sw ra, 0(sp)
  sw s0, 4(sp)
  addi s0, sp, 8
  
  # Neste ponto o registrador f0 contem o valor de angle em radianos
  # *********************************************
  # ** INSIRA AQUI SEU CÓDIGO PARA CÁLCULO DA SERIE **

  #f4 = angle
  li a1, 0
  fcvt.s.w f6, a1
  fadd.s f4, f0, f6 

  #f0 = 0
  li a1, 0
  fcvt.s.w f0, a1

  #f3 = 1 (guarda o valor do fatorial)
  li a1, 1
  fcvt.s.w f3, a1

  #f2 = 1 (guarda o numero n tal que f3 = n!)
  li a1, 1
  fcvt.s.w f2, a1

  #f1 = 1 (guarda o "sinal" do valor)
  li a1, 1
  fcvt.s.w f1, a1

  #f5 = angle (guarda a parte referente a x**(2n+1))
  fmul.s f5, f4, f1

  #t1 = 10 (guarda o contador de iteracoes)
  li t1, 10

  #f7 = -1
  li a1, -1
  fcvt.s.w f7, a1

  #f8 = 1
  li a1, 1
  fcvt.s.w f8, a1

  #f0 = iteracao inicial
  fdiv.s f0, f1, f3
  fmul.s f0, f0, f5

laco_serie:
  beqz t1, fim_laco

  # f1 * -1
  fmul.s f1, f1, f7

  #f2++, f3 * f2 -> f3 (2 vezes)
  fadd.s f2, f2, f8
  fmul.s f3, f3, f2

  fadd.s f2, f2, f8
  fmul.s f3, f3, f2

  #f5 * angle * angle
  fmul.s f5, f5, f4
  fmul.s f5, f5, f4

  #f1/f3 * f5 -> f9, f9 + f0 -> f0
  fdiv.s f9, f1, f3
  fmul.s f9, f9, f5
  fadd.s f0, f0, f9

  #t1 = t1 - 1 (decrementa o contador)
  addi t1, t1, -1

  j laco_serie

fim_laco:

  # *********************************************
  
  lw ra, 0(sp)
  lw s0, 4(sp)
  addi sp, sp, 8
  jr ra


funcao_imprime:
  addi sp, sp, -8
  sw ra, 0(sp)
  sw s0, 4(sp)
  addi s0, sp, 8
  
  # Neste ponto os registradores contem:
  #   a0 -> valor 0 se f0 for negativo e !=0 caso contratio
  #   a1 -> Parte inteira de f0
  #   a2 -> Parte fracionaria de f0 (truncada com 3 casas decimais, i.e. 0 a 999)
  # **************************************
  # ** INSIRA AQUI SEU CÓDIGO PARA IMPRESSÃO **

  #verifica sinal
  la a3, string

  beqz a0, caso_positivo
  li a4, 45
  j continua_sinal

caso_positivo:
  li a4, 43
  j continua_sinal

continua_sinal:
  sw a4, 6(a3)

  #imprime a parte inteira, seguida de .
  addi a4, a1, 48
  sw a4, 7(a3)
  li a4, 46
  sw a4, 8(a3)

  #imprime a parte fracionaria, seguida de \n
  li a4, 10
  blt a2, a4, um_digito
  li a4, 100
  blt a2, a4, dois_digitos
  j tres_digitos

um_digito:
  li a5, 48
  li a6, 48
  addi a7, a2, 48
  j continua_fracionaria
  
dois_digitos:
  li a5, 48
  li t1, 10
  div a6, a2, t1
  addi a6, a6, 48
  rem a7, a2, t1
  addi a7, a7, 48
  j continua_fracionaria

tres_digitos:
  li t1, 100
  div a5, a2, t1
  addi a5, a5, 48
  rem t2, a2, t1
  li t1, 10
  div a6, t2, t1
  addi a6, a6, 48
  rem a7, t2, t1
  addi a7, a7, 48
  j continua_fracionaria

continua_fracionaria:
  sw a5, 9(a3)
  sw a6, 10(a3)
  sw a7, 11(a3)
  li t1, 10
  sw t1, 12(a3)

faz_print:
    li a0, 1 # file descriptor = 1 (stdout)
    la a1, string #  buffer
    li a2, 13 # size
    li a7, 64 # syscall write (64)
    ecall

    li a0, 0 # exit code
    li a7, 93 # syscall exit
    ecall

  # **************************************
  
  lw ra, 0(sp)
  lw s0, 4(sp)
  addi sp, sp, 8
  jr ra

  
funcao_pegar_angulo:
  addi sp, sp, -8
  sw ra, 0(sp)
  sw s0, 4(sp)
  addi s0, sp, 8
  
  # load angle value to a0
  lw a0, angle
  # convert angle to float and put in f0
  fcvt.s.w f0, a0
  # load pi address to a0
  la a0, .float_pi
  # load float_pi value (from a0 address) into f1
  flw f1, 0(a0)
  # load value 180 into a0
  li a0, 180
  # convert 180 to float and put in f2
  fcvt.s.w f2, a0

  # f0 -> angle, f1 -> pi, f2 -> 180
  # Now, put angle in radians (angle*pi/180)
  # f0 = angle * pi
  fmul.s f0, f0, f1
  # f0 = f0 / 180
  fdiv.s f0, f0, f2
  
  lw ra, 0(sp)
  lw s0, 4(sp)
  addi sp, sp, 8
  jr ra
  
funcao_float_para_inteiro:
  addi sp, sp, -8
  sw ra, 0(sp)
  sw s0, 4(sp)
  addi s0, sp, 8
  
  # Get signal
  li a0, 0
  fcvt.s.w f1, a0
  flt.s a0, f0, f1
  
  # Drop float signal
  fabs.s f0, f0
  
  # Truncate integer part
  fcvt.s.w f1, a0
  fadd.s f1, f1, f0
  jal funcao_truncar_float
  fcvt.w.s a1, f0
  
  # Truncate float part with 3 decimal places
  fsub.s f1, f1, f0
  li a3, 1000
  fcvt.s.w f2, a3
  fmul.s f0, f1, f2
  jal funcao_truncar_float
  fcvt.w.s a2, f0
  li a3, 1000
  rem a2, a2, a3
  
  lw ra, 0(sp)
  lw s0, 4(sp)
  addi sp, sp, 8
  jr ra
  
funcao_truncar_float:
  addi sp, sp, -8
  sw ra, 0(sp)
  sw s0, 4(sp)
  addi s0, sp, 8
  
  fmv.x.w a5, f0
  li a3, 22
  srai a4, a5,0x17
  andi a4, a4, 255
  addi a4, a4, -127
  addi a2, a5, 0
  blt a3, a4, .funcao_truncar_float_continue
  lui a5, 0x80000
  and a5, a5, a2
  bltz a4, .funcao_truncar_float_continue
  lui a5, 0x800
  addi a5, a5, -1
  sra a5, a5, a4
  not a5, a5
  and a5, a5, a2
.funcao_truncar_float_continue:
  fmv.w.x f0, a5
  
  lw ra, 0(sp)
  lw s0, 4(sp)
  addi sp, sp, 8
  jr ra
  
  
# Additional data variables
.align  4
.data
  angle:
    .word 45
  .float_pi:
    .word 0x40490fdb
  string: .asciz "SENO: +0.000\n" 

