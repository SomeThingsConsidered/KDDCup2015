library(glmnet)
library(caret)
library(matrixStats)
library("c060", lib.loc="/work/Rpackages/")
library(randomGLM)


setwd ("/work/KDD2015/R_data")

runreg <-function(x,folds){
  
  file1 <- read.csv(paste("course",x,".csv", sep=""),header=TRUE)
  file2 <- read.csv(paste("course",x,"VAL.csv", sep=""),header=TRUE)
  

t1 <-subset(file1, select=dropout)
t2 <- subset(file1, select = -c(dropout) )

x =as.matrix(t2)
y=as.matrix(t1)

t3 <-subset(file2, select=dropout)
t4 <- subset(file2, select =  -c(dropout) )

                             
xVAL =as.matrix(t4)
yVAL=as.matrix(t3)


RGLM =randomGLM(x,y,xVAL, classify=TRUE, nThreads=4)


test= RGLM$predictedTest.response

t4$prob <-test[,2]

finfile <-subset(t4, select=c(enrollment_id, prob))
return(finfile)
}

findata1 <-runreg(1, 10)
findata2 <-runreg(2, 8)
findata3 <-runreg(3, 10)
findata4 <-runreg(4, 10)
findata5 <-runreg(5, 5)
findata6 <-runreg(6, 5)
findata7 <-runreg(7, 10)
findata8 <-runreg(8, 10)
findata9 <-runreg(9, 5)
findata10 <-runreg(10, 5)
findata11 <-runreg(11, 8)
findata12 <-runreg(12, 10)
findata13 <-runreg(13, 5)
findata14 <-runreg(14, 10)
findata15 <-runreg(15, 8)
findata16 <-runreg(16, 5)
findata17 <-runreg(17, 10)
findata18 <-runreg(18, 5)
findata19 <-runreg(19, 10)
findata20 <-runreg(20, 4)
findata21 <-runreg(21, 10)
findata22 <-runreg(22, 5)
findata23 <-runreg(23, 10)
findata24 <-runreg(24, 4)
findata25 <-runreg(25, 10)
findata26 <-runreg(26, 4)
findata27 <-runreg(27, 8)
findata28 <-runreg(28, 5)
findata29 <-runreg(29, 10)
findata30 <-runreg(30, 8)
findata31 <-runreg(31, 8)
findata32 <-runreg(32, 4)
findata33 <-runreg(33, 4)
findata34 <-runreg(34, 5)
findata35 <-runreg(35, 5)
findata36 <-runreg(36, 10)
findata37 <-runreg(37, 4)
findata38 <-runreg(38, 10)
findata39 <-runreg(39, 10)


tst=rbind(findata1, findata2, findata3, findata4, findata5, findata6, findata7, findata8,
          findata9, findata10, findata11, findata12, findata13, findata14, findata15,
          findata16, findata17, findata18, findata19, findata20, findata21, findata22,
          findata23, findata24, findata25, findata26, findata27, findata28, findata29, findata30,
          findata31, findata32, findata33, findata34, findata35, findata36, 
          findata37, findata38, findata39)

tst2 <-tst[order(tst$enrollment_id),]

write.csv(tst2, file="multdays.csv", row.names=FALSE)


