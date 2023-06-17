#TAD Gerador

#Construtor
def cria_gerador(b,s):
    '''
    cria_gerador: int x int -> gerador
    cria um gerador 
    '''
    if type(b) != int or b not in [64,32] or type(s) != int or 1 > s or 2**b <= s :
        raise ValueError('cria_gerador: argumentos invalidos')
    return [b,s]

def cria_copia_gerador(g):
    '''
    cria_copia_gerador: gerador -> gerador
    cria uma copia do gerador
    '''
    return g.copy()

#Seletor
def obtem_estado(g):
    '''
    obtem estado: gerador -> int
    devolve o a seed do gerador
    '''
    return g[1]

#Modificador
def define_estado(g,s):
    '''
    define estado: gerador x int -> int
    define uma nova seed
    '''
    g[1] = s
    return obtem_estado(g)

def atualiza_estado(g):
    '''
    atualiza estado: gerador -> int
    atualiza a seed
    '''
    s = obtem_estado(g)

    if g[0] == 32:
        s =  s ^ ( s << 13) & 0xFFFFFFFF
        s =  s ^ ( s >> 17) & 0xFFFFFFFF
        s =  s ^ ( s << 5 ) & 0xFFFFFFFF

    if g[0] == 64:
        s =  s ^ ( s << 13) & 0xFFFFFFFFFFFFFFFF
        s =  s ^ ( s >> 7 ) & 0xFFFFFFFFFFFFFFFF
        s =  s ^ ( s << 17) & 0xFFFFFFFFFFFFFFFF
    
    define_estado(g,s)
    return s

#Reconhecedor
def eh_gerador(arg):
    '''
    eh gerador: universal -> booleano
    verifica se e gerador
    '''
    s = obtem_estado(arg)
    return type(arg) == list and len(arg) == 2 and type(arg[0]) == int and type(s) == int \
        and arg[0] in [64,32] and s > 0 and s <= 2**arg[0]

#teste
def geradores_iguais(g1,g2):
    '''
    geradores iguais: gerador x gerador -> booleano
    verifica se os geradores sao iguais
    '''
    return eh_gerador(g1) and eh_gerador(g2) and g1[0] == g2[0] and obtem_estado[g1] == obtem_estado[g2]


#transformador
def gerador_para_str(g):
    '''
    gerador para str : gerador -> str
    devolve uma string com as caractristicas do gerador
    '''
    if g[0] == 32:
        return 'xorshift32(s=' + str(obtem_estado(g)) +')'
    elif g[0] == 64:
        return 'xorshift64(s=' + str(obtem_estado(g)) +')'

#funcoes de alto nivel
def gera_numero_aleatorio(g,n):
    '''
    gera numero aleatorio: gerador x int -> int
    gera um numero aleatorio atravez do gerador
    '''
    s = atualiza_estado(g)
    return 1 + s % n

def gera_carater_aleatorio(g,c):
    '''
    gera carater aleatorio: gerador x str -> str
    gera um caracter aleatorio atravez do gerador
    '''
    s = atualiza_estado(g)
    l = (ord(c)-ord('A'))+1
    return chr(s % l + ord('A'))

#TAD cordenada

#contrutores
def cria_coordenada(col,lin):
    '''
    cria coordenada: str x int -> coordenada
    cria uma coordenada
    '''
    if type(col) != str or type(lin) != int or len(col)!= 1 or ord('A')>ord(col) or ord(col)>ord('Z') \
        or 1 > lin or 99 < lin :
        raise ValueError('cria_coordenada: argumentos invalidos')
    return (col,lin)

#seletores
def obtem_coluna(c):
    '''
    obtem coluna: coordenada -> str
    obtem a coluna da coordenada
    '''
    return c[0]

def obtem_linha(c):
    '''
    obtem linha: coordenada -> int
    obtem a linha da coordenada
    '''
    return c[1]

#reconhedor
def eh_coordenada(arg):
    '''
    eh coordenada: universal -> booleano
    verifica se e coordenada
    '''
    return type(arg) == tuple and len(arg) == 2 and type(obtem_linha(arg)) == int \
        and type(obtem_coluna(arg)) == str and len(obtem_coluna(arg)) == 1\
        and 99>=obtem_linha(arg)>=1 and ord('A')<=ord(obtem_coluna(arg))<=ord('Z') 

