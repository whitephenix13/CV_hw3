function [res_x ,res_y] = map_coord_to_region(x_coord,y_coord,region_size)
res_x = floor(x_coord ./ region_size) + 1;
res_y = floor(y_coord ./ region_size) + 1;
end