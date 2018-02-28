% Run this script before the real time test, to calculate the basis and
% determine the necessary parameters. 
% Load images.
images = loadImages(5,10);
% Load a test image, get the error vector and determine which image has the
% smallest error in the traning set.
[M,B,weight,numimages] = getWeights(images);
% Names of gestures.
gestures = ["1","2","3","4","5"];


