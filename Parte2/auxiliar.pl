%----------------------------------------------------------------------------
%						Conhecimento imperfeito
%----------------------------------------------------------------------------

% utente (ID_Utente, Nome, Idade, Morada)
% servico (ID_Serviço, Descrição, Instituição, Cidade).
% ato (Data, ID_Utente, ID_Serviço, Custo, ID_Médico).
% medico (ID_Médico, Nome, Idade, Morada, Especialização).
% data (Dia, Mês, Ano)

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% 	Incerto
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Desconhecimento da morada do utente.
utente(15,'António Manuel',47,morada_desconhecida).

% Desconhecimento da idade do utente.
utente(16,'Zé Maria',idade_desconhecida,'Rua das azeitonas').

% Desconhecimento do custo associado a um ato.
ato(data(12,02,2017),3,2,custo_desconhecido,2).

% Desconhecimento do utente associado a um ato.
ato(data(20,01,2017),utente_desconhecido,5,47,5).
	
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

excecao(utente(17,'Luís Peixoto',38,'Largo das flores')).
excecao(utente(17,'Luís Peixoto',39,'Largo das flores')).

% A Dra. Ana Fonseca abriu recentemente uma clínica que oferece serviços de uma só 
% especialidade. Sabe-se também que a Dra. Ana Fonseca se especializou em Cardiologia,
% Neurologia e ainda Neurocirurgia, desta forma, o serviço oferecido pela clínica
% pode efetivamente ser de qualquer uma das especialidade da doutora.

excecao(servico(10,'Cardiologia','Clínica Fonseca','Guimarães')).
excecao(servico(10,'Neurologia','Clínica Fonseca','Guimarães')).
excecao(servico(10,'Neurocirurgia','Clínica Fonseca','Guimarães')).

% Devido a um problema na base de dados do Centro de Saúde, foi perdido o dia referente
% a um determinado ato, sabendo-se agora apenas o ano e mês deste.

excecao(ato(data(Dia,03,2017),6,3,85,3)) :- Dia >= 1, Dia <= 31.

% O António contou ao José que na sua última consulta de Oftamologia gastou cerca de 100€.
% O José não sabe o valor certo do custo associado à consulta do amigo, mas sabe todas as 
% informações restantes.

excecao(ato(data(30,04,2017),8,6,Custo,6)) :- cercade(Custo,100).
cercade(X,Y) :- A is 0,9*Y, B is 1,1*Y, X>=A, X=<B.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% 	Interdito 
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Impossibilidade de se saber a morada de um determinado utente.
utente(18,'Fernando Torres',22,morada_interdita).
nulo(morada_interdita).
+utente(ID_Utente, Nome, Idade, Morada) :: (solucoes( (ID_Utente, Nome, Idade, Morada_Interdita),
											(utente(18,'Fernando Torres',22,Morada_Interdita)),nao(nulo(Morada_Interdita))),S ),
                  							comprimento( S,N ), N == 0 ).


% Impossibilidade de se saber a especialização de um determinado médico.
medico(10, 'Dr. Armando Leal', 68, 'Rua Nova de Santa Cruz', especializacao_interdita).
nulo(especializacao_interdita).
+medico(ID_Medico, Nome, Idade, Morada, Especializacao) :: (solucoes( (ID_Medico, Nome, Idade, Morada, Especializacao_Interdita),
											(medico(10, 'Dr. Armando Leal', 68, 'Rua Nova de Santa Cruz', Especializacao_Interdita)),nao(nulo(Especializacao_Interdita))),S ),
                  							comprimento( S,N ), N == 0 ).


% Conjunto das exceções associadas.
excecao(utente(ID_Utente, Nome, Idade, Morada)) :- utente(ID_Utente, Nome, Idade, morada_interdita).
excecao(medico(ID_Medico, Nome, Idade, Morada, Especializacao)) :- medico(ID_Medico, Nome, Idade, Morada, especializacao_interdita).


