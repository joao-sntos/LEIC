/*
 * File:  auxiliaresLigacoes.c
 * Author:  João
 * Description: Ficheiro com as funções auxiliares para as ligações.
*/

#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Adiciona uma nova ligação. */

Ligacao* criaLigacao(Carreira **noCarreira, Paragem **noOrigem, Paragem 
                            **noDestino, double custo, double duracao) {

    Ligacao *novaLigacao = (Ligacao*) calloc(1,(sizeof(Ligacao)));

    novaLigacao->noOrigem = *noOrigem;
    novaLigacao->noDestino = *noDestino;
    novaLigacao->custo = custo;
    novaLigacao->duracao = duracao;
    (*noCarreira)->custoTotal += novaLigacao->custo;
    (*noCarreira)->duracaoTotal += novaLigacao->duracao;

    if ((*noCarreira)->numLigacoes == 0){
        (*noCarreira)->primeiraLigacao = novaLigacao;
        (*noCarreira)->ultimaLigacao = novaLigacao;
    }
    (*noCarreira)->numLigacoes++;
    return novaLigacao;

}

/* Acrescenta uma nova ligação no fim de uma carreira. */

void acrescentaLigacaoFim(Carreira **noCarreira, Ligacao **novaLigacao) {

    (*noCarreira)->ultimaLigacao->nextLigacao = *novaLigacao;
    (*novaLigacao)->prevLigacao = (*noCarreira)->ultimaLigacao; 
    (*noCarreira)->ultimaLigacao = *novaLigacao;
    (*novaLigacao)->nextLigacao = NULL;

}

/* Acrescenta uma nova ligação no início de uma carreira. */

void acrescentaLigacaoInicio(Carreira **noCarreira, Ligacao **novaLigacao) {

    (*noCarreira)->primeiraLigacao->prevLigacao = *novaLigacao;
    (*novaLigacao)->nextLigacao = (*noCarreira)->primeiraLigacao;
    (*noCarreira)->primeiraLigacao = *novaLigacao;
    (*novaLigacao)->prevLigacao = NULL;

}

/* Adiciona que existe uma nova carreira associada a uma paragem. */

void adicionaCarreiraParagem(Paragem *noParagem, Carreira*noCarreira) {
    char* nome = (char*) malloc(sizeof(char)*(strlen(noCarreira->nome)+1));
    ListaCarreirasParagens* novaCarreiraNaLista = (ListaCarreirasParagens*)
        calloc(1,(sizeof(ListaCarreirasParagens)));

    if (nome == NULL || novaCarreiraNaLista == NULL){
        printf("No memory.\n");
        exit(1);
    }

    strcpy(nome,noCarreira->nome);
    novaCarreiraNaLista->nome = nome; 
    if (noParagem->primeiraCarreira == NULL){
        noParagem->primeiraCarreira = novaCarreiraNaLista;
    }
    else noParagem->ultimaCarreira->nextCarreira = novaCarreiraNaLista;
    noParagem->ultimaCarreira = novaCarreiraNaLista;
}


/* Adiciona primeira ligacao da carreira. */

void adicionaPrimeiraLigacao(Carreira *noCarreira, Paragem *noOrigem, 
                    Paragem *noDestino,double custo, double duracao) {
    Ligacao* novaLigacao;

    adicionaCarreiraParagem(noOrigem, noCarreira);
    if (strcmp(noOrigem->nome,noDestino->nome))
        adicionaCarreiraParagem(noDestino, noCarreira);
    novaLigacao = criaLigacao(&noCarreira, &noOrigem, &noDestino, custo, duracao);
    novaLigacao->nextLigacao = NULL;
    acrescentaLigacaoFim(&noCarreira, &novaLigacao);
}

/* Adiciona uma nova ligação a uma carreira. */

void adicionaLigacao(Carreira **noCarreira, Paragem **noOrigem, Paragem 

                            **noDestino, double custo, double duracao) {

    Ligacao* novaLigacao;

    if ((*noCarreira)->numLigacoes == 0) 
        adicionaPrimeiraLigacao(*noCarreira, *noOrigem, *noDestino,
				custo, duracao);
    else {
        if (!strcmp((*noOrigem)->nome,(*noCarreira)->ultimaLigacao->noDestino->nome)) {
            if (encontraParagemCarreira(*noCarreira, *noDestino) == NULL)
                adicionaCarreiraParagem(*noDestino, *noCarreira);
            novaLigacao = criaLigacao(noCarreira, noOrigem, noDestino, custo, duracao);
            acrescentaLigacaoFim(noCarreira, &novaLigacao);
            return;
        }
        else if (!strcmp((*noDestino)->nome, (*noCarreira)->primeiraLigacao->noOrigem->nome)) {
            if (encontraParagemCarreira(*noCarreira, *noOrigem) == NULL)
                adicionaCarreiraParagem(*noOrigem, *noCarreira);
            novaLigacao = criaLigacao(noCarreira, noOrigem, noDestino, custo, duracao);
            acrescentaLigacaoInicio(noCarreira, &novaLigacao);
        }
        else 
            printf("link cannot be associated with bus line.\n");
    }
}
