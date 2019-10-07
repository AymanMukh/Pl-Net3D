
addpath('/home/ayman/papers/pointnet2-master/data/modelnet40_ply_hdf5_2048/')





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


save('data/train_data','data')
save('data/train_data','label','-append')
save('data/train_data','normals','-append')

%------------------------------------------------------------
clear

filename1='ply_data_test0.h5';
data = h5read(filename1,'/data');
label = h5read(filename1,'/label');
normals = h5read(filename1,'/normal');
filename1='ply_data_test1.h5';
data=cat(3,data,h5read(filename1,'/data'));
label=[label,h5read(filename1,'/label')];
normals = cat(3,normals,h5read(filename1,'/normal'));

 save('data/test_data','data')
 save('data/test_data','label','-append')
 save('data/test_data','normals','-append')



