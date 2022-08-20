#include "montador.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/*
    ---- Você Deve implementar esta função para a parte 1.  ----
    Essa função é chamada pela main em main.c
    Entrada da função: arquivo de texto lido e seu tamanho
*/
int processarEntrada(char* entrada, unsigned tamanho)
{
    char atual;
    char prev;
    int comeco = 1;
    int linha = 1;
    int indice;
    int comentario = -1;
    char* palavra;
    int fimPalavra;
    char instrucoes[17][8] = {"ld", "ldinv", "ldabs", "ldmq", "ldmqmx", "store", "jump", "jge", "add", "addabs", "sub", "subabs", "mult", "div", "lsh", "rsh", "storend"};

    for (int posicao = 0; posicao < tamanho; posicao++) {
        //Caractere atual
        atual = entrada[posicao];

        //Caractere anterior
        if(posicao != 0) {
            prev = entrada[posicao - 1];
        }
        else {
            prev = 0;
        }

        //Contagem de linha
        if(prev == '\n') {
            linha++;
        }

        //Se comentario == linha, o resto da linha deve ser desconsiderado
        if(atual == '#') {
            comentario = linha;
        }

        //Determina se esta no comeco do token
        if(atual != ' ' && atual != '\t' && atual != '\n' && atual != '\0') {
            if(prev == 0 || prev == ' ' || prev == '\t' || prev == '\n') {
                comeco = 1;
            }
            else {
                comeco = 0;
            }
        }
        else {
            comeco = 0;
        }

        //Para analisar apenas quando a posicao atual for o comeco de um token
        if (!comeco || comentario == linha) {
            continue;
        }

        //Separando os tokens
        else {
            if(comentario < linha) {
                indice = 0;
                palavra = malloc(65 * sizeof(char));
                while (entrada[posicao + indice] != ' ' && entrada[posicao + indice] != '\t' && entrada[posicao + indice] != '\n' && entrada[posicao + indice] != '\0') {
                    palavra[indice] = tolower(entrada[posicao + indice]);
                    indice ++;
                }
                palavra[indice] = '\0';
                fimPalavra = indice - 1;
            }
        }

        // Identifica diretiva
        if (palavra[0] == '.') {
            adicionarToken(Diretiva, palavra, linha);
        }

        else {
            // Identifica definicao de rotulo
            if (palavra[fimPalavra] == ':'){
                adicionarToken(DefRotulo, palavra, linha);
            }
            
            else if (isdigit(palavra[0])){
                // Identifica hexadecimal
                if(palavra[1] == 'x') {
                    adicionarToken(Hexadecimal, palavra, linha);
                }
                // Identifica decimal
                else {
                    adicionarToken(Decimal, palavra, linha);
                }
            }
            
            else {
                int instrucao;
                // Identifica instrucao
                for(int i = 0; i < 17; i++) {
                    instrucao = strcmp(palavra, instrucoes[i]);
                    if(instrucao == 0) {
                        adicionarToken(Instrucao, palavra, linha);
                        break;
                    }
                }
                // Identifica nome
                if(instrucao != 0) {
                    adicionarToken(Nome, palavra, linha);
                }

            }
        }
    }

    /* printf("Você deve implementar esta função para a Parte 1.\n"); */
    return 0;
}

