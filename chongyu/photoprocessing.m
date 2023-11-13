% Load the image
inputImage = imread('D:\Master files\ME5411\charact2.bmp'); % Replace 'your_image.jpg' with your image file

% grayimage
grayImage = rgb2gray(inputImage);

denoisedImage = medfilt2(grayImage, [3 3]);

% Create the averaging mask
averageMask = ones(3) / 9;

% Create the rotating mask (example)
rotatingMask = [0 1 0; -1 0 1; 0 1 0]; % This is an example rotating mask
%%rotatingMask = [0 1 0; -1 0 1; 0 -1 0];

% Apply the masks using convolution
smoothedImageAvg = conv2(grayImage, averageMask, 'same');
smoothedImageRot = conv2(grayImage, rotatingMask, 'same');

% Display the original and smoothed images
%subplot(1, 3, 1), imshow(inputImage), title('Original Image');
%subplot(1, 3, 2), imshow(uint8(smoothedImageAvg)), title('Averaging Mask');
%subplot(1, 3, 3), imshow(uint8(smoothedImageRot)), title('Rotating Mask');

% Get the dimensions of the original image
[rows, cols, ~] = size(inputImage);

% Get the middle row index
bottomhalfIndex = round(rows / 2); % Use round() to handle odd-sized images

% Extract the middle row from the original image
bottomhalfImage = inputImage(bottomhalfIndex:end, :, :);

% Display the middle row image
%figure,imshow(bottomhalfImage);
%title('Bottom half of the Original Image');

junhengImage = histeq(bottomhalfImage, 256);

% grayhalfimage
grayhalfImage = rgb2gray(junhengImage);
invertedImage = imcomplement(grayhalfImage);

% Define threshold
threshold = 64;
binaryImage = invertedImage > threshold;

% 定义均值滤波核
filterSize = 3;  % 滤波器的大小，通常是奇数
h = fspecial('average', filterSize);

% 应用均值滤波
outputImg = imfilter(binaryImage, h);

%scale = 1;
%outputImg = imresize(filterImg, scale, 'bicubic');


% im2bw method
% threshold = 0.5;
% binary2bwImage = imbinarize(grayhalfImage, threshold);
% figure,imshow(binary2bwImage);

% Display binaryImage
figure,imshow(outputImg);
title('binaryImage');

invertedImage = imcomplement(binaryImage);

% use edge function
% cannyedgeImage = edge(grayhalfImage,'canny');
% sobeledgeImage = edge(grayhalfImage,'sobel');
%PrewittedgeImage = edge(invertedImage,'Prewitt');


% Display edgeImage
% figure,imshow(cannyedgeImage);
% figure,imshow(sobeledgeImage);
%figure,imshow(PrewittedgeImage);


%figure;
%J1=binaryImage(4:180,29:150);
%J1=imresize(J1,[312,179]);
%A=J1;ED_type='disk';
%se=strel(ED_type, 8);
%A=imdilate(A,se);
%subplot(1,5,1),imshow(A),title('第1个数字');
