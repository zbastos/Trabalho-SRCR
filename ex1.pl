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

+utente(IDU,N,I,M) :: (solucoes(IDU,utente(IDU,_,_,_),S), 
					   comprimento(S,X), 
					   X == 1).

+servico(IDS,D,I,C) :: (solucoes(IDS,servico(IDS,_,_,_),S), 
						comprimento(S,X), 
						X == 1).

+ato(D,IDUT,IDSE,C) :: (solucoes((D,IDUT,IDSE), ato(D,IDUT,IDSE,_),S), 
						comprimento(S,X), 
						X == 1).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Id do utente e do servico tem de existir para inserir um ato médico

+ato(D,IDU,IDS,C) :: (utente(IDU,_,_,_), 
					  servico(IDS,_,_,_)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%Base de conhecimento inicial

utente(1,'Renato Portoes',32,'Rua Nova Santa Cruz').
utente(2,'Renato Portoes',32,'Rua Nova Santa Cruz').
utente(3,'Ricardo',20,'Rua Nova Santa Cruz').
utente(4,'Ana',22,'Rua Nova Santa Cruz').
utente(5,'Ze',12,'Rua Nova Santa Cruz').
servico(1,'Unidade de saude','Centro de Saude','Braga').
servico(2,'Unidade de saude','Centro de Saude','Braga').
servico(3,'Unidade de saude','Centro','Braga').
servico(4,'Unidade de saude','Centro de Saude','Braga').
servico(5,'Unidade de saude','Centro','Braga').
servico(6,'Unidade de saude','Centro de Saude','Braga').
ato('12-01-2017',1,1,19).
ato('13-01-2017',1,2,10).
ato('14-01-2017',1,3,15).
ato('15-01-2017',1,4,5).
ato('16-01-2017',1,5,12).
ato('17-01-2017',1,6,14).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado registar: Termo -> {V,F}

registar(T) :- evolucao(T).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado remover: Termo -> {V,F}

remover(T) :- retrocesso(T).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado utenteID: ID, Resultado -> {V,F}

utenteID(ID,R) :- solucoes((ID,F,P,E),utente(ID,F,P,E),R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado utentesNome: Nome, Resultado -> {V,F}

utentesNome(N,R) :- solucoes((ID,N,P,E),utente(ID,N,P,E),R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado utentesIdade: Idade, Resultado -> {V,F}
		
utentesIdade(I,R) :- solucoes((ID,N,I,E),utente(ID,N,I,E),R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado utentesCidade: Morada, Resultado -> {V,F}

utentesCidade(M,R) :- solucoes((ID,N,P,M),utente(ID,N,P,M),R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado instituicao: Instituicao -> {V,F}

instituicoes(H) :- servico(_,_,H,_).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado que permite a evolucao do conhecimento

comprimento([],0).
comprimento([H|T],N) :- 
	comprimento(T,N1),
	N is N1+1.

remove(T) :- retract(T).

insercao(T) :- assert(T).
insercao(T) :- retract(T), !,fail.

testar([]).
testar([I|L]) :- I, testar(L).

evolucao(F) :- 
	solucoes(I,+F::I,L),
	insercao(F), 
	testar(L).

retrocesso(F) :- 
	solucoes(I,+F::I,L),
	testar(L),
	remove(F).

solucoes(X,Y,Z) :- findall(X,Y,Z).
