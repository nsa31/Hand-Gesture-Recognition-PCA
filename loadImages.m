% Function loadImages(m,setSize) takes the number of gestures m and the
% number of images in a single set setSize and loads the training images
% from a provided folder into one matrix.
function [im] = loadImages(m,setSize)
    addpath('trainingset');
    k = 1;
    for i = 1:m
        for j = 1:setSize
            jpgFilename = sprintf('%d%d.mat', i,j-1);
            temp = load(jpgFilename);
            im(:,:,k) = imresize(uint8(temp.grayBin),[100,80]);
            k = k+1;
        end
    end
end
