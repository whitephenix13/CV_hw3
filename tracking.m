folder_name = 'pingpong';%pingpong person_toy

kernel_size = 10;
window_size = 5;
region_size = 10;
dt = 7 ;

listing = dir(folder_name);
name = strcat(folder_name,'/',listing(3).name);
mem_image = imread(name);
[H,W,D] = size(mem_image);

[row,col,Ix,Iy] = harris_corner(mem_image, kernel_size, window_size);
vect_ut = zeros(size(xt));%vectors to plot the optical flow
vect_vt = zeros(size(yt));

figure;
for i=1:length(listing)-4
    name = strcat(folder_name,'/',listing(i+3).name);
    image = imread(name);
    [vect_u, vect_v] = optical_flow(mem_image, image, region_size, kernel_size, false);
    x_num_region =  floor(W / region_size);
    y_num_region = floor(H / region_size);
    [x_reg, y_reg] = map_coord_to_region(row,col,region_size);
    for j=1:length(x_reg)-1
        [H2,W2] = size(vect_u);
        if(x_reg(j) < W2 && (y_reg(j) < H2))
           % {x_reg(j),y_reg(j),vect_u(y_reg(j),x_reg(j)),vect_v(y_reg(j),x_reg(j))}
            vect_ut(j,j)=vect_u(x_reg(j),y_reg(j));
            vect_vt(j,j)=vect_v(x_reg(j),y_reg(j));
            row(j) = row(j) + vect_v(x_reg(j),y_reg(j))*dt;
            col(j) = col(j) + vect_u(x_reg(j),y_reg(j))*dt;
        end
    end
    imshow(mem_image);
    disp('show new image')
    hold on;
   [xt,yt]= meshgrid(col,row);%x,y to plot the optical flow
    quiver(xt,yt,vect_ut,vect_vt,'y');
    % plot should receive c first because the plot function plots Y over X
    plot(col,row,'r.');
    hold off;
    mem_image = image;
    pause(0.1)
end