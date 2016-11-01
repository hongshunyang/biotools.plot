#!/usr/bin/env Rscript

# support batch 
#./volcano.plot.r ../result/10262016/
# _result

args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
    stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

fls <- list.files(args[1],pattern='*.csv',full.names=TRUE,recursive=TRUE)

for (fl in fls){
    res <- read.table(fl, header=TRUE)
    head(res)
    pdf(paste('_result/',basename(fl),'.pdf',sep=''),width=6,height=4,paper='special')
    with(res,plot(-log2(Coverage),Frequency,pch=19,cex=0.3,main=fl,cex.main=0.5))
    with(subset(res, repFamilySINE=='Alu' ), points(-log2(Coverage),Frequency, pch=19,cex=0.3,col="red"))
    dev.off()
}
