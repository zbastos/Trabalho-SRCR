library(neuralnet)
library(hydroGOF)

#weka (verifcar dados)
#summary()

#ler dados
dadosnorm <- read.csv("/Users/josebastos/um/3ano/srcr/Trabalho-SRCR/Parte3/exaustao-normalizado.csv",header=TRUE,sep=";",dec=",")


formulaRNA <- Performance.Task+ExhaustionLevel ~ Performance.KDTMean+Performance.MAMean+Performance.MVMean+Performance.TBCMean+Performance.DDCMean+Performance.DMSMean+Performance.AEDMean+Performance.ADMSLMean

fatiguenet <- neuralnet(formulaRNA, dadosnorm, hidden = c(4,2), lifesign = "full", linear.output = FALSE, threshold = 0.01)

plot(fatiguenet, rep="best")

#teste.01 <- subset(teste, select = c("LTI", "age"))







rnacredito.resultados <- compute(rnacredito, teste.01)

resultados <- data.frame(atual = teste$default10yr, previsao = rnacredito.resultados$net.result)

resultados$previsao <- round(resultados$previsao, digits = 0)

rmse(c(teste$default10yr), c(resultados$previsao))
