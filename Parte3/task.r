library(neuralnet)
library(hydroGOF)
library(leaps)
#weka (verifcar dados)
#summary()

#ler dados
dados <- read.csv("/Users/Ricardo/Documents/Git/Trabalho-SRCR/Parte3/dados.csv",header=TRUE,sep=";",dec=",")
dados <- dados[sample(nrow(dados)), ]

#normalizar fatiguelevel para 0 e 1
#dados$FatigueLevel[dados$FatigueLevel <= 3] <- 0
#dados$FatigueLevel[dados$FatigueLevel > 3] <- 1

#dados para treinar a rede
trainset <- dados[1:600,]

#dados para testar a rede
testset <- dados[601:845,]

#formulaTask <- Performance.Task ~ Performance.KDTMean+Performance.MAMean+Performance.MVMean+Performance.TBCMean+Performance.DDCMean+Performance.DMSMean+Performance.AEDMean+Performance.ADMSLMean
formulaTask <- Performance.Task ~ Performance.KDTMean + Performance.MAMean + Performance.DDCMean + Performance.DMSMean + Performance.AEDMean + Performance.ADMSLMean + FatigueLevel

tasknet <- neuralnet(formulaTask, trainset, hidden = c(3), lifesign = "full", linear.output = TRUE, threshold = 0.05)

#vartest <- subset(testset, select = -c(FatigueLevel, Performance.Task))
vartest <- subset(testset, select = -c(Performance.Task,Performance.MVMean,Performance.TBCMean))

tasknet.results <- compute(tasknet,vartest)

#tasknet.results$net.result <- round(tasknet.results$net.result, digits = 0)
resultadotask <- data.frame(OutputEsperado = testset$Performance.Task, Output = tasknet.results$net.result)

rmse(c(testset$Performance.Task),c(resultadotask$Output))
