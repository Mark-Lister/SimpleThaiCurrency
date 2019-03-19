%Mark Lister Kasetsart University Digitial Image Processing Assignment 2019
%files = dir('*.jpg');
%for i = 1:length(files)
    %fileName = files(i).name;
    fileName = '100 Baht Other Side.jpg';
    original = imread(fileName);
    disp('Input is: ');
    disp(fileName);
    im = original;
    result = rgb2gray(im); % Converts image to gray
    result = medfilt2(result, [36,36]); %Removes the details on the note
    result = imgaussfilt(result,3); % Smoothens the circles by removeing hash edges
    result = result < (max(result(:)) / 1.50); % Deletes high intensity pixles from image and converts to binary
    result = bwareaopen(result,10000); % Deletes objects from image with low pixel counts
    imwrite(result, 'Pre-Processing.jpg');
    sobel = imgradient(result,'Sobel');
    imwrite(sobel, 'Sobel Gradient.jpg');
    canny = edge(result,'Canny');
    imwrite(canny, 'Canny Edge.jpg');
    [centers, radii, metric] = imfindcircles(result,[35, 65], 'ObjectPolarity', 'dark'); % Detects circles with radius 35 to 65 that are black and have white outline
    circleCount = length(radii);
    [height, width, dim] = size(im);
    im = imcrop(im, [(width/2 - 500) (height/2 - 500) 1000 1000]); %crops to center of image for better color detection
    imwrite(im, 'Colour Crop.jpg');
    HSV = rgb2hsv(im); %converts to HSV
    if circleCount == 1
        HSV(:, :, 2) = HSV(:, :, 2) * 0.7; %decreases saturation
    end
    if circleCount == 2
        HSV(:, :, 2) = HSV(:, :, 2) * 0.8; %decreases saturation
    end
    
    HSV(HSV > 1) = 1;
    im = hsv2rgb(HSV); %converts back to RGB
    imwrite(im, 'Saturation Decrease.jpg');
    %redBand = imhist(im(:, :, 1)); %intensity of grey for red channel
    redBand = im(:, :, 1); %intensity of grey for red channel
    imwrite(redBand, 'Red Hist.jpg');
    redBand = imhist(redBand);
    %greenBand = imhist(im(:, :, 2)); %intensity of grey for green channel
    greenBand = im(:, :, 2); %intensity of grey for green channel
    imwrite(greenBand, 'Green Hist.jpg');
    greenBand = imhist(greenBand);
    %blueBand = imhist(im(:, :, 3)); %intensity of grey for blue channel
    blueBand = im(:, :, 3); %intensity of grey for blue channel
    imwrite(blueBand, 'Blue Hist.jpg');
	subplot(3,1,1);
    imhist(im(:, :, 1));
    title('Red Channel');
    subplot(3,1,2);
    imhist(im(:, :, 2));
    title('Green Channel');
    subplot(3,1,3);
    imhist(im(:, :, 3));
    title('Blue Channel');
    blueBand = imhist(blueBand);
    maxGreys = max([redBand, greenBand, blueBand]); 
    disp(maxGreys);
    redGrey = max(redBand);
    blueGrey = max(blueBand);
    greenGrey = max(greenBand);
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
    figure();
    imshow(result);
    viscircles(centers, radii,'EdgeColor','r'); % Overlays circles
    %disp('Press a Key to move on to the next file.');
    %pause;
%end