#teste
def coordenadas_iguais(c1,c2):
    '''
    coordenadas iguais: coordenada x coordenada -> booleano
    verifica se as coordenadas sao iguais
    '''
    return eh_coordenada(c1) and eh_coordenada(c2) and obtem_coluna(c1) == obtem_coluna(c2) and obtem_linha(c1) == obtem_linha(c2)

#transformador
def coordenada_para_str(c):
    '''
    coordenada para str : coordenada -> str
    devolve uma string equivalente a coordenada
    '''
    if obtem_linha(c) < 10:
        return f"{obtem_coluna(c)}0{obtem_linha(c)}"
    else:
        return obtem_coluna(c) + str(obtem_linha(c))

def str_para_coordenada(s):
    '''
    str para coordenada: str -> coordenada
    devolve uma coordenada equivalente a string
    '''
    return (s[0],int(s[1:]))

# funcoes de alto nivel
def obtem_coordenadas_vizinhas(c):
    '''
    obtem coordenadas vizinhas: coordenada -> tuplo
    obtem as coordenadas vizinhas e verifica se esta no campo
    '''
    a = ord('A')
    z = ord('Z')
    coordenadas_vizinhas = ()

    if a <=(ord(obtem_coluna(c)) - 1)<= z and 1 <=(obtem_linha(c) - 1)<= 99:
        coordenadas_vizinhas += ((chr(ord(obtem_coluna(c)) - 1),obtem_linha(c) - 1),)

    if a <=ord(obtem_coluna(c))<= z and 1 <=(obtem_linha(c) - 1)<= 99:
        coordenadas_vizinhas += ((chr(ord(obtem_coluna(c))),obtem_linha(c) - 1),)

    if a <=(ord(obtem_coluna(c)) + 1)<= z and 1 <=(obtem_linha(c) - 1)<= 99:
        coordenadas_vizinhas += ((chr(ord(obtem_coluna(c)) + 1),obtem_linha(c) - 1),)

    if a <=(ord(obtem_coluna(c)) + 1)<= z and 1 <=(obtem_linha(c))<= 99:
        coordenadas_vizinhas += ((chr(ord(obtem_coluna(c)) + 1),obtem_linha(c)),)

    if a <=(ord(obtem_coluna(c)) + 1)<= z and 1 <=(obtem_linha(c) + 1)<= 99:
        coordenadas_vizinhas += ((chr(ord(obtem_coluna(c)) + 1),obtem_linha(c) + 1),)

    if a <=(ord(obtem_coluna(c)))<= z and 1 <=(obtem_linha(c) + 1)<= 99:
        coordenadas_vizinhas += ((chr(ord(obtem_coluna(c))),obtem_linha(c) + 1),)

    if a <=(ord(obtem_coluna(c)) - 1)<= z and 1 <=(obtem_linha(c) + 1)<= 99:
        coordenadas_vizinhas += ((chr(ord(obtem_coluna(c)) - 1),obtem_linha(c) + 1),)

    if a <=(ord(obtem_coluna(c)) - 1)<= z and 1 <=(obtem_linha(c))<= 99:
        coordenadas_vizinhas += ((chr(ord(obtem_coluna(c)) - 1),obtem_linha(c)),)
         
    return coordenadas_vizinhas

def obtem_coordenada_aleatoria(c,g):
    '''
    obtem coordenada aleatoria: coordenada x gerador -> coordenada
    obtem uma coordenada aletoria atravez das funcoes obtem linnha e coluna aleatoria
    '''
    carater = gera_carater_aleatorio(g,obtem_coluna(c))
    numero = gera_numero_aleatorio(g,obtem_linha(c))
    return cria_coordenada(carater,numero)

#TAD Parcela

#construtor
def cria_parcela():
    '''
    cria parcela: {} -> parcela
    '''
    return {'ESTADO':'tapada','MINA':'nao'}

def cria_copia_parcela(p):
    '''
    cria copia parcela: parcela -> parcela
    cria uma copia da parcela
    '''
    parcela_copia = {}
    x = p.items()
    for key,value in x:
        parcela_copia[key] = value
    return parcela_copia

#modificadores
def limpa_parcela(p):
    '''
    limpa parcela: parcela -> parcela
    limpa a parcela
    '''
    p['ESTADO'] = 'limpa'
    return p

def marca_parcela(p):
    '''
    marca parcela: parcela -> parcela
    marca a parcela
    '''
    p['ESTADO'] = 'marcada'
    return p

def desmarca_parcela(p):
    '''
    desmarca parcela: parcela -> parcela
    desmarca a parcela
    '''
    p['ESTADO'] = 'tapada'
    return p

