/* iaed-23 - ist1107365 - project2 */
/*
 * File:  project2.c
 * Author:  João
 * Description: Este programa gere e cria carreiras de transportes publicos.
*/

#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Funções para tratar comandos */

/* Função para tratar do comando 'c'. */

void carreiras(Carreira **InicioCarreiras, Carreira **FimCarreiras) {
    char *s ;

    int fimLinha = leEspacos();
    Carreira* noCarreira;
    
    if (!fimLinha) {
        listaCarreiras(InicioCarreiras);
        return;
    }

    s = leNome();
    noCarreira = encontraCarreira(s, *InicioCarreiras);
    fimLinha = leEspacos();
    if (!fimLinha) {
        if (noCarreira == NULL)
            criaCarreira(s, InicioCarreiras, FimCarreiras);
        else
            mostraLigacoesCarreira(noCarreira, FALSO);
    }
    else {
        s = leNome();
        if (verificaInversoOk(s))
            mostraLigacoesCarreira(noCarreira, VERDADE);
        else
            printf("incorrect sort option.\n");
        leAteFinalLinha();
    }
    free(s);
}

/* Função para tratar o comando 'p'. */

void paragens(Paragem **inicioParagens, Paragem **fimParagens, 
                                Carreira **inicioCarreiras) {
    char *s;
    int fimLinha = leEspacos();
    Paragem* noParagem;

    if (!fimLinha) {
        listaParagens(inicioParagens, inicioCarreiras);
        return;
    }
    s = leNome();
    fimLinha = leEspacos();
    if (!fimLinha) {
        if ((noParagem = encontraParagem(s, *inicioParagens)) == NULL)
            printf("%s: no such stop.\n", s);
        else   
            printf("%16.12f %16.12f\n", noParagem->latitude, 
                                    noParagem->longitude);
    }
    else {
        double latitude, longitude;
        if(scanf("%lf%lf", &latitude, &longitude)){;}
        if (encontraParagem(s, *inicioParagens) == NULL){
            criaParagem(s, latitude, longitude, inicioParagens, fimParagens);
        }
        else
            printf("%s: stop already exists.\n", s);

        leAteFinalLinha();
    }
    free(s);
}

/* Função para tratar o comando 'l'. */

void ligacoes(Carreira **InicioCarreiras, Paragem **InicioParagens ) { 
    char *nomeCarreira;
    char *nomeOrigem; 
    char *nomeDestino;
    
    double custo, duracao;
    Carreira* noCarreira;
    Paragem* noOrigem, *noDestino;

    leNomesComando(&nomeCarreira, &nomeOrigem, &nomeDestino);
    if(scanf("%lf%lf", &custo, &duracao)){;};
    leAteFinalLinha();

    noCarreira = encontraCarreira(nomeCarreira, *InicioCarreiras);
    if (noCarreira == NULL)
        printf("%s: no such line.\n", nomeCarreira);
    else {
        noOrigem = encontraParagem(nomeOrigem, *InicioParagens);
        if (noOrigem == NULL) 
	    printf("%s: no such stop.\n", nomeOrigem);
	else {
	    noDestino = encontraParagem(nomeDestino, *InicioParagens);
	    if (noDestino == NULL)
	        printf("%s: no such stop.\n", nomeDestino);
	    else if (custo < 0.0 || duracao < 0.0)
	            printf("negative cost or duration.\n");
		else 
		    adicionaLigacao(&noCarreira, &noOrigem, &noDestino, custo, duracao);
	}
    }
    free(nomeCarreira),free(nomeOrigem),free(nomeDestino);
}


/*Função para tratar o comando 'i'. */

