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
library('stringr');
library("tools");
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


opt_i = opt$i
opt_c = opt$c;
opt_x = opt$x;
opt_y = opt$y;
opt_m = tolower(opt$m);


APP_TOOLS_DIRNAME = 'tools'
APP_TOOLS_DATA_DIRNAME = '_data'
APP_TOOLS_RESULT_DIRNAME = '_result'
APP_DATA_DIRNAME = 'data'
APP_RESULT_DIRNAME = 'result'


if (is.null(opt_i)) {
    print_help(opt_parser)
    stop("at least one argument must be supplied (input directory).n", call.=FALSE);
}

generateResultFilePath <- function(dataFilePath,prefix=""){

    initial.options =  commandArgs(trailingOnly = FALSE)
    file.arg.name = "--file="
    script.name = sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])

    filename = basename(dataFilePath);
    fileext = file_ext(dataFilePath); 
    if (prefix==''){
       resultFileName = paste('r_',filename,'.pdf',sep="");
    }else{
       resultFileName = paste('r_',prefix,filename,'.pdf',sep=''); 
    } 
    dataFileAbsPath =file_path_as_absolute(dataFilePath);
   
    app_root_dir = dirname(dirname(file_path_as_absolute(script.name)))	
    app_data_dir = paste(app_root_dir,'/',APP_DATA_DIRNAME,'/',sep="");
	app_result_dir = paste(app_root_dir ,'/' , APP_RESULT_DIRNAME,sep="");

	result_tmp_dirstr = str_replace_all(dirname(dataFileAbsPath),app_data_dir,'');
	result_tmp_dirstr = str_replace_all(dirname(dataFileAbsPath),app_result_dir,'');

	resultFileDir = paste(app_result_dir,'/',result_tmp_dirstr,"/",sep="");

    if (!dir.exists(resultFileDir)){
        dir.create(path=resultFileDir,recursive=TRUE);
    }

    resultFilePath = paste(resultFileDir,resultFileName,sep="");

    return(resultFilePath);
}

rplot <- function(opt_i,opt_c,opt_x,opt_y,opt_m){

    fls = list.files(opt_i,pattern='*.csv',full.names=TRUE,recursive=TRUE);

    img_main = ""
    img_xlab = ""
    img_ylab = ""

    for (fl in fls){
        res_fl = generateResultFilePath(fl);
        res = read.table(fl, header=TRUE);
        print(res_fl);
        head(res);
        pdf(res_fl,width=60,height=40);
    # mgp = c(3,4,0):4->xlab(ylab) and x(y) axes distance 
    # mai image margin pdf 
        par(mai=c(5,5,5,5),mgp=c(3, 3, 0));

        if (opt_m=='nlog10csqrtf') {
        ## -x -log10  the negative - can not work with -x
            opt_x = '-log10(Coverage)';
            opt_y = 'sqrt(Frequency)';
        } else if (opt_m=='nlog10flog2c'){
            opt_x = "-log10(Frequency)";
            opt_y = "log2(Coverage)";
        } else {


        }
   
        with(res,plot(eval(parse(text=opt_x)),eval(parse(text=opt_y)),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab=""));
        with(subset(res, eval(parse(text=opt_c))), points(eval(parse(text=opt_x)),eval(parse(text=opt_y)), pch=19,cex=2,col="red"));
        img_xlab = opt_x;
        img_ylab = opt_y;

        img_main = basename(fl);
        mtext(img_main,side=3,line=8,cex=6);
        mtext(img_xlab,side=1,line=8,cex=6);
        mtext(img_ylab,side=2,line=8,cex=6);

        dev.off();
    }

}

rplot(opt_i,opt_c,opt_x,opt_y,opt_m);
