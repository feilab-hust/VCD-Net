function generate_patches(cropped_size, overlap, pixel_threshold, var_threshold, ...
    save_all, source_path_3d, save_path_3d, source_path_2d, save_path_2d)
% GENERATE_PATCHES crops small 3-D stacks and corresponding 2-D light field
% raw image for training. It discards the patches lack of information based
% on mean intensity and variation
%   generate_patches(cropped_size, overlap, pixel_threshold, var_threshold, ...
%    save_all, source_path_3d, save_path_3d, source_path_2d, save_path_2d)
%   Inputs:
%     cropped_size - vector of int, patch size x, y, z
%     overlap - vector of double 0-1, patch overlap x, y, z
%     pixel_threshold - double
%     var_threshold - double
%     save_all - enable to save patches without discarding
%     source_path_3d, source_path_2d - where to read stacks
%     save_path_3d, save_path_2d - where to save light field raw images

    addpath('./utils');
    
    if ~exist('save_path_2d','dir')
        mkdir(save_path_2d);
    end    
    if ~exist('save_path_3d','dir')
        mkdir(save_path_3d);
    end

    if save_all    
        crop_static_3d(cropped_size, overlap, source_path_3d, save_path_3d, save_all, pixel_threshold, var_threshold);
    else
        delete(fullfile(save_path_3d, '*.tif'));
        delete(fullfile(save_path_2d, '*.tif'));
        crop_static_3d(cropped_size, overlap, source_path_3d, save_path_3d, save_all, pixel_threshold, var_threshold);
        crop_static_lightfield(cropped_size(1), overlap, source_path_2d, save_path_2d);
    end    
end