#ifndef ESTRUTURAS_H_INCLUDED
#define ESTRUTURAS_H_INCLUDED

#include <stdio.h>

/* Definicao Constantes */

#define VERDADE 1
#define FALSO 0

#define MAX_TAMANHO_LINHA BUFSIZ

/* Defenicao da string inverso*/

#define INVERSO "inverso"

/* Definicao de Tipos de Dados */

typedef struct ListaCarreirasParagens{
    char* nome;
    struct ListaCarreirasParagens* nextCarreira;
} ListaCarreirasParagens;

typedef struct Paragem{
    char* nome;
    double latitude, longitude;
    ListaCarreirasParagens* primeiraCarreira;
    ListaCarreirasParagens* ultimaCarreira;
    struct Paragem* nextParagem;
    struct Paragem* prevParagem;
} Paragem;

typedef struct Carreira{
    char* nome;
    double custoTotal;
    double duracaoTotal;
    int numLigacoes;
    struct Ligacao* primeiraLigacao;
    struct Ligacao* ultimaLigacao;
    struct Carreira* nextCarreira;
    struct Carreira* prevCarreira;
} Carreira;

typedef struct Ligacao{
    Paragem* noOrigem, *noDestino;
    double custo, duracao;
    struct Ligacao* nextLigacao;
    struct Ligacao* prevLigacao;
} Ligacao;

#endif

