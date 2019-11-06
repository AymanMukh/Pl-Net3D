import os
import sys
import numpy as np
import h5py
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(BASE_DIR)

# Download dataset for point cloud classification
DATA_DIR = os.path.join(BASE_DIR, 'data')
if not os.path.exists(DATA_DIR):
    os.mkdir(DATA_DIR)
if not os.path.exists(os.path.join(DATA_DIR, 'modelnet40_ply_hdf5_2048')):
    www = 'https://shapenet.cs.stanford.edu/media/modelnet40_ply_hdf5_2048.zip'
    zipfile = os.path.basename(www)
    os.system('wget %s; unzip %s' % (www, zipfile))
    os.system('mv %s %s' % (zipfile[:-4], DATA_DIR))
    os.system('rm %s' % (zipfile))


def shuffle_data(data, labels):
    """ Shuffle data and labels.
        Input:
          data: B,N,... numpy array
          label: B,... numpy array
        Return:
          shuffled data, label and shuffle indices
    """
    idx = np.arange(len(labels))
    np.random.shuffle(idx)
    return data[idx, ...], labels[idx], idx


def rotate_point_cloud(batch_data):
    """ Randomly rotate the point clouds to augument the dataset
        rotation is per shape based along up direction
        Input:
          BxNx3 array, original batch of point clouds
        Return:
          BxNx3 array, rotated batch of point clouds
    """
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
    return rotated_data


def rotate_point_cloud_by_angle(batch_data, rotation_angle):
    """ Rotate the point cloud along up direction with certain angle.
        Input:
          BxNx3 array, original batch of point clouds
        Return:
          BxNx3 array, rotated batch of point clouds
    """
    batch_data1=batch_data[:, :, 1:4]
    batch_data2=batch_data[:, :, 8:11]

    rotated_data1= np.zeros(batch_data1.shape, dtype=np.float32)
    rotated_data2= np.zeros(batch_data2.shape, dtype=np.float32)
    for k in range(batch_data.shape[0]):
        # rotation_angle = np.random.uniform() * 2 * np.pi
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
    return rotated_data


def jitter_point_cloud(batch_data, sigma=0.01, clip=0.05):
    """ Randomly jitter points. jittering is per point.
        Input:
          BxNx3 array, original batch of point clouds
        Return:
          BxNx3 array, jittered batch of point clouds
    """
    B, N, C = batch_data.shape
    assert(clip > 0)
    jittered_data = np.clip(sigma * np.random.randn(B, N, C), -1*clip, clip)
    jittered_data += batch_data
    return jittered_data

def getDataFiles(list_filename):
    return [line.rstrip() for line in open(list_filename)]

def load_h5(h5_filename):
    f = h5py.File(h5_filename)
    data = f['data'][:]
    label = f['label'][:]
    return (data, label)

def loadDataFile(filename):
    return load_h5(filename)

def load_h5_data_label_seg(h5_filename):
    f = h5py.File(h5_filename)
    data = f['data'][:]
    label = f['label'][:]
    seg = f['pid'][:]
    return (data, label, seg)


def loadDataFile_with_seg(filename):
    return load_h5_data_label_seg(filename)
