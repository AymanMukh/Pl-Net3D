clear
close all

addpath('./utils','./moduls','./data');

 %% training data
 
%%      load training data
load('data/train_data','data') 
load('data/train_data','label')
% load('data/train_data','normals')

folder='data/files/train/';
outputname='data/train.h5';

% add augmentation 
% data=noise(data,.01);



% find planes in data
disp('training data')
status = mkdir(folder)
tic

processdata_gpu(data,label,folder) %    processdata(data,1,2,label,folder)   %

% collect data in one h5 file
disp(outputname)
 collect_data(folder,outputname,length(label))
toc
 %% testing data
 
  %load testing data
load('data/test_data','data') % MN40_10K
load('data/test_data','label')
% load('data/train_data','normals')

folder='data/files/test/';
outputname='data/test.h5';

% add augmentation 
% data=noise(data,.01);
% data=outliers(data,.1,[-1 1]);
% data=missing_points(data,.5);
% data=cluster_outliers(data,.2,20,.04);

disp('test data')
status = mkdir(folder)
% find planes in data
tic

processdata_gpu(data,label,folder) %    processdata(data,1,2,label,folder)

% collect data in one h5 file
disp(outputname)
  collect_data(folder,outputname,length(label))
toc    
