rm()
# ************* Tablas de frecuencias en R *************

#Guarda en my_data la tabla que este copiada en Control + C
my_data <- read.table(file = "clipboard",sep = "\t", header=TRUE)
my_dataSemanalmente <- read.table(file = "clipboard",sep = "\t", header=TRUE)
my_dataQuincenalmente <- read.table(file = "clipboard",sep = "\t", header=TRUE)

#muestra los primeros 90 datos
head(my_data, 10)

#Crea la tabla de frecuencia absoluta
FrecuenciAbsolutaGastoPromedio <- as.data.frame(table(Gasto_Promedio= (cut(my_dataQuincenalmente$Gasto_Promedio, breaks=8))))

#Crea la tabla de frecuencia Relativa
FrecuenciaRelativaGastoPromedio <- as.data.frame(prop.table(table(Gasto_Promedio= (cut(my_dataQuincenalmente$Gasto_Promedio, breaks=8)))))

#Convierte en porcentajes
FrecuenciaRelativaGastoPromedio$Freq <- FrecuenciaRelativaGastoPromedio$Freq*100

#Redondea a 2 decimales
FrecuenciaRelativaGastoPromedio$Freq <- round(FrecuenciaRelativaGastoPromedio$Freq, 2)


#Crea los marcos
#Marco1
marco1 <- data.frame(FrecuenciAbsolutaGastoPromedio)
#Marco2
marco2 <- data.frame(FrecuenciaRelativaGastoPromedio)
#Nombres de los marcos(organizacion de los nombres de las filas)
#Ejemplo:
names(marco1) <- c("Gasto promedio semanalmente","Frecuencia Absoluta")
names(marco2) <- c("Gasto promedio semanalmente","Frecuencia Relativa")

#mezclar marcos
TablaFrecuenciaGastoPromedioSemanlmente <- merge(marco1,marco2,by="Gasto promedio semanalmente")

View(TablaFrecuenciaGastoPromedioSemanlmente)

library(modes)
summary(my_dataQuincenalmente$Gasto_Promedio)
modes(my_dataQuincenalmente$Gasto_Promedio)

#medidas de variacion
sd(my_dataQuincenalmente$Gasto_Promedio)
var(my_dataQuincenalmente$Gasto_Promedio)
100*sd(my_dataQuincenalmente$Gasto_Promedio)/mean(my_dataSemanalmente$Gasto_Promedio)
IQR(my_dataQuincenalmente$Gasto_Promedio)
fivenum(my_dataQuincenalmente$Gasto_Promedio)


