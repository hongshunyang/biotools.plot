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
    pdf(paste('_result/',basename(fl),'.pdf',sep=''),width=60,height=40)
    par(mai=c(5,5,5,5))
    with(res,plot(-log10(Coverage),sqrt(Frequency),pch=19,cex=2,main=basename(fl),cex.main=4,cex.axis=2.5,cex.lab=4))
    with(subset(res, repFamilySINE=='Alu' ), points(-log10(Coverage),sqrt(Frequency), pch=19,cex=2,col="red"))
    dev.off()
}
