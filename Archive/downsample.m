close all;
clear all;
% CS 543 Assignment 1, starter Matlab code
% Adapted from A. Efros
% (http://graphics.cs.cmu.edu/courses/15-463/2010_fall/hw/proj1/)

% name of the input file
% imname = 'butterfly.jpg';
% imname = 'einstein.jpg';
% imname = 'fishes.jpg';
imname = 'sunflowers.jpg';
% imname = 'migrationHD.jpg';
% imname = 'statueSmall.jpg';
% imname = 'southparkMedium.jpg';
% imname = 'KievLarge.jpg';

% read in the image
fullim = imread(imname);

% convert to double matrix (might want to do this later on to same memory)
fullim = im2double(fullim);

greyImage = rgb2gray(fullim);
greyImage = im2double(greyImage);

iter = 13
[r,c] = size(greyImage);
results = zeros(r,c,iter);



% for n=1:iter
%     sigma = 2*n;
%     size = 6*sigma;
%     size = mod(size+1,2)+size;
%     filter = fspecial('log',size,sigma);
%     filteredImage = imfilter(greyImage,filter,'same')  ;
%     results(:,:,n) = filteredImage* sigma^2;
% end

tic;
for n=1:iter
%     newHeight = (int32)r/n;
%     newWidth = (int32)c/n;
    downImage= imresize(greyImage,1/(n),'bilinear');
    sigma = 2;
    size = 6*sigma;
    size = mod(size+1,2)+size;
    filter = fspecial('log',size,sigma);
    filteredImage = imfilter(downImage,filter,'same');
    scaledBackImage = imresize(filteredImage,[r c],'bilinear')*sigma^2;
    results(:,:,n) = abs(scaledBackImage) ;
    
    
%     sigma = 2*n;
%     size = 6*sigma;
%     size = mod(size+1,2)+size;
%     filter = fspecial('log',size,sigma);
%     tempImage = imfilter(greyImage,filter,'same')*sigma^2;
% 
%     
%     figure;
%     subplot(2, 1, 1);
%     imshow(results(:,:,n));
%     subplot(2, 1, 2);
%     imshow(tempImage);
end
toc;

threshold=.1;
circle=zeros(r,c);
for n=iter:-1:1
    sigma = 2*n;
    radius = sigma * 2^.5;
%     localDim=int32(sigma/2);
     localDim=sigma/2+1;
%      localDim=2;
    max(max(results(:,:,n)))
    for row=1:r
        for col=1:c
            %         if (results(r,c,n)<.5)
            %             results(r,c,n)=0;
            %         else
            
            
            
            %             pks = max(max(localMatrix1));
            
            if (results(row,col,n)>threshold)
                
                localMatrix1 = results(max(1,row-localDim):min(r,row+localDim),max(1,col-localDim):min(c,col+localDim),n);
                localMatrix2 = results(max(1,row-localDim):min(r,row+localDim),max(1,col-localDim):min(c,col+localDim),min(n+1,iter));
                localMatrix3 = results(max(1,row-localDim):min(r,row+localDim),max(1,col-localDim):min(c,col+localDim),max(n-1,1));
                pks = max(max(max(max(localMatrix1)),max(max(localMatrix2))),max(max(localMatrix3)));
%                 pks = max(max(max(localMatrix1)),max(max(localMatrix2)));
%                 pks = max(max(localMatrix1));
                if (isequal(pks,results(row,col,n)))                    
                    circle = MidpointCircle(circle, radius,row,col,1);
                end
            end
        end
    end
    
end
figure;
fullim(:,:,1) = fullim(:,:,1) +circle;
fullim(:,:,2) = fullim(:,:,2) +circle;
fullim(:,:,3) = fullim(:,:,3) +circle;
imshow(fullim);
% imshow(circle+greyImage);
title(sprintf('Down Sampling. Threshold: %0.4f',threshold));





