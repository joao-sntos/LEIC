/*
 * File:  auxiliaresRemoveCarreiras.c
 * Author:  João
 * Description: Ficheiro com as funções auxiliares para remover carreiras.
*/

#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/*procura a carreira na lista de carreiras que passam na paragem e elimina-a*/

void removeNomeCarreira(ListaCarreirasParagens **primeiraCarreira, 
                            Carreira **noCarreira){
    ListaCarreirasParagens* noAtual = (*primeiraCarreira);
    

    if (noAtual == NULL)
        return;

    while (noAtual != NULL){
        if (noAtual->nextCarreira == NULL){
            if(strcmp(noAtual->nome, (*noCarreira)->nome) == 0){
                free(noAtual->nome);
                free(noAtual);
                noAtual = NULL;
                return;
            }
        }
        else if (strcmp(noAtual->nextCarreira->nome, (*noCarreira)->nome) == 0){
            ListaCarreirasParagens *temp = noAtual->nextCarreira;
            noAtual->nextCarreira = temp->nextCarreira;
            free(temp->nome);
            free(temp);
            return;
        }
        noAtual = noAtual->nextCarreira;
    }
}


/*percorre as ligacoes da carreira para eliminar as aparicoes da carreira
na lista de carreiras na paragem*/

void removeCarreiraParagem(Carreira **noCarreira){
    Carreira* noAtual = (*noCarreira);
    Ligacao* LigacaoAtual;

    if (noAtual == NULL)
        return;

    while (noAtual != NULL){
        if (noAtual->primeiraLigacao == NULL)
            return;
        removeNomeCarreira(&(noAtual)->primeiraLigacao->noOrigem->
        primeiraCarreira, noCarreira);
        LigacaoAtual = noAtual->primeiraLigacao;
        while (LigacaoAtual != NULL){
            removeNomeCarreira(&(LigacaoAtual)->noDestino->primeiraCarreira, 
            noCarreira);
            LigacaoAtual = LigacaoAtual->nextLigacao;
        }
        noAtual = noAtual->nextCarreira;
    }
}


/*remove carreira no inicio da lista de carreiras*/

void removeCarreiraInicio(Carreira **inicioCarreiras){
    Carreira* noAtual = (*inicioCarreiras);

    if (noAtual && (*inicioCarreiras)){
        (*inicioCarreiras) = noAtual->nextCarreira;
        removeLigacoesCarreira(&noAtual);
        free(noAtual->nome);
        free(noAtual);
    }
}

/*remove carreira no fim da lista de carreiras*/

void removeCarreiraFim(Carreira **fimCarreiras){
    Carreira* noAtual = (*fimCarreiras);

    if (noAtual && (*fimCarreiras)){
        (*fimCarreiras) = noAtual->prevCarreira;
        (*fimCarreiras)->nextCarreira = NULL;
        removeLigacoesCarreira(&noAtual);
        free(noAtual->nome);
        free(noAtual);
    }
}

/*remove carreira no meio da lista de carreiras*/

void removeCarreiraMeio(Carreira **noCarreira){
    Carreira* noAtual = (*noCarreira);

    if (noAtual){
        noAtual->prevCarreira->nextCarreira = noAtual->nextCarreira;
        noAtual->nextCarreira->prevCarreira = noAtual->prevCarreira;
        removeLigacoesCarreira(&noAtual);
        free(noAtual->nome);
        free(noAtual);
    }
}

/*remove ligacoes de uma carreira*/
 
void removeLigacoesCarreira(Carreira **noCarreira){
    Ligacao* LigacaoAtual = (*noCarreira)->primeiraLigacao;
    Ligacao* LigacaoTemp = NULL;
    
    if (LigacaoAtual != NULL){
        if (LigacaoAtual->nextLigacao == NULL){
            while (LigacaoAtual != NULL){
                free(LigacaoAtual);
                if (LigacaoTemp == NULL)
                    break;
                LigacaoTemp = LigacaoTemp->nextLigacao;
                LigacaoAtual = LigacaoTemp;
            }
        }
    }
    else
        return;

}
