rm()
# ************* Graficos en R *************

#Guarda en my_data la tabla que este copiada en Control + C
my_data <- read.table(file = "clipboard",sep = "\t", header=TRUE)

#muestra los primeros 90 datos
head(my_data, 10)

#Genero [Diagrama Circular]
label <- c( paste(levels(my_data$Genero)," [",FrecuenciaRelativaGenero,'%',"]",sep=''))
pie(table(my_data$Genero),labels = label,main="Distribución de los tipos de genero",radius =1,col=rainbow(length(label)))


#Cabeza Hogar[Diagrama Circular]
label <- c( paste(levels(my_data$Cabeza_De_Hogar)," [",FrecuenciaRelativaCabezaHogar,'%',"]",sep=''))
pie(table(my_data$Cabeza_De_Hogar),labels = label,main="Distribución de cabezas de hogar",radius =1,col=rainbow(length(label)))

#Realiza pago de servicios[Diagrama Circular]
label <- c( paste(levels(my_data$Pago_De_Servicios)," [",FrecuenciaRelativaPagoServicios,'%',"]",sep=''))
pie(table(my_data$Pago_De_Servicios),labels = label,main="Distribución de  la realización de pagos de servicios",radius =1,col=rainbow(length(label)))

#Cuales servicios públicos paga
df <- data.frame(x=c(levels(my_data$Cuales_Paga)),
                 y=c(table(my_data$Cuales_Paga)))


library(ggplot2)
# Basic barplot
p<-ggplot(data=df, aes(x=x, y=y)) +
  geom_bar(stat="identity", color="black", fill="blue")+
  geom_text(aes(label=y), vjust=1.6, color="white", size=3.5)+
  theme_minimal()
p

p + scale_x_discrete(limits=c("Gases", "Ninguno", "Emcali_Energía","Emcali_Telecom","Celular"))


#Razones de frecuencia
df <- data.frame(x=c(levels(my_data$Razones)),
                 y=c(table(my_data$Razones)))


library(ggplot2)
# Basic barplot
p<-ggplot(data=df, aes(x=x, y=y)) +
  geom_bar(stat="identity", color="black", fill="blue")+
  geom_text(aes(label=y), vjust=1.6, color="white", size=3.5)+
  theme_minimal()
p

p + scale_x_discrete(limits=c("Cercanía", "Variedad", "Economía","Servicios","Comodidad"))

#cada cuanto merca
df <- data.frame(x=c(levels(my_data$Cada_Cuanto)),
                 y=c(table(my_data$Cada_Cuanto)))


library(ggplot2)
# Basic barplot
p<-ggplot(data=df, aes(x=x, y=y)) +
  geom_bar(stat="identity", color="black", fill="blue")+
  geom_text(aes(label=y), vjust=1.6, color="white", size=3.5)+
  theme_minimal()
p

p + scale_x_discrete(limits=c("Semanalmente", "Quincenalmente", "Mensualmente","Otra"))


#Gasto Promedio[Histograma]

h <- hist(my_data$Gasto_Promedio, breaks=8,
     main="Maximum daily temperature at La Guardia Airport",
     col="blue",ylim=c(0,40),xlim=c(109000,991000)
)

text(h$mids,h$counts,labels=h$counts, adj=c(0.5, -0.5))

#Gasto Promedio Semanalmente[Histograma]

h <- hist(my_dataSemanalmente$Gasto_Promedio, breaks=8,
          main="Maximum daily temperature at La Guardia Airport",
          col="blue",ylim=c(0,20),xlim=c(110000,330000)
)

text(h$mids,h$counts,labels=h$counts, adj=c(0.5, -0.5))


#Edad[Histograma]

h <- hist(my_data$Edad, breaks=8,
          main="Maximum daily temperature at La Guardia Airport",
          col="blue",ylim=c(0,30),las=1
)

text(h$mids,h$counts,labels=h$counts, adj=c(0.5, -0.5))

summary(my_data)

#tabla doble entrada

data1<-data[my_data$Cada_Cuanto=="Semanalmente",]
data2<-data[my_data$Cada_Cuanto=="Quincenalmente",]

tabla<-table(data1$Cada_Cuanto )