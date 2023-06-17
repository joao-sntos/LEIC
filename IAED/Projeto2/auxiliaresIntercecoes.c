/*
 * File:  auxiliaresIntercecoes.c
 * Author:  João
 * Description: Ficheiro com as funções auxiliares para as interceções.
*/

#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*Aplica Bubble Sort a um vector de identificadores de carreiras.*/ 

void ordenaCarreiras(ListaCarreirasParagens** primeiraCarreira) {
    int houveTroca = 1;
    ListaCarreirasParagens *noAtual, *q, *temporario = NULL;
    if (*primeiraCarreira == NULL) {
        return;
    }
    while (houveTroca) {
        houveTroca = FALSO;
        noAtual = *primeiraCarreira;
        while (noAtual->nextCarreira != temporario) {
            q = noAtual->nextCarreira;
            if (strcmp(noAtual->nome, q->nome) > 0) {
                /*troca os nós*/
                ListaCarreirasParagens* temporarioCarreira = noAtual;
                noAtual = q;
                q = temporarioCarreira;
                houveTroca = VERDADE;
            }
            noAtual = noAtual->nextCarreira;
        }
        temporario = noAtual;
    }
}