function [r, c, Ix, Iy] = harris_corner(image, kernel_size, window_size)

[H,W,D] = size(image); 

img = image;
if D>1
    img = rgb2gray(image);
end

disp(size(img))
% use sobel operator to approximate gaussian derivative
%fx = [-1 0 1;-2 0 2;-1 0 1];
%Ix = conv2(double(img),fx);
%fy = [1 2 1;0 0 0;-1 -2 -1];
%Iy = conv2(double(img),fy);
[Ix,Iy] = imgradientxy(img);

Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;

h= fspecial('gaussian',[kernel_size kernel_size],2); 
Ix2 = conv2(h,Ix2);
Iy2 = conv2(h,Iy2);
Ixy = conv2(h,Ixy);
height = size(img,1);
width = size(img,2);
result = zeros(height,width); 
H = zeros(height,width);

% constructing H matrix and retrieve maximum element in H for threshold
max_element = 0; 
for i = 1:height
    for j = 1:width
        Q = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)]; 
        H(i,j) = det(Q)-0.04*(trace(Q))^2;
        if H(i,j) > max_element
            max_element = H(i,j);
        end;
    end;
end;

% retrieving corner points with 3x3 window
% TODO : make the window general
threshold = max_element * 0.1;
% only handles odd number of window_size
pad = (window_size-1)/2;
mid = (window_size * window_size + 1)/2;
H = padarray(H,[pad pad]);
for i = 1+pad:height-pad
    for j = 1+pad:width-pad
        sub_H = H(i-pad:i+pad,j-pad:j+pad);
        if(sub_H(mid) > threshold && max(max(sub_H)) == sub_H(mid))
            result(i,j) = 1;
        end
        %if H(i,j) > threshold && H(i,j) > H(i-1,j-1) && H(i,j) > H(i-1,j) && H(i,j) > H(i-1,j+1) && H(i,j) > H(i,j-1) && H(i,j) > H(i,j+1) && H(i,j) > H(i+1,j-1) && H(i,j) > H(i+1,j) && H(i,j) > H(i+1,j+1)
        %    result(i,j) = 1;
        %end;
    end;
end;
[r, c] = find(result == 1);
end