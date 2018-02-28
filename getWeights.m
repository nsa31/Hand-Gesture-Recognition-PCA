% This function calculates the basis set and the weights of the training
% set of images. 
function [M,B,Weight,numImages] = getWeights(images)

numImages = size(images, 3);
sizeM = size(images,1)*size(images,2);
M = zeros(sizeM,numImages);
% Resize the images.
for i = 1:numImages
    im_temp = images(:,:,i);
    M(:,i) = im_temp(:);
end
% Find the mean, calculate the covariance matrix and get the eigenvalues
% and eigenvectors.
M_new = M - mean(M,2)*ones(1,size(M,2));
C = M_new'*M_new; 
[V, ~] = eig(C);
% Get the basis images and their weights.
B = M_new*V;
Weight = B'*M_new;
end