def esconde_mina(p):
    '''
    esconde mina: parcela -> parcela
    escoonde a mina 
    '''
    p['MINA'] = 'sim'
    return p 
    
#reconhecedor
def eh_parcela(arg):
    '''
    eh parcela: universal -> booleano
    verifica se e uma parcela 
    '''
    return type(arg) == dict and 'ESTADO' in arg and 'MINA' in arg \
        and arg['ESTADO'] in ('tapada','marcada','limpa') \
            and arg['MINA'] in ('sim','nao') and len(arg) == 2  
# depois
def eh_parcela_tapada(p):
    '''
    eh parcela tapada: parcela -> booleano
    verifica se a parcela e tapada
    '''
    return 'tapada' in p['ESTADO']

def eh_parcela_marcada(p):
    '''
    eh parcela marcada: parcela -> booleano
    verifica se e uma parcela marcada
    '''
    return 'marcada' in p['ESTADO']

def eh_parcela_limpa(p):
    '''
    eh parcela limpa: parcela -> booleano
    verifica se e uma parcela limpa
    '''
    return 'limpa' in p['ESTADO']

def eh_parcela_minada(p):
    '''
    eh parcela minada: parcela -> booleano
    verifiva se e uma parcela minada
    '''
    return 'sim' in p['MINA']

#teste
def parcelas_iguais(p1,p2):
    '''
    parcelas iguais: parcela x parcela -> booleano
    verifica se as parcelas sao iguais 
    '''
    return eh_parcela(p1) and eh_parcela(p2) and p1.keys() == p2.keys() and p1.values() == p2.values()

#transformadores
def parcela_para_str(p):
    '''
    parcela para str : parcela -> str
    passa a parcela para string
    '''
    if eh_parcela_tapada(p):
        return '#'
    if eh_parcela_marcada(p):
        return '@'
    if eh_parcela_limpa(p) and not eh_parcela_minada(p):
        return '?'
    if eh_parcela_limpa(p) and eh_parcela_minada(p):
        return 'X'

def alterna_bandeira(p):
    '''
    alterna bandeira: parcela -> booleano
    coloca a bandeira se nao tiver e tira se tiver
    '''
    if eh_parcela_marcada(p):
        desmarca_parcela(p)
        return True

    if eh_parcela_tapada(p):
        marca_parcela(p)
        return True

    else:
        return False

#TAD campo

#construtor
def cria_campo(c, l):
    '''
    cria campo: str x int -> campo
    cria um campo de parcelas
    '''
    if not isinstance(c,str) or len(c) != 1 or (ord('A') > ord(c)) or (ord(c) > ord('Z')) \
        or not isinstance(l,int) or 1> l or l > 99:
        raise ValueError('cria_campo: argumentos invalidos')
    linha = []
    campo = []
    for b in range(l):
        for coluna in range(ord(c)-ord('A')+1):
            linha += [cria_parcela()]
        campo += [linha]
        linha = []
    return campo

def cria_copia_campo(m):
    '''
    cria copia campo: campo -> campo
    cria uma copia do campo
    '''
    campo = []
    lista = []
    for linha in campo:
        for coluna in linha:
            lista += [cria_copia_parcela(coluna)]
        campo += [lista]
        lista = []
    return campo

#seletores
def obtem_ultima_coluna(m):
    '''
    obtem ultima coluna: campo -> str
    obtem a ultima coluna do campo
    '''
    return chr(len(m[0]) + ord('A')- 1)

def obtem_ultima_linha(m):
    '''
    obtem ultima linha: campo -> int
    obtem a ultima linha do campo
    '''
    return len(m)

def obtem_parcela(m,c):
    '''
    obtem parcela: campo x coordenada -> parcela
    obtem a parcela de um coordenada expecifica 
    '''
    x = obtem_linha(c) - 1
    y = obtem_coluna(c)
    return  m[x][ord(y)-(ord('A'))]

