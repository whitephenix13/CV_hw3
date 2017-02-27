img = imread('sphere1.ppm');
if length(size(img))>2
    img = rgb2gray(img);
end
[r,c,Ix,Iy] = harris_corner(img, 7);
figure;
subplot(2,2,1)
imshow(Ix,[]);
title('gradient in x direction')
subplot(2,2,2)
imshow(Iy,[]);
title('gradient in y direction')
subplot(2,2,3);
imshow(img,[]);
hold on;
% plot should receive c first because the plot function plots Y over X
plot(c,r,'r.');
title('image with corner points')