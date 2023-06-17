/* iaed-23 - ist1107365 - project1 */
/*
 * File:  project1.c
 * Author:  João
 * Description: Este programa gere e cria carreiras de transportes publicos.
*/

#include <stdio.h>
#include <string.h>
#include <math.h>

/*Número máximo de carreiras*/
#define MAX_CAR 200

/*Número máximo de paragens*/
#define MAX_PAR 10000

/*Número máximo de ligacoes*/
#define MAX_LIG 30000

/*Comprimento máximo do nome da paragem*/
#define COMP_NOME_PARAGEM 51

/*comprimento máximo do nome da carreira*/
#define COMP_NOME_CARREIRA 21

/*Constantes para a leitura de palavras*/
#define DENTRO 1
#define FORA 0
#define TRUE 0
#define FALSE 1
#define INICIO 0
#define FIM 1
#define FALSOINDEX -1

/*estrutura de localizações*/
typedef struct{
    double lon;
    double lat;
} localizacao; 

/*estrutura de pargens*/
typedef struct{
    char nome[COMP_NOME_PARAGEM];
    localizacao local;
    int cont_carreiras;
} paragem;

/*estrutura de carreiras*/
typedef struct{
    char nome[COMP_NOME_CARREIRA];
    int l_paragens[MAX_PAR];
    double custo;
    double duracao;
} carreira;

/*criação de arrays com todas as carreiras/ligações/paragens/localizações*/
carreira v_carreiras[MAX_CAR];
paragem v_paragens[MAX_PAR];
int cont_indv_paragens[MAX_CAR];

/*criação de variaveis de contagem do numero de carreiras/ligações/paragens/
localizações para usar como tamanho dos arrays*/
int cont_carreiras = 0, cont_paragens = 0, cont_localizacoes = 0;


/*lê as strings do terminal por palavras*/
int input_palavras(char p_string[]){
    int estado = FORA, starded = FALSE,i = 0;
    char c;
    while ((c = getchar()) != EOF) {
        if (c == '\n'){
            p_string[i] = '\0';
            return TRUE;
        }
        else if ((c == '"' || c == '\t') && estado == FORA) {
            estado = DENTRO;
            starded = TRUE;
        } else if (c == '"' && estado == DENTRO) {
            estado = FORA;
        } else if ((c == ' ' || c == '\t') && estado == FORA){
            if (starded == FALSE){
            continue;
            }
            else break;
        } else { 
            starded = TRUE;
            p_string[i] = c;
            i++;
        }
        
    }
    p_string[i] = '\0';
    return FALSE;
}

/*sobe todas as posições para a direita no array de paragens*/
void sobe_array(int index_carr){
    int i;

    for (i = cont_indv_paragens[index_carr] ; i > 0; i--){
        v_carreiras[index_carr].l_paragens[i] = v_carreiras[index_carr].
        l_paragens[i-1];
    }
    return;
}

/*verifica se o input é um inverso*/
int inverso_autenticator(char s_string[]){
    if ((strcmp(s_string, "inv") == 0 || strcmp(s_string, "inve") == 0 ||
    strcmp(s_string, "inver") == 0 || strcmp(s_string, "invers") == 0 ||
    strcmp(s_string, "inverso") == 0) && strlen(s_string) > 2 && 
    strlen(s_string) < 8) {
        return TRUE;
    }
    else return FALSE;
}

/*verifica se uma carreira com um nome específico existe*/
int procura_carreiras(char nome_carreira[]){
    int i;

    for (i = 0; i < cont_carreiras; i++){
        if(strcmp(v_carreiras[i].nome,nome_carreira) == 0){
            return i;
        }
    }
    return FALSOINDEX;
}

/*verifica se uma paragem com um nome específico existe*/
int procura_paragens(char nome_paragem[]){
    int i; 

    for (i = 0; i < cont_paragens; i++){
        if(strcmp(v_paragens[i].nome,nome_paragem) == 0){
            return i;
        }
    }
    return FALSOINDEX;
}

/*incrementa o contador de ligações/custo/duração de uma viagem*/
void incrementador_lig(int index_carr, int index_paragem, double custo, double 
duracao, int lado){

    if (lado == FIM){
        v_carreiras[index_carr].l_paragens[cont_indv_paragens[index_carr]] 
        = index_paragem;
    }
    else if (lado == INICIO){
        v_carreiras[index_carr].l_paragens[0] = index_paragem;
    }
        cont_indv_paragens[index_carr]++;
        v_carreiras[index_carr].custo += custo;
        v_carreiras[index_carr].duracao += duracao;
}

