rm()
# ************* Tablas de frecuencias en R *************

#Guarda en my_data la tabla que este copiada en Control + C
my_data <- read.table(file = "clipboard",sep = "\t", header=TRUE)

#muestra los primeros 90 datos
head(my_data, 10)

#Cambia las variables de las posiciones de levels
levels(my_data$Pago_De_Servicios) <- c("No","Si")

#Crea la tabla de frecuencia absoluta
FrecuenciAbsolutaPagoServicios <- table(my_data$Pago_De_Servicios)

#Crea la tabla de frecuencia relativa
FrecuenciaRelativaPagoServicios <- prop.table(table(my_data$Pago_De_Servicios))

#Convierte en porcentajes
FrecuenciaRelativaPagoServicios <- FrecuenciaRelativaPagoServicios*100

#Redondea a 2 decimales
FrecuenciaRelativaPagoServicios <- round(FrecuenciaRelativaPagoServicios, 2)

#Crea los marcos
#Marco1
marco1 <- data.frame(FrecuenciAbsolutaPagoServicios)
#Marco2
marco2 <- data.frame(FrecuenciaRelativaPagoServicios)
#Nombres de los marcos(organizacion de los nombres de las filas)
#Ejemplo:
names(marco1) <- c("Realiza el pago de servicios públicos en el supermercado","Frecuencia Absoluta")
names(marco2) <- c("Realiza el pago de servicios públicos en el supermercado","Frecuencia Relativa")

#mezclar marcos
TablaFrecuenciaPagoServicios <- merge(marco1,marco2,by="Realiza el pago de servicios públicos en el supermercado")


summary(my_data)
