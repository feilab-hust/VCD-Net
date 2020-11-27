function show_some3d(folder, n, ratio, cmap, savefig, save_path, save_name)
    
    
    img_names = dir(folder);
    assert( length(img_names) >= (n+2));
    
    figure;
    set(gcf, 'Units','pixels', 'Position',  [0, 0, 400*n, 600])
    for i = 3 : n+2
        axis equal;
        img = imread3d(fullfile(folder, img_names(i).name));
        [row, col, depth] = size(img);
        ax1 = subplot(2,n,i-2);
        imagesc(max(img,[],3)); axis off; axis equal; axis tight; colormap(cmap);
        ax1.XLim = [0 col]; ax1.YLim = [0 row];
        set(gca,'Units','pixels','Position',[50+400*(i-3),300,300,300])
        ax2 = subplot(2,n,i-2+n);
        imagesc( imresize(squeeze(max(img,[],1))', 'Scale', [ratio, 1] ) ); axis off; axis equal; axis tight;colormap(cmap);
        ax2.XLim = [0 col]; ax2.YLim = [0 depth*ratio];
        set(gca,'Units','pixels','Position',[50+400*(i-3),0,300,300])
    end 
    
    if savefig
        if ~exist('save_path', 'dir')
            mkdir(save_path);
        end
        saveas(gcf, fullfile(save_path, save_name));
        disp(['Figure saved in ' fullfile(save_path, save_name)]);
    end
    
end