% 107365 Joao Santos
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % para listas completas
:- ['dados.pl'], ['keywords.pl']. % ficheiros a importar.

% 3.1 Qualidade de dados

/*
eventosSemSalas/1  (EventosSemSala)
Devolve uma lista ordenada de Ids nao repetidos de eventos sem sala 
*/
eventosSemSalas(EventosSemSala):-
findall(ID,evento(ID,_,_,_,semSala),Eventos),sort(Eventos,EventosSemSala).

/*
eventosSemSalasDiaSemana/2  (DiaDaSemana, EventosSemSala)
Devolve uma lista ordenada de Ids nao repetidos de eventos sem sala num dia especifico da semana 
*/
eventosSemSalasDiaSemana(DiaDaSemana,EventosSemSala):-
    findall(ID,(horario(ID,DiaDaSemana,_,_,_,_),evento(ID,_,_,_,semSala)),Eventos),
    sort(Eventos,EventosSemSala).

/*
eventosSemSalasPeriodo/2  (ListaPeriodos, EventosSemSala)
Devolve uma lista ordenada de Ids nao repetidos de eventos sem sala referentes a um periodo ou periodos expecificos 
*/
eventosSemSalasPeriodo([],[]).

eventosSemSalasPeriodo([PeriodosCabeca|PeriodosCorpo],EventosSemSala2):- % caso o/os periodo/s seja/m do primeiro semestre
    (PeriodosCabeca == p1 ; PeriodosCabeca == p2),
    findall(ID,((horario(ID,_,_,_,_,p1_2);horario(ID,_,_,_,_,PeriodosCabeca)),evento(ID,_,_,_,semSala)),Eventos),
    eventosSemSalasPeriodo(PeriodosCorpo, EventosSemSala),
    append([Eventos,EventosSemSala], EventosSemSala1),sort(EventosSemSala1,EventosSemSala2).


eventosSemSalasPeriodo([PeriodosCabeca|PeriodosCorpo],EventosSemSala2):-% caso o/os periodo/s seja/m do segundo semestre
    (PeriodosCabeca == p3 ; PeriodosCabeca == p4),
    findall(ID,((horario(ID,_,_,_,_,p3_4);horario(ID,_,_,_,_,PeriodosCabeca)),evento(ID,_,_,_,semSala)),Eventos),
    eventosSemSalasPeriodo(PeriodosCorpo,EventosSemSala),
    append([Eventos,EventosSemSala], EventosSemSala1),sort(EventosSemSala1,EventosSemSala2).


% 3.2 Pesquisas simples 

%Auxiliar da OrganizaEventos/3 que verifica se o ID esta no periodo e no semestre  
auxPeriodos(CabecaLista,Periodo):-
    (Periodo == p1 ; Periodo == p2),
    (horario(CabecaLista,_,_,_,_,Periodo);horario(CabecaLista,_,_,_,_,p1_2)),!.
auxPeriodos(CabecaLista,Periodo):-
    (Periodo == p3 ; Periodo == p4),
    (horario(CabecaLista,_,_,_,_,Periodo);horario(CabecaLista,_,_,_,_,p2_3)).

/*
organizaEventos/3  (ListaEventos, Periodo, EventosNoPeriodo)
Recebe uma lista de IDs e devolve os IDs que pertencem a um certo periodo 
*/ 
organizaEventos([],_,[]).
organizaEventos([CabecaLista|CorpoLista],Periodo,EventosNoPeriodo):-
    auxPeriodos(CabecaLista,Periodo),!,
    EventosNoPeriodoPorOrganizar = [CabecaLista|EventosNoPeriodo2],
    organizaEventos(CorpoLista,Periodo,EventosNoPeriodo2),
    sort(EventosNoPeriodoPorOrganizar,EventosNoPeriodo).
organizaEventos([_|CorpoLista],Periodo,EventosNoPeriodo):-
    organizaEventos(CorpoLista,Periodo,EventosNoPeriodo).


/*
eventosMenoresQue/2  (Duracao, ListaEventosMenoresQue)
Devolve uma lista de Ids noa repetidos e ordenada que tem duracao menor ou igual a Duracao
*/   
eventosMenoresQue(Duracao, ListaEventosMenoresQue):-
    findall(ID,(horario(ID,_,_,_,Tempo,_),Tempo =< Duracao),ListaEventos),
    sort(ListaEventos,ListaEventosMenoresQue).

