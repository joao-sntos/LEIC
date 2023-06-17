/*
 * File:  auxiliaresCarreiras.c
 * Author:  João
 * Description: Ficheiro com as funções auxiliares para as carreiras.
*/

#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Funções para tratar as carreiras */

/* Mostra no output a carreira com indice i */

void mostraCarreira(Carreira *noAtual) {

    printf("%s ", noAtual->nome);
    if (noAtual->numLigacoes > 0) {
        printf("%s %s ", noAtual->primeiraLigacao->noOrigem->nome,
                        noAtual->ultimaLigacao->noDestino->nome);
        printf("%d ", noAtual->numLigacoes +1);
        printf("%.2f ", noAtual->custoTotal);
        printf("%.2f\n", noAtual->duracaoTotal);
    }
    else 
        printf("%d %.2f %.2f\n", 0, 0.0, 0.0);
}

/* Mostra as ligações da carreira com indice i. */

void mostraLigacoesCarreira(Carreira *noCarreira, int inverso) {
    Ligacao* ligacaoAtual;

    if (noCarreira == NULL)
        return;
    if (noCarreira->numLigacoes == 0) 
        return;
    if (inverso == FALSO) {
        ligacaoAtual = noCarreira->primeiraLigacao;
        while (ligacaoAtual != NULL){
            printf("%s, ",ligacaoAtual->noOrigem->nome);
            ligacaoAtual = ligacaoAtual->nextLigacao;
        }
        printf("%s\n", noCarreira->ultimaLigacao->noDestino->nome);
    }

    else {
        ligacaoAtual = noCarreira->ultimaLigacao;
        while (ligacaoAtual != NULL){
            printf("%s, ", ligacaoAtual->noDestino->nome);
            ligacaoAtual = ligacaoAtual->prevLigacao;
        }
        printf("%s\n", noCarreira->primeiraLigacao->noOrigem->nome);
    }
}

/* Mostra todas as carreiras. */

void listaCarreiras(Carreira **InicioCarreiras) {
    Carreira *noAtual = *InicioCarreiras;

    while (noAtual != NULL) {
        mostraCarreira(noAtual);
        noAtual = noAtual->nextCarreira;
    }
}

/* Procura uma carreira por nome.
   Devolve o indice da carreira ou NAO_ENCONTRADO se não existe. */

Carreira* encontraCarreira(char *nomeCarreira, Carreira *InicioCarreiras) {
    Carreira *noAtual = InicioCarreiras;

    while (noAtual != NULL){
        if (!strcmp(noAtual->nome, nomeCarreira))
            return noAtual;
        noAtual = noAtual->nextCarreira;
    }
    return NULL;
}

/* Procura se uma paragem existe numa carreira.
   Se existir, devolve o indice da primeira ligação que usa
   a paragem. Caso contrário, devolve NAO_ENCONTRADO. */

Ligacao* encontraParagemCarreira(Carreira *noCarreira, Paragem *noParagem) {
    Ligacao* noAtual = noCarreira->primeiraLigacao;

    while (noAtual != NULL){
        if (!strcmp(noAtual->noOrigem->nome,noParagem->nome))
            return noAtual;
        noAtual = noAtual->nextLigacao;
    }

    if (!strcmp(noCarreira->ultimaLigacao->noDestino->nome,noParagem->nome))
        return noCarreira->ultimaLigacao;
    return NULL;

}

/* Cria uma carreira nova. */

void criaCarreira(char *nomeCarreira, Carreira **InicioCarreiras, 
    Carreira **FimCarreiras) {

    Carreira* novaCarreira = (Carreira*) calloc(1,(sizeof(Carreira)));
    novaCarreira->nome = (char*) malloc(sizeof(char)*(strlen(nomeCarreira)+1)); 

    if (novaCarreira == NULL || novaCarreira->nome == NULL){
        printf("No memory.\n");
        exit(1);
    }

    strcpy(novaCarreira->nome, nomeCarreira);
    novaCarreira->prevCarreira = *FimCarreiras;

    if (*InicioCarreiras == NULL) {
        *InicioCarreiras = novaCarreira; 
    } else {
        (*FimCarreiras)->nextCarreira = novaCarreira;
    }

    *FimCarreiras = novaCarreira;
}

/* Verifica se a string é um prefixo de tamanho pelo menos 3 da
   palavra inverso. */

int verificaInversoOk(char *s) {
    int size = strlen(s), i;

    if (size < 3 || size > 7)
        return FALSO;
    for (i = 0; i < size; i++)
        if (INVERSO[i] != s[i])
            return FALSO;
    return VERDADE;
}