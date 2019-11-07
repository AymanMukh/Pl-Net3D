# PL-Net3D: Robust 3D Object Class Recognition Using Geometric Models


### Citation
```
@misc{
}
```


![main](https://drive.google.com/open?id=1Voyp0JSC5uMY2osxXPzPLupOSpB0-52H){:height="50%" width="50%"}


### Introduction

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

### Requirements:
The code uses the following:
* Matlab.
* [PointNet](https://github.com/charlesq34/pointnet).

We used matlab for the extraction of planar primitives from a given point cloud, while we used PointNet for classification using the extracted planar data. 


### Usage

#### Dataset
Download and unzip MODELNET40 dataset:

```
mkdir data
cd data
wget --no-check-certificate https://shapenet.cs.stanford.edu/media/modelnet40_ply_hdf5_2048.zip
unzip modelnet40_ply_hdf5_2048.zip
```
And then run the file 'convert_h5_m.m' to convert the h5 files to .m files, one training and one testing file will be generated.

#### Extracting planar geometris

After obtaining the .m files from the above step, run the main.m file to extract planar geometries from objects. After the codes finish, it will generate one testing and one training h5 files which will be used as an input to PointNet.
The thersholds can be modified at line 37 from the 'processdata.m' file.
The max number of planes can be modified at line 63 from the 'processdata.m' file.

#### Using the extracted planar geometris for object classification in PoinNet

The following modifications are done in [PointNet](https://github.com/charlesq34/pointnet):
* The number of points in PointNet is set to the number of planes (20 default).
* Each planar geometiry is represneted by a vector of size 11 (default), therefore in 'pointnet_cls.py': The placeholder_inputs class, the size should be set to 11 instead of 3. In the get_model class, The size of the fist conv2d is set to 11 instead of 3
* The rotate data classes in provider.py is modified   
* The 'jitter_point' command in the training file is not required ( jittering is done in the matlab part.)

### Training and testing

To achieve similar results as reported in the paper, three sets of the training data should be generated with the following properties:
```
distance threshold 0.08,  normal threshold 0.3
distance threshold 0.08,  normal threshold 0.1
distance threshold 0.08,  normal threshold 0.3, at noise level of 0.01
```
While for testing, we used the test data with the following properties:
```
distance threshold 0.08,  normal threshold 0.3
```

### Acknowledgement
We used [PointNet](https://github.com/charlesq34/pointnet) with slight modifications mentioned above.

### License
This repository is released under MIT License.
