; *********************************************************************
; * PROJETO DE IAC
; * Grupo 57
; * Realizado por: 
; * - João Santos ist1107365
; * - Alexandre Umbelino ist199175
; * - Guilherme Henriques ist103403
; *********************************************************************

; *********************************************************************
; Funcionamento das teclas:
; Tecla 0: lança uma sonda para a esquerda;
; Tecla 1: lança uma sonda em frente;
; Tecla 2: lança uma sonda para a direita;
; Tecla C: começa o jogo;
; Tecla D: suspende/continua o jogo;
; Tecla E: termina o jogo.
; **********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************

; endereços de memória do media center
COMANDOS				EQU	6000H			    ; endereço de base dos comandos do MediaCenter
DEFINE_LINHA    		EQU COMANDOS + 0AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU COMANDOS + 0CH	    ; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU COMANDOS + 12H	    ; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU COMANDOS + 40H	    ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 			EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
CENARIO_FRONTAL         EQU COMANDOS + 46H      ; endereço do comando para selecionar uma imagem frontal
APAGA_CENARIO_FRONTAL   EQU COMANDOS + 44H      ; endereço do comando para apagar a imagem frontal
TOCA_SOM				EQU COMANDOS + 5AH		; endereço do comando para tocar um som
DISPLAY_VALOR           EQU 100                 ; valor inicial do display (100)
DISPLAYS                EQU 0A000H              ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN                 EQU 0C000H              ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL                 EQU 0E000H              ; endereço das colunas do teclado (periférico PIN)

; teclas
TECLA_0		        	EQU 	00H	    ; tecla para disparar sonda da esquerda
TECLA_1		        	EQU 	01H	    ; tecla para disparar sonda do meio        
TECLA_2			        EQU 	02H	    ; tecla para disparar sonda da direita
TECLA_C			        EQU 	0CH		; tecla na primeira coluna do teclado (tecla C)
TECLA_D			        EQU 	0DH		; tecla na segunda coluna do teclado (tecla D)
TECLA_E			        EQU     0EH		; tecla na terceira coluna do teclado (tecla E)

; asteróides
N_ASTEROIDES            EQU 4
POSICAO_NAO_DISPONIVEL  EQU 1
POSICAO_DISPONIVEL      EQU 0

COLIDIU                 EQU 1
NAO_COLIDIU             EQU 0

ASTEROIDE_MINERAVEL     EQU 0H          ; um dos valores associados a um asteroide não mineravel
MASCARA_ASTEROIDES      EQU 11H         ; mascara para isolar os dois bits de menor peso

LINHA_LIMITE_ASTEROIDE  EQU 31	     	; linha fora do ecrã

LARGURA_ASTEROIDE	    EQU	5		    ; largura do boneco
ALTURA_ASTEROIDE	    EQU	5		    ; altura do boneco
LARGURA_PAINEL          EQU	15		    ; largura do painel
ALTURA_PAINEL           EQU	5  		    ; altura do painel

LINHA_INICIO            EQU  0        	; linha do asteroide
COLUNA_INICIO           EQU  0        	; coluna do asteroide
COLUNA_FIM              EQU  59        	; coluna do fim

; direções
DIAGONAL_ESQUERDA       EQU -1          ; direção para a esquerda
VERTICAL                EQU  0          ; direção vetical
DIAGONAL_DIREITA        EQU  1          ; direção para a direita

; algumas noções do ecrã
COLUNA_ESQUERDA         EQU  0          ; coluna do inicio
COLUNA_MEIO             EQU  28         ; coluna do meio
COLUNA_DIREITA          EQU  59         ; coluna do fim

; sonda
LINHA_SONDA				EQU  28			; linha inicial da sonda
COLUNA_SONDA_ESQUERDA	EQU  26			; coluna da sonda da esquerda
COLUNA_SONDA_MEIO       EQU  30         ; coluna da sonda do meio
COLUNA_SONDA_DIREITA    EQU  35         ; coluna da sonda da direita
LINHA_LIMITE_SONDA      EQU  14         ; linha limite da sonda
LARGURA_SONDA 			EQU  1			;
ALTURA_SONDA 			EQU  1			;

; painel
LINHA_PAINEL			EQU  27			; linha do painel
COLUNA_PAINEL			EQU  23        	; coluna do painel

LIMITE_ESQUERDA_PAINEL  EQU  22         ; coluna limite do painel
LIMITE_DIREITA_PAINEL   EQU  36         ; coluna limite do painel
LIMITE_SUPERIOR_PAINEL  EQU  22         ; linha limite do painel

; sons
SOM_SONDA               EQU  0          ; som da sonda
SOM_ASTEROIDE           EQU  1          ; som do asteroide
SOM_MINERAVEL           EQU  2          ; som do asteroide mineravel
SOM_GAME_OVER           EQU  3          ; som do game over

; energia 
ENERGIA_ABSORCAO        EQU  25
ENERGIA_FUNCIONAMENTO   EQU  3
ENERGIA_SONDA_LANCADA   EQU  5

; cores
COR_CASTANHA_1          EQU 0F500H
COR_CASTANHA_2          EQU 0F900H
COR_VERMELHA_1          EQU 0FC24H
COR_VERMELHA_2          EQU 0FC34H
COR_VERMELHA_3          EQU 0FF22H
COR_VERMELHA_4          EQU 0FF23H
COR_VERMELHA            EQU 0FF00H
COR_VERDE               EQU 0F0F0H
COR_AZUL                EQU 0A00EH

COR_AZUL_1              EQU 0F005H
COR_AZUL_2              EQU 0F0FFH
COR_CINZENTA_1          EQU 0F444H
COR_CINZENTA_2          EQU 0F777H
COR_AMARELA             EQU 0FFF0H
COR_LILAS               EQU 0FB8BH


; outros
MASCARA                 EQU 0FH         ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
STACK_SIZE              EQU 100H
DC                      EQU 10          ; divisor para display
HX                      EQU 16          ; multiplicador para display


; *********************************************************************************
; * DADOS 
; *********************************************************************************

	PLACE 1000H
pilha:
	STACK STACK_SIZE	; espaço reservado para a pilha 
						; (100H bytes, pois são 100H words)
