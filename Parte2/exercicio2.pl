%----------------------------------------------------------------------------
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI
% Trabalho de grupo 2º exercício
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
:- dynamic ato/5.			% (Data, ID_Utente, ID_Serviço, Custo, ID_Médico).
:- dynamic medico/5.		% (ID_Médico, Nome, Idade, Morada, Especialização).
:- dynamic data/3.			% (Dia, Mês, Ano)

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
	solucoes(I,-F::I,L),
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
%					META-PREDICADOS - Conhecimento Imperfeito
%----------------------------------------------------------------------------

demo(Q,verdadeiro) :- Q.
demo(Q,falso) :- -Q.
demo(Q,desconhecido) :- nao(Q), nao(-Q).

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).
%----------------------------------------------------------------------------


%----------------------------------------------------------------------------
%								Invariantes
%----------------------------------------------------------------------------

% dias válidos para a data
+data(Dia, Mes, Ano) :: (Dia>=0; Dia=<31; Mes>=0; Mes=<12; Ano>=0).


% não permitir a inserção de conhecimento repetido

+utente(IDU,N,I,M) :: (solucoes(IDU,utente(IDU,_,_,_),S), 
					   comprimento(S,X), 
					   X == 1).

+servico(IDS,D,I,C) :: (solucoes(IDS,servico(IDS,_,_,_),S), 
						comprimento(S,X), 
						X == 1).

+medico(ID,N,I,M,E) :: (solucoes(ID,medico(ID,_,_,_,_),S),
						comprimento(S,X),
						X == 1).

+servico(IDS,D,I,C) :: (solucoes((D,I),servico(_,D,I,C),S), 
						comprimento(S,X), 
						X == 1).


% Id do utente, do servico e do medico tem de existir para inserir um ato médico
+ato(D,IDU,IDS,C,IDMED) :: (utente(IDU,_,_,_), 
					  		servico(IDS,D,_,_),
					  		medico(IDMED,_,_,_,D)).

%----------------------------------------------------------------------------
% não permitir a remoção de conhecimento inexistente
-utente(IDU,N,I,M) :: (solucoes(IDU,utente(IDU,_,_,_),S), 
					   comprimento(S,X), 
					   X == 1).

-servico(IDS,D,I,C) :: (solucoes(IDS,servico(IDS,_,_,_),S), 
						comprimento(S,X), 
						X == 1).

-medico(ID,N,I,M,E) :: (solucoes(ID,medico(ID,_,_,_,_),S),
						comprimento(S,X),
						X == 1).

-ato(D,IDU,IDS,C,IDMED) :: (solucoes((D,IDU,IDS),ato(D,IDU,IDS,_,IDMED),S),
					  		comprimento(S,X),
					  		X==1).

%não permitir a remoção de utentes, servicos e medicos caso existem atos associados a eles
-utente(IDU,N,I,M) :: (nao(ato(_,IDU,_,_,_)),
					   nao(excecao(ato(_,IDU,_,_,_)))).

-servico(IDS,D,I,C) :: (nao(ato(_,_,IDS,_,_)),
						nao(excecao(ato(_,_,IDS,_,_)))).

-medico(ID,N,I,M,E) :: (nao(ato(_,_,_,_,ID)),
						nao(excecao(ato(_,_,_,_,ID)))).

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
utente(12,'Luis Marcio',15,'Republica das Bananas').
utente(13,'Pedro Luis',53,'Largo do Bigode').
utente(14,'Marco Cardoso',33,'Avenida Principal').


servico(1,'Ortopedia','Centro de Saude Santa Tecla','Braga').
servico(2,'Cardiologia','Centro de Saude Santa Tecla','Braga').
servico(3,'Neurocirurgia','Hospital Privado de Braga','Braga').
servico(4,'Pediatria','Posto medico de Fao','Esposende').
servico(5,'Otorrinolaringologia','Hospital Santa Maria','Porto').
servico(6,'Oftalmologia','Clinica de Santa Madalena','Felgueiras').
servico(7,'Urologia','Casa de Saude de Caldelas','Amares').
servico(8,'Ginecologia','Clinica do Tubarao','Viana do Castelo').
servico(9,'Ortopedia','Espaco Saude Beirao Rendeiro','Moledo').


