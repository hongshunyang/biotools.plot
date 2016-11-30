#!/usr/bin/env python3
# -*- coding:utf-8 -*-
# Copyright (C) yanghongshun@gmail.com
#

import os,sys,configparser,getopt
import csv,shutil


# get custom columns data from data files 

APP_TOOLS_DIRNAME = 'tools'
APP_TOOLS_DATA_DIRNAME = '_data'
APP_TOOLS_RESULT_DIRNAME = '_result'
APP_DATA_DIRNAME = 'data'
APP_RESULT_DIRNAME = 'result'

def usage():
    print('get columns data from single file or directory')
    print('./app.py -i ../data/10262016 -c 0,1,2,3,4,5,6,7,8,9,10,17,18,19')

def getDataFromCSV(title,spliter,filePath):
	print("reading data from csv file:%s" % filePath)
	data = []
	if not os.path.isfile(filePath):
		print("%s not exist!" % filePath)
		sys.exit()
	
	csvfile=csv.reader(open(filePath, 'r'),delimiter=spliter)
	
	for line in csvfile:
		data.append(line)
	if title == True:
		print("delete first row:title row")
		del data[0]
	print("reading end")
	
	return data


def saveDataToCSV(title,data,filePath,fmt=''):
	print("saving data to csv file:%s" % filePath)
	
	if os.path.isfile(filePath):
		print("delete old csv file:%s" % filePath)
		os.remove(filePath)
	
	file_handle = open(filePath,'w')
	
	if fmt=='':
		csv_writer = csv.writer(file_handle,delimiter='\t')
	else:
		csv_writer = csv.writer(file_handle,delimiter=fmt)
	
	if len(title) >0 :
		csv_writer.writerow(title)
	
	csv_writer.writerows(data)
	
	file_handle.close()
	
	print("saved end")

def generateResultFilePath(dataFilePath,prefix=''):
	
	print("generating result file path from data file path:%s" % dataFilePath)
	filename,fileext=os.path.splitext(os.path.basename(dataFilePath))
	
	if prefix=='':
		resultFileName = 'result_'+filename+'.csv'
	else:
		resultFileName = 'result'+prefix+filename+'.csv'


	dataFileAbsPath = os.path.abspath(dataFilePath)
	
	app_root_dir = os.path.dirname(os.path.dirname(os.path.abspath(sys.argv[0])))	
	app_data_dir = app_root_dir + os.sep + APP_DATA_DIRNAME+os.sep
	app_result_dir = app_root_dir + os.sep + APP_RESULT_DIRNAME+os.sep
	
	result_tmp_dirstr = os.path.dirname(dataFileAbsPath).replace(app_data_dir,'')
	
	resultFileDir = os.path.join(app_result_dir,result_tmp_dirstr)

	if not os.path.exists(resultFileDir):
		print("create directory:%s " % resultFileDir)
		os.makedirs(resultFileDir)
	
	resultFilePath = os.path.join(resultFileDir,resultFileName)
	print("result file path is:%s" % resultFilePath)
	print("generated end")
	return resultFilePath

def getColDataFromFile(dataFilePath,res_cols):
	_getColDataFromFile(dataFilePath,res_cols)
	
def _getColDataFromFile(dataFilePath,res_cols):
	print("acting input   data file")
	if os.path.isdir(dataFilePath):
		print("  data file is a directory:%s" % dataFilePath)
		for root,dirs,files in os.walk(os.path.abspath(dataFilePath)):
			for file in files:
				filename,fileext=os.path.splitext(file)
				if fileext=='.csv':
					datafileabspath = root+os.sep+file					
					_getColDataFromSingleFile(datafileabspath,res_cols)
					
	elif os.path.isfile(dataFilePath):
		print("  data file is a single file:%s" % dataFilePath)
		datafileabspath = os.path.abspath(dataFilePath)
		_getColDataFromSingleFile(datafileabspath,res_cols)
	print("action is end")

def _getColDataFromSingleFile(datafileabspath,res_cols):
    print("data file :%s" % datafileabspath)
    if not os.path.isfile(datafileabspath):
        print("data file :%s is not exist!" % datafileabspath)
        sys.exit()


    resultFilePath = generateResultFilePath(datafileabspath)
    if os.path.isfile(resultFilePath):
        print("delete old  result file :%s" % resultFilePath)
        os.remove(resultFilePath)

    print("loading file")
    # print(datafileabspath)
    i=0
    filename,fileext=os.path.splitext(datafileabspath)
    if fileext=='.csv':
        inputFileDataSetOrig = getDataFromCSV(False,',',datafileabspath)
        inputFileDataSetOrigTitleRow = inputFileDataSetOrig[0]
        for col in inputFileDataSetOrigTitleRow:
            print(i,col)	
            i+=1
        ## get chromosome column index
        chr_column = -1

        for j in range(len(inputFileDataSetOrigTitleRow )):
            if inputFileDataSetOrigTitleRow[j].lower() == 'chromosome':
                chr_column = j
                print('chromosome column:%s' % chr_column)
            j+=1

        mmXY = list(range(1,20,1))
        mmXY.extend(['X','Y'])
    
        mmXY = list(map(lambda x:str(x),mmXY))
        # print(chrSet)
        # sys.exit()

        inputFileColIndexMax = len(inputFileDataSetOrigTitleRow)-1
        
        res_cols = [x for x in res_cols if x <= inputFileColIndexMax]
        print("check valid column index")
        print(res_cols)
        colDataSet=[]
        line=0
        for cl in inputFileDataSetOrig:
            row=[]

            ## Insert Index Column
            if line ==0:
                row.append('Index')
            else:
                row.append(line)


            if (line>0) and (str(cl[chr_column]).replace(' ','') not in mmXY):
                continue
            
            ##repClassLINE:2 Alu
            # if cl[2].lower()!='alu':
                # continue

            for idx in range(len(cl)):
                if idx in res_cols:
                    if cl[idx]=='':
                        cl[idx]=-1
                    row.append(cl[idx])
            line+=1 
            if row !=[]:
                colDataSet.append(row)
                
    saveDataToCSV([],colDataSet,resultFilePath)	


def main():
    try:
        opts,args = getopt.getopt(sys.argv[1:],"hi:c:",["--input=","--columns="])
    except getopt.GetoptError as err:
        print(err) 
        usage()
        sys.exit(2)

    input_data=""	
    
    res_cols=""



    for opt,arg in opts:
        if opt in ('-h',"--help"):
            usage()
            sys.exit()
        elif opt in ('-i','--input'):
            input_data=arg
        elif opt in ('-c','--columns'):
            res_cols = arg.replace(',','|').replace(' ','|').split('|')
            # delete null
            res_cols = [x for x in res_cols if x !=''] 
            # delete duplicates
            res_cols = [int(res_cols[i]) for i in range(len(res_cols)) if i == res_cols.index(res_cols[i])]



    if input_data != '':
        getColDataFromFile(input_data,res_cols)
    else:
        sys.exit()


if __name__ == "__main__":
	main()





    
