rm()
# ************* Tablas de frecuencias en R *************

#Guarda en my_data la tabla que este copiada en Control + C
my_data <- read.table(file = "clipboard",sep = "\t", header=TRUE)

#muestra los primeros 90 datos
head(my_data, 10)

#Crea la tabla de frecuencia absoluta
FrecuenciAbsolutaGastoPromedio <- as.data.frame(table(Edad= factor(cut(my_data$Gasto_Promedio, breaks=8))))

#Crea la tabla de frecuencia Relativa
FrecuenciaRelativaGastoPromedio <- as.data.frame(prop.table(table(Edad= factor(cut(my_data$Gasto_Promedio, breaks=8)))))

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
names(marco1) <- c("Gasto promedio","Frecuencia Absoluta")
names(marco2) <- c("Gasto promedio","Frecuencia Relativa")

#mezclar marcos
TablaFrecuenciaEdad <- merge(marco1,marco2,by="Edad")


summary(my_data)