medico(1,'Dr. Eugenio Andrade',54,'Viana do Castelo','Ortopedia').
medico(2,'Dr. Firmino Cunha',63,'Guimaraes','Cardiologia').
medico(3,'Dr. Jorge Costa',38,'Santo Tirso','Neurocirurgia').
medico(4,'Dr. Bruno Hermenegildo',48,'Vila das Aves','Pediatria').
medico(5,'Dra. Alberta Mendes',57,'Matosinhos','Otorrinolaringologia').
medico(6,'Dr. Cristiano Soares',34,'Terras de Bouro','Oftalmologia').
medico(7,'Dra. Rosalina Oliveira',49,'Vieira do Minho','Urologia').
medico(8,'Dr. Carlos Mota',44,'Maia','Ginecologia').


ato(data(12,01,2017),1,1,19,1).
ato(data(13,01,2017),14,2,10,2).
ato(data(14,01,2017),2,3,15,3).
ato(data(15,01,2017),13,4,5,4).
ato(data(16,01,2017),3,6,12,6).
ato(data(17,01,2017),12,6,14,6).
ato(data(15,01,2017),4,7,5,7).
ato(data(16,01,2017),11,5,12,5).
ato(data(17,01,2017),5,8,100,8).
ato(data(24,01,2017),6,2,35,2).
ato(data(15,01,2017),7,7,80,7).
ato(data(19,01,2017),8,2,200,2).
ato(data(11,01,2017),9,6,10,6).
ato(data(25,01,2017),10,2,55,2).
ato(data(26,01,2017),11,3,40,3).
ato(data(29,01,2017),12,4,90,4).
ato(data(31,01,2017),13,9,50,1).

%----------------------------------------------------------------------------
%									Registar
%----------------------------------------------------------------------------

% Extensão do predicado registar: Termo -> {V,F}
registar(T) :- evolucao(T).

% Extensão do predicado registarUtente: Id_Utente, Nome, Idade, Morada -> {V,F}
registarUtente(IDU,N,I,M) :- evolucao(utente(IDU,N,I,M)).

% Extensão do predicado registarServico: Id_Serviço, Descrição, Instituição, Cidade -> {V,F}
registarServico(IDS,D,I,C) :- evolucao(servico(IDS,D,I,C)).

% Extensão do predicado registarAto: Data, Id_Utente, Id_Serviço, Custo, Id_Médico -> {V,F}
registarAto(D,IDUT,IDSE,C,IDMED) :- evolucao(ato(D,IDUT,IDSE,C,IDMED)).

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

% Extensão do predicado removerAto: Data, Id_Utente, Id_Serviço, Id_Médico -> {V,F}
removerAto(D,IDUT,IDSE,IDMED) :- retrocesso(ato(D,IDUT,IDSE,C,IDMED)).

% Extensão do predicado removerMedico: Id_Médico, Nome, Idade, Morada, Especialização -> {V,F}
removerMedico(ID) :- retrocesso(medico(ID,N,I,M,E)).
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
					   ato(Data,IDU,IDS,Custo,IDMED).			 

% Extensão do predicado servicoUtentes: Servico, Resultado -> {V,F}
servicoUtentes(IDS,R) :- solucoes(IDU,ato(_,IDU,IDS,_,_),S),
						 eliminarRepetidos(S,W),
						 findUtentesServico(W,R).						 

findUtentesServico([],[]).
findUtentesServico([X],R) :- solucoes((X,N,I,M),utente(X,N,I,M),R).
findUtentesServico([X|T],R) :- solucoes((X,N,I,M),utente(X,N,I,M),S),
							   findUtentesServico(T,W),
							   concat(S,W,R).

%--------------------------------- - - - - - - - - - -  -  -  -  - 
% Extensão do predicado atoUtente: Id_Utente, Resultado -> {V,F}
atoUtente(IDU,R) :- solucoes((em(D),de(IDU),servico(Des),custa(C)),atoServicoInfo(D,IDU,IDS,C,IDMED,Des),R).

% Extensão do predicado atoServico: Id_Serviço, Resultado -> {V,F}
atoServico(IDS,R):- solucoes((em(D),id(IDS),servico(Des),custo(C)),atoServicoInfo(D,IDU,IDS,C,IDMED,Des),R).

