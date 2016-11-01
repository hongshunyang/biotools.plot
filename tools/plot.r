#!/usr/bin/env Rscript

# support batch 
#./plot.r -i ../result/10262016/ -m  fc,nlog10csqrtf,nlog10flog2c -c repFamilySINE==\'Alu\'
# _result

library("optparse");
option_list = list(
    make_option(
        c('-i',"--input"),
        type = "character",        
        default = NULL,
        help ="input directory",        
        metavar = "character"         
    ),               
    make_option(
        c('-m',"--mode"),
        type = "character",        
        default = 'fc',
        help ="plot model data",        
        metavar = "character"         
    ),
    make_option(
        c('-c',"--condition"),
        type = "character",        
        default = "repFamilySINE==\'Alu\'",
        help ="subset condition",        
        metavar = "character"         
    )
);
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser)

if (is.null(opt$input)) {
    print_help(opt_parser)
    stop("at least one argument must be supplied (input directory).n", call.=FALSE);
}

# args[1] directory
fls = list.files(opt$input,pattern='*.csv',full.names=TRUE,recursive=TRUE);
mod = tolower(opt$mode);

img_main = ""
img_xlab = ""
img_ylab = ""

for (fl in fls){
    res = read.table(fl, header=TRUE);
    head(res);
    pdf(paste('_result/',basename(fl),'.pdf',sep=''),width=60,height=40);
    # mgp = c(3,4,0):4->xlab(ylab) and x(y) axes distance 
    # mai image margin pdf 
    par(mai=c(5,5,5,5),mgp=c(3, 3, 0));

    if(mod=='fc'){
        with(res,plot(Frequency,Coverage,pch=19,cex=2,cex.axis=4,main="",xlab="",ylab=""));
        with(subset(res, eval(parse(text=opt$condition))), points(Frequency,Coverage, pch=19,cex=2,col="red"));
        #with(subset(res, repFamilySINE=='Alu' ), points(Frequency,Coverage, pch=19,cex=2,col="red"));
        #img_main = basename(fl);
        img_xlab = "Frequency";
        img_ylab = "Coverage";
    } else if (mod=='nlog10csqrtf') {
        with(res,plot(-log10(Coverage),sqrt(Frequency),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab=""));
        with(subset(res, repFamilySINE=='Alu' ), points(-log10(Coverage),sqrt(Frequency), pch=19,cex=2,col="red"));
        #img_main = basename(fl);
        img_xlab = "-log10(Coverage)";
        img_ylab = "sqrt(Frequency)";
    } else if (mod=='nlog10flog2c'){
        with(res,plot(-log10(Frequency),log2(Coverage),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab=""));
        with(subset(res, repFamilySINE=='Alu' ), points(-log10(Frequency),log2(Coverage), pch=19,cex=2,col="red"));
        #img_main = basename(fl);
        img_xlab = "-log10(Frequency)";
        img_ylab = "log2(Coverage)";
    }
    
    img_main = basename(fl);
    mtext(img_main,side=3,line=8,cex=6);
    mtext(img_xlab,side=1,line=8,cex=6);
    mtext(img_ylab,side=2,line=8,cex=6);

    dev.off();
}
