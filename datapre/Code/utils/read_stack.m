function [volume,row,col] = read_stack(img,depth,beginning_index)
%READ_STACK reads the 3D tif forwardly from the beginning_index and for depth stacks
%   [volume,row,col] = read_stack(img,depth,beginning_index);
%   Inputs:
%       img - file to read
%       depth - number of slices to read
%       beginning_index - beginning position to start reading
%   Outputs:
%       volume - matrix of image stack data
%       row - row number
%       col - col number


    imtest = imread(img);
    [row,col] = size(imtest);
    volume = zeros(row,col,depth);
    for d = 1:depth
        stack = imread(img,'Index',d+beginning_index-1);
        volume(:,:,d) = stack;
    end
    
    
end