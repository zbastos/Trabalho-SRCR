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

:- op( 900,xfy,'::' ). % não é PROLOG, preciso definir para usar os invariantes
% op(Precedência(prioridade) 1 a 1200 ,formato do operador(binário, unário...), operador/functor)
:- dynamic utente/4.
:- dynamic servico/4.
:- dynamic ato/4.

%Base de conhecimento inicial

utente(1,'Renato Portoes',32,'Rua Nova Santa Cruz').
servico(1,'Unidade de saude','Centro de Saude','Braga').
ato('12-01-2017',1,1,105).


% Invariante Estrutural:  nao permitir a insercao de conhecimento
%                         repetido
+utente( Id,N,I,M ) :: (findall( Id ,utente( Id,N,I,M ), S),
                  comprimento( S,X ), 
				  X == 1).

+servico( Id,D,I,C ) :: (findall( ( Id ),(servico( Id,D,I,C )),S ),
                  comprimento( S,X ), 
				  X == 1).

+ato( D,IdU,IdS,C ) :: (findall( ( IdU,IdS ),(ato( D,IdU,IdS,C )),S ),
                  comprimento( S,X ), 
				  X == 1).
% Id do utente e do servico tem de existir para inserir um ato médico
+ato( D,IdU,IdS,C ) :: utente( IdU,_,_,_ ), servico( IdS,_,_,_ ).




%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado que permite a evolucao do conhecimento



comprimento([], 0) .
comprimento([H|T], R) :-
	comprimento(T, X),	R is 1+X .

evolucao( F ) :- 	solucoes(I,+F::I,L), 
					insercao(F), 
					testar(L).

insercao( T ) :- assert(T).
insercao( T ) :- retract(T), !,fail.

testar([]).
testar([I|L]) :- I , testar(L).

