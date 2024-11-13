
#### Pacotes ####

library(vegan)
library(car)

rm(list=ls()) ### limpa a mem?ria
   
#### Importando os dados ####

dados<-read.table('resultados_Yolanda.txt',header=TRUE, sep="\t", na.strings="NA", dec=".")
attach(dados)

##### Teste T zooplancton #####

zool<-log2(zoo.total+1)

# homocedasticidade
leveneTest(zool~Per?odo)

# normalidade dos res?duos
modelo<-aov(zool~Per?odo)
shapiro.test(modelo$residuals)

#### Teste de Mann-Whitney ####

wilcox.test(zool~Per?odo)
boxplot(zool~Per?odo)
boxplot(zoo.total~Per?odo)

wilcox.test(zool~Fazenda)
boxplot(zool~Fazenda)
boxplot(zoo.total~Fazenda)

#### MDS ####
library(vegan)
library(BiodiversityR)
library(MASS)

grupos_zoo<-dados[,27:31]

grupos_zool<-log(grupos_zoo+1,2)
zoo.dist<-dist(grupos_zool)

zoo.nmds<-metaMDS(grupos_zool, distance = "eu")
plot(zoo.nmds)
zoo.nmds$points
write.table(cpue.nmds$points, "mds_rbai_points.txt", sep="\t")

#### Anosim ####

cpue.test<- anosim(grupos_zool, grouping=Per?odo, distance='eu')
cpue.test
plot(cpue.test)

#### PCA com vari?veis ambientais ####

env<-dados[,5:19]
attach(env)
names(env)
envl<-log(env+1,2)
envl[,4]<-pH
envl

cor.test(envl, method = "spearman")


#### PCA de correla??o
pca.correla?ao<-prcomp(envl) 
summary(pca.correla?ao)
biplot(pca.correla?ao)
pca.correla?ao$x ##### das amostras
pca.correla?ao$rotation ##### das variaveis ambientais
pca.correla?ao$center

escores<-scores(pca.correla?ao)
escores
autovalores<-apply(escores,2,var)
autovalores 

autovetores<-t(t(pca.correla?ao$rotation)*pca.correla?ao$sdev) #utilizados para selecionar as vari?veis que mais influenciaram na forma??o do eixo (encontrar a quebra)
autovetores
bstick(pca.correla?ao)

biplot(pca.correla?ao)
screeplot(pca.correla?ao)

#Plotar o gr?fico da PCA:

plot(escores[,1:2], type="n",ylim=c(-3.2,1.8), xlim=c(-2.7,4.7))  #plota um gr?fico vazio

#Locais como s?mbolos distintos:
points(escores[1:8,1],escores[1:8,2] , pch=16, col="red", cex=1.5)
points(escores[9:16,1],escores[9:16,2] , pch=17, col="blue", cex=1.5)

legend("topright", c("30 dias", "60 dias"),  pch=c(16,17), col=c("red","blue"),  bty="n")

#Gr?fico dos locais com flechas indicando as vari?veis mais representativas no eixo 
legend("bottomright", legend=c("Temp"), bty="n", y.intersp=1)  #insere o nome da vari?vel
arrows(3.4, -3.1, 3.9, -3.1)  #insere seta
legend("bottomleft", legend=c("P"), bty="n", y.intersp=1) #insere o nome da vari?vel
arrows(-2.5, -2.4, -2.5, -2.9)  #insere seta



