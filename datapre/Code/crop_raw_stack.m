function crop_raw_stack(substack_depth, overlap, dx, Nnum, range_adjust, z_sampling, ...
    rotation_step, rectification_enable, rotation_enable, compstack_enable,...
    flipx, flipy, flipz, file_path, file_name, save_path)
% CROP_RAW_STACK crops the HR data in depth and augments the dataset
%   crop_raw_stack(substack_depth, overlap, dx, Nnum, range_adjust, z_sampling, ...
%                   rotation_step, rectification_enale, rotation_enable, compstack_enable,...
%                   flipx, flipy, flipz, save_path)
%   Inputs:
%     substack_depth - int, number of slices of each substack
%     overlap - double 0-1, overlap of each substack
%     dx - double, the number of pixels behind each lenslet, it comes from LFDisplay
%     Nnum - int, output number of pixels behind each lenslet
%     range_adjust - double 0-1, scale the dynamic range
%     z_sampling - int, downsample ratio of depth
%     rotation_step - double, increment of the rotation in degree
%     rectification_enable - enable the rectification of lf raw image
%     rotation_enable - enable the rotation
%     compstack_enable - enable to add black slices if the origianl stack
%     has insufficient slice number
%     flipx, flipy, flipz - enable to flip along one dimension
%     file_path - folder to read stacks
%     file_name - cell, cell that stores file names of each stack
%     save_path - where to save

addpath('./utils');

if ~exist('save_path','dir')
    mkdir(save_path);
end

overlap_slice = floor(overlap * substack_depth);

file_num = size(file_name,2);

for n=1:file_num
    save_name = file_name{n};
    save_name = save_name(1:end-4);

    file = fullfile(file_path,file_name{n});
    original_stack = imread3d(file);    
    [row,col,depth] = size(original_stack);

    sampled_stack = original_stack(:,:,1:z_sampling:depth); 
    % todo: extend z sampling to a double ratio
    depth = size(sampled_stack,3);
    
    
    if(depth < substack_depth)    
        if (compstack_enable)
            f = zeros([row, col, substack_depth]); b = f;
            f(:,:, 1 : depth) = sampled_stack;
            b(:,:, end-depth+1 : end) = sampled_stack;
            stacks_to_rotate = zeros([row, col, substack_depth, 2]);
            stacks_to_rotate(:,:,:,1) = f;
            stacks_to_rotate(:,:,:,2) = b;
        else
            disp([save_name ' ... ' 'insufficient slices: ' num2str(depth) ' < ' num2str(substack_depth) ' ...  skipped.  ']);
            continue;
        end
    else        
        stacks_to_rotate = sampled_stack;            
    end
    
    if (flipz)        
        [r, c, d, n_stack] = size(stacks_to_rotate);
        temp = zeros([r, c, d, n_stack*2]);
        temp(:,:,:,1:n_stack) = stacks_to_rotate;
        temp(:,:,:,n_stack+1:end) = flip(stacks_to_rotate, 3);
        stacks_to_rotate = temp;
    end
    
    if (flipx)        
        [r, c, d, n_stack] = size(stacks_to_rotate);
        temp = zeros([r, c, d, n_stack*2]);
        temp(:,:,:,1:n_stack) = stacks_to_rotate;
        temp(:,:,:,n_stack+1:end) = flip(stacks_to_rotate, 2);
        stacks_to_rotate = temp;
    end
    
    if (flipy)        
        [r, c, d, n_stack] = size(stacks_to_rotate);
        temp = zeros([r, c, d, n_stack*2]);
        temp(:,:,:,1:n_stack) = stacks_to_rotate;
        temp(:,:,:,n_stack+1:end) = flip(stacks_to_rotate, 1);
        stacks_to_rotate = temp;
    end
    
    [row, col, depth, n_stack] = size(stacks_to_rotate);
            
    for nn_stack = 1 : n_stack
        
        stack2rotate = stacks_to_rotate(:,:,:, nn_stack);
        
        for angle = 0 : rotation_step : (179*rotation_enable)

            rotated_stack = imrotate(stack2rotate, angle, 'bicubic', 'loose');
            substack_num = ceil((depth-substack_depth)/(substack_depth-overlap_slice)) + 1;   % when Overlap = 0 and depth = SubStackDepth, subStackNum = 1; No Wrap;
            for nn = 1:substack_num
                tic;
                s = 1 + (nn-1)*(substack_depth-overlap_slice);
                e = s + substack_depth - 1;
                if e > depth   % Wrap the last SubStack
                    s = s - (e - depth);
                    e = depth;
                end
                substack = rotated_stack(:,:,s:e);
                if rectification_enable
                    xCenter = col/2;   
                    yCenter = row/2;
                    rectified_stack = VolumeRectify(substack,xCenter,yCenter,dx,Nnum,depth);
                else
                    rectified_stack = substack;
                end        
                rectified_stack = (rectified_stack ./ max(rectified_stack(:))) .* range_adjust .* 255.0;
                substack_name = sprintf('%s_Flip%02d_Angle%03d_SUB%02d.tif', save_name, nn_stack, angle, nn);
                save_stack(rectified_stack, [save_path '/' substack_name]);
                disp([substack_name ' ... ' '  done  ' ' in ' num2str(toc) ' sec']);
            end
            
            
        end
    end
        
end



end