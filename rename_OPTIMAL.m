% resize

clc;
clear;
close all;

data_name = 'OPTIMAL_original';

imagePath = ['./data_pre/', data_name];

imageFiles = dir(imagePath); 
numFiles = length(imageFiles);
for i=3:numFiles
    subfoldername = imageFiles(i).name; 
    filename_tif = dir(fullfile(strcat(imagePath, '/', subfoldername),'*.jpg'));
    savedir = ['./data_pre/OPTIMAL/', subfoldername,'/'];
    mkdir(savedir);
    num_img_per_class(i-2) = length(filename_tif);
    for j=1:num_img_per_class(i-2)
        filenames = strcat(imagePath,'/',subfoldername,'/',filename_tif(j).name);
        A = imread(filenames);
        if j< 10
            B = regexprep(filename_tif(j).name,'\(\w*\)',[num2str(0), num2str(j)]);
        else
            B = regexprep(filename_tif(j).name,'\(\w*\)',num2str(j));
        end
        imwrite(A,[savedir, B]);
     end
end





