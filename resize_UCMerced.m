% resize UCMerced dataset depend on image indexs of train, cross validation and test dataset
clc;
clear;
close all;

sizedirs = {'224','227','299'};
for beta=1:3
    beta
for alpha=1:10
    alpha
imagePath = './data_pre/UCMerced/';
load(['./data_split/UCMerced/traincvtest_', num2str(alpha, '%d'), '.mat']);

%% 
img_train = [];
n_1 = length(dataTrain.Files);
for i=1:n_1
    A_train = dataTrain.Files{i,1};
    B_train = A_train(isstrprop(A_train, 'digit'));
    C_train = str2num(B_train) + 1;
    img_train = [img_train; C_train];
end

img_CV = [];
n_2 = length(dataCV.Files);
for j=1:n_2
    A_CV = dataCV.Files{j,1};
    B_CV  = A_CV (isstrprop(A_CV , 'digit'));
    C_CV = str2num(B_CV) + 1;
    img_CV = [img_CV; C_CV ];
end

img_test = [];
n_3 = length(dataTest.Files);
for k=1:n_3
    A_test = dataTest.Files{k,1};
    B_test = A_test(isstrprop(A_test, 'digit'));
    C_test = str2num(B_test) + 1;
    img_test = [img_test; C_test];
end
save(['./data_split/UCMerced/trainCVtest_index_', num2str(alpha, '%d'),'.mat'],'img_train','img_CV','img_test');

%% 
imageFiles = dir(imagePath);
numFiles = length(imageFiles);
sizedir = sizedirs{1,beta};
data_resize = [str2num(sizedir), str2num(sizedir)];
n_train_test = n_1/(numFiles - 2);
n_cv = n_2/(numFiles - 2);
for q=3:numFiles
    subfoldername = imageFiles(q).name;    
    filename_tif = dir(fullfile(strcat(imagePath,subfoldername),'*.tif'));
    imagePath_1 = strcat('./data_pre/UCMerced_CLASS_',sizedir,'/', num2str(alpha, '%d'),...
    '/UCMerced_',sizedir,'_train/',subfoldername);
    mkdir(imagePath_1);
    a = (q-3) * n_train_test + 1;
    b = (q-2) * n_train_test;
    for p_train=a:b
        file_train = img_train(p_train,1);
        filenames_train = strcat(imagePath,'/',subfoldername,'/',filename_tif(file_train).name);
        res_train = imresize(imread(filenames_train), data_resize);
        imwrite(res_train, strcat(imagePath_1,'/',filename_tif(file_train).name));
    end
    
    imagePath_2 = strcat('./data_pre/UCMerced_CLASS_',sizedir,...
        '/', num2str(alpha, '%d'),'/UCMerced_',sizedir,'_CV/',subfoldername);
    mkdir(imagePath_2);
    c = (q-3) * n_cv + 1;
    d = (q-2) * n_cv;
    for p_CV=c:d
        file_cv = img_CV(p_CV,1);
        filenames_CV = strcat(imagePath,'/',subfoldername,'/',filename_tif(file_cv).name);
        res_CV = imresize(imread(filenames_CV), data_resize);
        imwrite(res_CV, strcat(imagePath_2,'/',filename_tif(file_cv).name));
    end
    
    imagePath_3 = strcat('./data_pre/UCMerced_CLASS_',sizedir,...
        '/', num2str(alpha, '%d'),'/UCMerced_',sizedir,'_test/',subfoldername);
    mkdir(imagePath_3);
    for p_test=a:b
        file_test = img_test(p_test,1);
        filenames_test = strcat(imagePath,'/',subfoldername,'/',filename_tif(file_test).name);
        res_test = imresize(imread(filenames_test), data_resize);
        imwrite(res_test, strcat(imagePath_3,'/',filename_tif(file_test).name));
    end
    
end
end

end
    






