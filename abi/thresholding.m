function bin = thresholding(img,th)
    [h,w] = size(img);
    bin = uint8(zeros(h, w));
    bin(img > th) = 0;
    bin(img <= th) = 255;
end