% Extensão do predicado atoInstituicao: Instituição, Resultado -> {V,F}
atoInstituicao(I,R) :- solucoes(IDS,servico(IDS,_,I,_),L),
					   findAto(L,R).

findAto([],[]).
findAto([X],R) :- solucoes((em(D),de(IDU),idServico(X),custo(C)),ato(D,IDU,X,C,IDMED),R).
findAto([H|T],R) :- solucoes((em(D),de(IDU),idServico(H),custo(C)),ato(D,IDU,H,C,IDMED),S),
					findAto(T,W),
					concat(S,W,R).

atoServicoInfo(D,IDU,IDS,C,IDMED,Des) :- ato(D,IDU,IDS,C,IDMED), servico(IDS,Des,Inst,Cidade).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado utenteInstituicoes: Id_Utente, Resultado -> {V,F}
utenteInstituicoes(U,R) :- solucoes(IDS,ato(_,U,IDS,_,_),S),
					  	   eliminarRepetidos(S,W),
					  	   findInst(W,R).

findInst([],[]).
findInst([X],R) :- solucoes((I,C),servico(X,D,I,C),R).
findInst([H|T],R) :- solucoes((I,C),servico(H,D,I,C),S),
					 findInst(T,W),
					 concat(S,W,R).

% Extensão do predicado utenteServico: Id_Serviço, Resultado -> {V,F}
utenteServico(U,R) :- solucoes(IDS,ato(_,U,IDS,_,_),S),
					  eliminarRepetidos(S,W),
					  findServico(W,R).

findServico([],[]).
findServico([X],R) :- solucoes((X,D,I,C),servico(X,D,I,C),R).
findServico([H|T],R) :- solucoes((H,D,I,C),servico(H,D,I,C),S),
						findServico(T,W),
						concat(S,W,R).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado custoPorUtente: Id_Utente, Resultado -> {V,F}
custoPorUtente(IDU,R) :- solucoes(Custo,ato(D,IDU,IDS,Custo,IDMED),S),
						 sum(S,R).
						
% Extensão do predicado custoPorServico: Id_Serviço, Resultado -> {V,F}
custoPorServico(IDS,R) :- solucoes(Custo,ato(D,IDU,IDS,Custo,IDMED),S),
						  sum(S,R).

% Extensão do predicado custoPorData: Data, Resultado -> {V,F}
custoPorData(Data,R) :- solucoes(Custo,ato(Data,IDU,IDS,Custo,IDMED),S),
						sum(S,R).

% Extensão do predicado custoPorInstituicao: Instituição, Resultado -> {V,F}
custoPorInstituicao(I,R) :- solucoes(IDS,servico(IDS,D,I,C),S),
							findCusto(S,W),
							sum(W,R).

findCusto([],[]).
findCusto([X],R) :- solucoes(C,ato(_,_,X,C,_),R).
findCusto([X|T],R) :- solucoes(C,ato(_,_,X,C,_),S),
					  findCusto(T,W),
					  concat(S,W,R).
%----------------------------------------------------------------------------


%----------------------------------------------------------------------------
%						Listagem de informação (Extra)
%----------------------------------------------------------------------------

% Extensão do predicado medicoID: ID, Resultado -> {V,F}
medicoID(ID,R) :- solucoes((ID,N,I,M,E),medico(ID,N,I,M,E),R).

% Extensão do predicado medicosNome: Nome, Resultado -> {V,F}
medicosNome(N,R) :- solucoes((ID,N,I,M,E),medico(ID,N,I,M,E),R).

% Extensão do predicado medicosIdade: Idade, Resultado -> {V,F}
medicosIdade(I,R) :- solucoes((ID,N,I,M,E),medico(ID,N,I,M,E),R).

% Extensão do predicado medicosMorada: Morada, Resultado -> {V,F}
medicosMorada(M,R) :- solucoes((ID,N,I,M,E),medico(ID,N,I,M,E),R).

% Extensão do predicado medicosEspecialização: Especialização, Resultado -> {V,F}
medicosEspecializacao(E,R) :- solucoes((ID,N,I,M,E),medico(ID,N,I,M,E),R).

