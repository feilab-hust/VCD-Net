function show_some2d(folder, n, cmap, savefig, save_path, save_name)
    
    
    img_names = dir(folder);
    assert( length(img_names) >= (n+2));
    
    figure;
    set(gcf, 'Units','pixels', 'Position',  [0, 0, 400*n, 400])
    for i = 3 : n+2
        axis equal;
        img = imread(fullfile(folder, img_names(i).name));
        [row, col] = size(img);
        ax1 = subplot(2,n,i-2);
        imagesc(img); axis off; axis equal; axis tight;colormap(cmap);
        ax1.XLim = [0 col]; ax1.YLim = [0 row];
        set(gca,'Units','pixels','Position',[50+400*(i-3),50,300,300])
    end 
    
    if savefig
        if ~exist('save_path', 'dir')
            mkdir(save_path);
        end
        saveas(gcf, fullfile(save_path, save_name));
        disp(['Figure saved in ' fullfile(save_path, save_name)]);
    end
    
end