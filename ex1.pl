%----------------------------------------------------------------------------
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI
% Trabalho de grupo 1º exercício
% Grupo de trabalho nº10 

% A74696 José Diogo Paiva Bastos
% A75353 Júlio Dinis Sá Peixoto
% A75210 Marcelo Alexandre Matos Fonseca Lima
% A74185 Ricardo António Gonçalves Pereira

%----------------------------------------------------------------------------
% SICStus PROLOG: Declarações iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).
:- set_prolog_flag(toplevel_print_options, [quoted(true), portrayed(true), max_depth(0)]).

%----------------------------------------------------------------------------
% SICStus PROLOG: definições iniciais

:- op( 900,xfy,'::' ). 
:- dynamic utente/4. 		% (ID_Utente, Nome, Idade, Morada)
:- dynamic servico/4.		% (ID_Serviço, Descrição, Instituição, Cidade).
:- dynamic ato/4.			% (Data, ID_Utente, ID_Serviço, Custo).
:- dynamic medico/5.		% (ID_Médico, Nome, Idade, Morada, Especialização).

%----------------------------------------------------------------------------
% Extensão do predicado que permite a evolucao/retrocesso do conhecimento 
%----------------------------------------------------------------------------

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

%----------------------------------------------------------------------------
%									GERAL
%----------------------------------------------------------------------------

% Extensão do predicado sum: Lista, Resultado -> {V,F}
sum([],0).
sum([X|Y],G) :- sum(Y,R), G is R+X. 

% Extensão do predicado concat: Lista_1, Lista_2, Resultado -> {V,F}
concat([],R,R).
concat([X|L],R,[X|S]) :- concat(L,R,S).

% Extensão do predicado comprimento: Lista, Resultado -> {V,F}
comprimento([],0).
comprimento([H|T],N) :- 
	comprimento(T,N1),
	N is N1+1.

% Extensão do predicado eliminarRepetidos: Lista, Resultado -> {V,F}
eliminarRepetidos([], []) .
eliminarRepetidos([H|T], Res) :- eliminarElemento(T, H, E), 
						  eliminarRepetidos(E, R), 
						  Res = [H|R].

% Extensão do predicado eliminarElemento: Lista, Elemento, Resultado -> {V,F}
eliminarElemento([], _, []).
eliminarElemento([H|T], H, R) :- eliminarElemento(T, H, R).
eliminarElemento([H|T], E, Res)	:- H\== E, 
								   eliminarElemento(T, E, R), 
								   Res = [H|R].
%----------------------------------------------------------------------------


%----------------------------------------------------------------------------
%								Invariantes
%----------------------------------------------------------------------------

% Invariante Estrutural:  não permitir a inserção de conhecimento repetido

+utente(IDU,N,I,M) :: (solucoes(IDU,utente(IDU,_,_,_),S), 
					   comprimento(S,X), 
					   X == 1).

+servico(IDS,D,I,C) :: (solucoes(IDS,servico(IDS,_,_,_),S), 
						comprimento(S,X), 
						X == 1).

+servico(IDS,D,I,C) :: (solucoes((D,I),servico(_,D,I,_),S), 
						comprimento(S,X), 
						X == 1).

% Conhecimento extra
+medico(ID,N,I,M,E) :: (solucoes(ID,medico(ID,_,_,_,_),S),
						comprimento(S,X),
						X == 1).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Id do utente e do servico tem de existir para inserir um ato médico

+ato(D,IDU,IDS,C) :: (utente(IDU,_,_,_), 
					  servico(IDS,_,_,_)).
%----------------------------------------------------------------------------


%----------------------------------------------------------------------------
%						Base de conhecimento inicial
%----------------------------------------------------------------------------

utente(1,'Renato Portoes',32,'Rua Nova Santa Cruz').
utente(2,'Renato Portoes',32,'Rua Nova Santa Cruz').
utente(3,'Ricardo Azevedo',20,'Rua Velha Santa Cruz').
utente(4,'Ana Martins',22,'Rua do Outeiro').
utente(5,'Jose Vilaca',12,'Rua das Cegonhas').
utente(6,'Sara Alberto',45,'Rua dos Marcianos').
utente(7,'Joao Guilherme',89,'Avenida Central').
utente(8,'Afonso Aragao',26,'Rua dos Palacetes').
utente(9,'Jose Silva',73,'Estreito Largo').
utente(10,'Frederico Pereira',4,'Rua dos Carretos').
utente(11,'Rita Gameiro',52,'Rua Engenheiro Antonio Filipe').
utente(12,'Luis Marcio',15,'República das Bananas').
utente(13,'Pedro Luis',53,'Largo do Bigode').
utente(14,'Marco Cardoso',33,'Avenida Principal').


