%-----------------------------------------------------------
% Finds planes in Point cloud
% auther: ayman mukhaimer
% Oct 2019
%-----------------------------------------------------------

clear
close all

addpath('./utils','./moduls','./data');

 %% training data
 
% load training data
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
processdata_mc(data,label,folder) %    processdata(data,1,2,label,folder)   %
toc
% collect data in one h5 file
disp(outputname)
collect_data(folder,outputname,length(label))

 %% testing data
 
% load testing data
load('data/test_data','data') 
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
processdata_mc(data,label,folder) %    processdata(data,1,2,label,folder)
toc
% collect data in one h5 file
disp(outputname)
collect_data(folder,outputname,length(label))
  
