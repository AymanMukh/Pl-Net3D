# PL-Net3D: Robust 3D Object Class Recognition Using Geometric Models



#### Requirements:

matlab
Pointnet


#### Dataset
Download and unzip MODELNET40 dataset:

```
cd data
wget --no-check-certificate https://shapenet.cs.stanford.edu/media/modelnet40_ply_hdf5_2048.zip
unzip modelnet40_ply_hdf5_2048.zip
```
And then run the file 'convert_h5_m.m' to convert the h5 files to .m files. One trainingand one testing file will be gernerated

#### Extract Planar geometries

After optaining the .m files from the above step. run the main.m file to extract planar geometries from objects. After the codes finish, it wil generate one testing and one training h5 files which are then used as an input to PointNet.


#### Planar geometries usage

The following modifications should be done in PointNet:
The number of points in PointNet should be set to the number of planes (20 default)
Each planar geometiry is represneted by a vector of size 11 (default),  therefore in 'pointnet_cls.py':
In the placeholder_inputs class, the size should be set to 11 instead of 3.
In the get_model class, replace the 'point_cloud_transformed vaiable' with: 

```
    point_cloud_transformed1=tf.matmul(point_cloud[:,:,1:4], transform)
    #tf.Print(transform[1,1,:])    
    
    tt=tf.matrix_inverse(transform)
    point_cloud_transformed2 = tf.matmul(point_cloud[:,:,8:11],tt, transpose_b=True)  
    point_cloud_transformed=tf.concat(axis=2, values=[point_cloud[:,:,0:1],point_cloud_transformed1,point_cloud[:,:,4:8],point_cloud_transformed2])

```
The size of the fist conv2d needs o be 11 instead of 3

The rotate data classes in provider.py should be modified as follows:  
```
    batch_data1=batch_data[:, :, 1:4]
    batch_data2=batch_data[:, :, 8:11]

    rotated_data1= np.zeros(batch_data1.shape, dtype=np.float32)
    rotated_data2= np.zeros(batch_data2.shape, dtype=np.float32)
    for k in range(batch_data.shape[0]):
        rotation_angle = np.random.uniform() * 2 * np.pi
        cosval = np.cos(rotation_angle)
        sinval = np.sin(rotation_angle)
        rotation_matrix = np.array([[cosval, 0, sinval],
                                    [0, 1, 0],
                                    [-sinval, 0, cosval]])
        normal_rotation_matrix=np.transpose(np.linalg.inv(rotation_matrix))
                 
        shape_pc1 = batch_data1[k, ...]                            
        shape_pc2 = batch_data2[k, ...]
        rotated_data1[k, ...] = np.matmul(shape_pc1.reshape((-1, 3)), rotation_matrix)
        rotated_data2[k, ...] = np.matmul(shape_pc2.reshape((-1, 3)), normal_rotation_matrix)
        
rotated_data = np.append(batch_data[:,:,0:1],rotated_data1, axis = 2)
rotated_data = np.append(rotated_data,batch_data[:,:,4:8], axis = 2) 
rotated_data = np.append(rotated_data,rotated_data2, axis = 2)
```
jitter_point command in the training file is not required ( jittering is done in the matlab part.)


