% extract image indexs from train, cross validation and test datasets for 10 times

clc;
clear;
close all;

datasets = {'OPTIMAL/','NWPU/', 'UCMerced/', 'RSSCN/'};
for j=1:length(datasets)
    dataset = datasets{1,j}
    imagedir = strcat('./data_pre/', dataset);
    savedir = strcat('./data_split/', dataset);
    mkdir(savedir);
    
    data = imageDatastore(imagedir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    datanames = data.Labels;
    categorynames = categories(datanames);
    numClasses = numel(categorynames);
    
    for i=1:10
        i
        [dataTrain, dataCV, dataTest]  = splitEachLabel(data, 0.4, 0.2, 'randomized');
        save(strcat(savedir, 'traincvtest_', num2str(i, '%d'), '.mat'), 'dataTrain', 'dataCV', 'dataTest', '-v7.3')
    end
end