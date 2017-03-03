test='optical_flow'; % harris_corner optical_flow
if(strcmp(test,'harris_corner'))
    img = imread('sphere1.ppm');
    [r,c,Ix,Iy] = harris_corner(img, 15, 3);
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

elseif(strcmp(test,'optical_flow'))
    sphere1 = imread('sphere1.ppm');
    sphere2 = imread('sphere2.ppm');
    synth1 = imread('synth1.pgm');
    synth2 = imread('synth2.pgm');

    optical_flow( sphere1 , sphere2 , 15, 3, true);
    %optical_flow( synth1 , synth2 , 10, 3, true);

end