/*ordena as lista de carreiras*/
void sort_lista(int lista_carreiras[], int cont){
    int temp;
    int i,j;

    for (i = 0; i < cont-1; i++){
        for (j = 0; j < cont-i-1; j++){

            if (strcmp(v_carreiras[lista_carreiras[j]].nome, 
            v_carreiras[lista_carreiras[j+1]].nome) > 0){

                temp = lista_carreiras[j];
                lista_carreiras[j] = lista_carreiras[j+1];
                lista_carreiras[j+1] = temp;
            }
        }
    }
    for (i = 0; i < cont; i++){
        printf(" %s", v_carreiras[lista_carreiras[i]].nome);
    }

}

/*cria nova ligação*/
void aux_nova_ligacao(int index_carr, int index_origem,int index_destino,
double duracao, double custo ){
    v_carreiras[index_carr].l_paragens[0] = index_origem;
    v_carreiras[index_carr].l_paragens[1] = index_destino;
    v_carreiras[index_carr].custo += custo;
    v_carreiras[index_carr].duracao += duracao;
    cont_indv_paragens[index_carr] += 2;
    v_paragens[index_origem].cont_carreiras++;
    v_paragens[index_destino].cont_carreiras++;
}
 
/*adiciona e lista as ligações entre paragens*/
void add_lista_ligacoes(){
    char p_string[COMP_NOME_CARREIRA],s_string[COMP_NOME_PARAGEM],
    t_string[COMP_NOME_PARAGEM];
    int index_carr = FALSOINDEX, index_origem = FALSOINDEX, 
        index_destino = FALSOINDEX,lado, in;
    double custo, duracao;

    input_palavras(p_string);
    input_palavras(s_string);
    input_palavras(t_string);

    index_carr = procura_carreiras(p_string);
    index_origem = procura_paragens(s_string);
    index_destino = procura_paragens(t_string);

    if (index_carr == FALSOINDEX){
        printf("%s: no such line.\n",p_string);
        return;
    }

    if (index_origem == FALSOINDEX){
        printf("%s: no such stop.\n",s_string);
        return;
    }

    if (index_destino == FALSOINDEX){
        printf("%s: no such stop.\n",t_string);
        return;
    }

    in = scanf("%lf %lf",&custo,&duracao);
        if (in != 2)
            return;

    if (custo < 0 || duracao < 0){
        printf("negative cost or duration.\n");
        return;
    }

    /*adiciona as duas paragens para a lista das paragens da carreira*/
    if (cont_indv_paragens[index_carr] == 0){
        aux_nova_ligacao(index_carr,index_origem,index_destino,duracao,custo);
    }

    /*cria uma carreira circular*/
    else if (index_destino == v_carreiras[index_carr].l_paragens[0] &&
        index_origem == v_carreiras[index_carr].l_paragens[cont_indv_paragens
        [index_carr] - 1]){
        lado = FIM;
        incrementador_lig(index_carr, index_destino, custo, duracao, lado);
    }   

    /*coloca a paragem no inicio da carreira e pucha o resto das paragens um 
    index para a frente*/
    else if (index_destino == v_carreiras[index_carr].l_paragens[0]){
        lado = INICIO;
        sobe_array(index_carr);
        incrementador_lig(index_carr, index_origem, custo, duracao, lado);
        v_paragens[index_origem].cont_carreiras++;
    }

    /*coloca a paragem no fim da carreira*/
    else if (index_origem == v_carreiras[index_carr].l_paragens
        [cont_indv_paragens[index_carr] - 1]){
        lado = FIM;
        incrementador_lig(index_carr, index_destino, custo, duracao, lado);
        v_paragens[index_destino].cont_carreiras++;
        }

    else printf("link cannot be associated with bus line.\n");

}

/*cria e lista paragens*/
void add_lista_paragens(){
    char p_string[COMP_NOME_PARAGEM];
    int i,existe = FALSE,num_inputs,barra;
    double ln,lt;
    localizacao loc;
    paragem par; 

    barra = input_palavras(p_string);    
   
    if (barra == TRUE){
        
        /*listar as paragens*/
        if (strlen(p_string) == 0){
            for (i = 0; i < cont_paragens; i++){
                printf("%s: %16.12f %16.12f %d\n",v_paragens[i].nome, 
                v_paragens[i].local.lon ,v_paragens[i].local.lat,v_paragens[i]
                .cont_carreiras); 
            }
        }
        
        /*mostrar a localização de uma paragem*/
        else {
            for (i = 0; i < cont_paragens; i++){
                if(strcmp(v_paragens[i].nome,p_string) == 0){
                    printf("%16.12f %16.12f\n",v_paragens[i].local.lon,
                    v_paragens[i].local.lat);
                    existe = TRUE;
                    break;
                }
            }

            if (existe == FALSE){
                printf("%s: no such stop.\n",p_string);
            }
        }
    }
    
    /*verifica se a paragem ja existe*/
    else {
        for (i = 0; i < cont_paragens; i++){
                if (strcmp(v_paragens[i].nome,p_string) == 0){
                    printf("%s: stop already exists.\n",p_string);
                    existe = TRUE;
                    break;
                }
        }

        /*criar nova paragens*/ 
        if (existe == FALSE){
            num_inputs = scanf("%lf %lf",&ln,&lt);
            if (num_inputs == 2){
                loc.lon = ln,loc.lat = lt;
                strcpy(par.nome,p_string);
                par.local = loc;
                v_paragens[cont_paragens] = par;
                v_paragens[cont_paragens].cont_carreiras = 0;
                cont_paragens++;
            }
        }
    }   
}

