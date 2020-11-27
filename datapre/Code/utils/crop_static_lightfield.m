function crop_static_lightfield(cropped_size, overlap, source_path, save_path)
                    
    overlap_px = floor(overlap * cropped_size);
    wrap_content = false;

    if mod(overlap_px, 2) == 1
        overlap_px = overlap_px + 1;
    end

    file_list = dir(source_path);
    file_num = length(file_list);
    cropped_num = 0;

    step = cropped_size - overlap_px;
    for n = 3 : file_num
        file = strcat(source_path, '/', file_list(n).name);
        img = imread(file);
        [height, width, ~] = size(img);
        fprintf('processing img %d / %d\n', n - 2, file_num - 2)

        % cut image
        cropped_num_current_slice = 0;
        idx_y = 0;
        for i = 1 : step : height
            if i > height-cropped_size+1
                if wrap_content
                    i = height - cropped_size + 1;
                else
                    break;
                end
            end

            idx_x = 0;
            idx_y = idx_y + 1;

            for j = 1 : step : width
                if j > width-cropped_size+1
                    if wrap_content
                        j = width - cropped_size + 1;
                    else
                        break;
                    end
                end
                idx_x = idx_x + 1;
                h = i + cropped_size - 1;
                w = j + cropped_size - 1;

                region = img(i : h, j : w, :);

                imwrite(region, fullfile(save_path,sprintf('%03d-%06d.tif', n - 2, cropped_num_current_slice)));
    %             fprintf('x : %d  y : %d\n', idx_x, idx_y);
                cropped_num_current_slice = cropped_num_current_slice + 1;
            end

        end
        cropped_num = cropped_num + cropped_num_current_slice;
    end

    disp(['cropped images : ' num2str(cropped_num)])
    % % delete invalid patches 
    load('crop3dparams.mat');
    [num, ~] = size(abandoned_list);
    for i = 1 : num
        delete(fullfile(save_path, sprintf('%s', abandoned_list(i, :) )));
        fprintf('deleting %s/%s-*...\n', save_path, abandoned_list(i, :))
    end

end
