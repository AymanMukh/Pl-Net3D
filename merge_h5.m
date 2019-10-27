
addpath('data/modelnet40_ply_hdf5_2048/')
addpath('./utils','./moduls','./data');

filename1='test_file_miss_50.h5';
% h5disp(filename1);
plane = h5read(filename1,'/data');
label1 = h5read(filename1,'/label');

filename1='train_th08_.3_n01.h5';
% h5disp(filename1);
plane = cat(3,plane,h5read(filename1,'/data'));
label1 = [label1;h5read(filename1,'/label')];


filename1='ply_data_train0.h5';
% h5disp(filename1);
data = h5read(filename1,'/data');
label = h5read(filename1,'/label');
normals = h5read(filename1,'/normal');
filename1='ply_data_train1.h5';
data=cat(3,data,h5read(filename1,'/data'));
label=[label,h5read(filename1,'/label')];
normals = cat(3,normals,h5read(filename1,'/normal'));
filename1='ply_data_train2.h5';
data=cat(3,data,h5read(filename1,'/data'));
label=[label,h5read(filename1,'/label')];
normals = cat(3,normals,h5read(filename1,'/normal'));
filename1='ply_data_train3.h5';
data=cat(3,data,h5read(filename1,'/data'));
label=[label,h5read(filename1,'/label')];
normals = cat(3,normals,h5read(filename1,'/normal'));
filename1='ply_data_train4.h5';
data=cat(3,data,h5read(filename1,'/data'));
label=[label,h5read(filename1,'/label')];
normals = cat(3,normals,h5read(filename1,'/normal'));

% data=cat(3,data,data);
% label=[label,label];
outputname='train_filecn.h5';

 h5create(outputname,'/data',size(data),'Datatype','single');
 h5write(outputname,'/data',data);
 h5create(outputname,'/label',size(label),'Datatype','uint8');
 h5write(outputname,'/label',label);
 h5create(outputname,'/plane',size(plane),'Datatype','uint8');
 h5write(outputname,'/plane',plane);

%------------------------------------------------------------
clear

filename1='test_file_miss_50.h5';
% h5disp(filename1);
plane = h5read(filename1,'/data');
label1 = h5read(filename1,'/label');

filename1='test_th08_.3_n01.h5';
plane = cat(3,plane,h5read(filename1,'/data'));
label1 = [label1;h5read(filename1,'/label')];


filename1='ply_data_test0.h5';
data = h5read(filename1,'/data');
label = h5read(filename1,'/label');
normals = h5read(filename1,'/normal');
filename1='ply_data_test1.h5';
data=cat(3,data,h5read(filename1,'/data'));
label=[label,h5read(filename1,'/label')];
normals = cat(3,normals,h5read(filename1,'/normal'));

 data=cat(3,data,data);
 label=[label,label];

% data=outliers(data,.3,[-1 1]);
%   data=missing_points(data,.7);
%   data=noise(data,.1);


outputname='test_filecn.h5';

 h5create(outputname,'/data',size(data),'Datatype','single');
 h5write(outputname,'/data',data);
 h5create(outputname,'/label',size(label),'Datatype','uint8');
 h5write(outputname,'/label',label);
 h5create(outputname,'/plane',size(plane),'Datatype','uint8');
 h5write(outputname,'/plane',plane);
h5disp(outputname);