% Extensão do predicado atosMedico: Id_Médico, Resultado -> {V,F}
atosMedico(IDMED,R) :- solucoes((em(D),id_utente(IDU),servico(Des),custa(C)),atoServicoInfo(D,IDU,IDS,C,IDMED,Des),R).

% Extensão do predicado custoMedioPorAto: Id_Médico, Resultado -> {V,F}
custoMedioPorMedico(IDMED,R) :- solucoes(Custo,ato(D,IDU,IDS,Custo,IDMED),S),
						  	 	sum(S,Sum),
						  	 	comprimento(S,L),
						  	 	R is Sum/L.

medicosInstituicao(M,R) :- solucoes(IDS,ato(_,_,IDS,_,M),S),
					  	   findInst(S,W),
					  	   eliminarRepetidos(W,R).


instituicoesMedico(I,R) :- solucoes(IDMED,institMed(I,IDMED),S),
							   eliminarRepetidos(S,W),
							   findMedicosServico(W,R).					   

institMed(I,IDMED) :- servico(IDS,D,I,C), 
					ato(Data,IDU,IDS,Custo,IDMED).

findMedicosServico([],[]).
findMedicosServico([X],R) :- solucoes((X,N,I,M,E),medico(X,N,I,M,E),R).
findMedicosServico([X|T],R) :- solucoes((X,N,I,M,E),medico(X,N,I,M,E),S),
							   findMedicosServico(T,W),
							   concat(S,W,R).

%----------------------------------------------------------------------------
%						Conhecimento Negativo
%----------------------------------------------------------------------------


-utente(ID_Utente, Nome, Idade, Morada) :- nao(utente(ID_Utente, Nome, Idade, Morada)),
										   nao(excecao(utente(ID_Utente, Nome, Idade, Morada))).

-servico(ID_Servico, Descricao, Instituicao, Cidade) :- nao(servico(ID_Servico, Descricao, Instituicao, Cidade)),
														nao(excecao(servico(ID_Servico, Descricao, Instituicao, Cidade))).

-ato(Data, ID_Utente, ID_Servico, Custo, ID_Medico) :- nao(ato(Data, ID_Utente, ID_Servico, Custo, ID_Medico)),
													   nao(excecao(ato(Data, ID_Utente, ID_Servico, Custo, ID_Medico))).

-medico(ID_Medico, Nome, Idade, Morada, Especializacao) :- nao(medico(ID_Medico, Nome, Idade, Morada, Especializacao)),
														   nao(excecao(medico(ID_Medico, Nome, Idade, Morada, Especializacao))).

% Exemplos de conhecimento negativo.
-utente(25,'Antonio Manuel',47,'Avenida Manuel Carvalho').
-servico(15,'Cardiologia','Clinica Limao','Guimaraes')
-ato(data(20,05,2017),1,7,87,7).
-medico(9,'Dr. Fernando Silva',36,'Porto','Ginecologia').


%----------------------------------------------------------------------------
%						Conhecimento imperfeito
%----------------------------------------------------------------------------


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% 	Incerto
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Desconhecimento da morada do utente.
utente(15,'Antonio Manuel',47,morada_desconhecida).

% Desconhecimento da idade do utente, mas com o conhecimento de que não é 50 anos.
utente(16,'Ze Maria',idade_desconhecida,'Rua das azeitonas').
-utente(16,'Ze Maria',50,'Rua das azeitonas').

% Desconhecimento do custo associado a um ato.
ato(data(12,02,2017),3,2,custo_desconhecido,2).

% Desconhecimento do utente associado a um ato, mas com o conhecimento de que não é o Marco Cardoso (id: 14).
ato(data(20,01,2017),utente_desconhecido,5,47,5).
-ato(data(20,01,2017),14,5,47,5).
	
% Desconhecimento da especialização de um médico.
medico(9,'Dr. Fernando Silva',36,'Porto',especializacao_desconhecida).

