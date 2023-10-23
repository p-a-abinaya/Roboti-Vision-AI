function filtered_img = average_mask(img_grey, mask_size)
% Input gray image and mask size

    % padding the image
    [h,w] = size(img_grey);
    n = (mask_size-1)/2;

    padded_img = zeros(h+2*n, w+2*n);


    padded_img(n+1:end-n, n+1:end-n) = img_grey;
    padded_img = uint8(padded_img);
    filtered_img = zeros(h,w);

    for i = (1+n):(h+n)
        for j = (1+n):(w+n)
            neighbourhood = padded_img(i-n:i+n, j-n:j+n);
            filtered_img(i-n,j-n) = uint8(mean(neighbourhood,[1,2]));
        end
    end
    filtered_img = uint8(filtered_img);
end