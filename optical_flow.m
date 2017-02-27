function [ v ] = optical_flow( image1 , image2 , region_size, kernel_size) %region_size = 15 for image of size 256
%divide image on non overlaping regions
im1 = rgb2gray(image1);
im2 = rgb2gray(image2);

[H,W,D] = size(image1); 
assert (H == W)
x_num_region =  floor(W / region_size);
y_num_region = floor(H / region_size) ;
if( (x_num_region *y_num_region  * region_size^2) ~= H*W)
    warning ( (H*W - x_num_region *  y_num_region* region_size^2) + ' pixels will not be considered' )
end
regions1 = zeros( x_num_region * y_num_region ,region_size,region_size);
regions2 = zeros( x_num_region * y_num_region ,region_size,region_size);

% ________________
%|1  |2  |3  |4  |  cell_number from 1 to 12
%|5  |6  |7  |8  |  cell 7 has x_cell=2, y_cell = 1
%|9__|10_|11_|12_|  cell 7 correspond to image coordinate: x= x_cell*(x_num_region-1) +1 : x_cell*(x_num_region-1) +region_size
%                   cell 7 correspond to image coordinate: y= y_cell*(x_num_region-1) +1 : y_cell*(x_num_region-1) +region_size
for i= 1: (x_num_region*y_num_region)
    x_cell = mod((i-1),x_num_region) ; %from 0 to x_num_region -1 
    y_cell = floor ( (i-1)/ x_num_region) ; %from 0 to y_num_region -1 
    x_start = x_cell*(x_num_region-1) +1;
    y_start = y_cell*(y_num_region-1) +1;
    x_end = x_start+(region_size-1);
    y_end = y_start+(region_size-1);
    regions1(i,:,:) = im1(x_start:x_end,y_start:y_end);
    regions2(i,:,:) = im2(x_start:x_end,y_start:y_end);
end

%For each region compute A = [Ix(q1) Iy(q1) ; ...; Ix(qn), Iy(qn)]  of size
% (region_size^2 2), A^T and b= [-It(q1); ...; -It(qn)] of size (region_size^2 1)
for reg=1:x_num_region*y_num_region
    A=zeros(region_size^2,2);
    b=zeros(region_size^2,1);
    
    g_x=fspecial('gaussian',[1 kernel_size]);
    img_X=imfilter(regions1(i,:,:),g_x);
    g_y=fspecial('gaussian',[kernel_size 1]);
    img_Y=imfilter(regions1(i,:,:),g_y);
    
    for i=1:region_size^2
      x=mod(i-1,region_size)+1;
      y=floor((i-1) / region_size) +1;
      A(i,1) = img_X(x,y);
      A(i,2) = img_Y(x,y);
      b(i,1) = -1* ;
    end
end
   
%solve v = (A^T A)^(-1) A^T b

%display result using "quiver"
end