SP_inicial:				; este é o endereço (1000H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 10FEH (1100H-2)

    STACK STACK_SIZE
SP_inicial_prog_princ:

    STACK STACK_SIZE
SP_inicial_teclado:

    STACK STACK_SIZE
SP_inicial_energia:

    STACK STACK_SIZE * N_ASTEROIDES
SP_inicial_asteroide:

    STACK STACK_SIZE
SP_inicial_painel:

    STACK STACK_SIZE 
SP_inicial_sonda_1:

    STACK STACK_SIZE
SP_inicial_sonda_2:

    STACK STACK_SIZE
SP_inicial_sonda_3:

    STACK STACK_SIZE
SP_inicial_estado:

DEF_ASTEROIDE_NAO_MINERAVEL:

	WORD		LARGURA_ASTEROIDE, ALTURA_ASTEROIDE
    WORD		0 , COR_VERMELHA_2, COR_VERMELHA_3, COR_VERMELHA_4, 0 ;          # # #   
	WORD 		COR_VERMELHA_1, COR_VERMELHA_1, COR_VERMELHA_2, COR_VERMELHA_3, COR_VERMELHA_4 ;           # #    
    WORD		COR_CASTANHA_2, COR_CASTANHA_2, COR_VERMELHA_1, COR_VERMELHA_2, COR_VERMELHA_3 ;  #   #   
    WORD 		COR_CASTANHA_1, COR_CASTANHA_1, COR_CASTANHA_2, COR_VERMELHA_1, COR_VERMELHA_3 ;           # #    
	WORD		0, COR_CASTANHA_1, COR_CASTANHA_2, COR_VERMELHA_1, 0 ;          # # #   

DEF_ASTEROIDE_MINERAVEL:

	WORD		LARGURA_ASTEROIDE, ALTURA_ASTEROIDE
    WORD		0 , COR_VERMELHA_2, COR_VERMELHA_3, COR_VERMELHA_4, 0 ;          # # #   
	WORD 		COR_VERMELHA_1, COR_VERMELHA_1, COR_VERMELHA_2, COR_VERMELHA_3, COR_VERMELHA_4 ;           # #    
    WORD		COR_CASTANHA_2, COR_CASTANHA_2, COR_VERDE, COR_VERMELHA_2, COR_VERMELHA_3 ;  #   #   
    WORD 		COR_CASTANHA_1, COR_CASTANHA_1, COR_CASTANHA_2, COR_VERMELHA_1, COR_VERMELHA_3 ;           # #    
	WORD		0, COR_CASTANHA_1, COR_CASTANHA_2, COR_VERMELHA_1, 0 ;          # # #   

DEF_ASTEROIDE_NAO_MINERAVEL_DESTRUIDO:

	WORD		LARGURA_ASTEROIDE, ALTURA_ASTEROIDE
    WORD		0 , COR_AZUL, 0, COR_AZUL, 0 ;          #  #   
	WORD 		COR_AZUL, 0, COR_AZUL, 0, COR_AZUL ;           # #    
    WORD		COR_AZUL, COR_AZUL, COR_AZUL, COR_AZUL, COR_AZUL ;     #   #   
    WORD 		COR_AZUL, 0, COR_AZUL, 0, COR_AZUL ;           # #    
	WORD		0, COR_AZUL, 0, COR_AZUL, 0 ;          # # #       

DEF_ASTEROIDE_MINERAVEL_DESTRUIDO:

	WORD		LARGURA_ASTEROIDE, ALTURA_ASTEROIDE
    WORD		0, 0, 0, 0, 0 ;          # # #   
	WORD 		0, 0, COR_VERMELHA_2, 0, 0 ;           # #    
    WORD		0, COR_CASTANHA_2, COR_VERMELHA_1, COR_VERMELHA_2, 0 ;          #   #   
    WORD 		0, 0, COR_CASTANHA_2, 0, 0 ;           # #    
	WORD		0, 0, 0, 0, 0 ;          # # #       


DEF_PAINEL:

	WORD		LARGURA_PAINEL, ALTURA_PAINEL	
    WORD		0, 0, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, 0, 0
	WORD		0, COR_AZUL_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_LILAS, COR_AZUL_1,0
	WORD		COR_AZUL_1, COR_CINZENTA_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_AMARELA, COR_VERMELHA, COR_VERDE, COR_AZUL_1, COR_VERDE, COR_AZUL_2, COR_AMARELA, COR_CINZENTA_2, COR_LILAS, COR_LILAS, COR_AZUL_1			
    WORD		COR_AZUL_1, COR_CINZENTA_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_VERDE, COR_AZUL_1, COR_AZUL_2, COR_VERMELHA, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_LILAS, COR_AZUL_1		
	WORD		COR_AZUL_1, COR_CINZENTA_1, COR_CINZENTA_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_LILAS, COR_AZUL_1; 


DEF_PAINEL_V1:

	WORD		LARGURA_PAINEL, ALTURA_PAINEL	
    WORD		0, 0, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, 0, 0
	WORD		0, COR_AZUL_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_LILAS, COR_AZUL_1,0
	WORD		COR_AZUL_1, COR_CINZENTA_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_AZUL_1, COR_VERMELHA, COR_AZUL_2, COR_AZUL_1, COR_VERDE, COR_AZUL_1, COR_AZUL_1, COR_CINZENTA_2, COR_LILAS, COR_LILAS, COR_AZUL_1			
    WORD		COR_AZUL_1, COR_CINZENTA_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_VERDE, COR_AZUL_1, COR_VERMELHA, COR_VERDE, COR_AMARELA, COR_AZUL_2, COR_AZUL_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_LILAS, COR_AZUL_1		
	WORD		COR_AZUL_1, COR_CINZENTA_1, COR_CINZENTA_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_LILAS, COR_AZUL_1; 


DEF_PAINEL_V2:

	WORD		LARGURA_PAINEL, ALTURA_PAINEL	
    WORD		0, 0, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, COR_AZUL_1, 0, 0
	WORD		0, COR_AZUL_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_LILAS, COR_AZUL_1,0
	WORD		COR_AZUL_1, COR_CINZENTA_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_AZUL_1, COR_VERMELHA, COR_VERDE, COR_AZUL_1, COR_VERDE, COR_VERMELHA, COR_AMARELA, COR_CINZENTA_2, COR_LILAS, COR_LILAS, COR_AZUL_1			
    WORD		COR_AZUL_1, COR_CINZENTA_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_VERDE, COR_AZUL_1, COR_AZUL_2, COR_VERMELHA, COR_AMARELA, COR_AZUL_2, COR_AZUL_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_LILAS, COR_AZUL_1		
	WORD		COR_AZUL_1, COR_CINZENTA_1, COR_CINZENTA_1, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_CINZENTA_2, COR_LILAS, COR_AZUL_1; 


DEF_SONDA:
	WORD 		LARGURA_SONDA, ALTURA_SONDA
	WORD		COR_VERDE

DEF_ENERGIA:
    WORD        DISPLAY_VALOR

; Tabela com as possiveis variaçoes de direção e colunas de inicio dos asteroides
POSICOES_SONDAS:
    WORD        LINHA_INICIO, COLUNA_ESQUERDA, NAO_COLIDIU
    WORD        LINHA_INICIO, COLUNA_MEIO, NAO_COLIDIU
    WORD        LINHA_INICIO, COLUNA_DIREITA, NAO_COLIDIU

DEF_GERA_ASTEROIDE_ALEATORIO:
    WORD        POSICAO_DISPONIVEL, COLUNA_INICIO, DIAGONAL_DIREITA 
    WORD        POSICAO_DISPONIVEL, COLUNA_MEIO, DIAGONAL_ESQUERDA
    WORD        POSICAO_DISPONIVEL, COLUNA_MEIO, VERTICAL
    WORD        POSICAO_DISPONIVEL, COLUNA_MEIO, DIAGONAL_DIREITA
    WORD        POSICAO_DISPONIVEL, COLUNA_FIM, DIAGONAL_ESQUERDA

tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
    WORD rot_int_1			; rotina de atendimento da interrupção 1
    WORD rot_int_2			; rotina de atendimento da interrupção 2
    WORD rot_int_3			; rotina de atendimento da interrupção 3

evento_int_painel:
    LOCK 0

evento_int_asteroides:			; LOCKs 
	LOCK 0				; LOCK para a rotina de interrupção 0

evento_int_sonda:
    LOCK 0

evento_int_energia:
    LOCK 0

evento_int_estado_jogo:
    LOCK 0

evento_int_tecla_sonda1:
    LOCK 0

evento_int_tecla_sonda2:
    LOCK 0

evento_int_tecla_sonda3:
    LOCK 0

tecla_carregada:
    LOCK 0

estado_de_jogo:
	WORD 0				; tecla pressionada
	WORD 0				; ESTADO

reset:
    WORD 0              ; se é preciso fazer reset dos asteroides quando se perde o jogo(0 nao é preciso, 1 é preciso)

; *********************************************************************************
; * Código
; *********************************************************************************

PLACE 0

inicializações:
	MOV  SP, SP_inicial		            ; inicializa SP para a palavra a seguir à última da pilha
    MOV  BTE, tab                       ; inicializa BTE (registo de Base da Tabela de Exceções)
    MOV [APAGA_AVISO], R1	            ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV [APAGA_ECRÃ], R1	            ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	R1, 1			                ; cenário de fundo número 0
    MOV [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
    MOV R1, 0                           ; cenário frontal número 0
    MOV [APAGA_CENARIO_FRONTAL], R1     ; Limpa o cenario frontal
    MOV [CENARIO_FRONTAL], R1	        ; seleciona o cenário de fundo


    EI0                     ; enable da interrupção 0 ou interrupção dos asteroides
    EI1                     ; enable da interrupção 1 ou interrupção das sondas
    EI2                     ; enable da interrupção 2 ou do display da energia
    EI3                     ; enable da interrupção 3 ou do painel da nave
    EI                      ; enable das interrupções gerais

    CALL estado_jogo
    CALL energia
    CALL teclado
    CALL painel
    CALL sonda_1
    CALL sonda_2
    CALL sonda_3


gera_asteroides:
	MOV	R11, N_ASTEROIDES	; número de bonecos a usar (até 4)
loop_asteroides:
	SUB	R11, 1			    ; próximo boneco
	CALL	asteroide       ; cria uma nova instância do processo boneco (o valor de R11 distingue-as)
						    ; Cada processo fica com uma cópia independente dos registos
	CMP  R11, 0			    ; já criou as instâncias todas?
    JNZ	loop_asteroides     ; se não, continua


funcao_tecla:
    MOV R1, [tecla_carregada]   ; fica bloqueado até uma tecla ser premida

    CMP R1, 0                   ; compara para ver se a tecla premida é o 0 que, se sim move a sonda para a esquerda 
    JNZ tecla_sonda2
    MOV [evento_int_tecla_sonda1], R1
    JMP funcao_tecla

tecla_sonda2:
    CMP R1, 1                   ; compara para ver se a tecla premida é o 1 que, se sim move a sonda para o meio
    JNZ tecla_sonda3
    MOV [evento_int_tecla_sonda2], R1
    JMP funcao_tecla

tecla_sonda3:
    CMP R1, 2                   ; compara para ver se a tecla premida é o 2 que, se sim move a sonda para a direita
    JNZ tecla_comeco
    MOV [evento_int_tecla_sonda3], R1
    JMP funcao_tecla

tecla_comeco:
    MOV R2, TECLA_C
    CMP	R1, R2		    ; é a coluna da tecla C?
	JNZ	tecla_pausa
	MOV [estado_de_jogo], R1
	MOV [evento_int_estado_jogo], R1
	JMP	funcao_tecla
tecla_pausa:	
    MOV R2, TECLA_D
	CMP	R1, R2  		                ; é a coluna da tecla D?
	JNZ	tecla_fim		                ; se não, ignora a tecla e espera por outra
	MOV [estado_de_jogo], R1
	MOV [evento_int_estado_jogo], R1
	JMP funcao_tecla	                ; processo do programa principal nunca termina
tecla_fim:	
    MOV R2, TECLA_E
	CMP	R1, R2		                    ; é a coluna da tecla D?
	JNZ	funcao_tecla	                ; se não, ignora a tecla e espera por outra
	MOV [estado_de_jogo], R1
	MOV [evento_int_estado_jogo], R1
	JMP	funcao_tecla	                ; processo do programa principal nunca termina


; **********************************************************************
; painel: processo encarrege em mudar as cores do painel
;
; **********************************************************************

PROCESS SP_inicial_painel

painel:
    MOV R1, LINHA_PAINEL              ; linha do painel
    MOV R2, COLUNA_PAINEL             ; coluna do painel
    MOV R4, DEF_PAINEL                ; tabela que define o boneco
    CALL desenha_boneco

painel_ciclo:

    YIELD

    MOV R0, [evento_int_painel]       ; LOCK do processo do painel
    
    MOV R11, [estado_de_jogo + 2]     ; estado de jogo
    MOV R10, 1                        ; estado de jogo 1
    CMP R11, R10                      ; compara o estado de jogo com o estado de jogo 1
    JNZ painel_ciclo                  ; se não for igual, continua o ciclo
    
    MOV R4, DEF_PAINEL_V1             ; tabela que define o boneco modificado
    CALL desenha_boneco

    MOV R0, [evento_int_painel]       ; LOCK do processo do painel

    MOV R11, [estado_de_jogo + 2]     ; estado de jogo
    MOV R10, 1                        ; estado de jogo 1
    CMP R11, R10                      ; compara o estado de jogo com o estado de jogo 1
    JNZ painel_ciclo

    MOV R4, DEF_PAINEL_V2             ; tabela que define o boneco modificado
    CALL desenha_boneco

    MOV R0, [evento_int_painel]

    MOV R11, [estado_de_jogo + 2]     ; estado de jogo
    MOV R10, 1                        ; estado de jogo 1
    MOV R11, R10                      ; compara o estado de jogo com o estado de jogo 1
    JNZ painel_ciclo

    MOV R4, DEF_PAINEL
    CALL desenha_boneco
    JMP painel_ciclo


; **********************************************************************
; TECLADO - Rotina de interrupção para tratamento das teclas premidas
; Argumentos:
;               R4 - tabela que define o boneco
;               R10 - DISPLAY 
;
; **********************************************************************
 

PROCESS SP_inicial_teclado

teclado:
    MOV  R2, TEC_LIN            ; endereço do periférico das linhas
    MOV  R3, TEC_COL            ; endereço do periférico das colunas
    MOV  R4, DISPLAYS           ; endereço do periférico dos displays
    MOV  R5, MASCARA            ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV  R6, 1                  ; valor da linha inicial


espera_tecla:                   ; neste ciclo espera-se até uma tecla ser premida

    YIELD

    MOV  R1, R6
    MOVB [R2], R1	            ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]               ; ler do periférico de entrada (colunas)
    AND  R0, R5                 ; elimina bits para além dos bits 0-3
    CMP  R0, 0                  ; há tecla premida?
    JZ   muda_linha             ; muda linha se nehuma tecla estiver pressionada

    CALL converter              ; converte a linha e a coluna

    MOV [tecla_carregada], R7   ; guarda no tecla_carregada o valor da tecla carregada e desbloqueia o lock


ha_tecla:                       ; neste ciclo espera-se até NENHUMA tecla estar premida

    YIELD

    MOVB R0, [R3]               ; ler do periférico de entrada (colunas)
    AND  R0, R5                 ; elimina bits para além dos bits 0-3
    CMP  R0, 0                  ; há tecla premida?
    JNZ  ha_tecla               ; se ainda houver uma tecla premida, espera até não haver
    SHL R6, 1                   ; Dobra o valor atual de R6
    MOV R9, 16                  ; armaneza o valor 16 no registo 9
    CMP R6, R9                  ; Compara R6 com R9
    JNZ espera_tecla            ; se R6 != 16, sai da função teclado
    MOV R6, 1                   ; Reinicia R6 para 1 
    JMP espera_tecla

muda_linha:
    SHL R6, 1                   ; dobra o valor atual de R6
    MOV R9, 10H                 ; armazena o valor 16 (10 em hexadecimal) no registo 9
    CMP R6, R9                  ; Compara R6 com R9
    JNZ espera_tecla            ; Se R6 != 16, vai para o ciclo_teclado
    MOV R6, 1          
    JMP espera_tecla

JMP espera_tecla


; **********************************************************************
; estado_jogo - define estado de jogo
;
; **********************************************************************
PROCESS	SP_inicial_estado

estado_jogo:

	MOV R10, [evento_int_estado_jogo]   ; Lock da tecla de estado
	MOV R10, [estado_de_jogo + 2]		; Estado atual do jogo
    MOV R9, 0                           ; Estado de jogo inicio
    CMP R10, R9                         ; Compara o estado atual com o estado inicio
    JNZ in_game_state                   ; Se não for igual, vai para o estado in_game
    MOV R10, [estado_de_jogo]           ; tecla pressionada
    MOV R9, 0CH                         ; tecla C
    CMP R10, R9                         ; Compara a tecla pressionada com a tecla C
    JNZ estado_jogo                     ; Se não for igual, volta para o estado inicio
    MOV R0, 4                           ; som de comeco
    MOV [TOCA_SOM], R0                  ; toca o som de comeco
    MOV R9, 1                           ; Estado de jogo in_game
    MOV [estado_de_jogo + 2], R9        ;
    MOV [APAGA_CENARIO_FRONTAL], R9     ; Atualiza o cenario frontal
    JMP estado_jogo                     ; Volta para o estado inicio

in_game_state:

    MOV R9, 0                           ; Estado nao ser preciso reiniciar o jogo
    MOV [reset], R9                     ; Atualiza o reset
	MOV R9, 1                           ; Estado de jogo in_game
	CMP R10, R9                         ; Compara o estado atual com o estado in_game
	JNZ pause_state                     ; Se não for igual, vai para o estado pause
	MOV R10, [estado_de_jogo]           ; tecla pressionada
	MOV R9, 0DH                         ; tecla D
	CMP R10, R9                         ; Compara a tecla pressionada com a tecla D
	JZ pause_game                       ; Se for igual, vai para o estado pause
	MOV R9, 0EH                         ; tecla E
    CMP R10, R9                         ; Compara a tecla pressionada com a tecla E
    JZ  stop_game                       ; Se for igual, vai para o estado stop
    JMP estado_jogo                     ; Se não for igual, volta para o estado in_game

pause_game:
    MOV R9, 5                           ; som de pausa
    MOV [TOCA_SOM], R9                  ; toca o som de pausa
    MOV R0, 2
    MOV [CENARIO_FRONTAL], R0           ; Limpa o cenario frontal
    MOV R10, 2                          ; Estado de jogo pause
    MOV [estado_de_jogo + 2], R10       ; Guarda o estado de jogo pause
    JMP estado_jogo                     ; volta ao ciclo

stop_game:
    MOV R10, SOM_GAME_OVER
    MOV [TOCA_SOM], R10                 ; Toca o som de game over
    MOV R10, 3                          ; Estado de jogo END
    MOV [APAGA_ECRÃ], R10               ; Limpa o ecrã
    MOV [estado_de_jogo + 2], R10       ; Guarda o estado de jogo END
    CALL acaba_jogo                     ; Chama a rotina acaba_jogo
    JMP estado_jogo                     ; volta ao ciclo

pause_state:
	MOV R9, 2                           ; Estado de jogo pause
	CMP R10, R9                         ; Compara o estado atual com o estado pause
	JNZ stop_state                      ; Se não for igual, vai para o estado stop
	MOV R10, [estado_de_jogo]           ; tecla pressionada
	MOV R9, 0DH                         ; tecla D
	CMP R10, R9                         ; Compara a tecla pressionada com a tecla D
    JZ  resume_game                     ; Se for igual, vai para o estado in_game
	MOV R9, 0EH                         ; tecla E
    CMP R10, R9                         ; Compara a tecla pressionada com a tecla E
    JZ  stop_game                       ; Se for igual, vai para o estado stop
    JMP estado_jogo

resume_game:
    MOV R9, 5                           ; som de pausa
    MOV [TOCA_SOM], R9                  ; toca o som de pausa
    MOV R9, 2                           ; Estado de jogo pause
	CMP R10, R9                         ; Compara o estado atual com o estado pause
    MOV R0, 2
    MOV [APAGA_CENARIO_FRONTAL], R0     ; Limpa o cenario frontal
    MOV R10, 1                          ; Estado de jogo in_game
    MOV [estado_de_jogo + 2], R10       ; Guarda o estado de jogo in_game
    JMP estado_jogo                     ; volta ao ciclo

stop_state:
    MOV R9, 3                           ; Estado de jogo END
    CMP R10, R9                         ; Compara o estado atual com o estado END
    JNZ estado_jogo                     ; Se não for igual, volta para o ciclo
    MOV R10, [estado_de_jogo]           ; tecla pressionada
	MOV R9, 0CH                         ; tecla C
	CMP R10, R9                         ; Compara a tecla pressionada com a tecla C
    JZ  restart_game                    ; Se for igual, vai para o restart_game
	JMP estado_jogo                     ; volta para o ciclo


restart_game:
    MOV R10, 1                          ; Estado de jogo in_game
    MOV [estado_de_jogo + 2], R10       ; Guarda o estado de jogo in_game
    CALL reinicia_jogo                  ; Vai para o inicio do jogo
    JMP estado_jogo                     ; volta ao ciclo
    

; **********************************************************************
; asteroide: processo que mantem os asteroides, verifica se estão entre os limites
;          e desenha na proxima posição, conforme as interrupções associadas ao
;          relógia dos asteroides
;
; **********************************************************************


PROCESS SP_inicial_asteroide

asteroide:				; processo que implementa o comportamento do boneco
	MOV	R1, STACK_SIZE	; tamanho em palavras da pilha de cada processo
	MUL	R1, R11			; TAMANHO_PILHA vezes o nº da instância do "boneco"
	SUB	SP, R1		    ; inicializa SP deste "boneco" (antes de subtrair já tinha sido inicializado com SP_inicial_boneco)
						; A instância 0 fica na mesma, e as seguintes vão andando para trás,
						; até esgotar todo o espaço de pilha reservado para os processos "boneco"

gera_asteroide:
	; desenha o boneco na sua posição inicial
	MOV R1, LINHA_INICIO         
    CALL gera_tipo_asteroide    ; escolhe um tipo de asteroide de forma pseudo-aletória (em R4 o endereco do tipo)
    CALL gera_posicao_aleatoria ; gera uma coluna e uma direção de forma pseudo-aletória(output em R2, linha, em R7 a direção)
    MOV R10, ALTURA_ASTEROIDE   ; guarda um contador

ciclo_asteroide:

    CALL verifica_disponibilidade
    CALL desenha_boneco
	MOV  R9, evento_int_asteroides
	MOV  R3, [R9]	     	        ; lê o LOCK desta instância bloqueia até a rotina de interrupção
    
    MOV R11, [estado_de_jogo + 2]
    MOV R9, 3
    CMP R11, R9
    JNZ ciclo_asteroide_2
    CALL limpa_disponibilidade
    JMP gera_asteroide

ciclo_asteroide_2:

    MOV R11, [estado_de_jogo + 2]
    MOV R9, 1
    CMP R11, R9
    JNZ ciclo_asteroide

	CALL	apaga_boneco	         ; apaga o boneco na sua posição corrente
	
    INC R1                           ; aumenta a linha
    ADD R2, R7                       ; muda a direção
	MOV	R6, [R4]			         ; obtém a largura do boneco
    MOV R8, [R4 + 2]                 ; obtém a altura do boneco
    CALL verifica_colisao_ast_painel ; verifica se colidiu com o painel
    MOV R3, LINHA_LIMITE_ASTEROIDE   ; linha limite do asteroide
    CMP R1, R3                       ; verifica se já excedeu o limite
    JGE gera_asteroide               ; se ja chegou ao limite vai para o inicializador da sonda
    CALL desenha_boneco              ; desenha o asteroide
    CALL verifica_colisao_sonda      ; verifica se colidiu com a sonda
    MOV R3, COLIDIU                  ; endereco da variavel que indica se colidiu
    CMP R11, R3                      ; verifica se colidiu
    JNZ ciclo_asteroide              ; se não colidiu, volta ao ciclo
    JMP asteroide_explosao           ; se colidiu, vai para o ciclo de explosão
    JMP ciclo_asteroide

asteroide_explosao:
    CALL apaga_boneco                ; apaga o asteroide
    MOV R9, DEF_ASTEROIDE_MINERAVEL  ; endereco do tipo de asteroide mineravel
    CMP R4, R9                       ; verifica se é mineravel
    JNZ asteroide_explosao_nao_mineravel ; se não for mineravel, vai para o ciclo de explosão não mineravel
    CALL incrementa_energia_mineravel ; se for mineravel, incrementa a energia
    JMP asteroide_explosao_mineravel ; vai para o ciclo de explosão mineravel


asteroide_explosao_mineravel:

    MOV R4, SOM_MINERAVEL
    MOV [TOCA_SOM], R4
    MOV  R4, DEF_ASTEROIDE_MINERAVEL_DESTRUIDO  ; endereco do tipo de asteroide mineravel destruido
    CALL desenha_boneco                         ; desenha o asteroide destruido
    
    MOV  R9, evento_int_asteroides              ; espera pela interrupção
    MOV  R3, [R9]	     	                    ; lê o LOCK desta instância bloqueia até a rotina de interrupção
    
    CALL apaga_boneco                           ; apaga o asteroide destruido
    JMP gera_asteroide                          ; volta para o gera asteroide

asteroide_explosao_nao_mineravel:  

    MOV R4, SOM_ASTEROIDE
    MOV [TOCA_SOM], R4
    MOV  R4, DEF_ASTEROIDE_NAO_MINERAVEL_DESTRUIDO  ; endereco do tipo de asteroide não mineravel destruido
    CALL desenha_boneco                             ; desenha o asteroide destruido
    
	MOV  R9, evento_int_asteroides              ; espera pela interrupção
	MOV  R3, [R9]	     	                    ; lê o LOCK desta instância bloqueia até a rotina de interrupção
    
    CALL apaga_boneco                           ; apaga o asteroide destruido
    JMP gera_asteroide                          ; volta para o gera asteroide
    



; **********************************************************************
; gera_posicao_aleatoria: gera um numero de 0 a 4 a partir da output do teclado 
;
; Argumentos Saida - R2 - Coluna inicial
;                    R7 - Direção do asteroide
;
; **********************************************************************


gera_posicao_aleatoria:
    PUSH R1
    PUSH R3
    PUSH R10
    PUSH R11
posicao_aletoria_ciclo:
    MOV  R2, [TEC_LIN]              ; endereço do periférico das linhas
    SHR  R2, 4                      ; passa os 4 bits aleatorios para o lower nible
    MOV  R3, 5                      ; valor de possiveis posições/direções de asteroides
    MOD  R2, R3                     ; faz o resto da divisão inteira por 5
    MOV  R11, 6
    MUL  R2, R11                    ; multiplica por 6 porque a tabela é constituida por 3 word
    MOV  R5, DEF_GERA_ASTEROIDE_ALEATORIO ; move o endereço da tabela das possibilidades dos asteroides
    ADD  R5, R2                     ; adiciona ao endereço para chegar a posição certa
    MOV  R1, [R5]                   ; vê se esta disponivel a localização
    MOV  R10, POSICAO_DISPONIVEL
    CMP  R1, R10                    ; vê se está disponivel
    JNZ  posicao_aletoria_ciclo     ; salta se nao estiver disponivel até encontrar um disponivel
    MOV  R3, POSICAO_NAO_DISPONIVEL
    MOV  [R5], R3                   ; coloca o estado para usado
    MOV  R2, [R5 + 2]               ; retira a coluna inicial
    MOV  R7, [R5 + 4]               ; retira a direção do asteroide
    POP  R11
    POP  R10
    POP  R3
    POP  R1
    RET


; **********************************************************************
; gera_tipo_asteroide: escolhe um tipo de asteroide (mineravel ou não mineravel)
;
; Argumentos Saida - R4 - tabela do asteroide (mineravel ou não mineravel)
;
; **********************************************************************


gera_tipo_asteroide:
    PUSH R2
    PUSH R3
    PUSH R5
    PUSH R11

    MOV  R2, [TEC_LIN]              ; endereço do periférico das linhas 
    SHR  R2, 4                      ; passa os 4 bits aleatorios para o lower nible
    MOV  R3, MASCARA_ASTEROIDES
    AND  R2, R3                     ; isola os dois ultimos bits 
    MOV  R3, ASTEROIDE_MINERAVEL    ; valor do asteroide mineravel
    CMP  R2, R3                     ; vê se o asteroide vai ser mineravel ou nao
    JZ   mineravel
    MOV  R4, DEF_ASTEROIDE_NAO_MINERAVEL; passa o enderço da tabela do asteroide nao mineravel
    JMP tipo_return
mineravel:
    MOV  R4, DEF_ASTEROIDE_MINERAVEL 

tipo_return:
    POP R11
    POP R5
    POP R3
    POP R2
    RET


; **********************************************************************
; incrementa_energia_mineravel: incrementa a energia em 25
;
; **********************************************************************
incrementa_energia_mineravel:
    PUSH R1
    PUSH R2
    
    MOV R1, ENERGIA_ABSORCAO        ; valor a incrementar a energia
    MOV R2, [DEF_ENERGIA]           ; carrega valor da energia
    ADD R2, R1                      ; soma os dois
    MOV [DEF_ENERGIA], R2           ; guarda o valor
    CALL conversao_hexadecimal      ; converte o novo valor para o display
    MOV R4, DISPLAYS
    MOV [R4], R2                    ; atualiza os displays

    POP R2
    POP R1
    RET
; **********************************************************************
; verifica_colisao_sonda: verifica se o asteroide colidiu com a
;
; **********************************************************************

verifica_colisao_sonda:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R10
    
    MOV R8, POSICOES_SONDAS         ; endereco do array de sondas
    MOV R5, 4                       ; tamanho de cada sonda
    MOV R7, R2                      ; coluna do asteroide
    ADD R7, R5                      ; coluna final do asteroide
    ADD R5, R1                      ; linha final do asteroide
    MOV R11, 0

check_colisao_sonda:
    MOV R6, [R8 + 2]                ; coluna da sonda
    CMP R6, R2                      ; verifica se a coluna da sonda é menor que a coluna do asteroide
    JLT next_sonda                  ; se for menor, passa para a proxima sonda
    CMP R6, R7                      ; verifica se a coluna da sonda é maior que a coluna final do asteroide
    JGT next_sonda                  ; se for maior, passa para a proxima sonda
    MOV R6, [R8]                    ; linha da sonda
    CMP R6, R1                      ; verifica se a linha da sonda é menor que a linha do asteroide
    JLT next_sonda                  ; se for menor, passa para a proxima sonda
    CMP R6, R5                      ; verifica se a linha da sonda é maior que a linha final do asteroide
    JGT next_sonda                  ; se for maior, passa para a proxima sonda
    JMP handle_colision             ; se não for maior nem menor, então houve colisão

next_sonda:
    ADD R8, 6                       ; passa para a proxima sonda
    MOV R6, POSICOES_SONDAS + 12     ; endereco da ultima sonda
    CMP R8, R6                      ; verifica se já chegou à ultima sonda
    JGT verifica_colisao_sonda_return  ; se já chegou à ultima sonda, retorna
    JMP check_colisao_sonda         ; se não chegou à ultima sonda, verifica a proxima sonda
    
handle_colision :
    MOV R11, COLIDIU
    MOV [R8 + 4], R11                 ; coloca a sonda como COLIDIU

verifica_colisao_sonda_return:
    POP R10
    POP R8
    POP R7
    POP R6
    POP R5
    POP R3
    POP R2
    POP R1
    RET
	

; **********************************************************************
; verifica_colisao_ast_painel: verifica se o asteroide colidiu com o painel
;
; **********************************************************************

verifica_colisao_ast_painel:
    PUSH R1
    PUSH R10
    MOV R10, LIMITE_SUPERIOR_PAINEL         ; limite superior do painel
    CMP R1, R10                             ; verifica se o asteroide está acima do painel
    JLE verifica_colisao_ast_painel_return  ; se estiver acima, não colidiu

    MOV R10, LIMITE_ESQUERDA_PAINEL         ; limite esquerdo do painel
    CMP R2, R10                             ; verifica se o asteroide está a esquerda do painel
    JLE verifica_colisao_ast_painel_return  ; se estiver a esquerda, não colidiu
    MOV R10, LIMITE_DIREITA_PAINEL          ; limite direito do painel
    CMP R2, R10                             ; verifica se o asteroide está a direita do painel
    JGE verifica_colisao_ast_painel_return  ; se estiver a direita, não colidiu

    MOV R1, SOM_GAME_OVER
    MOV [TOCA_SOM], R1                      ; toca o som de game over
    MOV R1, 5                               ; valor da tela de game over
    MOV [CENARIO_FRONTAL], R1               ; atualiza o cenario frontal para o de game over
    MOV R1, 3                               ; valor de game over
    MOV [estado_de_jogo + 2], R1            ; atualiza o estado de jogo

verifica_colisao_ast_painel_return:
    POP R10
    POP R1
    RET

; **********************************************************************
; limpa_disponibilidade: limpa as poiçoes ocupadas pelos asteroides para disponibilizar
;
; **********************************************************************

limpa_disponibilidade:
    PUSH R2
    MOV R2, POSICAO_DISPONIVEL
    MOV [R5], R2                          ; coloca a posição disponivel
    POP R2
    RET

; **********************************************************************
; verifica_disponibilidade: vai decremnetando um contador de 5 para colocar a 
;                           a posicao disponivel passado esse contador 
;
; **********************************************************************

verifica_disponibilidade:

    PUSH R1
    PUSH R3

    MOV R1, [R5]
    CMP R1, POSICAO_DISPONIVEL          ; verifica se a posição é disponivel
    JZ  verifica_disponibilidade_return ; se for disponivel, retorna
    CMP R10, 0                          ; vê se o contador esta a zero
    JZ  muda_disponibilidade            ; se estiver a zero, muda a disponibilidade
    DEC R10                             ; subtrai um ao contador para depois colocar o asteroide como disponivel
    JMP verifica_disponibilidade_return
muda_disponibilidade:
    MOV R3, POSICAO_DISPONIVEL
    MOV [R5], R3                        ; coloca a posição disponivel
verifica_disponibilidade_return:
    POP R3 
    POP R1
    RET

; **********************************************************************
; sonda_1: processo encarrege em mover a sonda e inicializar a sonda 1 
;           ou seja a sonda da esquerda 
;
; **********************************************************************

PROCESS SP_inicial_sonda_1

sonda_1:

    
    MOV R1, LINHA_SONDA             ; 2 linhas abaixo do começo da sonda
    MOV R2, COLUNA_SONDA_ESQUERDA   ; coluna de começo da sonda
    MOV R9, 0                       ; valor de sonda 2
    CALL atualiza_tabela_sonda      ; atualiza a tabela da sonda
    DEC R1                          ; para sonda sair da posicao certa
    DEC R1                          ; para sonda sair da posicao certa
    MOV R4, DEF_SONDA               ; coloca o endereço da sonda
    MOV R0, [evento_int_tecla_sonda1] ; lê o lock da que chama a sonda

    MOV R11, [estado_de_jogo + 2]   ; verifica se o jogo esta pausado
    MOV R10, 1                      ; valor de pausa
    CMP R11, R10                    ; verifica se o jogo esta pausado
    JNZ sonda_1                     ; se estiver vai para o ciclo da sonda

    MOV R0, SOM_SONDA
    MOV [TOCA_SOM], R0

    CALL decrementa_energia_sonda   ; decrementa a energia do painel
    CALL desenha_boneco             ; desenha a sonda
    MOV R9, 0                       ; valor de sonda 1
    CALL atualiza_tabela_sonda      ; atualiza a tabela da sonda
ciclo_sonda_1:
    MOV R0, [evento_int_sonda]

    MOV R11, [estado_de_jogo + 2]   ; verifica se o jogo esta acabado
    MOV R9, 3                       ; valor de game over
    CMP R11, R9                     ; verifica se o jogo esta acabado
    JZ sonda_1                      ; se estiver vai para o inicializador da sonda

    MOV R11, [estado_de_jogo + 2]   ; verifica se o jogo esta pausado
    MOV R10, 1                      ; valor de pausa
    CMP R11, R10                    ; verifica se o jogo esta pausado
    JNZ ciclo_sonda_1               ; se estiver vai para o ciclo da sonda

    CALL apaga_boneco
    
    MOV R9, 0                       ; valor de sonda 1
    CALL verifica_colidiu_sonda     ; verifica se a sonda colidiu com o asteroide
    MOV R5, NAO_COLIDIU             ; valor de não colidiu
    CMP R8, R5                      ; verifica se a sonda colidiu com o asteroide
    JNZ sonda_1                     ; se colidiu vai para o inicializador da sonda

    DEC R1                          ; diminui a linha
    DEC R2                          ; diminui a coluna
    MOV R5, LINHA_LIMITE_SONDA      ; linha limite da sonda
    CMP R1, R5                      ; verifica se já excedeu o limite
    JLE sonda_1                     ; se ja chegou ao limite vai para o inicializador da sonda
    CALL desenha_boneco             ; desenha a sonda
    MOV R9, 0                       ; valor de sonda 1
    CALL atualiza_tabela_sonda      ; atualiza a tabela da sonda
    JMP ciclo_sonda_1


; **********************************************************************
; sonda_2: processo encarrege em mover a sonda e inicializar a sonda 2
;           ou seja a sonda do meio
;
; **********************************************************************

PROCESS SP_inicial_sonda_2

sonda_2:


    MOV R1, LINHA_SONDA             ; 2 linhas abaixo de começo da sonda
    MOV R2, COLUNA_SONDA_MEIO       ; coluna de começo da sonda
    MOV R9, 1                       ; valor de sonda 2
    CALL atualiza_tabela_sonda      ; atualiza a tabela da sonda
    DEC R1                          ; para sonda sair da posicao certa
    DEC R1                          ; para sonda sair da posicao certa
    MOV R4, DEF_SONDA               ; coloca o endereço da sonda
    MOV R0, [evento_int_tecla_sonda2] ; lê o lock da que chama a sonda


    MOV R11, [estado_de_jogo + 2]   ; verifica se o jogo esta pausado
    MOV R10, 1                      ; valor de pausa
    CMP R11, R10                    ; verifica se o jogo esta pausado
    JNZ sonda_2                     ; se estiver vai para o ciclo da sonda

    MOV R0, SOM_SONDA
    MOV [TOCA_SOM], R0

    CALL decrementa_energia_sonda   ; decrementa a energia do painel
    CALL desenha_boneco             ; desenha a sonda
    MOV R9, 1                       ; valor de sonda 2
    CALL atualiza_tabela_sonda      ; atualiza a tabela da sonda
ciclo_sonda_2:
    MOV R0, [evento_int_sonda]

    MOV R11, [estado_de_jogo + 2]   ; verifica se o jogo esta acabado
    MOV R9, 3                       ; valor de game over
    CMP R11, R9                     ; verifica se o jogo esta acabado
    JZ sonda_2                      ; se estiver vai para o inicializador da sonda

    MOV R11, [estado_de_jogo + 2]   ; verifica se o jogo esta pausado
    MOV R10, 1                      ; valor de pausa
    CMP R11, R10                    ; verifica se o jogo esta pausado
    JNZ ciclo_sonda_2               ; se estiver vai para o ciclo da sonda

    CALL apaga_boneco

    MOV R9, 1                       ; valor de sonda 1
    CALL verifica_colidiu_sonda     ; verifica se a sonda colidiu com o asteroide
    MOV R7, NAO_COLIDIU             ; valor de não colidiu
    CMP R8, R7                      ; verifica se a sonda colidiu com o asteroide
    JNZ sonda_2                     ; se colidiu vai para o inicializador da sonda

    DEC R1                          ; diminui a linha
    MOV R5, LINHA_LIMITE_SONDA      ; linha limite da sonda
    CMP R1, R5                      ; verifica se já excedeu o limite
    JLE sonda_2                     ; se ja chegou ao limite vai para o inicializador da sonda
    CALL desenha_boneco             ; desenha a sonda
    MOV R9, 1                       ; valor de sonda 2
    CALL atualiza_tabela_sonda      ; atualiza a tabela da sonda
    JMP ciclo_sonda_2


; **********************************************************************
; sonda_3: processo encarrege em mover a sonda e inicializar a sonda 3 
;           ou seja a sonda da direita
;
; **********************************************************************

PROCESS SP_inicial_sonda_3

sonda_3:


    MOV R1, LINHA_SONDA             ; 2 linhas abaixo de começo da sonda
    MOV R2, COLUNA_SONDA_DIREITA    ; coluna de começo da sonda
    MOV R9, 2                       ; valor de sonda 2
    CALL atualiza_tabela_sonda      ; atualiza a tabela da sonda
    DEC R1                          ; para sonda sair da posicao certa
    DEC R1                          ; para sonda sair da posicao certa
    MOV R4, DEF_SONDA               ; coloca o endereço da sonda
    MOV R0, [evento_int_tecla_sonda3] ; lê o lock da que chama a sonda

    MOV R11, [estado_de_jogo + 2]   ; verifica se o jogo esta pausado
    MOV R10, 1                      ; valor de pausa
    CMP R11, R10                    ; verifica se o jogo esta pausado
    JNZ sonda_3                     ; se estiver vai para o ciclo da sonda

    MOV R0, SOM_SONDA
    MOV [TOCA_SOM], R0

    CALL decrementa_energia_sonda   ; decrementa a energia do painel
    CALL desenha_boneco             ; desenha a sonda
    MOV R9, 2                       ; valor de sonda 3
    CALL atualiza_tabela_sonda      ; atualiza a tabela da sonda
ciclo_sonda_3:
    MOV R0, [evento_int_sonda]
    MOV R11, [estado_de_jogo + 2]   ; verifica se o jogo esta acabado
    MOV R9, 3                       ; valor de game over
    CMP R11, R9                     ; verifica se o jogo esta acabado
    JZ sonda_3                      ; se estiver vai para o inicializador da sonda

    MOV R11, [estado_de_jogo + 2]   ; verifica se o jogo esta pausado
    MOV R10, 1                      ; valor de pausa
    CMP R11, R10                    ; verifica se o jogo esta pausado
    JNZ ciclo_sonda_3               ; se estiver vai para o ciclo da sonda

    CALL apaga_boneco

    MOV R9, 2                       ; valor de sonda 2
    CALL verifica_colidiu_sonda     ; verifica se a sonda colidiu com o asteroide
    MOV R7, NAO_COLIDIU             ; valor de não colidiu
    CMP R8, R7                      ; verifica se a sonda colidiu com o asteroide
    JNZ sonda_3                     ; se colidiu vai para o inicializador da sonda

    DEC R1                          ; diminui a linha
    INC R2                          ; diminui a coluna
    MOV R5, LINHA_LIMITE_SONDA      ; linha limite da sonda
    CMP R1, R5                      ; verifica se já excedeu o limite
    JLE sonda_3                     ; se ja chegou ao limite vai para o inicializador da sonda
    CALL desenha_boneco             ; desenha a sonda
    MOV R9, 2                       ; valor de sonda 3
    CALL atualiza_tabela_sonda      ; atualiza a tabela da sonda
    JMP ciclo_sonda_3


; **********************************************************************
; atualiza_tabela_sonda: processo encarrege em atualizar a tabela da sonda 
;
;   argumentos de entrada: R1 - linha da sonda
;                          R2 - coluna da sonda
;                          R9 - numero da sonda
;
; **********************************************************************

atualiza_tabela_sonda:
    PUSH R3
    PUSH R4
    PUSH R9
    MOV R3, POSICOES_SONDAS
    MOV R4, 6
    MUL R4, R9                      ; multiplica o numero da sonda por 4 porque são duas words por linha
    ADD R4, R3                      ; coloca o endereço da sonda na tabela para a linha
    MOV [R4], R1                    ; coloca o endereço da sonda na tabela para a linha
    ADD R4, 2                       ; adiciona 2 para colocar na coluna da tabela
    MOV [R4], R2                    ; coloca o endereço da sonda na tabela para a coluna
    POP R9
    POP R4
    POP R3
    RET


; **********************************************************************
; verifica_colidiu_sonda- verifica se a sonda colidiu com algum obstaculo
;
;   argumentos de entrada: R1 - linha da sonda
;                          R2 - coluna da sonda
;                          R9 - numero da sonda
; **********************************************************************

verifica_colidiu_sonda:
    PUSH R2
    PUSH R4
    PUSH R6
    PUSH R7
    PUSH R10

    MOV R8, NAO_COLIDIU             ; valor de não colidiu
    MOV R6, POSICOES_SONDAS         ; coloca o endereço da tabela das sondas
    MOV R7, 6                       ; numero de sondas
    MUL R7, R9                      ; multiplica o numero da sonda por 6 porque são três words por linhau
    ADD R7, 4                       ; soma 4 para ir para o colidiu
    MOV R10, [R6 + R7]              ; coloca o endereço da sonda na tabela para a linha
    MOV R4, COLIDIU                 ; valor de colidiu     
    CMP R4, R10                     ; verifica se a sonda colidiu
    JNZ nao_colidiu_sonda           ; se não colidiu vai para o inicializador da sonda
    MOV R8, NAO_COLIDIU             ; valor de não colidiu
    MOV [R6 + R7], R8               ; coloca o endereço da sonda na tabela para a linha
    SUB R7, 2                       ; subtrai 2 para ir para a coluna
    MOV R2, COLUNA_ESQUERDA         ; coloca o endereço da sonda na tabela para a coluna
    MOV [R6 + R7], R2               ; coloca o endereço da coluna da tabela para o default
    SUB R7, 2                       ; subtrai 2 para ir para a linha
    MOv R2, LINHA_SONDA             ; coloca o endereço da sonda na tabela para a linha
    MOV [R6 + R7], R2               ; coloca o endereço da linha da tabela para o default
    MOV R8, COLIDIU                 ; valor de colidiu

nao_colidiu_sonda:
    POP R10
    POP R7
    POP R6
    POP R4
    POP R2
    RET


; **********************************************************************
; decerementa_energia_sonda- decrementa a energia do dysplay 
;
; **********************************************************************

decrementa_energia_sonda:
    PUSH R1
    PUSH R2
    PUSH R4
    MOV R2, [DEF_ENERGIA]           ; enderço da tabela de energia
    MOV R1, ENERGIA_SONDA_LANCADA   ; valor de decremento
    SUB R2, R1                      ; decrementa o valor da energia
    MOV [DEF_ENERGIA], R2           ; atualiza o valor da energia
    CALL conversao_hexadecimal      ; converte para hexadecimal
    MOV R4, DISPLAYS                ; endereço dos displays
    MOV [R4], R2                    ; atualiza os displays
    POP R4
    POP R2
    POP R1
    RET


; **********************************************************************
; energia: processo encarrege em decrementar o valor da energia 
;
; **********************************************************************


PROCESS SP_inicial_energia


energia:

    MOV R4, DISPLAYS
    MOV R2, [DEF_ENERGIA]            ; enderço da tabela de energia
    CALL conversao_hexadecimal          
    MOV [R4], R2                     ; atualiza os displays
    MOV R1, [evento_int_energia]     ; le do lock de interrupção de energia
    MOV R3, [estado_de_jogo + 2]
    MOV R1, 1                        ; valor de in_game
    CMP R3, R1                       ; 
    JNZ energia                      ; salta para energia se nao estiver em modo de jogo
    MOV R2, [DEF_ENERGIA]            ; endereço da tabela de energia
    MOV R3, 2
    CMP R2, R3                       ; vê se esta a zero
    JLE energia_fim_jogo
    MOV R3, ENERGIA_FUNCIONAMENTO
    SUB R2, R3                       ; desce o valor do display
    MOV [DEF_ENERGIA], R2            ; atualiza o valor da energia
    CALL conversao_hexadecimal       ; converte para hexadecimal
    MOV R4, DISPLAYS
    MOV [R4], R2                     ; atualiza os displays
    JMP energia                      ; volta para o ciclo

energia_fim_jogo:
    MOV R1, SOM_GAME_OVER
    MOV [TOCA_SOM], R1               ; toca o som de game over
    MOV R1, 0
    MOV [DEF_ENERGIA], R1            ; atualiza o valor da energia
    MOV [R4], R1
    MOV R1, 4                        ; valor da tela de game over
    MOV [CENARIO_FRONTAL], R1        ; atualiza o cenario frontal para o de game over
    MOV R1, 3                        ; valor de game over
    MOV [estado_de_jogo + 2], R1     ; atualiza o estado de jogo
    JMP energia


; **********************************************************************
; conversao_hexadecimal- converte a energia que esta a decimal para hexadecimal 
;
; **********************************************************************

conversao_hexadecimal:

    PUSH R1
    PUSH R3
    PUSH R5
    PUSH R7
    PUSH R8
    PUSH R9

    MOV  R7, 0
    MOV  R1, R2
    MOV  R8, DC                 ; 10
    MOV  R9, HX                 ; 16
    MOV  R5, R1
    MOV  R2, 0


conversao_hexadecimal_loop:

    DIV  R1, R8                 ; Divide o decimal por 10
    CMP  R1, 0                  ; verifica se o coeficiente é zero
    JZ   add_n
    
    ADD  R7, 1
    MOV  R3, R1
    DIV  R3, R8
    CMP  R3, 0
    JNZ  conversao_hexadecimal_loop

    MOV R3, R1
    conversao_hexadecimal_loop2:
    SHL  R3, 4                  ; Faz o shift left de 4 bits
    MUL  R1, R8
    DEC  R7                     ; Decrement the count of hexadecimal digits
    CMP  R7, 0
    JNZ  conversao_hexadecimal_loop2

    SUB R5, R1
    MOV R1, R5
    ADD R2, R3
    CMP R5, 0
    JNZ conversao_hexadecimal_loop

add_n:
    ADD  R2, R5

    POP R9
    POP R8
    POP R7
    POP R5
    POP R3
    POP R1

    RET


; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:
;               R4 - tabela que define o boneco
;
; **********************************************************************

desenha_boneco:
    PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
    PUSH R7

	MOV	R5, [R4]    		; obtém a largura do boneco
	ADD	R4, 2			    ; endereço da altura do boneco
	MOV	R6, [R4]		    ; obtem a altura do boneco
	ADD R4, 2 			    ; endereço da cor do 1º pixel (2 porque a altura é uma word)
    MOV R7, R5              ; guarda uma copia da largura do boneco

    desenha_pixels:       	; desenha os pixels do boneco a partir da tabela
	MOV	 R3, [R4]			; obtém a cor do próximo pixel do boneco
	CALL escreve_pixel	    ; escreve cada pixel do boneco
	ADD	 R4, 2			    ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1              ; próxima coluna
    SUB  R5, 1			    ; menos uma coluna para tratar
    JNZ  desenha_pixeis_p2  ; se der zero vai para o proxima linha 
    CALL proxima_linha      ; passa para a próxima linha
    desenha_pixeis_p2:      ;
	CMP  R6, 0			    ; se já desenhou todas as colunas do objeto, termina
    JNZ  desenha_pixels     ; continua a desenhar os pixels do objeto

    POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
    POP R1
	RET


; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************

escreve_pixel:
	MOV  [DEFINE_LINHA], R1		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2		; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna já selecionadas
	RET


; **********************************************************************
; PROXIMA_LINHA - Passa para a proxima linha do boneco
; Argumentos:   R1 - linha
;               R2 - coluna
;               R6 - altura do boneco
;
; **********************************************************************

proxima_linha:
	INC  R1               ; próxima linha
    MOV  R5, R7           ; largura do boneco
	DEC  R6               ; menos uma linha para tratar
	SUB  R2, R7           ; volta para a coluna inicial
	RET                   ; continua até percorrer toda a altura do objeto


; **********************************************************************
; APAGA_BONECO - Apaga um boneco na linha e coluna indicadas
;			  com a forma definida na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************

apaga_boneco:
    PUSH    R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
    PUSH    R6
    PUSH    R7

	MOV	R5, [R4]    		; obtém a largura do boneco
	ADD	R4, 2			    ; endereço da altura do boneco
	MOV	R6, [R4]		    ; obtem a altura do boneco
	ADD R4, 2 			    ; endereço da cor do 1º pixel (2 porque a altura é uma word)
    MOV R7, R5              ; guarda uma copia da largura do boneco

apaga_pixels:       	   ; desenha os pixels do boneco a partir da tabela
	MOV	 R3, 0			   ; cor para apagar o próximo pixel do boneco
	CALL escreve_pixel     ; escreve cada pixel do boneco
	ADD	 R4, 2		  	   ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1             ; próxima coluna
    SUB  R5, 1			   ; menos uma coluna para tratar
    JNZ  apaga_pixeis_p2   ;salta para a proxima linha se o R5 for 0
    CALL proxima_linha     ; passa para a próxima linha
    apaga_pixeis_p2:
    CMP R6,0               ;
    JNZ  apaga_pixels      ; continua até percorrer toda a largura do objeto

    POP R7
    POP R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
    POP R1
    RET



; **********************************************************************
; CONVERTER - Converte entradas da linha e coluna num inteiro
;
; Argumentos de entrada:
;               R1 - linha
;               R0 - coluna
;
; Argumento de saída:
;               R7 - inteiro da conversão
;
; **********************************************************************


converter:

    MOV R7, 0          ; inicia o contador

converte_linha:

    CMP R1, 1          ; compara com 1
    JZ fim_converte_linha
    SHR R1, 1          ; desloca à direita
    INC R7             ; incrementa o contador
    JMP converte_linha
fim_converte_linha:
    SHL R7, 2          ; duas deslocações à esquerda(multiplica a linha por 4)

converte_coluna:

    CMP R0, 1          ; compara com 1
    JZ  fim_converte_coluna
    SHR R0, 1          ; desloca à direita
    INC R7             ; incrementa o contador
    JMP converte_coluna
    fim_converte_coluna:

    RET 


; **********************************************************************
; acaba_jogo - rotina que acaba o jogo
;
; **********************************************************************

acaba_jogo:
    PUSH R1
    MOV R1, 3
    MOV [CENARIO_FRONTAL], R1
    POP R1
    RET


; **********************************************************************
; reinicia_jogo- rotina que reinicia o jogo
;
; **********************************************************************


reinicia_jogo:
    PUSH R1
    PUSH R2
    PUSH R4
    MOV R1, 1
    MOV [reset], R1                     ; coloca o reset a 1 para reiniciar os asteroides
    MOV R2, DISPLAY_VALOR
    MOV [DEF_ENERGIA], R2
    CALL conversao_hexadecimal
    MOV R4, DISPLAYS
    MOV [R4], R2
    MOV	R1, 1			                ; cenário de fundo número 0
    MOV [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
    MOV [APAGA_ECRÃ], R1	            ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    MOV [APAGA_CENARIO_FRONTAL], R1	    ; apaga o cenário frontal
    POP R4
    POP R2
    POP R1
    RET
    

; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;			    Faz uma escrita no LOCK que o preocesso asteroide lê
;
; **********************************************************************

rot_int_0:
	PUSH	R1
	MOV  R1, evento_int_asteroides
	MOV	[R1], R0	; desbloqueia processo boneco (qualquer registo serve) 
	POP	R1
	RFE


; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 1
;			    Faz uma escrita no LOCK que o preocesso das sondas lê
;
; **********************************************************************

rot_int_1:
	PUSH R1
	MOV  R1, evento_int_sonda
    MOV  [R1], R0
    POP  R1
	RFE


; **********************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2
;			    Faz uma escrita no LOCK que o preocesso da energia lê
;
; **********************************************************************

rot_int_2:
	PUSH R1
	MOV  R1, evento_int_energia
    MOV  [R1], R0
    POP  R1
	RFE


; **********************************************************************
; ROT_INT_3 - 	Rotina de atendimento da interrupção 3
;			    Faz uma escrita no LOCK que o preocesso das o painel lê
;
; **********************************************************************

rot_int_3:
	PUSH R1
	MOV  R1, evento_int_painel
    MOV  [R1], R0
    POP  R1
	RFE