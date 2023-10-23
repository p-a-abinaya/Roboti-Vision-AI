function rotat = rotating_mask(img, mask_size)
    %input grayscale image and odd mask size
    n = (mask_size-1)/2;
    [h,w] = size(img);

    rotat = zeros(h+2*n, w+2*n);
    rotat = uint8(rotat);
    rotat(n+1:end-n, n+1:end-n) = img;

    % calculate variance for each mask
    lookup_mean = average_mask(img, mask_size);
    lookup_variance = zeros(h+2*n, w+2*n);

    img_square = img.^2;
    mean_square = lookup_mean.^2;

    variance = average_mask(img_square, mask_size) - mean_square; %calculates the variance of the input image for each pixel
    lookup_variance(n+1:n+h,n+1:n+w) = variance; %variance is stored in the lookup_variance matrix: like a lookup table

    for i = n+1:n+h
        for j = n+1:n+w
            var = lookup_variance(i-n:i+n, j-n:j+n); % For each pixel at coordinates (i, j) in the rotat image, 
                                                     % a region of the lookup_variance 
                                                     % matrix corresponding to the size of the mask is stored in 'var'
            minimum = min(var,[],"all"); % finds the minimum variance value within that mask region 
            [x,y] = find(minimum == var); % coordinates of the minimum variance value using the find function
            
            % bias in height (x) and width (y) between the current pixel and the location of minimum variance
            x = x-n-1; 
            y = y-n-1; 

            % new coordinates (x1 and y1) by applying the bias to the current pixel coordinates
            x1 = i+x(1)-n; 
            y1 = j+y(1)-n;

            % BOUNDARY CHECK: if the new coordinates (x1 and y1) fall outside the boundaries 
            % of the original image (h and w) it assigns the value of the mean 
            % from the lookup_mean to the corresponding pixel in the 'rotat' image.

            if x1<=0 || x1>h || y1<=0 || y1>w
                rotat(i,j) = lookup_mean(i-n,j-n);
            else
                rotat(i,j) = lookup_mean(i+x(1)-n,j+y(1)-n);
            end
        end
    end

    % cropping
    rotat = rotat(n+1:end-n, n+1:end-n, :);
end