function crop_static_3d(cropped_size, overlap, static_path, save_path, save_all, pixel_threshold, var_threshold, bitdepth)

%%% crop small 3-D stacks into training data
%clear
% path(path, '_utils')
% cropped_size = [176, 176, 31];
% overlap = [0.5, 0.5, 0.];
% pixel_threshold = 1e5;
% var_threshold   = 1e0;
%
%
% save_all = false;

%%% specify the cropping operation when window moves to the margin
% if false, the margin of the original stack of which the size is samller
% than cropped_size will be discarded;
% if true, the crop window will move forward , making more overlap to cover
% the margin.subVolSource = dir(folderSourceName)
wrap_content = false;

overlap_px = floor(overlap .* cropped_size);

file_list = dir(static_path);

file_num = length(file_list);
cropped_num = 0;
% save_dir = sprintf('\\cropped%dX%dX%d_overlap%.2f-%.2f-%.2f',cropped_size, overlap);
% mkdir(path, save_dir);

step = cropped_size - overlap_px;
abandoned_list = [];

if save_all
    if file_num <= 4
        interval = 1;
    elseif mod(file_num, 2) == 1
        interval = floor((file_num - 2) / 2);
    else
        interval = floor((file_num - 3) / 2);
    end
else
    interval = 1;
end

for n = 3 : interval : file_num
    file = fullfile(static_path,file_list(n).name);
%     file = strcat(path, file_list(n).name);
    img = imread3d(file);
    [height, width, depth] = size(img);
    
    
    % cut image
    cropped_num_current_stack = 0;
    
    idx_z = 0;
    for k = 1 : step(3) : depth-cropped_size(3)+1
        if k > depth-cropped_size(3)+1
            if wrap_content
                k = depth - cropped_size(3) + 1;
            else
                break;
            end
        end
        idx_z = idx_z + 1;
        idx_y = 0;
        
        for i = 1 : step(1) : height
            if i > height-cropped_size(1)+1
                if wrap_content
                    i = height - cropped_size(1) + 1;
                else
                    break;
                end
            end
            idx_y = idx_y + 1;
            
            idx_x = 0;
            for j = 1 : step(2) : width
                if j > width-cropped_size(2)+1
                    if wrap_content
                        j = width - cropped_size(2) + 1;
                    else
                        break;
                    end
                end
                idx_x = idx_x + 1;
                
                fprintf('processing img %d / %d : ', n - 2, file_num - 2)
                fprintf('block[%d  %d  %d]   ', idx_y, idx_x, idx_z);
                
                h = i + cropped_size(1) - 1;
                w = j + cropped_size(2) - 1;
                d = k + cropped_size(3) - 1;
                fprintf('%d : %d, %d : %d, %d : %d\n', i, h ,j, w, k, d);
                block = img(i : h, j : w, k : d);
                block_id = sprintf('%03d-%06d.tif',  n - 2, cropped_num_current_stack);
                pixel_sum = sum(block(:));
                pixel_var = var(double(block(:)));
                
                %writeSequence(block, [path save_dir sprintf('\\%d-%06d', n, cropped_num_current_stack)]);
                if ~save_all
                    if pixel_sum > pixel_threshold && pixel_var > var_threshold
                        fprintf('sum %d var %d : saved as %s', pixel_sum, pixel_var, block_id)
                        write3d(block, [save_path '/' block_id], bitdepth);
                    else
                        abandoned_list = [abandoned_list; block_id];
                        fprintf('sum %d var %d : abandoned', pixel_sum, pixel_var)
                    end
                else  % save all blocks , no matter valid or not
                    fprintf('sum %d var %d : saved as %s', pixel_sum, pixel_var, block_id)
                    write3d(block, [save_path '/' block_id], bitdepth);
                end
                fprintf('\n')
                cropped_num_current_stack = cropped_num_current_stack + 1;
            end
            
        end
        
    end
    cropped_num = cropped_num + cropped_num_current_stack;
end

% grid_dim = [idx_y, idx_x, idx_z];
fprintf('valid blocks : %d / %d \n', cropped_num - length(abandoned_list), cropped_num);
if ~save_all
    save('crop3dparams.mat', 'cropped_size', 'overlap', 'abandoned_list');
end