servico(1,'Ortopedia','Centro de Saude','Braga').
servico(2,'Cardiologia','Centro de Saude','Braga').
servico(3,'Neurocirurgia','Hospital privado','Braga').
servico(4,'Pediatria','Posto medico','Esposende').
servico(5,'Otorrinolaringologia','Hospital publico','Porto').
servico(6,'Oftalmologia','Clinica de Santa Madalena','Felgueiras').
servico(7,'Urologia','Centro de Saude','Amares').
servico(8,'Ginecologia','Clinica do Tubarao','Viana do Castelo').


ato('12-01-2017',1,1,19).
ato('13-01-2017',14,2,10).
ato('14-01-2017',2,3,15).
ato('15-01-2017',13,4,5).
ato('16-01-2017',3,6,12).
ato('17-01-2017',12,6,14).
ato('15-01-2017',4,7,5).
ato('16-01-2017',11,5,12).
ato('17-01-2017',5,8,100).
ato('24-01-2017',6,2,35).
ato('15-01-2017',7,7,80).
ato('19-01-2017',8,2,200).
ato('11-01-2017',9,6,10).
ato('25-01-2017',10,2,55).
ato('26-01-2017',11,3,40).
ato('29-01-2017',12,4,90).

%----------------------------------------------------------------------------


%----------------------------------------------------------------------------
%									Registar
%----------------------------------------------------------------------------

% Extensão do predicado registar: Termo -> {V,F}
registar(T) :- evolucao(T).

% Extensão do predicado registarUtente: Id_Utente, Nome, Idade, Morada -> {V,F}
registarUtente(IDU,N,I,M) :- evolucao(utente(IDU,N,I,M)).

% Extensão do predicado registarServico: Id_Serviço, Descrição, Instituição, Cidade -> {V,F}
registarServico(IDS,D,I,C) :- evolucao(servico(IDS,D,I,C)).

% Extensão do predicado registarAto: Data, Id_Utente, Id_Serviço, Custo -> {V,F}
registarAto(D,IDUT,IDSE,C) :- evolucao(ato(D,IDUT,IDSE,C)).

% Extensão do predicado registarMedico: Id_Médico, Nome, Idade, Morada, Especialização -> {V,F}
registarMedico(ID,N,I,M,E) :- evolucao(medico(ID,N,I,M,E)).
%----------------------------------------------------------------------------


%----------------------------------------------------------------------------
%									Remover
%----------------------------------------------------------------------------

% Extensão do predicado remover: Termo -> {V,F}
remover(T) :- retrocesso(T).

% Extensão do predicado removerUtente: Id_Utente, Nome, Idade, Morada -> {V,F}
removerUtente(ID) :- retrocesso(utente(ID,N,I,M)).

% Extensão do predicado removerServico: Id_Serviço, Descrição, Instituição, Cidade -> {V,F}
removerServico(ID) :- retrocesso(servico(ID,D,I,C)).

% Extensão do predicado removerAto: Data, Id_Utente, Id_Serviço -> {V,F}
removerAto(D,IDUT,IDSE) :- retrocesso(ato(D,IDUT,IDSE,C)).

% Extensão do predicado removerMedico: Id_Médico, Nome, Idade, Morada, Especialização -> {V,F}
removerMedico(ID,N,I,M,E) :- retrocesso(medico(ID,N,I,M,E)).
%----------------------------------------------------------------------------


%----------------------------------------------------------------------------
%							Listagem de informação
%----------------------------------------------------------------------------

% Extensão do predicado utenteID: ID, Resultado -> {V,F}
utenteID(ID,R) :- solucoes((ID,N,I,M),utente(ID,N,I,M),R).

% Extensão do predicado utentesNome: Nome, Resultado -> {V,F}
utentesNome(N,R) :- solucoes((ID,N,I,M),utente(ID,N,I,M),R).

% Extensão do predicado utentesIdade: Idade, Resultado -> {V,F}
utentesIdade(I,R) :- solucoes((ID,N,I,M),utente(ID,N,I,M),R).

% Extensão do predicado utentesMorada: Morada, Resultado -> {V,F}
utentesMorada(M,R) :- solucoes((ID,N,I,M),utente(ID,N,I,M),R).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado instituicoes: Resultado -> {V,F}
instituicoes(R) :- solucoes(I,servico(_,_,I,_),S),
				   eliminarRepetidos(S,R).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado servicoInstituicao: Instituição, Resultado -> {V,F}
