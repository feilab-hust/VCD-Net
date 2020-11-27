function forward_projection(psf, poisson_noise, gaussian_noise, gaussian_sigma, brightness_adjust, gpu, source_path, save_path)
% FORWARD_PROJECTION projects the HR data into synthetic light field raw
% image
%   forward_projection(psf, poisson_noise, gaussian_noise, gaussian_sigma,...
%                               brightness_adjust, gpu, source_path, save_path)
%   Inputs:
%     psf - string, filepath to the Light Field PSF mat file
%     poisson_noise - bool, enable to add poisson noise
%     gaussian_noise - bool, enable to add gaussian noise
%     gaussian_sigma - double, std of the gaussian noise (when gaussian_noise is enabled)
%     brightness_adjust - double 0-1, scale the dynamic range
%     gpu - bool, enable to use GPU for convolution
%     source_path - where to read stacks
%     save_path - where to save light field raw images
    
    addpath('./utils');

    disp([ 'Loading LF_PSF...' ]);
    [LFpsf,psf_h,psf_w,psf_d,Nnum,CAindex] = read_psf(psf);
    disp(['LF_PSF has been loaded. Size: ' num2str(psf_h) 'x' num2str(psf_w) 'x' num2str(Nnum) 'x' num2str(Nnum) 'x' num2str(psf_d) '.']);
    depth = psf_d;

    if ~exist('save_path','dir')
        mkdir(save_path);
    end

    vol_source = dir(source_path);
    target_num = size(vol_source,1); 
    for t =3:target_num
        tic; 
        target = vol_source(t);                         
        volume = imread3d([source_path '/' target.name]);
        volume_dims = size(volume);
        
        if depth == volume_dims(3)
        
            if gpu  
                volume = gpuArray(single(volume));
                stacks = zeros(volume_dims,'double');
                global zeroImageEx;
                global exsize;
                xsize = [volume_dims(1), volume_dims(2)];
                msize = [size(LFpsf,1), size(LFpsf,2)];
                mmid = floor(msize/2);
                exsize = xsize + mmid;  
                exsize = [ min( 2^ceil(log2(exsize(1))), 128*ceil(exsize(1)/128) ), min( 2^ceil(log2(exsize(2))), 128*ceil(exsize(2)/128) ) ];    
                zeroImageEx = gpuArray(zeros(exsize, 'single'));
                for d = 1 : depth 
                    for i = 1 : Nnum
                        for j = 1 : Nnum
                            sub_region =  gpuArray.zeros(volume_dims(1),volume_dims(2),'single');
                            sub_region(i: Nnum: end,j: Nnum: end) = volume(i: Nnum: end, j: Nnum: end, d);
                            sub_psf = gpuArray(single(squeeze(LFpsf( CAindex(d,1):CAindex(d,2), CAindex(d,1):CAindex(d,2) ,i,j,d))));
                            sub_Out = conv2FFT(sub_region, sub_psf);
%                             sub_Out = conv2(sub_region, sub_psf,'same');
                            sub_out = gather(sub_Out);
                            stacks(:, :, d) = stacks(:, :, d) + sub_out;
                        end
                    end
                end            
            else
                stacks = zeros(volume_dims,'double');
                for d = 1 : depth 
                    for i = 1 : Nnum
                        for j = 1 : Nnum
                            sub_region =  zeros(volume_dims(1),volume_dims(2));
                            sub_region(i: Nnum: end,j: Nnum: end) = volume(i: Nnum: end, j: Nnum: end, d);
                            sub_psf = squeeze(LFpsf( CAindex(d,1):CAindex(d,2), CAindex(d,1):CAindex(d,2) ,i,j,d));
                            sub_out = conv2(sub_region,sub_psf,'same');
                            stacks(:, :, d) = stacks(:, :, d) + sub_out;
                        end
                    end
                end                        
            end            
            

            LF_raw  = (sum(stacks , 3)).* brightness_adjust;
            LF_raw = uint8(LF_raw);
            if poisson_noise
                LF_raw_poisson_noise = imnoise(LF_raw, 'poisson');
            else
                LF_raw_poisson_noise = LF_raw;
            end
            if gaussian_noise
                LF_raw_gaussian_noise = imnoise(LF_raw_poisson_noise, 'gaussian', 0, gaussian_sigma);
            else
                LF_raw_gaussian_noise = LF_raw_poisson_noise;
            end        
            imwrite(LF_raw_gaussian_noise, [save_path '/' target.name]);
            disp( ['Projected Image : ' target.name   ' ... ' num2str(toc) 'sec' ] );
        else
            disp( ['Skipped Image : ' target.name   ' ... ' 'The slice number of the stack: ' num2str(volume_dims(3)) ' does not match the PSF depth: ' num2str(depth) '.'] );         
        end
    end
end