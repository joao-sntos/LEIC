/*
 * File:  auxiliaresApagaDados.c
 * Author:  João
 * Description: Ficheiro com as funções auxiliares para apagar dados.
*/

#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*apaga os dados relativos as paragens*/

void apagaDadosParagem(Paragem **inicioParagens){

    Paragem* noParagem = *inicioParagens;

    while (noParagem != NULL){
        noParagem = noParagem->nextParagem;
        (*inicioParagens)->prevParagem = NULL;
        (*inicioParagens)->nextParagem = NULL;
        limpaListaCarreiraParagens(&(*inicioParagens));
        free((*inicioParagens)->nome);
        free(*inicioParagens);
        *inicioParagens = noParagem;
    }

}

/*apaga os dados relativos as carreiras*/

void apagaDadosCarreira(Carreira **inicioCarreiras){

    Carreira* noCarreira = *inicioCarreiras;
    Ligacao* noLigacao;

    while (noCarreira != NULL){
            noLigacao = noCarreira->primeiraLigacao;
            while (noLigacao != NULL){
                noLigacao = noLigacao->nextLigacao;
                noCarreira->primeiraLigacao->prevLigacao = NULL;
                noCarreira->primeiraLigacao->nextLigacao = NULL;
                free(noCarreira->primeiraLigacao);
                noCarreira->primeiraLigacao = noLigacao;
            }
            noCarreira = noCarreira->nextCarreira;
            (*inicioCarreiras)->prevCarreira = NULL;
            (*inicioCarreiras)->nextCarreira = NULL;
            free(*inicioCarreiras);
            *inicioCarreiras = noCarreira;
    }
}

/*atribui NULL aos ponteiros ao fim de os apagar*/

void atribuicaoPonteirosNulos(Carreira **inicioCarreiras, Paragem 
**inicioParagens, Carreira **fimCarreiras, Paragem **fimParagens){

    *inicioCarreiras = NULL;
    *fimCarreiras = NULL;
    *inicioParagens = NULL;
    *fimParagens = NULL;
}
