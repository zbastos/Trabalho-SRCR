library(neuralnet)
library(hydroGOF)

#weka (verifcar dados)
#summary()

#ler dados
dados <- read.csv("creditset.csv")

#treinar os primeiros 1000 dados
treino <- dados[1:1000, ]

#criar teste 
teste <- dados[1001: 2000, ]


formula01 <- 

rnacredito <- neuralnet(formula01, treino, hidden = c(4), lifesign = "full", linear.output = FALSE, threshold = 0.01)

plot(rnacredito, rep="best")

teste.01 <- subset(teste, select = c("LTI", "age"))

rnacredito.resultados <- compute(rnacredito, teste.01)

resultados <- data.frame(atual = teste$default10yr, previsao = rnacredito.resultados$net.result)

resultados$previsao <- round(resultados$previsao, digits = 0)

rmse(c(teste$default10yr), c(resultados$previsao))