/*
eventosMenoresQueBool/2 (ID, Duracao)
Devolve True se o evento tiver menor duracao ou igual a Duracao
*/ 
eventosMenoresQueBool(ID, Duracao):-
    horario(ID,_,_,_,Tempo,_), Tempo =< Duracao.


procuraDisciplinas(Curso, ListaDisciplinas):- 
    findall(ID,turno(ID,Curso,_,_),ListaIDs),
    findall(NomeDisciplina,(evento(ID,NomeDisciplina,_,_,_),member(ID,ListaIDs)),ListaDisciplinasNaoOrdenadas),
    sort(ListaDisciplinasNaoOrdenadas,ListaDisciplinas).

/*
procuraDisciplinas/2  (Curso, ListaDisciplinas)
Devolve uma lista com as disciplinar de um curso ordenada de forma alfabetica e sem repetidos
*/
organizaDisciplinas([], _, [[], []]).

organizaDisciplinas([Disciplina|Disciplinas], Curso, [[Disciplina|Semestre1], Semestre2]):-% caso o/os periodo/s seja/m do primeiro semestre
    evento(ID, Disciplina, _, _, _),
    turno(ID, Curso, _, _),horario(ID, _, _, _, _, Periodo),
    (Periodo == p1 ; Periodo == p2 ; Periodo == p1_2),
    organizaDisciplinas(Disciplinas, Curso, [Semestre1, Semestre2]).

organizaDisciplinas([Disciplina|Disciplinas], Curso, [Semestre1, [Disciplina|Semestre2]]):-% caso o/os periodo/s seja/m do segundo semestre
    evento(ID, Disciplina, _, _, _),
    turno(ID, Curso, _, _),horario(ID, _, _, _, _, Periodo),
    (Periodo == p3 ; Periodo == p4 ; Periodo == p3_4),
    organizaDisciplinas(Disciplinas, Curso, [Semestre1, Semestre2]).

/*
Auxiliar do Predicado horasCurso/4 e devolve uma lista de Ids ordenados e nao repetidos que fazem parte de um periodo,
Curso e ano expecificos
*/
auxVerificaIds(Periodo,Curso,Ano,ListaIDs):- 
    (Periodo == p3 ; Periodo == p4),% caso o/os periodo/s seja/m do primeiro semestre
    findall(ID,turno(ID,Curso,Ano,_),ListaIDs1),
    findall(ID,(horario(ID,_,_,_,_,Periodo);horario(ID,_,_,_,_,p3_4)),ListaIDs2),
    intersection(ListaIDs1,ListaIDs2,ListaIDs3),
    sort(ListaIDs3,ListaIDs).

auxVerificaIds(Periodo,Curso,Ano,ListaIDs):- 
    (Periodo == p1 ; Periodo == p2),% caso o/os periodo/s seja/m do segundo semestre
    findall(ID,turno(ID,Curso,Ano,_),ListaIDs1),
    findall(ID,(horario(ID,_,_,_,_,Periodo);horario(ID,_,_,_,_,p1_2)),ListaIDs2),
    intersection(ListaIDs1,ListaIDs2,ListaIDs3),
    sort(ListaIDs3,ListaIDs).

%Auxiliar do Predicado horasCurso/4 e recebe uma lista de Ids e devolve uma lista das Duracoes dos eventos desses IDs 
mudaVariaveis([], []).
mudaVariaveis([CabecaLista|RestoLista], [Duracao|NovaLista]) :-
    horario(CabecaLista,_,_,_,Duracao,_),
    mudaVariaveis(RestoLista, NovaLista).

/*
horasCurso/4  (Periodo, Curso, Ano, TotalHoras)
Devolve o numero de horas que um curso tem num certo ano num certo periodo 
*/
horasCurso(Periodo, Curso, Ano, TotalHoras):- 
    auxVerificaIds(Periodo,Curso,Ano,ListaIDs),
    mudaVariaveis(ListaIDs,ListaDuracao),
    sum_list(ListaDuracao,TotalHoras).

