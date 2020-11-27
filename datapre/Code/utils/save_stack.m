function save_stack(stacks, filename)
%SAVE_STACK saves stack in uint8 format
%   save_stack(stacks, filename)
%   Inputs:
%       stacks: data(uint8) to save
%       filename: filepath+filename to save


    assert(max(stacks(:)) <= 255, 'image data to be saved must be in 8-bit')
    stacks = uint8(stacks);
    depth = size(stacks,3);
    imwrite(stacks(:,:,1),filename);
    for d = 2:depth
        img = stacks(:,:,d);
        imwrite(img,filename,'WriteMode','append');
    end
end