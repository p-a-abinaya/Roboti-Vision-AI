img = imread("charact2.bmp");
imgg = rgb2gray(img);
avg = average_mask(imgg, 13);
avg2 = rotating_mask(avg, 13);
binary = thresholding(avg2, 113);


figure()
subplot(2,1,1)
imshow(avg2);

subplot(2,1,2)
imshow(binary);