def obtem_coordenadas(m,s):
    '''
    obtem coordenadas: campo x str -> tuplo
    obtem as coordenadas consoante um estado, se este for minadas devolve 
    todas as coordenadas minadas do campo isto e para os seguintes
    estados: minadas, tapadas, marcadas, limpas
    '''
    coordenadas = ()
    for a in range(obtem_ultima_linha(m)):
        for b in range((ord(obtem_ultima_coluna(m))-(ord('A')))+1):
            if s == 'minadas':
                if eh_parcela_minada(obtem_parcela(m,cria_coordenada(chr(b + ord('A')),a+1))):
                    coordenadas += (cria_coordenada(chr(b + ord('A')),a+1),)

            if s == 'tapadas':
                if eh_parcela_tapada(obtem_parcela(m,cria_coordenada(chr(b + ord('A')),a+1))):
                    coordenadas += (cria_coordenada(chr(b + ord('A')),a+1),)

            if s == 'marcadas':
                 if eh_parcela_marcada(obtem_parcela(m,cria_coordenada(chr(b + ord('A')),a+1))):
                    coordenadas += (cria_coordenada(chr(b + ord('A')),a+1),)

            if s == 'limpas':
                if eh_parcela_limpa(obtem_parcela(m,cria_coordenada(chr(b + ord('A')),a+1))):
                    coordenadas += (cria_coordenada(chr(b + ord('A')),a+1),)

    return coordenadas
    
def obtem_numero_minas_vizinhas(m,c):
    '''
    obtem numero minas vizinhas: campo x coordenada -> int
    obtem o numero das minas que estao nas coordenadas vizinhas 
    '''
    numero_minas = 0
    for coordenada in obtem_coordenadas_vizinhas(c):
        if eh_coordenada_do_campo(m,coordenada):
            if eh_parcela_minada(obtem_parcela(m,coordenada)):
                numero_minas += 1
    return numero_minas

#reconhecedores
def eh_campo(arg):
    '''
    eh campo: universal -> booleano
    verifica se e um campo
    '''
    if isinstance(arg,list) and arg != []:
        for a in arg:
            if isinstance(a,list) and a != []:
                for b in a:
                    if not eh_parcela(b):
                        return False
            else:
                return False
        return True
    return False


def eh_coordenada_do_campo(m,c):
    '''
    eh coordenada do campo: campo x coordenada -> booleano
    verifica se e uma coordenada do campo 
    '''
    return ord(obtem_ultima_coluna(m)) >= ord(obtem_coluna(c)) >= ord('A')\
        and obtem_ultima_linha(m) >= obtem_linha(c) >= 1
    
#teste
def campos_iguais(m1,m2):
    '''
    campos iguais: campo x campo -> booleano
    verifica se sao campos iguais
    '''
    obtem_ultima_coluna(m1) == obtem_ultima_coluna(m2) and obtem_ultima_linha(m1) == obtem_ultima_linha
    eh_campo(m1) and eh_campo(m2) 
    ##############################################  acabar  #######################################

#transformador
def campo_para_str(m):
    '''
    campo para str : campo -> str
    devolve uma string que representa o campo
    '''
    campo = '   '
    letras = ''
    ultima_letra = obtem_ultima_coluna(m)
    ordem_letra = ord(ultima_letra)
    tamanho_letras = ordem_letra - (ord('A')-1)
    ultimo_numero = obtem_ultima_linha(m)
    mais_menos = '  +' + '-'* tamanho_letras + '+'
    for a in range(tamanho_letras):
        letras += chr(a + ord('A'))
    campo += f'{letras}\n'
    campo += mais_menos +'\n' 
    for a in range(ultimo_numero):
        campo += str(a + 1).zfill(2) + '|'
        for b in range(ordem_letra-(ord('A')-1)):
            if parcela_para_str(m[a][b]) == '?':
                x = obtem_numero_minas_vizinhas(m,cria_coordenada(chr(b+ord('A')),a+1))
                if x == 0:
                    x = ' '
                campo += str(x)
            else:
                campo += parcela_para_str(m[a][b])
        campo += '|\n'
    campo += mais_menos 
    if campo[1] == '\n':
        campo = campo[2:]
    return campo

#funcoes de alto nivel
def coloca_minas(m,c,g,n):
    '''
    coloca minas: campo x coordenada x gerador x int -> campo
    coloca as minas que sao decididas aleatoriamente excluindo as 
    possibilidades de calhar na vizinhanca da coordenada
    e em cima das outras minas
    '''
    proibidas = []
    proibidas = proibidas + [c] + list(obtem_coordenadas_vizinhas(c))
    while n > 0:
        coordenada = obtem_coordenada_aleatoria((obtem_ultima_coluna(m),obtem_ultima_linha(m)),g)
        if coordenada not in proibidas:
            parcela = obtem_parcela(m,coordenada) 
            esconde_mina(parcela)
            proibidas += [coordenada]
            n -= 1
    return m

