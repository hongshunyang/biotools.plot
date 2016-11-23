#!/usr/bin/env Rscript


#-m pearson
#-m kendall
#-m spearman

# ./rcor.r -i ../result/10262016/ -m pearson -c ClusterName!=\'-1\'


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
        default = "ClusterName!=\'-1\'",
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
    ),
    make_option(
        c('-p',"--perfix"),
        type = "character",        
        default = NULL,
        help ="prefix file name of result ",        
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
opt_p = tolower(opt$p);


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
    app_data_dir = file.path(app_root_dir,APP_DATA_DIRNAME);
	app_result_dir =file.path(app_root_dir , APP_RESULT_DIRNAME);

	result_tmp_dirstr = str_replace_all(dirname(dataFileAbsPath),app_data_dir,'');
	result_tmp_dirstr = str_replace_all(dirname(dataFileAbsPath),app_result_dir,'');

	resultFileDir =file.path(app_result_dir,result_tmp_dirstr);
    if (!dir.exists(resultFileDir)){
        dir.create(path=resultFileDir,recursive=TRUE);
    }

    resultFilePath =file.path(resultFileDir,resultFileName);
    
    return(resultFilePath);
}

rcor <- function(opt_i,opt_c,opt_x,opt_y,opt_m,opt_p){

    fls = list.files(opt_i,pattern='*.csv',full.names=TRUE,recursive=TRUE);

    for (fl in fls){
        res_fl = generateResultFilePath(fl,opt_p);
        #res = read.table(fl, header=TRUE);
        res = read.csv(fl, sep='\t',header=TRUE);
        print(res_fl);
        #res = subset(res, eval(parse(text=opt_c)))
        #head(res);

        sink(res_fl);


        opt_x = 'res$Coverage';
        opt_y = 'res$Frequency';

        x = eval(parse(text=opt_x));
        y = eval(parse(text=opt_y));


        switch(opt_m,
            "pearson"=cor.test(x,y,method="pearson"),
            "kendall"=cor.test(x,y,method="kendall"),
            "spearman"=cor.test(x,y,method="spearman")
        );

        #dev.off();

    }

}
#generateResultFilePath(opt_i);
rcor(opt_i,opt_c,opt_x,opt_y,opt_m,opt_p)
