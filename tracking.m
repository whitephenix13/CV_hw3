folder_name = 'person_toy';

kernel_size = 3;
window_size = 3;

listing = dir(folder_name);
mem_image = imread(listing(1));
[row,col,Ix,Iy] = harris_corner(mem_image, kernel_size, window_size);
region_size = 10;
[H,W,D] = size(mem_image);

[row,col,Ix,Iy] = harris_corner(mem_image, kernel_size, window_size);
for i=1:length(listing)-1
    image = imread(listing(i+1));
    [vect_u, vect_v] = optical_flow(mem_image, image, region_size, kernel_size, false);
    y_num_region =  floor(W / region_size);
    x_num_region = floor(H / region_size);
    [x_reg, y_reg] = map_coord_to_region(row,col,region_size);
    for i=1:length(x_reg)-1
        [H2,W2] = size(vect_u);
        if(x_reg(i) < H2 && (y_reg(i) < W2))
            row(i) = row(i) + vect_u(x_reg(i),y_reg(i));
            col(i) = col(i) + vect_v(x_reg(i),y_reg(i));
        end
    end
    mem_image = image;
end