/*lista as carreiras*/
void aux_lista_carreiras(){
    int i;

    for (i = 0;i < cont_carreiras; i++){
            printf("%s ",v_carreiras[i].nome);
            if (cont_indv_paragens[i] != 0){
                printf("%s %s ",v_paragens[v_carreiras[i].l_paragens[0]].nome,
            v_paragens[v_carreiras[i].l_paragens[cont_indv_paragens[i] - 1]].
            nome);
            }
            printf("%d %.2f %.2f\n",cont_indv_paragens[i],v_carreiras[i].custo,
            v_carreiras[i].duracao);
    }
}

/*cira uma nova carreira*/
void aux_nova_carreira(char p_string[]){

    strcpy(v_carreiras[cont_carreiras].nome,p_string);
    v_carreiras[cont_carreiras].custo = 0;
    v_carreiras[cont_carreiras].duracao = 0;
    cont_carreiras++;
}

/*lista paragens*/
int aux_lista_paragens(char p_string[]){
    int i, j, existe = FALSE;

    for (i = 0;i < cont_carreiras; i++){
            if(strcmp(v_carreiras[i].nome,p_string) == 0){
                existe = TRUE;
                if (cont_indv_paragens[i] == 0)
                    return existe;
                for (j = 0;j < cont_indv_paragens[i]; j++){
                    if (j == (cont_indv_paragens[i] - 1))
                        printf("%s",v_paragens[v_carreiras[i].l_paragens[j]]
                        .nome);
                    
                    else printf("%s, ",v_paragens[v_carreiras[i].
                    l_paragens[j]].nome);
                }
                putchar('\n');
                break;
            }
        }
    return existe;
}

/*cria e lista carreiras*/
void add_lista_carreira(){
    char p_string[COMP_NOME_CARREIRA],s_string[COMP_NOME_CARREIRA];
    int i,j,barra,index_paragem,existe = FALSE,inv;

    barra = input_palavras(p_string);

    /*lista as carreiras*/
    if (strlen(p_string) == 0){
        aux_lista_carreiras();
    }

    /*lista as paragens pela sequencia normal*/
    else if (barra == TRUE){
        existe = aux_lista_paragens(p_string);

        /*cria um nova carreira*/
        if (existe == FALSE){
            aux_nova_carreira(p_string);
        }
    }
    /*lista as paragens pela sequencia inversa*/
    else {
        input_palavras(s_string);
        inv = FALSE;
        inv = inverso_autenticator(s_string);

        if (inv == TRUE){
            for (i = 0;i < cont_carreiras; i++){
                if(strcmp(v_carreiras[i].nome,p_string) == 0){
                    if (cont_indv_paragens[i] == 0)
                        return;
                    for (j = (cont_indv_paragens[i] - 1);j >= 0; j--){
                        index_paragem = v_carreiras[i].l_paragens[j];
                        if (j == 0){
                            printf("%s",v_paragens[index_paragem].nome);
                        }
                        else printf("%s, ",v_paragens[index_paragem].nome);
                    }
                    break;
                }
            }
            putchar('\n');
        }
        else {
            printf("incorrect sort option.\n");
        }
    }
}

/*lista os nós de interligação*/
void lista_interacoes(){
    int i,j,k,lista_carreiras[MAX_CAR],cont = 0;

    for (i = 0; i < cont_paragens; i++){
        if (v_paragens[i].cont_carreiras > 1){
        printf("%s %d:",v_paragens[i].nome,v_paragens[i].cont_carreiras);
        for (j = 0; j < cont_carreiras; j++){
            for (k = 0; k < cont_indv_paragens[j]; k++){
                if (v_carreiras[j].l_paragens[k] == i){
                    lista_carreiras[cont++] = j;
                    break;
                }   
            }
        }
        sort_lista(lista_carreiras, cont);
        putchar('\n');
        cont = 0;
        }
    }
}

/*verifica o primeiro input para executar os comandos*/
int main(){
    char c;
    while((c = getchar()) != EOF){
        switch (c){
            case ('q'):
                return 0;
                break;
        
            case ('c'):
                add_lista_carreira();
                break;

            case ('p'):
                add_lista_paragens();
                break;

            case ('l'):
                add_lista_ligacoes();
                break;

            case ('i'):
                lista_interacoes();
                break;

            default:
                break;
        }
    }   
return 0;
}