servicoInstituicao(I,R) :- solucoes((ID,D,C),servico(ID,D,I,C),R).

% Extensão do predicado servicoCidade: Cidade, Resultado -> {V,F}
servicoCidade(C,R) :- solucoes((ID,D,I),servico(ID,D,I,C),R).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado instituicaoUtentes: Instituição, Resultado -> {V,F}
instituicaoUtentes(I,R) :- solucoes(IDU,institUtente(I,IDU),S),
						   eliminarRepetidos(S,W),
						   findUtentesServico(W,R).						   

institUtente(I,IDU) :- servico(IDS,D,I,C), 
					   ato(Data,IDU,IDS,Custo).			 

% Extensão do predicado servicoUtentes: Servico, Resultado -> {V,F}
servicoUtentes(IDS,R) :- solucoes(IDU,ato(_,IDU,IDS,_),S),
						 eliminarRepetidos(S,W),
						 findUtentesServico(W,R).						 

findUtentesServico([],[]).
findUtentesServico([X],R) :- solucoes((X,N,I,M),utente(X,N,I,M),R).
findUtentesServico([X|T],R) :- solucoes((X,N,I,M),utente(X,N,I,M),S),
							   findUtentesServico(T,W),
							   concat(S,W,R).

%--------------------------------- - - - - - - - - - -  -  -  -  - 
% Extensão do predicado atoUtente: Id_Utente, Resultado -> {V,F}
atoUtente(IDU,R) :- solucoes((em(D),de(IDU),servico(Des),custa(C)),atoServicoInfo(D,IDU,IDS,C,Des),R).

% Extensão do predicado atoServico: Id_Serviço, Resultado -> {V,F}
atoServico(IDS,R):- solucoes((em(D),id(IDS),servico(Des),custo(C)),atoServicoInfo(D,IDU,IDS,C,Des),R).

% Extensão do predicado atoInstituicao: Instituição, Resultado -> {V,F}
atoInstituicao(I,R) :- solucoes(IDS,servico(IDS,_,I,_),L),
					   findAto(L,R).

findAto([],[]).
findAto([X],R) :- solucoes((D,IDU,X,C),ato(D,IDU,X,C),R).
findAto([H|T],R) :- solucoes((D,IDU,H,C),ato(D,IDU,H,C),S),
					findAto(T,W),
					concat(S,W,R).

atoServicoInfo(D,IDU,IDS,C,Des) :- ato(D,IDU,IDS,C), servico(IDS,Des,Inst,Cidade).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado utenteInstituicoes: Id_Utente, Resultado -> {V,F}
utenteInstituicoes(U,R) :- solucoes(IDS,ato(_,U,IDS,_),S),
					  	   findInst(S,W),
					  	   eliminarRepetidos(W,R).

findInst([],[]).
findInst([X],R) :- solucoes(I,servico(X,D,I,C),R).
findInst([H|T],R) :- solucoes(I,servico(H,D,I,C),S),
					 findInst(T,W),
					 concat(S,W,R).

% Extensão do predicado utenteServico: Id_Serviço, Resultado -> {V,F}
utenteServico(U,R) :- solucoes(IDS,ato(_,U,IDS,_),S),
					  findServico(S,R).

findServico([],[]).
findServico([X],R) :- solucoes((X,D,I,C),servico(X,D,I,C),R).
findServico([H|T],R) :- solucoes((H,D,I,C),servico(H,D,I,C),S),
						findServico(T,W),
						concat(S,W,R).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado custoPorUtente: Id_Utente, Resultado -> {V,F}
custoPorUtente(IDU,R) :- solucoes(Custo,ato(D,IDU,IDS,Custo),S),
						 sum(S,R).
						
% Extensão do predicado custoPorServico: Id_Serviço, Resultado -> {V,F}
custoPorServico(IDS,R) :- solucoes(Custo,ato(D,IDU,IDS,Custo),S),
						  sum(S,R).

% Extensão do predicado custoPorData: Data, Resultado -> {V,F}
custoPorData(Data,R) :- solucoes(Custo,ato(Data,IDU,IDS,Custo),S),
						sum(S,R).

% Extensão do predicado custoPorInstituicao: Instituição, Resultado -> {V,F}
custoPorInstituicao(I,R) :- solucoes(IDS,servico(IDS,D,I,C),S),
							findCusto(S,W),
							sum(W,R).

findCusto([],[]).
findCusto([X],R) :- solucoes(C,ato(_,_,X,C),R).
findCusto([X|T],R) :- solucoes(C,ato(_,_,X,C),S),
					  findCusto(T,W),
					  concat(S,W,R).
%----------------------------------------------------------------------------

