function varargout = IKONOS(varargin)
% IKONOS MATLAB code for IKONOS.fig
%      IKONOS, by itself, creates a new IKONOS or raises the existing
%      singleton*.
%
%      H = IKONOS returns the handle to a new IKONOS or the handle to
%      the existing singleton*.
%
%      IKONOS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IKONOS.M with the given input arguments.
%
%      IKONOS('Property','Value',...) creates a new IKONOS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IKONOS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IKONOS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IKONOS

% Last Modified by GUIDE v2.5 20-Apr-2017 15:30:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IKONOS_OpeningFcn, ...
                   'gui_OutputFcn',  @IKONOS_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before IKONOS is made visible.
function IKONOS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IKONOS (see VARARGIN)

% Choose default command line output for IKONOS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IKONOS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IKONOS_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in EXIT.
function EXIT_Callback(hObject, eventdata, handles)
close


% --- Executes on button press in SAVE.
function SAVE_Callback(hObject, eventdata, handles)
% hObject    handle to SAVE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Import.
function Import_Callback(hObject, eventdata, handles)
[name,path] = uigetfile('*.tif');
if isequal(name,0) || isequal(path,0)
    filename2 = '';
else
    filename2 = [path name];
end
setappdata(0,'filename2',filename2);

RGB=imread(filename2);
%figure,imagesc(RGB);
D=double(RGB);
NIR=D(:,:,3);
R=D(:,:,2);
G=D(:,:,1);

%Display
min_R = min(min(R));
max_R = max(max(R));
RED = (R-min_R)./(max_R - min_R);

min_NIR = min(min(NIR));
max_NIR = max(max(NIR));
NIR_= (NIR-min_NIR)./(max_NIR - min_NIR);

min_G = min(min(G));
max_G = max(max(G));
GREEN= (G-min_G)./(max_G - min_G);

axes(handles.axes5);
RGB2=cat(3,NIR_,RED,GREEN);
imshow(RGB2);
%% NDVI ;

NDVI=(NIR-R)./(NIR+R);
%figure,imshow(NDVI);
axes(handles.axes1);
imshow(NDVI);
title('NDVI Index Imagery');
%% Buildup Area;

NonBuildup=NDVI(:,:)>0;
%figure,imshow(NonBuildup);
axes(handles.axes2);
imshow(NonBuildup);
title('Non buildup Area');

%% NonBuildup Area;

Buildup=NDVI(:,:)<0;
%figure,imshow(Buildup);
axes(handles.axes3);
imshow(Buildup);
title('Buildup Area');

%% combine Level 1 Classification

data=2*Buildup+NonBuildup;
figure,imagesc(data);
title('Level 1 Classification ');
axes(handles.axes6);
imagesc(data);
axis off;

%NIR=RGB();
