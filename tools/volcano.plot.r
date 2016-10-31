#!/usr/bin/env Rscript

#./volcano.plot.r ../result/10262016/LPS/WT-1/xxx.csv
#../result/10262016/LPS/WT-1/xxx.csv.pdf

args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
    stop("At least one argument must be supplied (input file).n", call.=FALSE)
} 
res <- read.table(args[1], header=TRUE)
head(res)
pdf(paste(args[1],'.pdf',sep=''),width=6,height=4,paper='special')
with(res,plot(-log2(Coverage),Frequency,pch=19,cex=0.3,main=args[1],cex.main=0.5))
with(subset(res, repFamilySINE=='Alu' ), points(-log2(Coverage),Frequency, pch=19,cex=0.3,col="red"))
dev.off()

