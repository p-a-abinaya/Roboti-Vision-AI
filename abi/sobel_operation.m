function outlined_img = sobel_operation(binary_img)
    sobel_kernal_x = int16([-1 -2 -1; 0 0 0; 1 2 1]);
    sobel_kernal_y = int16([-1 0 1; -2 0 2; -1 0 1]);

    [h,w] = size(binary_img);
    n = 1;
    
    padded_img = zeros(h+2*n, w+2*n);
    padded_img(n+1:end-n, n+1:end-n) = binary_img;
    padded_img = uint8(padded_img);

    outlined_img = zeros(h,w);
    linking_pixels = zeros(h,w);
    magnitude_gradient = zeros(h,w);
    direction_gradient = zeros(h,w);

    for i = (1+n):(h+n)
        for j = (1+n):(w+n)
            neighbourhood = int16(padded_img(i-n:i+n, j-n:j+n));

            % Without convolution
            %x = neighbourhood.*sobel_kernal_x;
            %y = neighbourhood.*sobel_kernal_y;

            %x_dir = abs(sum(x,"all")).^2;
            %y_dir = abs(sum(y, "all")).^2;

            %magnitude_gradient(i-n,j-n) = int16(sqrt((x_dir + y_dir)));
            %direction_gradient(i-n,j-n) = rad2deg(atan2(y_dir, x_dir));

            % With convolution for faster computation:

            gradient_x = conv2(double(neighbourhood), sobel_kernal_x, 'same');
            gradient_y = conv2(double(neighbourhood), sobel_kernal_y, 'same');

            gradient_x_sum = sum(gradient_x,"all");
            gradient_y_sum = sum(gradient_y,"all");

            magnitude_gradient(i-n,j-n) = int16(sqrt(gradient_x_sum.^2 + gradient_y_sum.^2));
            direction_gradient(i-n,j-n) = atan2d(gradient_y_sum, gradient_x_sum);

            outlined_img(i-n,j-n) = magnitude_gradient(i-n,j-n);
        end
    end

    for i = 1:h
        for j=1:w
            for horiz = -1:1
                for vert = -1:1
                    neighb_x = i + vert;
                    neighb_y = j + horiz;
                    if neighb_x>=1 && neighb_x<=h && neighb_y>=1 && neighb_y<=w
                        if abs(magnitude_gradient(i,j)-magnitude_gradient(neighb_x,neighb_y))<25 && abs(direction_gradient(i,j)-direction_gradient(neighb_x,neighb_y))<15
                            linking_pixels(i,j) = 0;
                        end
                    end
                end 
            end
         
        end 
    end

    outlined_img = uint8(outlined_img + linking_pixels);



end