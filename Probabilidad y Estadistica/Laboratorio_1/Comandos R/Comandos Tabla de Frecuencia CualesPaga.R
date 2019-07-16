rm()
# ************* Tablas de frecuencias en R *************

#Guarda en my_data la tabla que este copiada en Control + C
my_data <- read.table(file = "clipboard",sep = "\t", header=TRUE)

#muestra los primeros 90 datos
head(my_data, 10)

#Crea la tabla de frecuencia absoluta
FrecuenciAbsolutaCualesPaga <- table(my_data$Cuales_Paga)

#Crea la tabla de frecuencia relativa
FrecuenciaRelativaCualesPaga <- prop.table(table(my_data$Cuales_Paga))

#Convierte en porcentajes
FrecuenciaRelativaCualesPaga <- FrecuenciaRelativaCualesPaga*100

#Redondea a 2 decimales
FrecuenciaRelativaCualesPaga <- round(FrecuenciaRelativaCualesPaga, 2)

#Crea los marcos
#Marco1
marco1 <- data.frame(FrecuenciAbsolutaCualesPaga)
#Marco2
marco2 <- data.frame(FrecuenciaRelativaCualesPaga)
#Nombres de los marcos(organizacion de los nombres de las filas)
#Ejemplo:
names(marco1) <- c("Servicios pagados","Frecuencia Absoluta")
names(marco2) <- c("Servicios pagados","Frecuencia Relativa")

#mezclar marcos
TablaFrecuenciaCualesPaga <- merge(marco1,marco2,by="Servicios pagados")


summary(my_data)