% Conjunto das exceções associadas.
excecao(utente(ID_Utente, Nome, Idade, Morada)) :- utente(ID_Utente, Nome, Idade,morada_desconhecida).
excecao(utente(ID_Utente, Nome, Idade, Morada)) :- utente(ID_Utente, Nome, idade_desconhecida, Morada).
excecao(ato(Data, ID_Utente, ID_Servico, Custo, ID_Medico)) :- ato(Data, ID_Utente, ID_Servico, custo_desconhecido, ID_Medico).
excecao(ato(Data, ID_Utente, ID_Servico, Custo, ID_Medico)) :- ato(Data, utente_desconhecido, ID_Servico, Custo, ID_Medico).
excecao(medico(ID_Medico, Nome, Idade, Morada, Especializacao)) :- medico(ID_Medico, Nome, Idade, Morada, especializacao_desconhecida).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% 	Impreciso
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Tendo conhecimento apenas do ano de nascimento do Luís é impossível confirmar 
% a idade deste, sendo, portanto, 38 ou 39 anos. (-> era boa ideia se metessemos o ano 
% nascimento dele, em vez da idade)

excecao(utente(17,'Luis Peixoto',38,'Largo das flores')).
excecao(utente(17,'Luis Peixoto',39,'Largo das flores')).

% A Dra. Ana Fonseca abriu recentemente uma clínica que oferece serviços de uma só 
% especialidade. Sabe-se também que a doutora se especializou em Cardiologia,
% Neurologia e ainda Neurocirurgia, desta forma, o serviço oferecido pela clínica
% pode efetivamente ser de qualquer uma das especialidade da doutora.

excecao(servico(10,'Cardiologia','Clinica Fonseca','Guimaraes')).
excecao(servico(10,'Neurologia','Clinica Fonseca','Guimaraes')).
excecao(servico(10,'Neurocirurgia','Clinica Fonseca','Guimaraes')).

% Devido a um problema na base de dados do Centro de Saúde, foi perdido o dia referente
% a um determinado ato, sabendo-se agora apenas o ano e mês deste.

excecao(ato(data(Dia,03,2017),6,3,85,3)) :- Dia>=1, Dia=<31.

% O António contou ao José que na sua última consulta de Oftamologia gastou cerca de 100€.
% O José não sabe o valor certo do custo associado à consulta do amigo, mas sabe todas as 
% informações restantes.

excecao(ato(data(30,04,2017),8,6,Custo,6)) :- cercade(Custo,100).
cercade(X,Y) :- A is 0.9*Y, B is 1.1*Y, X>=A, X=<B.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% 	Interdito 
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Impossibilidade de se saber a morada de um determinado utente.
utente(18,'Fernando Torres',22,morada_interdita).
nulo(morada_interdita).
+utente(ID_Utente, Nome, Idade, Morada) :: (solucoes( (ID_Utente, Nome, Idade, Morada_Interdita),
											(utente(18,'Fernando Torres',22,Morada_Interdita),nao(nulo(Morada_Interdita))),S ),
											comprimento( S,N ), N == 0 ).


% Impossibilidade de se saber a especialização de um determinado médico.
medico(10, 'Dr. Armando Leal', 68, 'Rua Nova de Santa Cruz', especializacao_interdita).
nulo(especializacao_interdita).
+medico(ID_Medico, Nome, Idade, Morada, Especializacao) :: (solucoes( (ID_Medico, Nome, Idade, Morada, Especializacao_Interdita),
											(medico(10, 'Dr. Armando Leal', 68, 'Rua Nova de Santa Cruz', Especializacao_Interdita),nao(nulo(Especializacao_Interdita))),S ),
                  							comprimento( S,N ), N == 0 ).


% Impossibilidade de se saber a instituição de um determinado serviço.
servico(11,'Pediatria',instituicao_interdita,'Lisboa').
nulo(instituicao_interdita).
+servico(ID_Servico, Descricao, Instituicao, Cidade) :: (solucoes( (ID_Servico, Descricao, Instituicao_Interdita, Cidade),
														 (servico(11,'Pediatria',instituicao_interdita,'Lisboa'),nao(nulo(Instituicao_Interdita))), S),
														 comprimento(S,N), N == 0 ).


% Conjunto das exceções associadas.
excecao(utente(ID_Utente, Nome, Idade, Morada)) :- utente(ID_Utente, Nome, Idade, morada_interdita).
excecao(medico(ID_Medico, Nome, Idade, Morada, Especializacao)) :- medico(ID_Medico, Nome, Idade, Morada, especializacao_interdita).
excecao(servico(ID_Servico, Descricao, Instituicao, Cidade)) :- servico(ID_Servico, Descricao, instituicao_interdita, Cidade).