void intersecoes(Paragem **inicioParagens, Carreira **inicioCarreiras) {
    Paragem* noAtual = *inicioParagens;
    int numCarreiras;

    leAteFinalLinha();

    while (noAtual != NULL){ 
        numCarreiras = numCarreirasParagens(noAtual, inicioCarreiras);
        if (numCarreiras > 1){
            ListaCarreirasParagens* noDaCarreira;
            printf("%s %d:", noAtual->nome, numCarreiras);
            ordenaCarreiras(&(noAtual->primeiraCarreira));
            noDaCarreira = noAtual->primeiraCarreira;
            while (noDaCarreira){
                printf(" %s", noDaCarreira->nome);
                noDaCarreira = noDaCarreira->nextCarreira;
            }
        printf("\n");
        }
        noAtual = noAtual->nextParagem;
    }
}

/*funcao que trata do comando 'r'*/

void removeCarreira(Carreira **inicioCarreiras, Carreira **fimCarreiras){
    Carreira* noCarreira;
    char* input;

    leEspacos();
    input = leNome();
    leAteFinalLinha();
    noCarreira = encontraCarreira(input, *inicioCarreiras);

    
    if (noCarreira == NULL){
        printf("%s: no such line.\n",input);
        return;
    }
    
    removeCarreiraParagem(&noCarreira);

    if (noCarreira == *inicioCarreiras)
        removeCarreiraInicio(inicioCarreiras);

    else if (noCarreira == *fimCarreiras)
        removeCarreiraFim(fimCarreiras);

    else removeCarreiraMeio(&noCarreira);


    free(input);
}

/*elimina uma paragem da base de dados*/

void eliminaParagem(Paragem **inicioParagens, Paragem **fimParagens, Carreira 
                                                            **inicioCarreiras){
    Paragem* noParagem;
    char* input;
    int numCarreirasParagem;

    leEspacos();
    input = leNome();
    leAteFinalLinha();
    noParagem = encontraParagem(input, *inicioParagens);
    numCarreirasParagem = numCarreirasParagens(noParagem,inicioCarreiras);

    if (noParagem == NULL)
        printf("%s: no such stop.\n",input);

    else if (numCarreirasParagem == 0)
        eliminaParagemLista(&noParagem, inicioParagens, fimParagens);
    
    else {
        eliminaParagemLigacao(&noParagem, inicioCarreiras);
        eliminaParagemLista(&noParagem, inicioParagens, fimParagens);
    }
}

/*elimina todos os dados da base de dados*/

void apagaDados(Paragem **inicioParagens, Paragem **fimParagens, Carreira 
                            **inicioCarreiras, Carreira **fimCarreiras){

    apagaDadosParagem(inicioParagens);
    apagaDadosCarreira(inicioCarreiras);
    atribuicaoPonteirosNulos(inicioCarreiras, inicioParagens, fimCarreiras, 
    fimParagens);
    leAteFinalLinha();
}


/* Função MAIN */

int main() {
    Paragem *inicioParagens = NULL;
    Paragem *fimParagens = NULL;
    Carreira *inicioCarreiras = NULL;
    Carreira *fimCarreiras = NULL;

    int c;

    do {
        c = getchar();
        switch(c) {
            case 'c':
                carreiras(&inicioCarreiras, &fimCarreiras);
                break;
            case 'p':
                paragens(&inicioParagens, &fimParagens, &inicioCarreiras);
                break;
            case 'l':
                ligacoes(&inicioCarreiras, &inicioParagens);
                break;
            case 'i':
                intersecoes(&inicioParagens, &inicioCarreiras);
                break;
            case 'r':
                removeCarreira(&inicioCarreiras, &fimCarreiras);
                break;
            case 'e':
                eliminaParagem(&inicioParagens,&fimParagens,&inicioCarreiras);
                break;
            case 'a':
                apagaDados(&inicioParagens, &fimParagens, &inicioCarreiras, 
                                                            &fimCarreiras);
                break;
	    case 'q':
            exit(0);
	        break;
            default:
	        /* Ignorar linhas em branco */
	        if (c == ' ' || c == '\t' || c == '\n') break;
        }
    } while (c != 'q');
    return 0;
}

