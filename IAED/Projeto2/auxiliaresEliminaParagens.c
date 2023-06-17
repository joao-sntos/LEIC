/*
 * File:  auxiliaresEliminaParagens.c
 * Author:  João
 * Description: Ficheiro com as funções auxiliares para eliminar paragens.
*/

#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*limpa a lista de carreiras de uma paragem*/

void limpaListaCarreiraParagens(Paragem **noParagem){
    ListaCarreirasParagens* noAtual = (*noParagem)->primeiraCarreira;
    ListaCarreirasParagens* noTemp = NULL;; 

    if (noAtual == NULL)
        return;

    noTemp = noAtual->nextCarreira;
    while (noAtual && noAtual->nextCarreira != NULL){
        free(noAtual->nome);
        free(noAtual);
        noAtual = noTemp;
        if (noTemp->nextCarreira != NULL)
            noTemp = noTemp->nextCarreira;
    }
}

/*remove paragem no inicio da lista de paragens*/

void eliminaParagemInicio(Paragem **noParagem, Paragem **inicioParagens){
    Paragem* noAtual = (*noParagem);

    if (noParagem){
        (*inicioParagens) = noAtual->nextParagem;
    }
}

/*remove paragem no fim da lista de paragens*/

void eliminaParagemFim(Paragem **noParagem, Paragem**fimParagens){
    Paragem* noAtual = (*noParagem);

    if (noParagem){
        (*fimParagens) = noAtual->prevParagem;
        (*fimParagens)->nextParagem = NULL;
    }
}

/*remove paragem no meio da lista de paragens*/

void eliminaParagemMeio(Paragem **noParagem){
    Paragem* noAtual = (*noParagem);

    if (noAtual){
        if (noAtual->prevParagem && noAtual->nextParagem){
            noAtual->prevParagem->nextParagem = noAtual->nextParagem;
            noAtual->nextParagem->prevParagem = noAtual->prevParagem;
        }
    }
}

/*funcao que trata da eliminacao da paragem na lista das paragens*/

void eliminaParagemLista(Paragem **noParagem, Paragem **inicioParagens, 
                                                Paragem **fimParagens){
    Paragem* noAtual = *noParagem;

    if (*noParagem == *inicioParagens)
        eliminaParagemInicio(&noAtual, inicioParagens);

    else if (*noParagem == *fimParagens)
        eliminaParagemFim(&noAtual, fimParagens);
        
    else
        eliminaParagemMeio(&noAtual);

    limpaListaCarreiraParagens(&noAtual);
    free(noAtual->nome);
    free(noAtual); 
}

/*decrementa a duracao e o custo total guardado na estrutura das carreiras*/

void decrementaCustoDuracao(Ligacao **noLigacao, Carreira **noCarreira){
    
    (*noCarreira)->custoTotal -= (*noLigacao)->custo;
    (*noCarreira)->duracaoTotal -= (*noLigacao)->duracao;
}

/*incrementa a duracao e o custo de uma ligacao quando uma outra e destruida*/

void incrementaCustoDuracaoLigacao(Ligacao **noLigacao, Ligacao **noDoador){

    (*noLigacao)->custo += (*noDoador)->custo;
    (*noLigacao)->duracao += (*noDoador)->duracao;
}

/*retira quando exite apenas uma ligacao*/

void retiraLigacaoUnica(Ligacao **noLigacao, Carreira **noCarreira){
    
    decrementaCustoDuracao(&(*noLigacao), &(*noCarreira));
    (*noCarreira)->primeiraLigacao = NULL;
    (*noCarreira)->ultimaLigacao = NULL;
}

/*retira a ligacao caso a paragem esteja na inicio*/

