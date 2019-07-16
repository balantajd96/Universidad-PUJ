rm()
# ************* Tablas de frecuencias en R *************

#Guarda en my_data la tabla que este copiada en Control + C
my_data <- read.table(file = "clipboard",sep = "\t", header=TRUE)

#muestra los primeros 90 datos
head(my_data, 10)

#Cambia las variables de las posiciones de levels
levels(my_data$Genero) <- c("Femenino","Masculino")

#Crea la tabla de frecuencia absoluta
FrecuenciAbsolutaGenero <- table(my_data$Genero)

#Crea la tabla de frecuencia relativa
FrecuenciaRelativaGenero <- prop.table(table(my_data$Genero))

#Convierte en porcentajes
FrecuenciaRelativaGenero <- FrecuenciaRelativaGenero*100

#Redondea a 2 decimales
FrecuenciaRelativaGenero <- round(FrecuenciaRelativaGenero, 2)

#Crea los marcos
#Marco1
marco1 <- data.frame(FrecuenciAbsolutaGenero)
#Marco2
marco2 <- data.frame(FrecuenciaRelativaGenero)
#Nombres de los marcos(organizacion de los nombres de las filas)
#Ejemplo:
names(marco1) <- c("Sexo","Frecuencia Absoluta")
names(marco2) <- c("Sexo","Frecuencia Relativa")

#mezclar marcos
TablaFrecuenciaGenero <- merge(marco1,marco2,by="Sexo")


summary(my_data)
