%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI
% Trabalho de grupo 1º exercício
% Grupo de trabalho nº10 

% A74696 José Diogo Paiva Bastos
% A75353 Júlio Dinis Sá Peixoto
% A75210 Marcelo Alexandre Matos Fonseca Lima
% A74185 Ricardo António Gonçalves Pereira

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ). 
% não é PROLOG, preciso definir para usar os invariantes
% op(Precedência(prioridade) 1 a 1200 ,formato do operador(binário, unário...), operador/functor)
:- dynamic utente/4.
:- dynamic servico/4.
:- dynamic ato/4.


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural:  nao permitir a insercao de conhecimento repetido

+utente(IDU,N,I,M) :: (solucoes(IDU,utente(IDU,N,I,M),S), comprimento(S,X), X == 1).

+servico(IDS,D,I,C) :: (solucoes(IDS,servico(IDS,D,I,C),S), comprimento(S,X), X == 1).

+ato(D,IDUT,IDSE,C) :: (solucoes((IDUT,IDSE),ato(D,IDUT,IDSE,C),S), comprimento(S,X), X == 1).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Id do utente e do servico tem de existir para inserir um ato médico

+ato(D,IDU,IDS,C) :: (utente(IDU,_,_,_), 
					  servico(IDS,_,_,_)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%Base de conhecimento inicial

utente(1,'Renato Portoes',32,'Rua Nova Santa Cruz').
servico(1,'Unidade de saude','Centro de Saude','Braga').
ato('12-01-2017',1,1,105).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado registar: Termo -> {V,F}

registar(T) :- evolucao(T).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado removerUtente: Termo -> {V,F}

remover(T) :- retrocesso(T).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado que permite a evolucao do conhecimento

comprimento(S,X) :- length(S,X).

remove(T) :- retract(T).

insercao(T) :- assert(T).
insercao(T) :- retract(T), !,fail.

testar([]).
testar([I|L]) :- I, testar(L).

evolucao(F) :- solucoes(I,+F::I,L),
			   insercao(F), 
			   testar(L).

retrocesso(F) :- solucoes(I,+F::I,L),
				 testar(L),
				 remove(F).

solucoes(X,Y,Z) :- findall(X,Y,Z).
