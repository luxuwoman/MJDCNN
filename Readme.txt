1.Experiment environment£º
(1) MATLAB 2018b (MATLAB deep learning toolbox as the deep learning framework)
(2) Linux system
(3) an NVIDIA Quadro P4000 GPU

2. Code
split_dataset.m  randomly split datasets for train,cross validation, test datasets for 10 times
resize_UCMerced.m, resize_NWPU.m, resize_OPTIMAL.m, resize_RSSCN.m  resized image sizes of datasets according to indexs obtained by split_dataset
train_T_CNNs.m  train T_CNNs
joint_decision.m  make joint decision by three single-structure T-CNNs

