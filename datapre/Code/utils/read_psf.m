function [LFpsf,height,width,depth,Nnum,CAindex] = read_psf(file)
    psf = load(file);
    psf5d = psf.H;
    Nnum = psf.Nnum;
    CAindex = psf.CAindex;
    [height, width, Nx, Ny, depth] = size(psf5d);
    LFpsf = double(psf5d);
end