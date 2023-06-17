# PRIMEIRO
# JUSTIFICAÇÃO DE TEXTOS

def limpa_texto(cad_caracteres):

    lim_cad_caracteres = cad_caracteres.split()
    lim_cad_caracteres = ' '.join(lim_cad_caracteres)
    return lim_cad_caracteres


def corta_texto(lim_cad_caracteres, larg_coluna):

    cad_caracteres1 = ()
    cad_caracteres2 = ()

    if len(lim_cad_caracteres) > larg_coluna:

        # se o tamanho da cadeia de caracteres for maior que o indice da largura da coluna
        # o algoritmo vai subtrair o valor da largura até encontrar um espaço
        while lim_cad_caracteres[larg_coluna] != ' ':
            larg_coluna -= 1
            if larg_coluna == 0:
                return ('', lim_cad_caracteres)

        # depois de encontrar o espaço atribuo a uma das variaveis o conjunto de palavras
        # que vai até ao indice da largura da coluna e a outra, o resto~
        cad_caracteres1 = lim_cad_caracteres[:larg_coluna].rstrip()
        cad_caracteres2 = lim_cad_caracteres[larg_coluna:].lstrip()
        return cad_caracteres1, cad_caracteres2

    
    elif lim_cad_caracteres == " ":
        return (" ", " ")

    else:
        return lim_cad_caracteres, ''


def insere_espacos(cad_caracteres, larg_coluna):

    comprimeto_cad_caracteres = len(cad_caracteres)

    if larg_coluna <= comprimeto_cad_caracteres:
        return cad_caracteres

    lista_da_cad_caracteres = cad_caracteres.split()
    comprimeto_lista = len(lista_da_cad_caracteres)

    espaços_precisos = larg_coluna - comprimeto_cad_caracteres

    
    if comprimeto_lista == 1:
        return cad_caracteres + " " * (larg_coluna - comprimeto_cad_caracteres)

    espaços_normais = espaços_precisos // (comprimeto_lista - 1)
    espaços_restantes = espaços_precisos % (comprimeto_lista - 1)

    adicao_espacos = " " * (espaços_normais + 1)
    adicao_espacos_extra = adicao_espacos + " "

    
    if espaços_restantes == 0:
        return adicao_espacos.join(lista_da_cad_caracteres)

    # caso reste espaços faze-se join dos espaços extra com o comprimento da lista 
    # até ao indice de valor dos espaços restantes mais um
    # depois faz join do resto da lista de caracteres com os espaços normais
    if espaços_restantes > 0:
        return adicao_espacos.join([adicao_espacos_extra.join(lista_da_cad_caracteres[:espaços_restantes + 1])]
                                   + [adicao_espacos.join(lista_da_cad_caracteres[espaços_restantes + 1:])])


def inserir_espacos_no_fim(cad_caracteres, larg_coluna):
    return cad_caracteres + ' ' * (larg_coluna - len(cad_caracteres))


def justifica_texto(cad_caracteres, larg_coluna):

    if not isinstance(cad_caracteres, str) or len(cad_caracteres) == 0:
        raise ValueError("justifica_texto: argumentos invalidos")
    if not isinstance(larg_coluna, int) or larg_coluna <= 0:
        raise ValueError("justifica_texto: argumentos invalidos")
    for palavra in cad_caracteres.split():
        if len(palavra) > larg_coluna:
            raise ValueError("justifica_texto: argumentos invalidos")

    cad_caracteres_limpa = limpa_texto(cad_caracteres)

    # se o tamanho da cadeira de caracteres for menor que a largura 
    # insere os espaços no fim para agradecer a largura da coluna
    if len(cad_caracteres_limpa) <= larg_coluna:
        return (inserir_espacos_no_fim(cad_caracteres_limpa, larg_coluna),)


    cad_caracteres_cor1 = corta_texto(cad_caracteres_limpa, larg_coluna)
    cad_caracteres_cortada = (insere_espacos(
        cad_caracteres_cor1[0], larg_coluna),)

    # O loop que pega no output do corta texto e volta a mete-lo no corta texto 
    # até o comprimento da ultima linha ser menor que a largura da coluna
    while len(cad_caracteres_cor1[1]) > larg_coluna:
        cad_caracteres_cor2 = corta_texto(cad_caracteres_cor1[1], larg_coluna)

        cad_caracteres_cortada += (insere_espacos(
            cad_caracteres_cor2[0], larg_coluna),)
        cad_caracteres_cor1 = cad_caracteres_cor2


    # Uso da funcao auxiliar insere para quando o tamanho do comprimento da cadeia de caracteres é menor que a
    # largura da coluna
    if cad_caracteres_cor1[1] != "":
        cad_caracteres_cortada += (inserir_espacos_no_fim(
            cad_caracteres_cor1[1], larg_coluna),)
    return cad_caracteres_cortada

