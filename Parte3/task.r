library(neuralnet)
library(hydroGOF)
library(leaps)

#weka (verifcar dados)
#summary()

#ler dados
dados <- read.csv("/Users/Ricardo/Documents/Git/Trabalho-SRCR/Parte3/dados.csv",header=TRUE,sep=";",dec=",")
dados <- dados[sample(nrow(dados)), ]

#normalizar fatiguelevel para 0 e 1
dados$FatigueLevel[dados$FatigueLevel <= 3] <- 1
dados$FatigueLevel[dados$FatigueLevel > 3] <- 2

#dados para treinar a rede
trainset <- dados[1:600,]
#dados para testar a rede
testset <- dados[601:845,]

#formulaTask <- Performance.Task ~ Performance.KDTMean + Performance.MAMean + Performance.MVMean + Performance.TBCMean + Performance.DDCMean + Performance.DMSMean + Performance.AEDMean + Performance.ADMSLMean
formulaTask <- Performance.Task ~ Performance.DDCMean + Performance.KDTMean + Performance.TBCMean


tasknet <- neuralnet(formulaTask, trainset, hidden = c(4,2), lifesign = "full", algorithm='slr', linear.output = TRUE, threshold = 0.1)

vartest <- subset(testset, select = -c(FatigueLevel, Performance.Task))
#vartest <- subset(testset, select = c(Performance.MAMean, Performance.DDCMean, Performance.DMSMean, Performance.ADMSLMean))

tasknet.results <- compute(tasknet,vartest)

tasknet.results$net.result <- round(tasknet.results$net.result, digits = 0)
resultadotask <- data.frame(OutputEsperado = testset$Performance.Task, Output = tasknet.results$net.result)

rmse(c(testset$Performance.Task),c(resultadotask$Output))
