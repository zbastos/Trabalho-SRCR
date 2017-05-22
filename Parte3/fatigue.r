library(neuralnet)
library(hydroGOF)
library(leaps)
library("arules")

#ler dados
dados <- read.csv("/Users/Ricardo/Documents/Git/Trabalho-SRCR/Parte3/dados.csv",header=TRUE,sep=";",dec=",")
dados <- dados[sample(nrow(dados)), ]

    dados$FatigueLevel <- as.numeric(discretize(dados$FatigueLevel, method = "frequency", categories = 5))

merdas <- table(dados$FatigueLevel)

barplot(merdas)

#normalizar fatiguelevel para 1 e 2
#dados$FatigueLevel[dados$FatigueLevel <= 3] <- 1
#dados$FatigueLevel[dados$FatigueLevel > 3] <- 2

dados$FatigueLevel[dados$FatigueLevel = 1] <- 1
dados$FatigueLevel[dados$FatigueLevel = 2] <- 2
dados$FatigueLevel[dados$FatigueLevel = 3] <- 3
dados$FatigueLevel[dados$FatigueLevel >= 4] <- 4

#dados para treinar a rede
trainset <- dados[1:600,]

#dados para testar a rede
testset <- dados[601:845,]


#todos os atributos

formulaFatigue <- FatigueLevel ~ Performance.KDTMean + Performance.MAMean + Performance.MVMean + 
                                 Performance.TBCMean + Performance.DDCMean + Performance.DMSMean + 
                                 Performance.AEDMean + Performance.ADMSLMean


 formulaFatigue <- FatigueLevel ~ Performance.KDTMean + Performance.MAMean + Performance.MVMMean + Performance.DDCMean

#R
#formulaFatigue <- FatigueLevel ~ Performance.KDTMean + Performance.MAMean + Performance.TBCMean + Performance.ADMSLMean

#Weka


#params <- regsubsets(formulaFatigue,dados,nvmax=10)
#summary(params)
#formulaFatigue <- FatigueLevel ~  Performance.MAMean + Performance.DDCMean 

fatiguenet <- neuralnet(formulaFatigue, trainset, hidden = c(16,20), lifesign = "full", algorithm='slr', linear.output = TRUE, threshold = 0.1)

#vartest <- subset(testset, select = c(Performance.KDTMean,Performance.MAMean,Performance.DDCMean, Performance.MVMean))
#vartest <- subset(testset, select = c(Performance.KDTMean,Performance.MAMean,Performance.DDCMean,Performance.Task))
vartest <- subset(testset, select = -c(FatigueLevel,Performance.Task))

fatiguenet.results <- compute(fatiguenet,vartest)

resultadoFatigue <- data.frame(OutputEsperado = testset$FatigueLevel, Output = fatiguenet.results$net.result)

rmse(c(testset$FatigueLevel),c(resultadoFatigue$Output))
