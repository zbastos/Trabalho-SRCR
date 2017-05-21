library(neuralnet)
library(hydroGOF)
library(leaps)

#weka (verifcar dados)
#summary()

#ler dados
dados <- read.csv("/Users/Ricardo/Documents/Git/Trabalho-SRCR/Parte3/dados.csv",header=TRUE,sep=";",dec=",")
dados <- dados[sample(nrow(dados)), ]

#dados 01
#dados <- read.csv("/Users/Ricardo/Documents/Git/Trabalho-SRCR/Parte3/dados01.csv",header=TRUE,sep=";",dec=",")
#dados <- dados[sample(nrow(dados)), ]

#normalizar fatiguelevel para 0 e 1
#dados$FatigueLevel[dados$FatigueLevel <= 3] <- 0
#dados$FatigueLevel[dados$FatigueLevel > 3] <- 1

#dados para treinar a rede
trainset <- dados[1:600,]

#dados para testar a rede
testset <- dados[601:845,]

formulaFatigue <- FatigueLevel ~ Performance.KDTMean + Performance.MAMean + Performance.MVMean + Performance.TBCMean + Performance.DDCMean + Performance.DMSMean + Performance.AEDMean + Performance.ADMSLMean + Performance.Task
#formulaFatigue <- FatigueLevel ~ Performance.KDTMean + Performance.MAMean + Performance.DDCMean + Performance.Task

params <- regsubsets(formulaFatigue,dados,method='backward',nvmax=10)
summary(params)
#formulaFatigue <- FatigueLevel ~  Performance.MAMean + Performance.DDCMean 

fatiguenet <- neuralnet(formulaFatigue, trainset, hidden = c(5), lifesign = "full", linear.output = TRUE, threshold = 0.01)

vartest <- subset(testset, select = -c(FatigueLevel, Performance.Task))
#vartest <- subset(testset, select = c(Performance.KDTMean,Performance.MAMean,Performance.DDCMean,Performance.Task))
#vartest <- subset(testset, select = c(Performance.MAMean,Performance.DDCMean))

fatiguenet.results <- compute(fatiguenet,vartest)

resultadoFatigue <- data.frame(OutputEsperado = testset$FatigueLevel, Output = fatiguenet.results$net.result)

rmse(c(testset$FatigueLevel),c(resultadoFatigue$Output))
