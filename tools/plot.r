#!/usr/bin/env Rscript

# support batch 
#./plot.r -i ../result/10262016/ -m default -c repFamilySINE==\'Alu\' -x log10\(Coverage\) -y sqrt\(Frequency\)

#-m default use x,y
#-m nlog10flog2c
#-m nlog10csqrtf

# ./plot.r -i ../result/10262016/ -m default -c repFamilySINE==\'Alu\' -x Frequency -y Coverage
# ./plot.r -i ../result/10262016/ -m nlog10csqrtf -c repFamilySINE==\'Alu\'
# ./plot.r -i ../result/10262016/ -m nlog10flog2c -c repFamilySINE==\'Alu\'


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
        default = 'default',
        help ="plot model data",        
        metavar = "character"         
    ),
    make_option(
        c('-c',"--condition"),
        type = "character",        
        default = "repFamilySINE==\'Alu\'",
        help ="subset condition",        
        metavar = "character"         
    ),
    make_option(
        c('-x',"--xcolumn"),
        type = "character",        
        default = NULL,
        help ="x column name",        
        metavar = "character"         
    ),
    make_option(
        c('-y',"--ycolumn"),
        type = "character",        
        default = NULL,
        help ="y column name",        
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

    if (mod=='nlog10csqrtf') {
        ## -x -log10  the negative - can not work with -x
        opt$x = '-log10(Coverage)';
        opt$y = 'sqrt(Frequency)';
    } else if (mod=='nlog10flog2c'){
        opt$x = "-log10(Frequency)";
        opt$y = "log2(Coverage)";
    } else {


    }
   
    with(res,plot(eval(parse(text=opt$x)),eval(parse(text=opt$y)),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab=""));
    with(subset(res, eval(parse(text=opt$condition))), points(eval(parse(text=opt$x)),eval(parse(text=opt$y)), pch=19,cex=2,col="red"));
    img_xlab = opt$x;
    img_ylab = opt$y;

    img_main = basename(fl);
    mtext(img_main,side=3,line=8,cex=6);
    mtext(img_xlab,side=1,line=8,cex=6);
    mtext(img_ylab,side=2,line=8,cex=6);

    dev.off();
}