/*
evolucaoHorasCurso/2  (Curso, Evolucao)
Devolve uma Lista tuplos no formato (Ano, Periodo, NumHoras) Usado o predicado horasCurso/4 para determinar o total de horas 
*/
evolucaoHorasCurso(Curso, Evolucao) :-
    findall((Ano,Periodo,TotalHoras),(member(Ano, [1,2,3]), 
    member(Periodo,[p1,p2,p3,p4]), horasCurso(Periodo,Curso,Ano,TotalHoras)), Evolucao).


% 3.3 Ocupacoes criticas de salas

/*
ocupaSlot/5  (HoraInicioDada, HoraFimDada, HoraInicioEvento, HoraFimEvento, Horas)
Devolve o num de Horas sobrepostas entre o horario Dado e o Horario do Evento
*/
ocupaSlot(HoraInicioDada, HoraFimDada, HoraInicioEvento, HoraFimEvento, Horas):-
    HoraInicio is max(HoraInicioDada,HoraInicioEvento),
    HoraFim is min(HoraFimDada,HoraFimEvento),
    HoraFim >= HoraInicio,
    Horas is HoraFim - HoraInicio.

/*
numHorasOcupadas/6  (Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras)
Devolve o numero de horas ocupadas nas salas do tipo TipoSala, no intervalo de tempo definido
*/
numHorasOcupadas(Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras):-
    (Periodo == p1; Periodo == p2),% caso o/os periodo/s seja/m do primeiro semestre
    salas(TipoSala,Salas),
    findall(Duracao,((horario(ID,DiaSemana,_,_,_,Periodo);
    horario(ID,DiaSemana,_,_,_,p1_2)),    
        evento(ID,_,_,_,Sala),member(Sala,Salas),
        horario(ID,_,HoraInicioDada,HoraFimDada,_,_),
        ocupaSlot(HoraInicio,HoraFim,HoraInicioDada,HoraFimDada,Duracao)),Lista),
        sum_list(Lista, SomaHoras).
numHorasOcupadas(Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras):-    
    (Periodo == p3; Periodo == p4),% caso o/os periodo/s seja/m do segundo semestre
    salas(TipoSala,Salas),
    findall(Duracao,((horario(ID,DiaSemana,_,_,_,Periodo);
    horario(ID,DiaSemana,_,_,_,p3_4)),    
        evento(ID,_,_,_,Sala),member(Sala,Salas),
        horario(ID,_,HoraInicioDada,HoraFimDada,_,_),
        ocupaSlot(HoraInicio,HoraFim,HoraInicioDada,HoraFimDada,Duracao)),Lista),
        sum_list(Lista, SomaHoras).
    
/*
ocupacaoMax/4  (TipoSala, HoraInicio, HoraFim, Max)
numero de horas possiveis de ser ocupadas por salas do tipo TipoSala no intervalo de tempo definido
*/
ocupacaoMax(TipoSala, HoraInicio, HoraFim, Max):-
    salas(TipoSala,Salas),
    length(Salas,Tamanho), Max is (HoraFim - HoraInicio)*Tamanho.

/*
percentagem/3  (SomaHoras, Max, Percentagem)
Devolve a percentagem da soma de horas relativo ao Max
*/
percentagem(SomaHoras, Max, Percentagem):-
    Percentagem is SomaHoras/ Max * 100.

/*
ocupacaoCritica/4  (HoraInicio, HoraFim, Threshold, Resultados)
Devolve uma lista de tuplos do formato casosCriticos(DiaSemana, TipoSala,Percentagem), onde a percentagem e a 
percentagem da SomaHoras relativo ao Max  
*/
ocupacaoCritica(HoraInicio, HoraFim, Threshold, Resultados):-
    findall(casosCriticos(DiaSemana,TipoSala,Percentagemfinal),
        (horario(ID,DiaSemana,_,_,_,Periodo),evento(ID,_,_,_,Sala),salas(TipoSala,Salas),member(Sala,Salas),
        numHorasOcupadas(Periodo,TipoSala,DiaSemana,HoraInicio,HoraFim,SomaHoras),
            ocupacaoMax(TipoSala,HoraInicio,HoraFim,Max),percentagem(SomaHoras,Max,Percentagem),
        Percentagem > Threshold,
        Percentagemfinal is ceiling(Percentagem)),
        ResultadosUnsorted),sort(ResultadosUnsorted,Resultados).


