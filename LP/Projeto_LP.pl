% 107365 Joao Santos
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % para listas completas
:- ['dados.pl'], ['keywords.pl']. % ficheiros a importar.
:- dynamic sort/1.

%evento(ID, NomeDisciplina, Tipologia, NumAlunos, Sala).
%horario(ID,DiaSemana, HoraInicio, HoraFim,Duracao, Periodo)
%turno(ID, SiglaCurso, Ano, NomeTurma)


% 3.1 Qualidade de dados

eventosSemSalas(EventosSemSala):-
findall(ID,evento(ID,_,_,_,semSala),Eventos),sort(Eventos,EventosSemSala).


eventosSemSalasDiaSemana(DiaDaSemana,EventosSemSala):-
    findall(ID,(horario(ID,DiaDaSemana,_,_,_,_),evento(ID,_,_,_,semSala)),Eventos),
    sort(Eventos,EventosSemSala).


eventosSemSalasPeriodo([],[]).

eventosSemSalasPeriodo([PeriodosCabeca|PeriodosCorpo],EventosSemSala2):-
    (PeriodosCabeca == p1 ; PeriodosCabeca == p2),
    findall(ID,((horario(ID,_,_,_,_,p1_2);horario(ID,_,_,_,_,PeriodosCabeca)),evento(ID,_,_,_,semSala)),Eventos),
    eventosSemSalasPeriodo(PeriodosCorpo, EventosSemSala),
    append([Eventos,EventosSemSala], EventosSemSala1),sort(EventosSemSala1,EventosSemSala2).


eventosSemSalasPeriodo([PeriodosCabeca|PeriodosCorpo],EventosSemSala2):-
    (PeriodosCabeca == p3 ; PeriodosCabeca == p4),
    findall(ID,((horario(ID,_,_,_,_,p3_4);horario(ID,_,_,_,_,PeriodosCabeca)),evento(ID,_,_,_,semSala)),Eventos),
    eventosSemSalasPeriodo(PeriodosCorpo,EventosSemSala),
    append([Eventos,EventosSemSala], EventosSemSala1),sort(EventosSemSala1,EventosSemSala2).


% 3.2 Pesquisas simples 


auxPeriodos(CabecaLista,Periodo):-
    (Periodo == p1 ; Periodo == p2),
    (horario(CabecaLista,_,_,_,_,Periodo);horario(CabecaLista,_,_,_,_,p1_2)),!.
auxPeriodos(CabecaLista,Periodo):-
    (Periodo == p3 ; Periodo == p4),
    (horario(CabecaLista,_,_,_,_,Periodo);horario(CabecaLista,_,_,_,_,p2_3)).


organizaEventos([],_,[]).
organizaEventos([CabecaLista|CorpoLista],Periodo,EventosNoPeriodo):-
    auxPeriodos(CabecaLista,Periodo),!,
    EventosNoPeriodoPorOrganizar = [CabecaLista|EventosNoPeriodo2],
    organizaEventos(CorpoLista,Periodo,EventosNoPeriodo2),
    sort(EventosNoPeriodoPorOrganizar,EventosNoPeriodo).
organizaEventos([_|CorpoLista],Periodo,EventosNoPeriodo):-
    organizaEventos(CorpoLista,Periodo,EventosNoPeriodo).

eventosMenoresQue(Duracao, ListaEventosMenoresQue):-
    findall(ID,(horario(ID,_,_,_,Tempo,_),Tempo =< Duracao),ListaEventos),
    sort(ListaEventos,ListaEventosMenoresQue).

eventosMenoresQueBool(ID, Duracao):-
    horario(ID,_,_,_,Tempo,_), Tempo =< Duracao.


procuraDisciplinas(Curso, ListaDisciplinas):-
    findall(ID,turno(ID,Curso,_,_),ListaIDs),
    findall(NomeDisciplina,(evento(ID,NomeDisciplina,_,_,_),member(ID,ListaIDs)),ListaDisciplinasNaoOrdenadas),
    sort(ListaDisciplinasNaoOrdenadas,ListaDisciplinas).


organizaDisciplinas([], _, [[], []]).

organizaDisciplinas([Disciplina|Disciplinas], Curso, [[Disciplina|Semestre1], Semestre2]):-
    evento(ID, Disciplina, _, _, _),
    turno(ID, Curso, _, _),horario(ID, _, _, _, _, Periodo),
    (Periodo == p1 ; Periodo == p2 ; Periodo == p1_2),
    organizaDisciplinas(Disciplinas, Curso, [Semestre1, Semestre2]).

