rm()
# ************* Tablas de frecuencias en R *************

#Guarda en my_data la tabla que este copiada en Control + C
my_data <- read.table(file = "clipboard",sep = "\t", header=TRUE)

#muestra los primeros 90 datos
head(my_data, 10)

#Crea la tabla de frecuencia absoluta
FrecuenciAbsolutaCadaCuanto <- table(my_data$Cada_Cuanto)

#Crea la tabla de frecuencia relativa
FrecuenciaRelativaCadaCuanto <- prop.table(table(my_data$Cada_Cuanto))

#Convierte en porcentajes
FrecuenciaRelativaCadaCuanto <- FrecuenciaRelativaCadaCuanto*100

#Redondea a 2 decimales
FrecuenciaRelativaCadaCuanto <- round(FrecuenciaRelativaCadaCuanto, 2)

#Crea los marcos
#Marco1
marco1 <- data.frame(FrecuenciAbsolutaCadaCuanto)
#Marco2
marco2 <- data.frame(FrecuenciaRelativaCadaCuanto)
#Nombres de los marcos(organizacion de los nombres de las filas)
#Ejemplo:
names(marco1) <- c("Cada cuanto merca","Frecuencia Absoluta")
names(marco2) <- c("Cada cuanto merca","Frecuencia Relativa")

#mezclar marcos
TablaFrecuenciaCadaCuanto <- merge(marco1,marco2,by="Cada cuanto merca")


summary(my_data)
