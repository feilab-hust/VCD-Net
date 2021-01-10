function varargout = Main(varargin)
%MAIN MATLAB code file for Main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('Property','Value',...) creates a new MAIN using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Main_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MAIN('CALLBACK') and MAIN('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MAIN.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main

% Last Modified by GUIDE v2.5 09-Jan-2021 17:02:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function saveState(handles)

    
    global settingCropStack;
    global settingForwardProjection;
    global settingCrop;
    
    fileName1 = '../RUN/recentsettingCropStack.mat';
    fileName2 = '../RUN/recentsettingForwardProjection.mat';
    fileName3 = '../RUN/recentsettingCrop.mat';
    runPath = '../RUN/';
    if exist(runPath,'dir')==7
        ;
    else
        mkdir(runPath);
    end
    
    settingCropStack.StackDepth = get(handles.editStackDepth,'string');
    settingCropStack.Overlap = get(handles.editOverlap,'string');
    settingCropStack.dx = get(handles.editdx,'string');
    settingCropStack.Nnum = get(handles.editNnum, 'string');
    settingCropStack.BrightnessAdjust = get(handles.editBrightnessAdjust,'string');
    settingCropStack.AxialSampling = get(handles.editAxialSampling,'string');
    settingCropStack.RotationStep = get(handles.editRotationStep,'string');
    
    settingCropStack.RectifyImage = get(handles.checkboxRectifyImage,'Value');
    settingCropStack.Rotate = get(handles.checkboxRotate,'Value');
    settingCropStack.CompStack = get(handles.checkboxCompStack,'Value');
    settingCropStack.FlipX = get(handles.checkboxFlipX,'Value');
    settingCropStack.FlipY = get(handles.checkboxFlipY,'Value');
    settingCropStack.FlipZ = get(handles.checkboxFlipZ,'Value');  
    settingCropStack.bit8 = get(handles.checkboxbit8, 'Value');
    settingCropStack.bit16 = get(handles.checkboxbit16, 'Value');
        
    settingForwardProjection.BrightnessAdjust2 = get(handles.editBrightnessAdjust2,'string');
    settingForwardProjection.GaussianSigma = get(handles.editGaussianSigma,'string');
    
    settingForwardProjection.GPU = get(handles.checkboxGPU,'Value');
    settingForwardProjection.PoissonNoise = get(handles.checkboxPoissonNoise,'Value');
    settingForwardProjection.GaussianNoise = get(handles.checkboxGaussianNoise,'Value');
        
    settingCrop.SizeX = get(handles.editSizeX,'string');
    settingCrop.SizeY = get(handles.editSizeY,'string');
    settingCrop.SizeZ = get(handles.editSizeZ,'string');
    settingCrop.SumThreshold = get(handles.editSumThreshold,'string');
    settingCrop.VarThreshold = get(handles.editVarThreshold,'string');
    
    save(fileName1,'settingCropStack');
    save(fileName2,'settingForwardProjection');
    save(fileName3,'settingCrop');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loadState(handles)

global settingCropStack;
global settingForwardProjection;
global settingCrop;


fileName1 = '../RUN/recentsettingCropStack.mat';
if exist(fileName1)
    load(fileName1);
    set(handles.editStackDepth,'string',settingCropStack.StackDepth);
    set(handles.editOverlap,'string',settingCropStack.Overlap);
    set(handles.editdx,'string',settingCropStack.dx);
    set(handles.editNnum,'string',settingCropStack.Nnum);
    set(handles.editBrightnessAdjust,'string',settingCropStack.BrightnessAdjust);
    set(handles.editAxialSampling,'string',settingCropStack.AxialSampling);
    set(handles.editRotationStep,'string',settingCropStack.RotationStep);
    
    set(handles.checkboxRectifyImage,'value',settingCropStack.RectifyImage);
    set(handles.checkboxRotate,'value',settingCropStack.Rotate);
    set(handles.checkboxCompStack,'value',settingCropStack.CompStack);
    set(handles.checkboxFlipX,'value',settingCropStack.FlipX);
    set(handles.checkboxFlipY,'value',settingCropStack.FlipY);
    set(handles.checkboxFlipZ,'value',settingCropStack.FlipZ);
    set(handles.checkboxbit8, 'value',settingCropStack.bit8);
    set(handles.checkboxbit16, 'value',settingCropStack.bit16);
    
    
else
    set(handles.editStackDepth,'string','31');
    set(handles.editOverlap,'string','0.5');
    set(handles.editdx,'string','23.265');
    set(handles.editNnum,'string','11');
    set(handles.editBrightnessAdjust,'string','0.77');
    set(handles.editAxialSampling,'string','1');
    set(handles.editRotationStep,'string','30')
    
    set(handles.checkboxRectifyImage,'value',1);
    set(handles.checkboxRotate,'value',1);
    set(handles.checkboxCompStack,'value',1);
    set(handles.checkboxFlipX,'value',0);
    set(handles.checkboxFlipY,'value',0);
    set(handles.checkboxFlipZ,'value',1);
    set(handles.checkboxbit8, 'value',1);
    set(handles.checkboxbit16, 'value',0);
end

fileName2 = '../RUN/recentsettingForwardProjection.mat';
if exist(fileName2)
    load(fileName2);
    set(handles.editBrightnessAdjust2,'string',settingForwardProjection.BrightnessAdjust2);
    set(handles.editGaussianSigma,'string',settingForwardProjection.GaussianSigma);
    
    set(handles.checkboxGPU,'value',settingForwardProjection.GPU);
    set(handles.checkboxPoissonNoise,'value',settingForwardProjection.PoissonNoise);
    set(handles.checkboxGaussianNoise,'value',settingForwardProjection.GaussianNoise);
    
else
    set(handles.editBrightnessAdjust2,'string','0.005');
    set(handles.editGaussianSigma,'string','0.00005');
    
    set(handles.checkboxGPU,'value',0);
    set(handles.checkboxPoissonNoise,'value',0);
    set(handles.checkboxGaussianNoise,'value',0);
end

fileName3 = '../RUN/recentsettingCrop.mat';
if exist(fileName3)
    load(fileName3);
    set(handles.editSizeX,'string',settingCrop.SizeX);
    set(handles.editSizeY,'string',settingCrop.SizeY);
    set(handles.editSizeZ,'string',settingCrop.SizeZ);
    set(handles.editSumThreshold,'string',settingCrop.SumThreshold);
    set(handles.editVarThreshold,'string',settingCrop.VarThreshold);
else
    set(handles.editSizeX,'string','176');
    set(handles.editSizeY,'string','176');
    set(handles.editSizeZ,'string','31');
    set(handles.editSumThreshold,'string','1e5');
    set(handles.editVarThreshold,'string','1e0');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function readState(handles)
    global settingCropStack;
    global settingForwardProjection;
    global settingCrop;
    
    settingCropStack.StackDepth = get(handles.editStackDepth,'string');
    settingCropStack.Overlap = get(handles.editOverlap,'string');
    settingCropStack.dx = get(handles.editdx,'string');
    settingCropStack.Nnum = get(handles.editNnum, 'string');
    settingCropStack.BrightnessAdjust = get(handles.editBrightnessAdjust,'string');
    settingCropStack.AxialSampling = get(handles.editAxialSampling,'string');
    settingCropStack.RotationStep = get(handles.editRotationStep,'string');
    
    settingCropStack.RectifyImage = get(handles.checkboxRectifyImage,'Value');
    settingCropStack.Rotate = get(handles.checkboxRotate,'Value');
    settingCropStack.CompStack = get(handles.checkboxCompStack,'Value');
    settingCropStack.FlipX = get(handles.checkboxFlipX,'Value');
    settingCropStack.FlipY = get(handles.checkboxFlipY,'Value');
    settingCropStack.FlipZ = get(handles.checkboxFlipZ,'Value');
    settingCropStack.bit8 = get(handles.checkboxbit8,'Value');
    settingCropStack.bit16 = get(handles.checkboxbit16,'Value');
    
    
    settingForwardProjection.BrightnessAdjust2 = get(handles.editBrightnessAdjust2,'string');
    settingForwardProjection.GaussianSigma = get(handles.editGaussianSigma,'string');
    
    settingForwardProjection.GPU = get(handles.checkboxGPU,'Value');
    settingForwardProjection.PoissonNoise = get(handles.checkboxPoissonNoise,'Value');
    settingForwardProjection.GaussianNoise = get(handles.checkboxGaussianNoise,'Value');
        
    settingCrop.SizeX = get(handles.editSizeX,'string');
    settingCrop.SizeY = get(handles.editSizeY,'string');
    set(handles.editSizeZ, 'string', settingCropStack.StackDepth);
    settingCrop.SizeZ = get(handles.editSizeZ,'string');
    settingCrop.SumThreshold = get(handles.editSumThreshold,'string');
    settingCrop.VarThreshold = get(handles.editVarThreshold,'string');

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function CropStackcheckState(handles)
    global settingCropStack;
    readState(handles);
    settingCropStack.check = 1;
    
    if ~(  str2num(settingCropStack.StackDepth) > 0 && mod(str2num(settingCropStack.StackDepth),1)==0  )
        disp('The Stack Depth should be a positive integer.');
        settingCropStack.check = 0;
    end
    if (str2num(settingCropStack.Overlap)<0) || (str2num(settingCropStack.Overlap)>1)
        disp('Overlap is a fraction between 0 and 1');
        settingCropStack.check = 0;
    end
    if ~(str2num(settingCropStack.dx)>0)
        disp('dx(equals to 150/PixelSize) should be positve.');
        settingCropStack.check = 0;
    end
    if mod(str2num(settingCropStack.Nnum),2)==0 || mod(str2num(settingCropStack.Nnum),1)>0 || str2num(settingCropStack.Nnum)<1
        disp('Nnum should be an odd integer number.');
        settingCropStack.check = 0;
    end
    if (str2num(settingCropStack.BrightnessAdjust)<=0) || (str2num(settingCropStack.BrightnessAdjust)>1)
        disp('Brightness Adjust is a fraction between 0 and 1. Higher, brighter.');
        settingCropStack.check = 0;
    end
    if mod(str2num(settingCropStack.AxialSampling),1)>0 || str2num(settingCropStack.AxialSampling)<1
        disp('Axial Sampling should be an integer number for axial downsampling.');
        settingCropStack.check = 0;
    end
    if mod(str2num(settingCropStack.RotationStep),1)>0 || str2num(settingCropStack.RotationStep)<0 || str2num(settingCropStack.RotationStep) > 180
        disp('Rotation Step should be an integer number between 0-180 degree');
        settingCropStack.check = 0;
    end
    
    if settingCropStack.check == 1
        saveState(handles);
        disp('=============Start CropStack==============');
        
        CropStacks;
        
    else
        disp('========= Retry after changing the variables according to the message =======');
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ForwardProjectioncheckState(handles)
    global settingForwardProjection;
    readState(handles);
    settingForwardProjection.check = 1;
    
    if (str2num(settingForwardProjection.BrightnessAdjust2)<=0) || (str2num(settingForwardProjection.BrightnessAdjust2)>1)
        disp('Brightness Adjust is a fraction between 0 and 1. Higher, brighter.');
        settingForwardProjection.check = 0;
    end
    if (str2num(settingForwardProjection.GaussianSigma) < 0)
        disp('Gaussian Sigma should be positive.');
        settingForwardProjection.check = 0;        
    end

    
    if settingForwardProjection.check == 1
        saveState(handles);
        disp('=============Start ForwardProjection==============');
        
        forward;
        
    else
        disp('========= Retry after changing the variables according to the message =======');
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CropTestcheckState(handles)
    global settingCrop;
    readState(handles);
    settingCrop.check = 1;
    settingCrop.saveAll = 1;
    
    if ~(str2num(settingCrop.SizeX) > 0)
        disp('The SizeX should be larger than 0');
        settingCrop.check = 0;
    end
    if ~(str2num(settingCrop.SizeY) > 0)
        disp('The SizeY should be larger than 0');
        settingCrop.check = 0;
    end
    if ~(str2num(settingCrop.SizeZ) > 0)
        disp('The SizeZ should be larger than 0');
        settingCrop.check = 0;
    end
    if ~(str2num(settingCrop.SumThreshold) > 0)
        disp('The SumThreshold should be larger than 0');
        settingCrop.check = 0;
    end
    if ~(str2num(settingCrop.VarThreshold) > 0)
        disp('The VarThreshold should be larger than 0');
        settingCrop.check = 0;
    end
   
    if settingCrop.check == 1
        saveState(handles);
        disp('=============Start CropTest==============');
        
        crop;
        
    else
        disp('========= Retry after changing the variables according to the message =======');
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CropcheckState(handles)
    global settingCrop;
    readState(handles);
    settingCrop.check = 1;
    settingCrop.saveAll = 0;
    
    if ~(str2num(settingCrop.SizeX) > 0)
        disp('The SizeX should be larger than 0');
        settingCrop.check = 0;
    end
    if ~(str2num(settingCrop.SizeY) > 0)
        disp('The SizeY should be larger than 0');
        settingCrop.check = 0;
    end
    if ~(str2num(settingCrop.SizeZ) > 0)
        disp('The SizeZ should be larger than 0');
        settingCrop.check = 0;
    end
    if ~(str2num(settingCrop.SumThreshold) > 0)
        disp('The SumThreshold should be larger than 0');
        settingCrop.check = 0;
    end
    if ~(str2num(settingCrop.VarThreshold) > 0)
        disp('The VarThreshold should be larger than 0');
        settingCrop.check = 0;
    end
   
    if settingCrop.check == 1
        saveState(handles);
        disp('=============Start Crop==============');
        
        crop;
        
    else
        disp('========= Retry after changing the variables according to the message =======');
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global settingCropStack;
global settingForwardProjection;
global settingCrop;
loadState(handles);



% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Operate.
function Operate_Callback(hObject, eventdata, handles)
% hObject    handle to Operate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CropStackcheckState(handles);



function editStackDepth_Callback(hObject, eventdata, handles)
% hObject    handle to editStackDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStackDepth as text
%        str2double(get(hObject,'String')) returns contents of editStackDepth as a double


% --- Executes during object creation, after setting all properties.
function editStackDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStackDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOverlap_Callback(hObject, eventdata, handles)
% hObject    handle to editOverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOverlap as text
%        str2double(get(hObject,'String')) returns contents of editOverlap as a double


% --- Executes during object creation, after setting all properties.
function editOverlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editdx_Callback(hObject, eventdata, handles)
% hObject    handle to editdx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editdx as text
%        str2double(get(hObject,'String')) returns contents of editdx as a double


% --- Executes during object creation, after setting all properties.
function editdx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editdx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxRectifyImage.
function checkboxRectifyImage_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxRectifyImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxRectifyImage
global settingCropStack;
if (get(hObject,'Value') == get(hObject,'Max'))
    settingCropStack.RectifyImage = 1;
else
    settingCropStack.RectifyImage = 0;
end


function editNnum_Callback(hObject, eventdata, handles)
% hObject    handle to editNnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNnum as text
%        str2double(get(hObject,'String')) returns contents of editNnum as a double


% --- Executes during object creation, after setting all properties.
function editNnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editBrightnessAdjust_Callback(hObject, eventdata, handles)
% hObject    handle to editBrightnessAdjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBrightnessAdjust as text
%        str2double(get(hObject,'String')) returns contents of editBrightnessAdjust as a double


% --- Executes during object creation, after setting all properties.
function editBrightnessAdjust_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBrightnessAdjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editAxialSampling_Callback(hObject, eventdata, handles)
% hObject    handle to editAxialSampling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAxialSampling as text
%        str2double(get(hObject,'String')) returns contents of editAxialSampling as a double


% --- Executes during object creation, after setting all properties.
function editAxialSampling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAxialSampling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editRotationStep_Callback(hObject, eventdata, handles)
% hObject    handle to editRotationStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRotationStep as text
%        str2double(get(hObject,'String')) returns contents of editRotationStep as a double


% --- Executes during object creation, after setting all properties.
function editRotationStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRotationStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editSumThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to editSumThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSumThreshold as text
%        str2double(get(hObject,'String')) returns contents of editSumThreshold as a double


% --- Executes during object creation, after setting all properties.
function editSumThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSumThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editVarThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to editVarThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVarThreshold as text
%        str2double(get(hObject,'String')) returns contents of editVarThreshold as a double


% --- Executes during object creation, after setting all properties.
function editVarThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVarThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSizeX_Callback(hObject, eventdata, handles)
% hObject    handle to editSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSizeX as text
%        str2double(get(hObject,'String')) returns contents of editSizeX as a double


% --- Executes during object creation, after setting all properties.
function editSizeX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonCropTest.
function pushbuttonCropTest_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCropTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CropTestcheckState(handles);

% --- Executes on button press in pushbuttonCrop.
function pushbuttonCrop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CropcheckState(handles);


function editSizeY_Callback(hObject, eventdata, handles)
% hObject    handle to editSizeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSizeY as text
%        str2double(get(hObject,'String')) returns contents of editSizeY as a double


% --- Executes during object creation, after setting all properties.
function editSizeY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSizeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSizeZ_Callback(hObject, eventdata, handles)
% hObject    handle to editSizeZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSizeZ as text
%        str2double(get(hObject,'String')) returns contents of editSizeZ as a double


% --- Executes during object creation, after setting all properties.
function editSizeZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSizeZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBrightnessAdjust2_Callback(hObject, eventdata, handles)
% hObject    handle to editBrightnessAdjust2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBrightnessAdjust2 as text
%        str2double(get(hObject,'String')) returns contents of editBrightnessAdjust2 as a double


% --- Executes during object creation, after setting all properties.
function editBrightnessAdjust2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBrightnessAdjust2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Project.
function Project_Callback(hObject, eventdata, handles)
% hObject    handle to Project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ForwardProjectioncheckState(handles);


% --- Executes on button press in checkboxRotate.
function checkboxRotate_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxRotate
global settingCropStack;
if (get(hObject,'Value') == get(hObject,'Max'))
    settingCropStack.Rotate = 1;
else
    settingCropStack.Rotate = 0;
end

% --- Executes on button press in checkboxCompStack.
function checkboxCompStack_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxCompStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxCompStack
global settingCropStack;
if (get(hObject,'Value') == get(hObject,'Max'))
    settingCropStack.CompStack = 1;
else
    settingCropStack.CompStack = 0;
end

% --- Executes on button press in checkboxFlipX.
function checkboxFlipX_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFlipX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFlipX
global settingCropStack;
if (get(hObject,'Value') == get(hObject,'Max'))
    settingCropStack.FlipX = 1;
else
    settingCropStack.FlipX = 0;
end

% --- Executes on button press in checkboxFlipY.
function checkboxFlipY_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFlipY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFlipY
global settingCropStack;
if (get(hObject,'Value') == get(hObject,'Max'))
    settingCropStack.FlipY = 1;
else
    settingCropStack.FlipY = 0;
end

% --- Executes on button press in checkboxFlipZ.
function checkboxFlipZ_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFlipZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFlipZ
global settingCropStack;
if (get(hObject,'Value') == get(hObject,'Max'))
    settingCropStack.FlipZ = 1;
else
    settingCropStack.FlipZ = 0;
end

% --- Executes on button press in checkboxbit8.
function checkboxbit8_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxbit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxbit8
global settingCropStack;
if ( get(hObject,'Value') == get(hObject,'Max') )
    settingCropStack.bit8 = 1;
    settingCropStack.bit16 = 0;
    set(handles.checkboxbit16, 'Value', settingCropStack.bit16);
    
else
    settingCropStack.bit8 = 0;
    settingCropStack.bit16 = 1;
    set(handles.checkboxbit16, 'Value', settingCropStack.bit16);
end

% --- Executes on button press in checkboxbit16.
function checkboxbit16_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxbit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxbit16
global settingCropStack;
if ( get(hObject,'Value') == get(hObject,'Max') )
    settingCropStack.bit16 = 1;
    settingCropStack.bit8 = 0;
    set(handles.checkboxbit8, 'Value', settingCropStack.bit8);
    
else
    settingCropStack.bit16 = 0;
    settingCropStack.bit8 = 1;
    set(handles.checkboxbit8, 'Value', settingCropStack.bit8);
end


% --- Executes during object creation, after setting all properties.
function checkboxCompStack_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkboxCompStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in checkboxGPU.
function checkboxGPU_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxGPU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxGPU
global settingForwardProjection;
if (get(hObject,'Value') == get(hObject,'Max'))
    settingForwardProjection.GPU = 1;
else
    settingForwardProjection.GPU = 0;
end


% --- Executes on button press in checkboxPoissonNoise.
function checkboxPoissonNoise_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPoissonNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPoissonNoise
global settingForwardProjection;
if (get(hObject,'Value') == get(hObject,'Max'))
    settingForwardProjection.PoissonNoise = 1;
else
    settingForwardProjection.PoissonNoise = 0;
end

% --- Executes on button press in checkboxGaussianNoise.
function checkboxGaussianNoise_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxGaussianNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxGaussianNoise
global settingForwardProjection;
if (get(hObject,'Value') == get(hObject,'Max'))
    settingForwardProjection.GaussianNoise = 1;
else
    settingForwardProjection.GaussianNoise = 0;
end


function editGaussianSigma_Callback(hObject, eventdata, handles)
% hObject    handle to editGaussianSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGaussianSigma as text
%        str2double(get(hObject,'String')) returns contents of editGaussianSigma as a double


% --- Executes during object creation, after setting all properties.
function editGaussianSigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editGaussianSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function CropStacks
%%% To crop the ground truth volumes into required substacks

warning('off');

load('../RUN/recentsettingCropStack.mat');
%%%%%%%%%%%%%%%%%%%%%%%%% Substacks Parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
substack_depth = str2num(settingCropStack.StackDepth);
overlap = str2num(settingCropStack.Overlap);
dx = str2num(settingCropStack.dx); 
Nnum = str2num(settingCropStack.Nnum);
range_adjust = str2num(settingCropStack.BrightnessAdjust);
z_sampling = str2num(settingCropStack.AxialSampling);
rotation_step = str2num(settingCropStack.RotationStep);

rectification_enable = settingCropStack.RectifyImage;
rotation_enable = settingCropStack.Rotate;
complement_stack = settingCropStack.CompStack;
flip_x = settingCropStack.FlipX;
flip_y = settingCropStack.FlipY;
flip_z = settingCropStack.FlipZ;
if settingCropStack.bit8>settingCropStack.bit16
    bitdepth = 8;
elseif settingCropStack.bit8<settingCropStack.bit16
    bitdepth = 16;
else
    bitdepth = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save_path = '../Data/Substacks';

[file_name,file_path] = uigetfile('*.tif','Select Original Stacks','MultiSelect','on');
if ~iscell(file_name)
    file_name = {file_name};
end

crop_raw_stack(substack_depth, overlap, dx, Nnum, range_adjust, z_sampling, ...
    rotation_step, rectification_enable, rotation_enable, complement_stack,...
    flip_x, flip_y, flip_z, file_path, file_name, save_path, bitdepth);

disp('Rectify and Augment HR data ... done');


function forward
%%% Multi Stacks Light Field Forward Projection
%%% The Stacks slice number should correspond to the depth of PSF
warning('off');

load('../RUN/recentsettingCropStack.mat');
load('../RUN/recentsettingForwardProjection.mat');
%%%%%%%%%%%%%%%%%%%%%%%%% Projection Parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
brightness_adjust = str2double(settingForwardProjection.BrightnessAdjust2);
gpu = settingForwardProjection.GPU;
poisson_noise = settingForwardProjection.PoissonNoise;
gaussian_noise = settingForwardProjection.GaussianNoise;
gaussian_sigma = str2double(settingForwardProjection.GaussianSigma);
if settingCropStack.bit8>settingCropStack.bit16
    bitdepth = 8;
elseif settingCropStack.bit8<settingCropStack.bit16
    bitdepth = 16;
else
    bitdepth = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_path = '../Data/Substacks';
save_path = '../Data/LFforward';

[psf_name,psf_path] = uigetfile('*.mat','Select PSF','MultiSelect','off','../PSFmatrix');

forward_projection([psf_path, psf_name], poisson_noise, gaussian_noise, gaussian_sigma,...
    brightness_adjust, gpu, source_path, save_path, bitdepth);

disp(['Forward Projection ... Done']);


function crop
warning('off');
load('../RUN/recentsettingCropStack.mat');
load('../RUN/recentsettingCrop.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%Crop Parameter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cropped_size = [str2num(settingCrop.SizeX),str2num(settingCrop.SizeY),str2num(settingCrop.SizeZ)];
overlap = [0.5,0.5,0.];
pixel_threshold = str2num(settingCrop.SumThreshold);
var_threshold   = str2num(settingCrop.VarThreshold);
save_all = settingCrop.saveAll;
if settingCropStack.bit8>settingCropStack.bit16
    bitdepth = 8;
elseif settingCropStack.bit8<settingCropStack.bit16
    bitdepth = 16;
else
    bitdepth = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
source_path_3d = '../Data/Substacks';
save_path_3d = '../Data/TrainingPair/WF';
source_path_2d = '../Data/LFforward';
save_path_2d = '../Data/TrainingPair/LF';

generate_patches(cropped_size, overlap, pixel_threshold, var_threshold, ...
    save_all, source_path_3d, save_path_3d, source_path_2d, save_path_2d, bitdepth);

disp('Crop ...Done');