organizaDisciplinas([Disciplina|Disciplinas], Curso, [Semestre1, [Disciplina|Semestre2]]):-
    evento(ID, Disciplina, _, _, _),
    turno(ID, Curso, _, _),horario(ID, _, _, _, _, Periodo),
    (Periodo == p3 ; Periodo == p4 ; Periodo == p3_4),
    organizaDisciplinas(Disciplinas, Curso, [Semestre1, Semestre2]).


auxVerificaIds(Periodo,Curso,Ano,ListaIDs):- 
    (Periodo == p3 ; Periodo == p4),
    findall(ID,turno(ID,Curso,Ano,_),ListaIDs1),
    findall(ID,(horario(ID,_,_,_,_,Periodo);horario(ID,_,_,_,_,p3_4)),ListaIDs2),
    intersection(ListaIDs1,ListaIDs2,ListaIDs3),
    sort(ListaIDs3,ListaIDs).

auxVerificaIds(Periodo,Curso,Ano,ListaIDs):- 
    (Periodo == p1 ; Periodo == p2),
    findall(ID,turno(ID,Curso,Ano,_),ListaIDs1),
    findall(ID,(horario(ID,_,_,_,_,Periodo);horario(ID,_,_,_,_,p1_2)),ListaIDs2),
    intersection(ListaIDs1,ListaIDs2,ListaIDs3),
    sort(ListaIDs3,ListaIDs).

mudaVariaveis([], []).
mudaVariaveis([CabecaLista|RestoLista], [Duracao|NovaLista]) :-
    horario(CabecaLista,_,_,_,Duracao,_),
    mudaVariaveis(RestoLista, NovaLista).

horasCurso(Periodo, Curso, Ano, TotalHoras):- 
    auxVerificaIds(Periodo,Curso,Ano,ListaIDs),
    mudaVariaveis(ListaIDs,ListaDuracao),
    sum_list(ListaDuracao,TotalHoras).


mudaAnoPeriodo(Ano,Periodo,NovoAno,NovoPeriodo):-
    Ano < 3,
    Periodo == p4,
    NovoAno is Ano + 1,
    NovoPeriodo = p1. 
mudaAnoPeriodo(Ano,Periodo,NovoAno,NovoPeriodo):-
    Periodo == p1,
    NovoPeriodo = p2,
    NovoAno is Ano.
mudaAnoPeriodo(Ano,Periodo,NovoAno,NovoPeriodo):-
    Periodo == p2,
    NovoPeriodo = p3,
    NovoAno is Ano.
mudaAnoPeriodo(Ano,Periodo,NovoAno,NovoPeriodo):-
    Periodo == p3,
    NovoPeriodo = p4,
    NovoAno is Ano.


auxEvolucao(_,_,_,[]).
auxEvolucao(Curso,Ano,Periodo,[Tuplo|Evolucao]):-
    horasCurso(Periodo,Curso,Ano,TotalHoras),
    Tuplo = (Ano, Periodo, TotalHoras),
    mudaAnoPeriodo(Ano,Periodo,NovoAno,NovoPeriodo),
    auxEvolucao(Curso,NovoAno,NovoPeriodo,Evolucao).

 
evolucaoHorasCurso(Curso, Evolucao):-
    auxEvolucao(Curso,1,p1,Evolucao).



% 3.3 Ocupações críticas de salas

maiorDeDois(Primeira_hora,Segunda_hora,MaiordasDuas):-
    Primeira_hora >= Segunda_hora,
    MaiordasDuas is Primeira_hora,!.
maiorDeDois(_,Segundahora,MaiordasDuas):-
    MaiordasDuas is Segundahora.

menorDeDois(Primeira_hora,Segunda_hora,MenordasDuas):-
    Primeira_hora =< Segunda_hora,
    MenordasDuas is Primeira_hora,!.
menorDeDois(_,Segunda_hora,MenordasDuas):-
    MenordasDuas is Segunda_hora.

ocupaSlot(HoraInicioDada, HoraFimDada, HoraInicioEvento, HoraFimEvento, Horas):-
    maiorDeDois(HoraInicioDada,HoraInicioEvento,HoraInicio),
    menorDeDois(HoraFimDada,HoraFimEvento,HoraFim),
    HoraFim >= HoraInicio,
    Horas is HoraFim - HoraInicio.



% numHorasOcupadas(Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras):-


percentagem(SomaHoras, Max, Percentagem):-
    Percentagem is SomaHoras/Max * 100.

