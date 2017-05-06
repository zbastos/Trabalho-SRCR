library(neuralnet)
library(hydroGOF)

#weka (verifcar dados)
#summary()

#ler dados
dadosnorm <- read.csv("/Users/josebastos/um/3ano/srcr/Trabalho-SRCR/Parte3/exaustao-normalizado.csv",header=TRUE,sep=";",dec=",")

#dados para treinar a rede
trainset <- dadosnorm[1:700,]

#dados para testar a rede
testset <- dadosnorm[701:845,]

#formulas
formulaRNA <- Performance.Task+FatigueLevel ~ Performance.KDTMean+Performance.MAMean+Performance.MVMean+Performance.TBCMean+Performance.DDCMean+Performance.DMSMean+Performance.AEDMean+Performance.ADMSLMean
formulaFatigue <- FatigueLevel ~ Performance.KDTMean+Performance.MAMean+Performance.MVMean+Performance.TBCMean+Performance.DDCMean+Performance.DMSMean+Performance.AEDMean+Performance.ADMSLMean
formulaTask <- Performance.Task ~ Performance.KDTMean+Performance.MAMean+Performance.MVMean+Performance.TBCMean+Performance.DDCMean+Performance.DMSMean+Performance.AEDMean+Performance.ADMSLMean

#redes
fatiguenet <- neuralnet(formulaFatigue, dadosnorm, hidden = c(10,5), lifesign = "full", linear.output = FALSE, threshold = 0.1)

tasknet <- neuralnet(formulaTask, dadosnorm, hidden = c(10,5), lifesign = "full", linear.output = FALSE, threshold = 0.1)

plot(fatiguenet, rep="best")

plot(tasknet, rep="best")



#testset tem valores de output que é necessário removê-los

vartest <- subset(testset, select = -c(FatigueLevel, Performance.Task))

#testar a rede

fatiguenet.results <- compute(fatiguenet,vartest)

tasknet.results <- compute(tasknet,vartest)

#comparar resultados de teste e de treino

resultadoFatigue <- data.frame(OutputEsperado = testset$FatigueLevel, Output = fatiguenet.results$net.result)

resultadotask <- data.frame(OutputEsperado = testset$Performance.Task, Output = tasknet.results$net.result)

#imprimir

print(round(fatiguenet.results$net.result, digits = 2))

print(round(tasknet.results$net.result, digits = 2))

#erros

rmse(c(testset$FatigueLevel),c(resultadoFatigue$Output))

rmse(c(testset$Performance.Task),c(resultadotask$Output))


#rnacredito.resultados <- compute(rnacredito, teste.01)

#resultados <- data.frame(atual = teste$default10yr, previsao = rnacredito.resultados$net.result)

#resultados$previsao <- round(resultados$previsao, digits = 0)

#rmse(c(teste$default10yr), c(resultados$previsao))