%3.4 And now for something completely different...

/*
ocupacaoMesa/3  (ListaPessoas, ListaRestricoes, OcupacaoMesa)
Este predicado recebe uma lista de pessoas e restricoes e vai permutando todas as formas de sentar a 
mesa e verifica se as condicoes estao a ser cumpridas ate encontrar uma combinacao que satisfaca as condicoes 

estas sao as condicoes que vao ser chamadas para sevir como restricoes 
*/
cab1(NomePessoa,[[_,_,_],[NomePessoa,_],[_,_,_]]).
cab2(NomePessoa,[[_,_,_],[_,NomePessoa],[_,_,_]]).
honra(NomePessoa1,NomePessoa2,[[_,_,_],[NomePessoa1,_],[NomePessoa2,_,_]]).
honra(NomePessoa1,NomePessoa2,[[_,_,NomePessoa2],[_,NomePessoa1],[_,_,_]]).
lado(NomePessoa1,NomePessoa2,[[NomePessoa1,NomePessoa2,_],[_,_],[_,_,_]]).
lado(NomePessoa1,NomePessoa2,[[_,NomePessoa1,NomePessoa2],[_,_],[_,_,_]]).
lado(NomePessoa1,NomePessoa2,[[_,_,_],[_,_],[NomePessoa1,NomePessoa2,_]]).
lado(NomePessoa1,NomePessoa2,[[_,_,_],[_,_],[_,NomePessoa1,NomePessoa2]]).
lado(NomePessoa1,NomePessoa2,[[NomePessoa2,NomePessoa1,_],[_,_],[_,_,_]]).
lado(NomePessoa1,NomePessoa2,[[_,NomePessoa2,NomePessoa1],[_,_],[_,_,_]]).
lado(NomePessoa1,NomePessoa2,[[_,_,_],[_,_],[NomePessoa2,NomePessoa1,_]]).
lado(NomePessoa1,NomePessoa2,[[_,_,_],[_,_],[_,NomePessoa2,NomePessoa1]]).
naoLado(NomePessoa1,NomePessoa2,ListaPermutada):- not(lado(NomePessoa1,NomePessoa2,ListaPermutada)).
frente(NomePessoa1,NomePessoa2,[[NomePessoa1,_,_],[_,_],[NomePessoa2,_,_]]).
frente(NomePessoa1,NomePessoa2,[[_,NomePessoa1,_],[_,_],[_,NomePessoa2,_]]).
frente(NomePessoa1,NomePessoa2,[[_,_,NomePessoa1],[_,_],[_,_,NomePessoa2]]).
frente(NomePessoa1,NomePessoa2,[[NomePessoa2,_,_],[_,_],[NomePessoa1,_,_]]).
frente(NomePessoa1,NomePessoa2,[[_,NomePessoa2,_],[_,_],[_,NomePessoa1,_]]).
frente(NomePessoa1,NomePessoa2,[[_,_,NomePessoa2],[_,_],[_,_,NomePessoa1]]).
naoFrente(NomePessoa1,NomePessoa2,ListaPermutada):- not(frente(NomePessoa1,NomePessoa2,ListaPermutada)).


ocupacaoMesa(ListaPessoas, Restricoes, Lista):-
    permutation(ListaPessoas,[A,B,C,D,E,F,G,H]),
    ListaPermutada = [[A,B,C],[D,E],[F,G,H]],
    vefRestricoes(ListaPermutada, Restricoes),
    Lista = ListaPermutada.

/*
O predicado vefRestricoes/2 e auxiliar do predicado ocupacaoMesa e recebe uma lista permutada de possiveis 
formas de sentar as pessoas para depois de forma recrusiva chamar as condicoes e verificar se a disposicao 
satisfaz as condicoes, se nao a ocupacaoMesa gera outra disposucao dos lugares
*/
vefRestricoes(_,[]).
vefRestricoes(ListaPermutada,[Cabeca|Restricoes]):-
    call(Cabeca,ListaPermutada),
    vefRestricoes(ListaPermutada,Restricoes).


