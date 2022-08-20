.globl _start
.text
.align 4

int_handler:
    ###### Tratador de interrupções e syscalls ######
    # <= Implemente o tratamento da sua syscall aqui =>

    csrr t0, mepc  # carrega endereço de retorno (endereço da instrução que invocou a syscall)
    addi t0, t0, 4 # soma 4 no endereço de retorno (para retornar após a ecall)
    csrw mepc, t0  # armazena endereço de retorno de volta no mepc
    mret           # Recuperar o restante do contexto (pc <- mepc)



_start:
    la t0, int_handler  # Carregar o endereço da rotina que tratará as syscalls
    csrw mtvec, t0      # no registrador MTVEC


    # Aqui você deve mudar para modo usuário, ajustar a pilha do usuário para
    # 0x7fffffc e saltar para o código de usuário (user_code)


  loop_infinito:
    j loop_infinito
