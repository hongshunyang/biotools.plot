#!/usr/bin/env Rscript

# support batch 
#./volcano.plot.r ../result/10262016/
# _result

args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
    stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

# args[1] directory
fls <- list.files(args[1],pattern='*.csv',full.names=TRUE,recursive=TRUE)
# args[2] FC,-log10CsqrtF,-log10Flog2C
styl<-tolower(args[2])

for (fl in fls){
    res <- read.table(fl, header=TRUE)
    head(res)
    pdf(paste('_result/',basename(fl),'.pdf',sep=''),width=60,height=40)
    # mgp = c(3,4,0):4->xlab(ylab) and x(y) axes distance 
    # mai image margin pdf 
    par(mai=c(5,5,5,5),mgp=c(3, 3, 0))

    if(styl=='fc'){
        with(res,plot(Frequency,Coverage,pch=19,cex=2,cex.axis=4,main="",xlab="",ylab=""))
        with(subset(res, repFamilySINE=='Alu' ), points(Frequency,Coverage, pch=19,cex=2,col="red"))
        mtext(basename(fl),side=3,line=8,cex=6)
        mtext("Frequency",side=1,line=8,cex=6)
        mtext("Coverage",side=2,line=8,cex=6)
    } else if (styl=='-log10csqrtf') {
        with(res,plot(-log10(Coverage),sqrt(Frequency),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab=""))
        with(subset(res, repFamilySINE=='Alu' ), points(-log10(Coverage),sqrt(Frequency), pch=19,cex=2,col="red"))
        mtext(basename(fl),side=3,line=8,cex=6)
        mtext("-log10(Coverage)",side=1,line=8,cex=6)
        mtext("sqrt(Frequency)",side=2,line=8,cex=6)
    } else if (styl=='-log10flog2c'){
        with(res,plot(-log10(Frequency),log2(Coverage),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab=""))
        with(subset(res, repFamilySINE=='Alu' ), points(-log10(Frequency),log2(Coverage), pch=19,cex=2,col="red"))
        mtext(basename(fl),side=3,line=8,cex=6)
        mtext("-log10(Frequency)",side=1,line=8,cex=6)
        mtext("log2(Coverage)",side=2,line=8,cex=6)
    }

    dev.off()
}