void retiraPrimeiraLigacao(Ligacao **noLigacao, Carreira **noCarreira, 
                                                Paragem **noParagem){
    if((*noCarreira)->primeiraLigacao == NULL || (*noCarreira)->
    primeiraLigacao->nextLigacao == NULL)
        return;

    if((*noCarreira)->primeiraLigacao->noDestino == (*noParagem)){
        (*noCarreira)->primeiraLigacao->nextLigacao->noOrigem = 
        (*noCarreira)->primeiraLigacao->noOrigem;
        incrementaCustoDuracaoLigacao(&(*noCarreira)->primeiraLigacao->
        nextLigacao, &(*noCarreira)->primeiraLigacao);
    }
    else decrementaCustoDuracao(&(*noCarreira)->primeiraLigacao, noCarreira);

    (*noCarreira)->primeiraLigacao = (*noLigacao)->nextLigacao;
    (*noCarreira)->primeiraLigacao->prevLigacao = NULL;
    free(*noLigacao);
}

/*retira a ligacao caso a paragem estaja no fim*/

void retiraUltimaLigacao(Ligacao **noLigacao, Carreira **noCarreira, 
                                                Paragem **noParagem){

    if((*noCarreira)->ultimaLigacao == NULL || (*noCarreira)-> 
    ultimaLigacao->prevLigacao == NULL)
        return;

    if ((*noCarreira)->ultimaLigacao->noOrigem == (*noParagem)){
        (*noCarreira)->ultimaLigacao->prevLigacao->noDestino = 
        (*noCarreira)->ultimaLigacao->noDestino;
        incrementaCustoDuracaoLigacao(&(*noCarreira)->ultimaLigacao->
        prevLigacao, &(*noCarreira)->ultimaLigacao);
    }
    else decrementaCustoDuracao(&(*noCarreira)->ultimaLigacao, noCarreira);
    (*noCarreira)->ultimaLigacao = (*noLigacao)->prevLigacao;
    (*noCarreira)->ultimaLigacao->nextLigacao = NULL;
    free(*noLigacao);
} 

/*retira a ligacao caso a paragem esteja no meio*/

void retiraLigacaoMeio(Ligacao **noLigacao, Carreira **noCarreira){

    (*noLigacao)->prevLigacao->nextLigacao = (*noLigacao)->nextLigacao;
    (*noLigacao)->nextLigacao->prevLigacao = (*noLigacao)->prevLigacao;
    (*noLigacao)->nextLigacao->noOrigem = (*noLigacao)->noOrigem;
    decrementaCustoDuracao(&(*noLigacao), noCarreira);
    free(*noLigacao);
}


/*modifica a lista de ligacoes para que eliminar as apareicoes da paragem*/

void modificaLigacoes(Ligacao **noLigacao, Carreira **noCarreira, Paragem 
                                                            **noParagem){

    if ((*noCarreira)->numLigacoes == 0)
        return;

    else if ((*noCarreira)->numLigacoes == 1)
        retiraLigacaoUnica(noLigacao, noCarreira);

    else if ((*noCarreira)->primeiraLigacao == (*noLigacao))
        retiraPrimeiraLigacao(noLigacao, noCarreira, noParagem);
        
    else if ((*noCarreira)->ultimaLigacao == (*noLigacao))
        retiraUltimaLigacao(noLigacao, noCarreira, noParagem);

    else retiraLigacaoMeio(noLigacao, noCarreira);
    
    (*noCarreira)->numLigacoes--;
}

/*porcura as ligacoes onde a paragem se econtra e elimina a suas aparecias*/

void eliminaParagemLigacao(Paragem **noParagem,Carreira **inicioCarreiras){
    Carreira* noCarreira = *inicioCarreiras;
    Ligacao* noLigacao;

    while (noCarreira){
        noLigacao = noCarreira->primeiraLigacao;
        while (noLigacao){
            if (noLigacao->noOrigem == *noParagem || noLigacao->noDestino == 
            *noParagem){
                modificaLigacoes(&noLigacao, &noCarreira, noParagem);
            }
            if (noLigacao)
                noLigacao = noLigacao->nextLigacao;
            else break;
        }
        noCarreira = noCarreira->nextCarreira;
    }
}
