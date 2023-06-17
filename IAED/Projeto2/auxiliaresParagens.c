/*
 * File:  auxiliaresParagens.c
 * Author:  João
 * Description: Ficheiro com as funções auxiliares para as paragens.
*/

#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Funções para tratar as paragens */

/* descobre o numero de carreiras que uma paragem tem*/

int numCarreirasParagens(Paragem *noAtual, Carreira **inicioCarreiras){
    Carreira* noCarreira = *inicioCarreiras;
    Ligacao* noLigacao;
    int contador = 0;

    for (; noCarreira != NULL ; noCarreira = noCarreira->nextCarreira){
        noLigacao = noCarreira->primeiraLigacao;
        if (noLigacao == NULL){
            continue;
        if (noCarreira->primeiraLigacao->noOrigem == noAtual ||
        noCarreira->primeiraLigacao->noDestino == noAtual || 
        noCarreira->ultimaLigacao->noDestino == noAtual || 
        noCarreira->ultimaLigacao->noOrigem == noAtual){
            contador++;
        }
        }
        for (;noLigacao != NULL; noLigacao = noLigacao->nextLigacao){
            if (noLigacao->noOrigem==noAtual||noLigacao->noDestino==noAtual){
                contador++;
                break;
            }
        }
    }
    return contador;
}

/* Mostra uma paragem. */

void mostraParagem(Paragem *noAtual, Carreira **inicioCarreiras) {
    int numCarreiras = 0;
    numCarreiras = numCarreirasParagens(noAtual, inicioCarreiras);
    printf("%s: %16.12f %16.12f %d\n",noAtual->nome,noAtual->latitude, 
            noAtual->longitude, numCarreiras);
}

/* Mostra todas as paragens. */

void listaParagens(Paragem **inicioParagens, Carreira **inicioCarreiras) {
    Paragem *noAtual = *inicioParagens;

    while (noAtual != NULL) {
        mostraParagem(noAtual, inicioCarreiras);
        noAtual = noAtual->nextParagem;

    }
}

/* Verifica se existe uma paragem com um determinado nome.
   Se existir devolve o indice. Caso contrário, devolve NAO_ENCONTRADO. */

Paragem* encontraParagem(char *nomeParagem, Paragem *InicioParagens) {
    Paragem *noAtual = InicioParagens;

    while (noAtual != NULL){
        if (!strcmp(nomeParagem,noAtual->nome))
            return noAtual;
        noAtual = noAtual->nextParagem;
    }
    return NULL;
}

/* Cria uma nova paragem. */

void criaParagem(char* nomeParagem, double latitude, double longitude, 
    Paragem **inicioParagens, Paragem **fimParagens) {

    Paragem* novaParagem = calloc(1,(sizeof(Paragem)));
    novaParagem->nome = (char*) malloc(sizeof(char)*(strlen(nomeParagem)+1));

    if (novaParagem == NULL || novaParagem->nome == NULL){
        printf("No memory.\n");
        exit(1);
    }

    strcpy(novaParagem->nome, nomeParagem);
    novaParagem->longitude = longitude;
    novaParagem->latitude = latitude;

    if (*inicioParagens == NULL) {
        *inicioParagens = novaParagem; 
    } else {
        novaParagem->prevParagem = (*fimParagens);
        (*fimParagens)->nextParagem = novaParagem;
    }

    *fimParagens = novaParagem;
}
