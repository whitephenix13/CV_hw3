function [ v ] = optical_flow( image1 , image2 , region_size, kernel_size, debug) %region_size = 15 for image of size 256
%divide image on non overlaping regions

[H,W,D] = size(image1); 
[H2,W2,D2] = size(image2); 

im1 = image1;
im2 = image2;
%convert image to gray if necessary
if(D>1)
    im1 = rgb2gray(image1);
end
if(D2>1)
    im2 = rgb2gray(image2);
end



assert (H == W)
x_num_region =  floor(W / region_size);
y_num_region = floor(H / region_size) ;
if( (x_num_region *y_num_region  * region_size^2) ~= H*W)
    txt = strcat((num2str(H*W - x_num_region *  y_num_region* region_size^2)), ' pixels will not be considered');
    warning (txt)
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
    x_start = x_cell*(region_size) +1;
    y_start = y_cell*(region_size) +1;
    x_end = x_start+(region_size-1);
    y_end = y_start+(region_size-1);
    regions1(i,:,:) = im1(x_start:x_end,y_start:y_end);
    regions2(i,:,:) = im2(x_start:x_end,y_start:y_end);
end

%For each region compute A = [Ix(q1) Iy(q1) ; ...; Ix(qn), Iy(qn)]  of size
% (region_size^2 2), A^T and b= [-It(q1); ...; -It(qn)] of size (region_size^2 1)
v= zeros(x_num_region*y_num_region,2);
for reg=1:x_num_region*y_num_region
    A=zeros(region_size^2,2);
    b=zeros(region_size^2,1);
   [s1,s2,s3]= size(regions1(reg,:,:));
    
    g_x=fspecial('gaussian',[1 kernel_size]);
    img_X=imfilter(reshape(regions1(reg,:,:),[s2,s3]),g_x);
    g_y=fspecial('gaussian',[kernel_size 1]);
    img_Y=imfilter(reshape(regions1(reg,:,:),[s2,s3]),g_y);
    
    for i=1:region_size^2
      x=mod(i-1,region_size)+1;
      y=floor((i-1) / region_size) +1;
      A(i,1) = img_X(x,y);
      A(i,2) = img_Y(x,y);
      b(i,1) = -1* (regions2(reg,x,y) - regions1(reg,x,y));
    end
    v(reg,:) = pinv(transpose(A) * A) * transpose(A) *b ; 
end
%solve v = (A^T A)^(-1) A^T b
%display result using "quiver": display vector u v at position x y

[x,y] = meshgrid(floor(region_size/2):region_size:H,floor(region_size/2):region_size:W);
vect_u=zeros(size(x));
vect_v=zeros(size(y));
for i=1:(x_num_region*y_num_region)
    xx= mod((i-1),x_num_region)+1;
    yy=floor((i-1)/x_num_region)+1;
    vect_u(xx,yy)=v(i,1);
    vect_v(xx,yy)=v(i,2);
end

figure
if(debug == false)
    quiver(x,y,vect_u,vect_v);
else
    subplot(1,2,1)
    imshow(im1)
    hold on;
    quiver(x,y,vect_u,vect_v,'y');
    subplot(1,2,2)
    imshow(im2)
end

end

