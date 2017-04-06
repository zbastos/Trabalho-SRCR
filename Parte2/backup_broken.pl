%----------------------------------------------------------------------------
%						Conhecimento imperfeito
%----------------------------------------------------------------------------

%utente mora numa destas 3 opçoes
excecao(utente(15,'Zeferino Costa',40,'Rua do Dente')).
excecao(utente(15,'Zeferino Costa',40,'Largo do Dente')).
excecao(utente(15,'Zeferino Costa',40,'Avenida do Dente')).

%sabe-se que o custo do ato foi superior a 50
excecao(ato(data(04,02,2017),1,5,X,5)) :-  X>=50.

%não se sabe o médico que fez o ato
ato(data(08,02,2017),9,desconhecido,75,1).

%idade do médico entre 2 valores
excecao(medico(9,'Dr. Antonio Zequinha',X,'Estoril','Cirurgia')) :- X>=27, X=<37.

%Impossível saber o custo deste ato
ato(data(12,02,2017),3,5,interdito,5).
nulo(interdito).

+ato(D,IDUT,IDSE,C,IDMED) :: (solucoes(C,(ato(data(12,02,2017),3,5,C,5),nao(nulo(C))),S), 
								comprimento(S,N), N == 0).

%Neste ato apenas se sabe que não foi o utente com Id=2 
ato(data(14,02,2017),desconhecido,6,85,6).
-ato(data(14,02,2017),2,6,85,6).

%Neste ato sabe-se que o custo foi cerca de 25. ACHO QUE ESTÁ MAL ?????????
ato(data(15,02,2017),6,7,X,7) :- cercade(X,25).
cercade(X,Y) :- A is 0,9*Y, B is 1,1*Y, X>=A, X=<B.

%sabe-se que este serviço não se encontra disponível
-servico(10,'Dermatologia','Espaco Saude Beirao Rendeiro','Moledo').

%neste caso sabe-se que o ato foi entre o dia 12 e 16 de Março de 2017
excepcao(ato(data(X,03,2017),2,8,41,8)) :- X>=1, X=<15.

%não se sabe se o ato foi em Fevereiro ou Março 
excepcao(ato(data(2,03,2017),11,9,14,9)).
excepcao(ato(data(3,03,2017),11,9,14,9)).


%----------------------------------------------------------------------------
%acho que é preciso alterar esta próxima excecao por causa da mudança da data
excecao(ato(D,IDUT,IDSE,C,IDMED)):- ato(desconhecido,IDUT,IDSE,C,IDMED).
excecao(ato(D,IDUT,IDSE,C,IDMED)):- ato(D,desconhecido,IDSE,C,IDMED).
excecao(ato(D,IDUT,IDSE,C,IDMED)):- ato(D,IDUT,desconhecido,C,IDMED).
excecao(ato(D,IDUT,IDSE,C,IDMED)):- ato(D,IDUT,IDSE,desconhecido,IDMED).
excecao(ato(D,IDUT,IDSE,C,IDMED)):- ato(D,IDUT,IDSE,C,desconhecido).

excecao(ato(D,IDUT,IDSE,C,IDMED)):- ato(interdito,IDUT,IDSE,C,IDMED).
excecao(ato(D,IDUT,IDSE,C,IDMED)):- ato(D,interdito,IDSE,C,IDMED).
excecao(ato(D,IDUT,IDSE,C,IDMED)):- ato(D,IDUT,interdito,C,IDMED).
excecao(ato(D,IDUT,IDSE,C,IDMED)):- ato(D,IDUT,IDSE,interdito,IDMED).
excecao(ato(D,IDUT,IDSE,C,IDMED)):- ato(D,IDUT,IDSE,C,interdito).

-ato(D,IDUT,IDSE,C,IDMED) :- nao(ato(D,IDUT,IDSE,C,IDMED)),
								nao(excepcao(ato(D,IDUT,IDSE,C,IDMED))).

-utente(IDU,N,I,M) :- nao(utente(IDU,N,I,M)),
						nao(excepcao(utente(IDU,N,I,M))).

-medico(ID,N,I,M,E) :- nao(medico(ID,N,I,M,E)),
						nao(excepcao(medico(ID,N,I,M,E))).


-servico(IDS,D,I,C) :- nao(servico(IDS,D,I,C)),
						nao(excepcao(servico(IDS,D,I,C))).


%+ato(D,IDUT,IDSE,C,IDMED)::(Med \= desconhecido, nao(nulo(Med))).

demo(Q,verdadeiro) :- Q.
demo(Q,falso) :- -Q.
demo(Q,desconhecido) :- nao(Q), nao(-Q).

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).