# SEGUNDO
# MÉTODO DE HONDT


def divisor_de_votos(value, num_deputados):
    divisor = 1
    lista_de_votos_divididos = []
    while divisor <= num_deputados:
        resultado = value / divisor
        divisor += 1
        lista_de_votos_divididos += [resultado, ]
    return lista_de_votos_divididos


def calcula_quocientes(dicionario, num_deputados):

    for key, value in dicionario.items():
        dicionario[key] = divisor_de_votos(value, num_deputados)

    return dicionario


def min_dict(dicionario):
    minimo = min(dicionario.values())
    for key, value in dicionario.items():
        if value == minimo:
            return key


def atribui_mandatos(dicionario, num_deputados):
    dict_s = calcula_quocientes(dicionario.copy(), num_deputados)
    menos_votado = min_dict(dicionario.copy())
    maior_quociente = 0
    lista_mandatos = []
    count = 0
    while count < num_deputados:
        for key, value in dict_s.items():
            if max(value) >= maior_quociente:
                if max(value) == maior_quociente:
                    if key != menos_votado:
                        k = menos_votado
                        maior_quociente = max(value)
                        i = value.index(maior_quociente)
                        continue
                maior_quociente = max(value)
                i = value.index(maior_quociente)
                k = key
        lista_mandatos += [k, ]
        dict_s[k].pop(i)
        maior_quociente = 0
        count += 1
    return lista_mandatos


    # dentro dos votos se nao existir a chave
    #adiciona a lista e faz return na lista em ordem
def obtem_partidos(info):
    lista_partidos = []
    for key in info:
        k = info[key]['votos']
        for key, value in k.items():
            if key not in lista_partidos:
                lista_partidos += [key, ]
    lista_partidos.sort()
    return lista_partidos

#auxiliar
def obtem_votos(info):
    lista_votos = []
    for key in info:
        k = info[key]['votos']
        lista_votos += [k, ]
    return lista_votos


def obtem_deputados(info):
    lista_deputados = []
    for key in info:
        k = info[key]['deputados']
        lista_deputados += [k, ]
    return lista_deputados

# check if its the correct input for obtem_resultado_eleicoes


def check_input(info):
    booli = False
    if not isinstance(info, dict):
        return booli
    if len(info) == 0:
        return booli
    for key in info:
        if not isinstance(key, str):
            return booli
        if not isinstance(info[key], dict):
            return booli
        if len(info[key]) != 2:
            return booli
        if 'deputados' not in info[key]:
            return booli
        if 'votos' not in info[key]:
            return booli
        if not isinstance(info[key]['votos'], dict):
            return booli
        if len(info[key]['votos']) == 0:
            return booli
        for key2 in info[key]['votos']:
            if not isinstance(key2, str):
                return booli
            if not isinstance(info[key]['votos'][key2], int):
                return booli

        if not isinstance(info[key]['deputados'], int):
            return booli
        if info[key]['deputados'] <= 0:
            return booli
        booli = True
        return booli


def obtem_resultado_eleicoes(dicionario):
    if check_input(dicionario) == False:
        raise ValueError("obtem_resultado_eleicoes: argumento invalido")
    count_k = 0
    count_v = 0
    count_m = 0
    lista_final = []
    lista_partidos = obtem_partidos(dicionario)
    for k in lista_partidos:
        lista_deputados = obtem_deputados(dicionario)
        lista_votos = obtem_votos(dicionario)
        for i in range(len(lista_votos)):
            mandatos = atribui_mandatos(
                lista_votos[i], lista_deputados[count_m])
            count_k += mandatos.count(k)
            if k in lista_votos[i]:
                count_v += lista_votos[i][k]
            count_m += 1
        lista_final += [(k, count_k, count_v), ]
        count_k = 0
        count_m = 0
        count_v = 0
    # sort lista_final by larger number of votes

    lista_final.sort(key=lambda tup: tup[2], reverse=True)
    return lista_final

#TERCEIRO
#SOLUCAO DE SISTEMA DE EQUACOES

def produto_interno(v1,v2):
    res = 0
    indice = 0
    for elemento in range(len(v1)):
        indice = elemento
        res += v1[elemento] * v2[indice]
    return "%.1f" % res
