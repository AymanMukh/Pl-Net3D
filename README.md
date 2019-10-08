# PL-Net3D: Robust 3D Object Class Recognition Using Geometric Models

## Introducstion

Three-dimensional point clouds produced by 3D scanners are often noisy and contains
outliers. Such data inaccuracies can significantly affect the recent deep learning based methods and reduce
their ability to classify objects. Most deep neural network based object classification methods were tested on
clean data and their robustness to the existence of data inaccuracies has not been examined. In this paper, we
show that these methods, despite their good performances on clean data, fail to achieve good classification
accuracy even with low levels of noise and outliers. We also propose a new method, using an existing
network, to robustify the object classification task. The proposed method uses planar patches to robustly
model the object’s geometry. The information of planar segments are then fed into a deep neural network for
classification. The method is based on using the PointNet deep learning architecture. We tested our method
against several kinds of data inaccuracies such as scattered outliers, clustered outliers, noise, and missing
points. The proposed method showed good performance in the presence of these inaccuracies compared to
state-of-the-art techniques. By decomposing objects into planes, the suggested method is simple, fast, yet
able to provide good classification accuracy, and can handle different kinds of point cloud data inaccuracies.
We provide the code to the community to support future works in this area

## Requirements:

Matlab
Pointnet, please refer to the orignal code for information about running the netwrok

### Usage

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


#### Planar geometries usage in PointNet

The following modifications should be done in PointNet:
The number of points in PointNet should be set to the number of planes (20 default)
Each planar geometiry is represneted by a vector of size 11 (default),  therefore in 'pointnet_cls.py':
In the placeholder_inputs class, the size should be set to 11 instead of 3.
In the get_model class, replace the 'point_cloud_transformed vaiable' with: 

```
    point_cloud_transformed1=tf.matmul(point_cloud[:,:,1:4], transform)  
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


