rm()
# ************* Tablas de frecuencias en R *************

#Guarda en my_data la tabla que este copiada en Control + C
my_data <- read.table(file = "clipboard",sep = "\t", header=TRUE)

#muestra los primeros 90 datos
head(my_data, 10)

#Crea la tabla de frecuencia absoluta
FrecuenciAbsolutaRazones <- table(my_data$Razones)

#Crea la tabla de frecuencia relativa
FrecuenciaRelativaRazones <- prop.table(table(my_data$Razones))

#Convierte en porcentajes
FrecuenciaRelativaRazones <- FrecuenciaRelativaRazones*100

#Redondea a 2 decimales
FrecuenciaRelativaRazones <- round(FrecuenciaRelativaRazones, 2)

#Crea los marcos
#Marco1
marco1 <- data.frame(FrecuenciAbsolutaRazones)
#Marco2
marco2 <- data.frame(FrecuenciaRelativaRazones)
#Nombres de los marcos(organizacion de los nombres de las filas)
#Ejemplo:
names(marco1) <- c("Razones de frecuencia","Frecuencia Absoluta")
names(marco2) <- c("Razones de frecuencia","Frecuencia Relativa")

#mezclar marcos
TablaFrecuenciaRazon <- merge(marco1,marco2,by="Razones de frecuencia")


summary(my_data)
