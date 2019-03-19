%Mark Lister Kasetsart University Digital Image Processing Assignment 2019
files = dir('*.jpg');
%for i = 1:length(files)
    %fileName = files(i).name;
    fileName = '500 Baht King Side.jpg';
    original = imread(fileName);
    disp('Input is: ');
    disp(fileName);
    im = original;
    result = rgb2gray(im); % Converts image to grey
    result = medfilt2(result, [36,36]); %Removes the details on the note
    result = imgaussfilt(result,3); % Smoothens the circles by removing harsh edges
    result = result < (max(result(:)) / 1.50); % Deletes high intensity pixles from image and converts to binary
    result = bwareaopen(result,10000); % Deletes objects from image with low pixel counts
    [centers, radii, metric] = imfindcircles(result,[35, 65], 'ObjectPolarity', 'dark'); % Detects circles with radius 35 to 65 that are black and have white outline
    circleCount = length(radii);
    [height, width, dim] = size(im);
    im = imcrop(im, [(width/2 - 500) (height/2 - 500) 1000 1000]); %crops to center of image for better color detection
    HSV = rgb2hsv(im); %converts to HSV
    if circleCount == 1
        HSV(:, :, 2) = HSV(:, :, 2) * 0.6; %decreases saturation
    end
    if circleCount == 2
        HSV(:, :, 2) = HSV(:, :, 2) * 0.8; %decreases saturation
    end
    HSV(HSV > 1) = 1;
    im = hsv2rgb(HSV); %converts back to RGB
    redGrey = max(imhist(im(:, :, 1))); %Max intensity of grey for red channel
    greenGrey = max(imhist(im(:, :, 2))); %Max intensity of grey for green channel
    blueGrey = max(imhist(im(:, :, 3))); %Max intensity of grey for blue channel
    if circleCount == 1
        disp("Detected 20 or 50 Baht");
        if greenGrey > blueGrey + 1000 % margin of error some greens creep in on 50 baht
            disp("Detected 20 Baht");
            resultText = '20 Baht';
        else
            disp("Detected 50 Baht");
            resultText = '50 Baht';
        end
    elseif circleCount == 2
        disp("Detected 100 or 500 Baht");
        if redGrey > blueGrey
            disp("Detected 100 Baht");
            resultText = '100 Baht';
        else
            disp("Detected 500 Baht");
            resultText = '500 Baht';
        end
    elseif circleCount == 3
        disp("Detected 1000 Baht");
        resultText = '1000 Baht';
    else
        disp("unknown");
        resultText = 'Error';
    end
    figure;
    subplot(2,1,1);
    imshow(original);
    title('Original', 'FontSize', 16);
    subplot(2,1,2);
    imshow(result);
    title(resultText, 'FontSize', 16);
    viscircles(centers, radii,'EdgeColor','r'); % Overlays circles
    %disp('Press a Key to move on to the next file.');
    %pause;
%end

