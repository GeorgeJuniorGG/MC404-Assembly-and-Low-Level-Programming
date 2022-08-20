#include "montador.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


/*
    ---- Voce deve implementar essa função para a Parte 2! ----
    Utilize os tokens da estrutura de tokens para montar seu código!
    Retorna:
        *  1 caso haja erro na montagem; (imprima o erro em stderr)
        *  0 caso não haja erro.
 */
int emitirMapaDeMemoria()
{
    int numeroDeRotulos = 0;
    int numeroDeSimbolos = 0;
    int posicao = 0;
    int esquerda = 1;
    int posicaoRotulos = 0;
    int posicaoSimbolos = 0;
    Token* aux;

    //Contando o numero de rotulos e de simbolos derivados de .set
    for (int i = 0; i < getNumberOfTokens(); i++) {
        aux = recuperaToken(i);
        if (aux->tipo == DefRotulo) {
            numeroDeRotulos ++;
        }
        else if (aux->tipo == Diretiva && !strcmp(aux->palavra, ".set")) {
            numeroDeSimbolos ++;
        }
    }

    //Montando a tabela de pares <rotulo, endereco>
    char** rotulos = malloc(numeroDeRotulos * sizeof(char*));
    int enderecos[numeroDeRotulos];
    int posicoes[numeroDeRotulos];
    char** simbolos = malloc(numeroDeSimbolos * sizeof(char*));
    int significados[numeroDeSimbolos];

    for (int i = 0; i < getNumberOfTokens(); i++) {
        aux = recuperaToken(i);

        if (aux->tipo == DefRotulo) {
            rotulos[posicaoRotulos] = aux->palavra;
            enderecos[posicaoRotulos] = posicao;
            posicoes[posicaoRotulos] = esquerda;
            posicaoRotulos ++;
        }

        else if (aux->tipo == Nome) {
            int valido = 0;
            for (int j = 0; j < numeroDeRotulos; j++) {
                if(rotulos[j] != NULL) {
                    if(!strncmp(recuperaToken(i)->palavra, rotulos[j], strlen(rotulos[j]) - 1)) {
                        valido = 1;
                    }
                }
            }
            for(int j = 0; j < numeroDeSimbolos; j++) {
                if(simbolos[j] != NULL) {
                    if(!strcmp(recuperaToken(i)->palavra, simbolos[j])) {
                        valido = 1;
                    }
                }
            }
            if(!valido) {
                printf("ERRO: Rótulo ou símbolo usado mas não definido: %s\n", recuperaToken(i)->palavra);
                return 1;
            }
        }

        else if (aux->tipo == Instrucao) {
            if(esquerda) {
                esquerda = 0;
            }
            else {
                posicao ++;
                esquerda = 1;
            }
        }
        
        else if (aux->tipo == Diretiva) {
            int numero;
            if(strcmp(aux->palavra, ".set")) {
                if(recuperaToken(i + 1)->tipo == Hexadecimal) {
                    numero = strtol(recuperaToken(i + 1)->palavra, NULL, 0);
                }
                else if (recuperaToken(i + 1)->tipo == Decimal) {
                    numero = (int)atoi(recuperaToken(i + 1)->palavra);
                }
                else if (recuperaToken(i + 1)->tipo == Nome) {
                    int achou = 0;
                    for (int j = 0; j < numeroDeSimbolos; j++) {
                        if(simbolos[j] != NULL) {
                            if(!strcmp(recuperaToken(i + 1)->palavra, simbolos[j])) {
                                achou = 1;
                                numero = significados[j];
                            }
                        }
                    }
                    for (int j = 0; j < numeroDeRotulos; j++) {
                        if(rotulos[j] != NULL) {
                            if (!strncmp(recuperaToken(i + 1)->palavra, rotulos[j], strlen(rotulos[j]) - 1)) {
                                achou = 1;
                                numero = enderecos[j];
                            }
                        }
                    }
                    if(!achou) {
                        printf("ERRO: Rótulo ou símbolo usado mas não definido: %s\n", recuperaToken(i + 1)->palavra);
                        return 1;
                    }
                }
            }

            if(!strcmp(aux->palavra, ".align")) {
                esquerda = 1;
                posicao ++;
                while(posicao % numero != 0) {
                    posicao ++;
                }
            }

            else if(!strcmp(aux->palavra, ".wfill")) {
                posicao = posicao + numero;
            }

            else if(!strcmp(aux->palavra, ".skip")) {
                posicao = posicao + numero;
            }

            else if(!strcmp(aux->palavra, ".org")) {
                posicao = numero;
            }

            else if(!strcmp(aux->palavra, ".word")) {
                posicao ++;
            }
            
            else if(!strcmp(aux->palavra, ".set")) {
                simbolos[posicaoSimbolos] = recuperaToken(i + 1)->palavra;
                significados[posicaoSimbolos] = atoi(recuperaToken(i + 2)->palavra);
                posicaoSimbolos++;
            }
        }

        else {
            continue;
        }
    }

    //Resetando o vetor de simbolos e o vetor de significados, para saber se ele foi declarado antes ou nao
    for(int i = 0; i < numeroDeSimbolos; i++) {
        simbolos[i] = NULL;
        significados[i] = -1;
    }
    posicaoSimbolos = 0;

    //Emitindo o mapa de memoria
    posicao = 0;
    esquerda = 1;

    for (int i = 0; i < getNumberOfTokens(); i++) {

        aux = recuperaToken(i);

        if (aux->tipo == Instrucao) {
            char* instruction = recuperaToken(i)->palavra;
            int instrucao = -1;
            int complemento = -1;

            //Casos de instrucao
            if(!strcmp(instruction, "ldmq")) {
                instrucao = 10;
                complemento = 0;
            }
            else if(!strcmp(instruction, "lsh")) {
                instrucao = 20;
                complemento = 0;
            }
            else if(!strcmp(instruction, "rsh")) {
                instrucao = 21;
                complemento = 0;
            }
            else {
                int endereco;
                int pos = -1;
                if(recuperaToken(i + 1)->tipo == Hexadecimal) {
                    endereco = strtol(recuperaToken(i + 1)->palavra, NULL, 0);
                }
                else if (recuperaToken(i + 1)->tipo == Decimal) {
                    endereco = (int)atoi(recuperaToken(i + 1)->palavra);
                }
                else if (recuperaToken(i + 1)->tipo == Nome) {
                    int achou = 0;
                    for (int j = 0; j < numeroDeSimbolos; j++) {
                        if(simbolos[j] != NULL) {
                            if(!strcmp(recuperaToken(i + 1)->palavra, simbolos[j])) {
                                achou = 1;
                                endereco = significados[j];
                            }
                        }
                    }
                    for (int j = 0; j < numeroDeRotulos; j++) {
                        if(rotulos[j] != NULL) {
                            if (!strncmp(recuperaToken(i + 1)->palavra, rotulos[j], strlen(rotulos[j]) - 1)) {
                                achou = 1;
                                endereco = enderecos[j];
                                pos = posicoes[j];
                            }
                        }
                    }
                    if(!achou) {
                        printf("ERRO: Rótulo ou símbolo usado mas não definido: %s\n", recuperaToken(i + 1)->palavra);
                        return 1;
                    }
                }   
                if(!strcmp(instruction, "ld")) {
                    instrucao = 1;
                }
                else if(!strcmp(instruction, "ldinv")) {
                    instrucao = 2;
                }
                else if(!strcmp(instruction, "ldabs")) {
                    instrucao = 3;
                }
                else if(!strcmp(instruction, "ldmqmx")) {
                    instrucao = 9;
                }
                else if(!strcmp(instruction, "store")) {
                    instrucao = 33;
                }
                else if(!strcmp(instruction, "jump")) {
                    if(pos == 0) { //direita
                        instrucao = 14;
                    }
                    else {
                        instrucao = 13;
                    }
                }
                else if(!strcmp(instruction, "jge")) {
                    if(pos == 0) {
                        instrucao = 16;
                    }
                    else {
                        instrucao = 15;
                    }
                }
                else if(!strcmp(instruction, "add")) {
                    instrucao = 5;
                }
                else if(!strcmp(instruction, "addabs")) {
                    instrucao = 7;
                }
                else if(!strcmp(instruction, "sub")) {
                    instrucao = 6;
                }
                else if(!strcmp(instruction, "subabs")) {
                    instrucao = 8;
                }
                else if(!strcmp(instruction, "mult")) {
                    instrucao = 11;
                }
                else if(!strcmp(instruction, "div")) {
                    instrucao = 12;
                }
                else if(!strcmp(instruction, "storend")) {
                    if(pos == 0) {
                        instrucao = 19;
                    }
                    else {
                        instrucao = 18;
                    }
                }
                complemento = endereco;
            }

            //imprimir mapa
            if(esquerda) {
                printf("%.3X %.2X %.3X ", posicao, instrucao, complemento);
                esquerda = 0;
            }
            else {
                printf("%.2X %.3X\n", instrucao, complemento);
                posicao ++;
                esquerda = 1;
            }
        }
        
        else if (aux->tipo == Diretiva) {
            int numero;
            if(strcmp(aux->palavra, ".set")) {
                if(recuperaToken(i + 1)->tipo == Hexadecimal) {
                    numero = strtol(recuperaToken(i + 1)->palavra, NULL, 0);
                }
                else if (recuperaToken(i + 1)->tipo == Decimal) {
                    numero = (int)atoi(recuperaToken(i + 1)->palavra);
                }
                else if (recuperaToken(i + 1)->tipo == Nome) {
                    int achou = 0;
                    for (int j = 0; j < numeroDeSimbolos; j++) {
                        if(simbolos[j] != NULL) {
                            if(!strcmp(recuperaToken(i + 1)->palavra, simbolos[j])) {
                                achou = 1;
                                numero = significados[j];
                            }
                        }
                    }
                    for (int j = 0; j < numeroDeRotulos; j++) {
                        if(rotulos[j] != NULL) {
                            if (!strncmp(recuperaToken(i + 1)->palavra, rotulos[j], strlen(rotulos[j]) - 1)) {
                                achou = 1;
                                numero = enderecos[j];
                            }
                        }
                    }
                    if(!achou) {
                        printf("ERRO: Rótulo ou símbolo usado mas não definido: %s\n", recuperaToken(i + 1)->palavra);
                        return 1;
                    }
                }
            }

            if(!strcmp(aux->palavra, ".align")) {
                if(!esquerda) {
                    printf("00 000\n");
                }
                esquerda = 1;
                posicao ++;
                while(posicao % numero != 0) {
                    posicao ++;
                }
            }

            else if(!strcmp(aux->palavra, ".wfill")) {
                int segundoNumero = -1;
                if(recuperaToken(i + 2)->tipo == Hexadecimal) {
                    segundoNumero = strtol(recuperaToken(i + 2)->palavra, NULL, 0);
                }
                else if (recuperaToken(i + 2)->tipo == Decimal) {
                    segundoNumero = (int)atoi(recuperaToken(i + 2)->palavra);
                }
                else if (recuperaToken(i + 2)->tipo == Nome) {
                    int achou = 0;
                    for (int j = 0; j < numeroDeSimbolos; j++) {
                        if(simbolos[j] != NULL) {
                            if(!strcmp(recuperaToken(i + 2)->palavra, simbolos[j])) {
                                achou = 1;
                                segundoNumero = significados[j];
                            }
                        }
                    }
                    for (int j = 0; j < numeroDeRotulos; j++) {
                        if(rotulos[j] != NULL) {
                            if (!strncmp(recuperaToken(i + 2)->palavra, rotulos[j], strlen(rotulos[j]) - 1)) {
                                achou = 1;
                                segundoNumero = enderecos[j];
                            }
                        }
                    }
                    if(!achou) {
                        printf("ERRO: Rótulo ou símbolo usado mas não definido: %s\n", recuperaToken(i + 2)->palavra);
                        return 1;
                    }
                }
                for (int j = 0; j < numero; j++) {
                    char number[11];
                    sprintf(number, "%010X", segundoNumero);
                    printf("%.3X %c%c %c%c%c %c%c %c%c%c\n", posicao, number[0], number[1], number[2], number[3], number[4], number[5], number[6], number[7], number[8], number[9]);
                    posicao ++;
                }
            }

            else if(!strcmp(aux->palavra, ".skip")) {
                posicao = posicao + numero;
            }

            else if(!strcmp(aux->palavra, ".org")) {
                posicao = numero;
            }

            else if(!strcmp(aux->palavra, ".word")) {
                char number[11];
                sprintf(number, "%010X", numero);
                printf("%.3X %c%c %c%c%c %c%c %c%c%c\n", posicao, number[0], number[1], number[2], number[3], number[4], number[5], number[6], number[7], number[8], number[9]);
                posicao ++;
            }
            
            else if(!strcmp(aux->palavra, ".set")) {
                simbolos[posicaoSimbolos] = recuperaToken(i + 1)->palavra;
                int significado = -1;
                if(recuperaToken(i + 2)->tipo == Hexadecimal) {
                    significado = strtol(recuperaToken(i + 2)->palavra, NULL, 0);
                }
                else if (recuperaToken(i + 2)->tipo == Decimal) {
                    significado = (int)atoi(recuperaToken(i + 2)->palavra);
                }
                else if (recuperaToken(i + 2)->tipo == Nome) {
                    int achou = 0;
                    for (int j = 0; j < numeroDeSimbolos; j++) {
                        if(simbolos[j] != NULL) {
                            if(!strcmp(recuperaToken(i + 2)->palavra, simbolos[j])) {
                                achou = 1;
                                significado = significados[j];
                            }
                        }
                    }
                    for (int j = 0; j < numeroDeRotulos; j++) {
                        if(rotulos[j] != NULL) {
                            if (!strncmp(recuperaToken(i + 2)->palavra, rotulos[j], strlen(rotulos[j]) - 1)) {
                                achou = 1;
                                significado = enderecos[j];
                            }
                        }
                    }
                    if(!achou) {
                        printf("ERRO: Rótulo ou símbolo usado mas não definido: %s\n", recuperaToken(i + 2)->palavra);
                        return 1;
                    }
                }
                significados[posicaoSimbolos] = significado;
                posicaoSimbolos ++;
            }
        }

        else {
            continue;
        }
    }
    if(!esquerda) {
        printf("00 000\n");
    }
    /* printf("Voce deve implementar essa função para a Parte 2!");*/
    free(simbolos);
    free(rotulos);
    return 0;
}