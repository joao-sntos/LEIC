/*
 * File:  auxiliaresLeituraInput.c
 * Author:  João
 * Description: Ficheiro com as funções auxiliares para a leitura do input.
*/

#include "estruturas.h"
#include "prototipos.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Le espaços. Devolve 0 se chegou ao final de linha ou 1 caso contrário. */

int leEspacos() {
    int c;
    while ((c = getchar()) == ' ' || c == '\t');
    if (c == '\n') 
        return 0;
    ungetc(c, stdin);
    return 1;
}

/* Le um nome para a string que recebe como parametro. */

char* leNome() {
    char *s ;
    char buffer[MAX_TAMANHO_LINHA];
    int i = 0, c, cont_caracteres = 2;
    
    buffer[0] = getchar();
    if (buffer[0] != '"') {
        i = 1;
        while ((c = getchar()) != ' ' && c != '\t' && c != '\n') {
            buffer[i++] = c;
            cont_caracteres++;
        }
        ungetc(c, stdin);
    }
    else {
        while((c = getchar()) != '"') {
            buffer[i++] = c;
            cont_caracteres++;
        }
    }
    buffer[i] = '\0';

    s = (char*) malloc(sizeof(char)*(strlen(buffer)+1));
    
    if (s == NULL) {
        printf("No memory.\n");
        exit(1);
    }
    strcpy(s,buffer);
    return s;
}

/* Le todo o texto até ao final de linha. */

void leAteFinalLinha() {
    while (getchar() != '\n');
}

/* Le nome de carreira e paragens de uma ligacao. */

void leNomesComando(char **nomeCarreira, char **nomeOrigem, char **nomeDestino) {
    leEspacos();
    *nomeCarreira = leNome();
    leEspacos();
    *nomeOrigem = leNome();
    leEspacos();
    *nomeDestino = leNome();
}