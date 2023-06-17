#ifndef PROTOTIPOS_H
#define PROTOTIPOS_H

#include "common.h"
#include <stdio.h>

/* defenicao dos prototipos*/

/*lê inputs*/
int leEspacos();
char* leNome();
void leAteFinalLinha();
void mostraCarreira(Carreira *noAtual);
void mostraLigacoesCarreira(Carreira *noCarreira, int inverso);
void listaCarreiras(Carreira **InicioCarreiras);
Carreira* encontraCarreira(char *nomeCarreira, Carreira *InicioCarreiras);
Ligacao* encontraParagemCarreira(Carreira *noCarreira, Paragem *noParagem);
void criaCarreira(char *nomeCarreira, Carreira **InicioCarreiras, Carreira 
**FimCarreiras);
int verificaInversoOk(char *s);
int numCarreirasParagens(Paragem *noAtual, Carreira **inicioCarreiras);
void carreiras(Carreira **InicioCarreiras, Carreira **FimCarreiras);
void listaParagens(Paragem **inicioParagens, Carreira **inicioCarreiras);
void mostraLigacoesParagem(Paragem *noParagem, int inverso);
void mostraLigacoesCarreira(Carreira *noCarreira, int inverso);
Paragem* encontraParagem(char *nomeParagem, Paragem *InicioParagens);
void criaParagem(char* nomeParagem, double latitude, double longitude, 
    Paragem **inicioParagens, Paragem **fimParagens);
void paragens(Paragem **inicioParagens, Paragem **fimParagens, 
                                Carreira **inicioCarreiras);
Ligacao* criaLigacao(Carreira **noCarreira, Paragem **noOrigem, Paragem 
                            **noDestino, double custo, double duracao);
void acrescentaLigacaoFim(Carreira **noCarreira, Ligacao **novaLigacao);
void acrescentaLigacaoInicio(Carreira **noCarreira, Ligacao **novaLigacao);
void adicionaCarreiraParagem(Paragem *noParagem, Carreira*noCarreira);
void adicionaPrimeiraLigacao(Carreira *noCarreira, Paragem *noOrigem, 
                    Paragem *noDestino,double custo, double duracao);
void adicionaLigacao(Carreira **noCarreira, Paragem **noOrigem, Paragem 
                            **noDestino, double custo, double duracao);
void leNomesComando(char **nomeCarreira, char **nomeOrigem, char **nomeDestino);
void ligacoes(Carreira **InicioCarreiras, Paragem **InicioParagens );
void ordenaCarreiras(ListaCarreirasParagens** primeiraCarreira);
void intersecoes(Paragem **inicioParagens, Carreira **inicioCarreiras);
void removeNomeCarreira(ListaCarreirasParagens **primeiraCarreira, Carreira 
                                                            **noCarreira);
void removeCarreiraParagem(Carreira **noCarreira);
void removeLigacoesCarreira(Carreira **noCarreira);
void removeCarreiraInicio(Carreira **inicioCarreiras);
void removeCarreiraFim(Carreira **fimCarreiras);
void removeCarreiraMeio(Carreira **noCarreira);
void removeCarreira(Carreira **inicioCarreiras, Carreira **fimCarreiras);
void limpaListaCarreiraParagens(Paragem **noParagem);
void eliminaParagemInicio(Paragem **noParagem, Paragem **inicioParagens);
void eliminaParagemFim(Paragem **noParagem, Paragem**fimParagens);
void eliminaParagemMeio(Paragem **noParagem);
void eliminaParagemLista(Paragem **noParagem, Paragem **inicioParagens, 
                                                Paragem **fimParagens);
void decrementaCustoDuracao(Ligacao **noLigacao, Carreira **noCarreira);
void incrementaCustoDuracaoLigacao(Ligacao **noLigacao, Ligacao **noDoador);
void retiraLigacaoUnica(Ligacao **noLigacao, Carreira **noCarreira);
void retiraPrimeiraLigacao(Ligacao **noLigacao, Carreira **noCarreira, 
                                                Paragem **noParagem);
void retiraUltimaLigacao(Ligacao **noLigacao, Carreira **noCarreira, 
                                                Paragem **noParagem);
void retiraLigacaoMeio(Ligacao **noLigacao, Carreira **noCarreira);
void modificaLigacoes(Ligacao **noLigacao, Carreira **noCarreira, Paragem 
                                                            **noParagem);
void eliminaParagemLigacao(Paragem **noParagem,Carreira **inicioCarreiras);
void eliminaParagem(Paragem **inicioParagens, Paragem **fimParagens, Carreira 
                                                            **inicioCarreiras);
void apagaDadosParagem(Paragem **inicioParagens);
void apagaDadosCarreira(Carreira **inicioCarreiras);
void atribuicaoPonteirosNulos(Carreira **inicioCarreiras, Paragem 
**inicioParagens, Carreira **fimCarreiras, Paragem **fimParagens);
void apagaDados(Paragem **inicioParagens, Paragem **fimParagens, Carreira 
                            **inicioCarreiras, Carreira **fimCarreiras);
int main();

#endif