def limpa_campo(m,c):
    '''
    limpa campo: campo x coordenada -> campo
    limpa as vizinhas da coordenada caso nao 
    haja minas na vizinhanca
    '''
    if eh_parcela_limpa(obtem_parcela(m,c)):
        return m
    
    if eh_parcela_tapada(obtem_parcela(m,c)):
        limpa_parcela(obtem_parcela(m,c))

        if eh_parcela_minada(obtem_parcela(m,c)):
            return m
        else:
            if obtem_numero_minas_vizinhas(m,c) != 0:
                return m
            else:
                for coordenada_vizinha in obtem_coordenadas_vizinhas(c):
                    if eh_coordenada_do_campo(m,coordenada_vizinha):
                        limpa_campo(m,coordenada_vizinha)
                        
    return m
            

def jogo_ganho(m):
    '''
    jogo ganho: campo  -> booleano
    devolve True caso tenha ganho o jogo e False caso nao
    '''
    return (obtem_ultima_linha(m)*(ord(obtem_ultima_coluna(m))-ord('A')+1)) \
        == len(obtem_coordenadas(m,'limpas')) + len(obtem_coordenadas(m,'minadas'))

            
#funcoes adicionais
def eh_coordenada_valida(string):
    '''
    eh_coordenada_valida: string -> booleano
    devolve True caso seja uma coordenada valida do campo
    e uma string valida para trocar para coordenada

    '''
    return len(string) == 3 and ord(string[0]) >= ord('A') and ord(string[0]) <= ord('Z') \
        and string[1] >= '0' and string[1] <= '9' and string[2] >= '0' and string[2] <= '9'

def turno_jogador(m):
    '''
    turno jogador: campo -> booleano
    e a funcao que interage com o jogador em que 
    devolve True caso tenha limpo uma parcela sem mina 
    e False caso tenha limpo uma parcela com mina
    '''
    acao = ''
    escolha = ''
    while acao != 'L' and acao != 'M':
        acao = input('Escolha uma ação, [L]impar ou [M]arcar:')
    while not eh_coordenada_valida(escolha) or not eh_coordenada_do_campo(m,str_para_coordenada(escolha)):
        escolha = input('Escolha uma coordenada:')   
    coordenada = str_para_coordenada(escolha)
    if acao == 'L':
            limpa_campo(m,coordenada)
            return not eh_parcela_minada(obtem_parcela(m,coordenada))
            

    if acao == 'M':
        alterna_bandeira(obtem_parcela(m,coordenada))
        return True


def minas(c,l,n,d,s):
    '''
    minas: str x int x int x int x int -> booleano
    e a funcao que faz o jogo funcionar em que devolve True
    caso ganhe o jogo e False caso perda o jogo
    '''
    campo = cria_campo(c,l)
    if not isinstance(c,str) or len(c) != 1 or ord("A")>ord(c) or ord(c)>ord("Z")\
    or not isinstance(l, int) or l<1 or l>99 or not l*(ord(c)-ord("A")+1) > 9\
    or not eh_campo(campo) or not isinstance(d, int) or d not in (32, 64)\
    or not isinstance(s, int) or s<=0 or s>2**d or not isinstance(n, int) \
    or n > (ord(obtem_ultima_coluna(campo))-ord("A")+1)*(obtem_ultima_linha(campo)) - 9 \
    or n<1 :
        raise ValueError('minas: argumentos invalidos')

    primeira_jogada = ''
    bandeiras = f'   [Bandeiras 0/{n}]'
    print(bandeiras)
    print(campo_para_str(campo))
    while not eh_coordenada_valida(primeira_jogada) or not eh_coordenada_do_campo(campo,str_para_coordenada(primeira_jogada)):
        primeira_jogada = input('Escolha uma coordenada:')   
    coordenada = str_para_coordenada(primeira_jogada)
    gerador = cria_gerador(d,s)
    coloca_minas(campo,coordenada,gerador,n)
    limpa_campo(campo,coordenada)
    print(bandeiras)
    print(campo_para_str(campo))

    while not jogo_ganho(campo):
        verifica = turno_jogador(campo)
        bandeiras = f'   [Bandeiras {len(obtem_coordenadas(campo,"marcadas"))}/{n}]'
        print(bandeiras)
        print(campo_para_str(campo))

        if not verifica:
            print('BOOOOOOOM!!!')
            return False

    print('VITORIA!!!')
    return True



minas('Z', 14, 54, 32, 2)


