rm()
# ************* Tablas de frecuencias en R *************

#Guarda en my_data la tabla que este copiada en Control + C
my_data <- read.table(file = "clipboard",sep = "\t", header=TRUE)

#muestra los primeros 90 datos
head(my_data, 10)

#Crea la tabla de frecuencia absoluta
FrecuenciAbsolutaCabezaHogar <- table(my_data$Cabeza_De_Hogar)

#Crea la tabla de frecuencia relativa
FrecuenciaRelativaCabezaHogar <- prop.table(table(my_data$Cabeza_De_Hogar))

#Convierte en porcentajes
FrecuenciaRelativaCabezaHogar <- FrecuenciaRelativaCabezaHogar*100

#Redondea a 2 decimales
FrecuenciaRelativaCabezaHogar <- round(FrecuenciaRelativaCabezaHogar, 2)

#Crea los marcos
#Marco1
marco1 <- data.frame(FrecuenciAbsolutaCabezaHogar)
#Marco2
marco2 <- data.frame(FrecuenciaRelativaCabezaHogar)
#Nombres de los marcos(organizacion de los nombres de las filas)
#Ejemplo:
names(marco1) <- c("Cabeza de Hogar","Frecuencia Absoluta")
names(marco2) <- c("Cabeza de Hogar","Frecuencia Relativa")

#mezclar marcos
TablaFrecuenciaCabezaHogar <- merge(marco1,marco2,by="Cabeza de Hogar")


summary(my_data)
