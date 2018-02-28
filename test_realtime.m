% Run after the the PCA_train.m to load in the necessary parameters.

close all;
%stop(vid); % Uncomment for the 2nd run.

format long g;
format compact;
fontSize = 20;
% Please change the following to vid = videoinput('winvideo', 1); for a
% Windows computer. 
vid = videoinput('macvideo', 1); 
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval =5;
start(vid);
% Change the number of frames for the length of the video.
while(vid.FramesAcquired<=200) 
    imge = getsnapshot(vid);
    img = imresize(imge, 0.2, 'nearest');
    [out bin] = generate_skinmap(img);
    grayImage=bin; 
    grIm = rgb2gray(img);
    % Get the dimensions of the image.
    % numberOfColorBands should be = 1.
    [rows, columns, numberOfColorBands] = size(grayImage);
    if numberOfColorBands > 1
        % It's not really gray scale like we expected - it's color.
        % Convert it to gray scale by taking only the green channel.
        grayImage = grayImage(:, :, 2); % Take green channel.
    end
    subplot(2, 2, 1);
    imshow(grayImage, []);
    axis on;
    title('Original Grayscale Image', 'FontSize', fontSize);
    % Enlarge figure to full screen.
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
%     % Give a name to the title bar.
    set(gcf, 'Name', 'Demo', 'NumberTitle', 'Off')
    binaryImage = grayImage;%<128;% < 128;
    % Display the image.
    subplot(2, 2, 2);
    imshow(img, []);
    title('Binary Image', 'FontSize', fontSize);
    % Label the image
    labeledImage = bwlabel(binaryImage);
    measurements = regionprops(labeledImage, 'BoundingBox', 'Area');
    for k = 1:length(measurements)
        thisBB = measurements(k).BoundingBox;
        rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
            'EdgeColor','r','LineWidth',2 );
    end
    % Let's extract the second biggest blob - that will be the hand.
    allAreas = [measurements.Area];
    [sortedAreas, sortingIndexes] = sort(allAreas, 'descend');
    % Find the rectange enclosing the largest area.
    if size(sortingIndexes) > 0
        Box = measurements(sortingIndexes(1)).BoundingBox;
    end
    
    if length(sortingIndexes) >= 1
        handIndex = sortingIndexes(1); % The hand is the second biggest, face is biggest.
        % Use ismember() to extact the hand from the labeled image.
        handImage = ismember(labeledImage, handIndex);
        % Now binarize
        handImage = handImage > 0;
        if exist('Box')
            Box = floor(Box);
            if Box(1) == 0
                Box(1) = 1;
            end
            if Box(2) == 0
                Box(2) = 1;
            end
            % Choose the largest area. 
            newImage = handImage(Box(2):Box(2)+Box(4)-1,Box(1):Box(1)+Box(3)-1);
            newImage = imfill(newImage,'holes');
            newGray = grIm(Box(2):Box(2)+Box(4)-1,Box(1):Box(1)+Box(3)-1);
            grayBin = zeros(size(newImage));
            % Replace the binary 1's with the grayscale pixels.
            for i = 1:size(newImage,1)
                for j = 1:size(newImage,2)
                    if newImage(i,j) == 1
                        grayBin(i,j) = newGray(i,j);
                    end
                end
            end
            % Perform the PCA comparison and get the result. 
            % Change the input 10 to the size of the training set.
            er = testImage(grayBin,M,B,weight,numimages,10);
            [~, num] = min(er);
            subplot(2,2,4)
            imshow(grayBin,[]);
            title(gestures(num),'FontSize', fontSize);
        end
        % Display the image of the hand alone.
        subplot(2, 2, 3);
        imshow(handImage, []);
%         Display a rectangle enclosing the largest area.
        if exist('Box')
            rectangle('Position',[Box(1),Box(2),Box(3),Box(4)],'EdgeColor','r','LineWidth',2 );
        end
        title('Hand Image', 'FontSize', fontSize);
    end
    
end

stop(vid);
flushdata(vid);
