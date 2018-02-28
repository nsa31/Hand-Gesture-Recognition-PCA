% This function compares the received image with the previously obtained
% weights. 
function [finalError] = testImage(imageInput,M,B,Weight, numImages, setSize)
    % Get the test image and find its projection on the training set.
    imageNew = imresize(imageInput,[100,80]);
    imageN = imageNew(:);
    imageN = double(imageN) - mean(M,2);
    projection = B'*imageN;
    % Calculate the error vector.
    err = zeros(1,size(Weight,2));
    for j = 1:size(Weight,2)
        err(j) = sqrt(sum((projection - Weight(:,j)).^2));
    end
    % Calculate the error for the whole set.
    finalError = zeros(1,numImages/setSize);
    for k = 1:numImages/setSize
       finalError(k) = sum(err((k-1)*setSize+1:k*setSize));
    end
end
