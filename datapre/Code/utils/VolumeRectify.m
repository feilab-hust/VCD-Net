function Volume_Rect = VolumeRectify(VolumeRAW,xCenter,yCenter,dx,Nnum,depth)

	dy = dx;
	Nnumdiff = floor(Nnum/2);
	[Yresolution, Xresolution, depth] = size(VolumeRAW);
	


	%%%%%%%%%%%%%%%  Resample the image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Xresample = [fliplr((xCenter+1):-dx/Nnum:1)  ((xCenter+1)+dx/Nnum:dx/Nnum:Xresolution)];%% dx/Nnum represents how many actual pixels a 'virtual pixel' behind mla has. Then we locate all these virtual pixels' positions in real space
	Yresample = [fliplr((yCenter+1):-dx/Nnum:1)  ((yCenter+1)+dx/Nnum:dx/Nnum:Yresolution)];
	[X, Y] = meshgrid( (1:1:Xresolution),   (1:1:Yresolution) );                      %% Grid in original image 2160*2560
	[Xq,Yq] = meshgrid( Xresample , Yresample );                                      %% Imported from LFDisplay. The position of each resampled pixel 1416*1679. The reduce of resolution is because that a virtual pixel is bigger than a real one

	XqCenterInit = find(Xq(1,:)==(xCenter+1)) - Nnumdiff;                             
	XqInit = XqCenterInit -  Nnum*floor(XqCenterInit/Nnum)+Nnum;                     
	XqLength = Nnum*floor((size(Xq,2)-XqInit+1)/Nnum);
	XqEnd = Nnum*floor((XqLength-XqInit)/Nnum) + XqInit - 1;                                  
	YqCenterInit = find(Yq(:,1)==(yCenter+1)) - Nnumdiff;                               
	YqInit = YqCenterInit -  Nnum*floor(YqCenterInit/Nnum)+Nnum;
	YqLength = Nnum*floor((size(Yq,1)-YqInit+1)/Nnum);
	YqEnd = Nnum*floor((YqLength-YqInit)/Nnum) + YqInit - 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	XresampleQ = Xresample(XqInit:XqEnd);      
% 	YresampleQ = Yresample(YqInit:YqEnd);
% 	[Xqq,Yqq] = meshgrid( XresampleQ , YresampleQ ); 
% 
% 	Xresolution_resampled = size(XresampleQ,2);
% 	Yresolution_resampled = size(YresampleQ,2);



% 
% 	Volume_Resampled = zeros(Yresolution_resampled, Xresolution_resampled, depth);
% 	for d = 1:depth
% 		Volume_Resampled(:,:,d) = interp2( X, Y, VolumeRAW(:,:,d), Xqq, Yqq);
% 	end

% 	Volume_Rect = Volume_Resampled;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The following was edited in corrsponding to ImageRectification_GUI.m from MIT in order to have the same image size 2018/2/28
%% Same function as the code block above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    XresampleQ = Xresample(XqInit:end);
    YresampleQ = Yresample(YqInit:end);
    [Xqq,Yqq] = meshgrid( XresampleQ , YresampleQ );
    
    Xresolution_resampled = size(XresampleQ,2);
	Yresolution_resampled = size(YresampleQ,2);

    Volume_Resampled = zeros(Yresolution_resampled, Xresolution_resampled, depth);
 	for d = 1:depth
		Volume_Resampled(:,:,d) = interp2( X, Y, VolumeRAW(:,:,d), Xqq, Yqq);
	end   

    Volume_Rect = Volume_Resampled( (1:1:Nnum*floor((size(Volume_Resampled,1)-YqInit)/Nnum)), (1:1:Nnum*floor((size(Volume_Resampled,2)-XqInit)/Nnum)),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%