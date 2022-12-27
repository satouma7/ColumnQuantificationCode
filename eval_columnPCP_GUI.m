function varargout = eval_columnPCP_GUI(varargin)
% eval_columnPCP_GUI MATLAB code for eval_columnPCP_GUI.fig
%      eval_columnPCP_GUI, by itself, creates a new eval_columnPCP_GUI or raises the existing
%      singleton*.
%
%      H = eval_columnPCP_GUI returns the handle to a new eval_columnPCP_GUI or the handle to
%      the existing singleton*.
%
%      eval_columnPCP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in eval_columnPCP_GUI.M with the given input arguments.
%
%      eval_columnPCP_GUI('Property','Value',...) creates a new eval_columnPCP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eval_columnPCP_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eval_columnPCP_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eval_columnPCP_GUI

% Last Modified by GUIDE v2.5 02-Jul-2021 14:12:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eval_columnPCP_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @eval_columnPCP_GUI_OutputFcn, ...
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

% --- Executes just before eval_columnPCP_GUI is made visible.
function eval_columnPCP_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eval_columnPCP_GUI (see VARARGIN)
global imgori imgcrop preW preH rot X Y Poly Mark Color contents;

filelist = ls(fullfile('nnPCP','*.mat'));
set(handles.cpselect,'String',filelist);

handles.home='LSMdata';
filelist = ls(fullfile(handles.home,'*.???'));
set(handles.lsmselect,'String',filelist);

contens = cellstr(get(handles.cpselect,'String'));
cpPath = fullfile('nnPCP',contens{get(handles.cpselect,'Value')});
handles.cppath = cpPath;

contents = cellstr(get(handles.lsmselect,'String'));
% get(handles.lsmselect,'Value')
% contents{get(handles.lsmselect,'Value')}
imgPath = fullfile(handles.home,contents{get(handles.lsmselect,'Value')});
handles.imgpath = imgPath;

handles.ori=bfopen(handles.imgpath);
info=handles.ori{1}{1,2};
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Cmax=str2num(extractAfter(extractAfter(info,"C="),"/"))
if isempty(extractAfter(info,"C="))
    Cmax=1;
    Zmax=str2num(extractAfter(extractAfter(info,"Z="),"/"));
else
    Zmax=str2num(extractAfter(extractBefore(extractAfter(info,"Z="),";"),"/"));
end
if isempty(extractAfter(info,"Z="))
    Zmax=1;
end

%C=1;G=1;
rot=0;
Z=round(Zmax/2);
Zstart=Z-2;Zend=Z+2;
if Zstart<1
    Zstart=1;
end
if Zend>Zmax
    Zend=Zmax;
end

set(handles.Zslider,'Value',Z);
set(handles.Zslider,'Min',1);
set(handles.Zslider,'Max',Zmax);
set(handles.Zslider,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);
set(handles.minlabel,'String',1);
set(handles.maxlabel,'String',Zmax);
set(handles.Zedit,'Value',Z);
set(handles.Zedit,'String',Z);

set(handles.Zstart,'Value',Zstart);
set(handles.Zstart,'Min',1);
set(handles.Zstart,'Max',Zmax);
set(handles.Zstart,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);
set(handles.Zstartvalue,'Value',Zstart);
set(handles.Zstartvalue,'String',Zstart);

set(handles.Zend,'Value',Zend);
set(handles.Zend,'Min',1);
set(handles.Zend,'Max',Zmax);
set(handles.Zend,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);
set(handles.Zendvalue,'Value',Zend);
set(handles.Zendvalue,'String',Zend);

if Cmax==1
    set(handles.cslider,'SliderStep',[0 0]);
    set(handles.gslider,'SliderStep',[0 0]);
    C=1;G=1;
else
    set(handles.cslider,'SliderStep',[1/(Cmax-1) 1/(Cmax-1)]);
    set(handles.gslider,'SliderStep',[1/(Cmax-1) 1/(Cmax-1)]);
    C=1;G=2;
end
set(handles.cslider,'Value',C);
set(handles.cslider,'Min',1);
set(handles.cslider,'Max',Cmax);
set(handles.gslider,'Value',G);
set(handles.gslider,'Min',1);
set(handles.gslider,'Max',Cmax);
set(handles.cvalue,'Value',C);
set(handles.cvalue,'String',C);
set(handles.gvalue,'Value',G);
set(handles.gvalue,'String',G);

set(handles.Lslider,'Value',2);%stride
set(handles.Lslider,'Min',1);
set(handles.Lslider,'Max',5);
set(handles.Lslider,'SliderStep',[0.25 0.25]);
set(handles.Lvalue,'Value',2);
set(handles.Lvalue,'String',2);

set(handles.Oslider,'Value',0.4);%Overlap threthold
set(handles.Ovalue,'Value',0.4);
set(handles.Ovalue,'String',0.4);

set(handles.Dslider,'Value',0.5);%Detection threthold
set(handles.Dvalue,'Value',0.5);
set(handles.Dvalue,'String',0.5);

Poly=4;
set(handles.Vertex_slider,'Value',Poly);
set(handles.Vertex_value,'String',Poly);
X=zeros(1,Poly);Y=zeros(1,Poly);
for I=1:Poly
    theta=(I-1)*2*pi/Poly+pi/4;
    X(I)=round(100*cos(theta)+Xmax/2);
    Y(I)=round(100*sin(theta)+Ymax/2);
end

V1=min(X);W1=min(Y);
width=max(X)-min(X);height=max(Y)-min(Y);

set(handles.Xslider1,'Value',V1);set(handles.Xslider1,'Max',Xmax);set(handles.Xslider1,'SliderStep',[1/(Xmax-1) 10/(Xmax-1)]);
set(handles.Yslider1,'Value',W1);set(handles.Yslider1,'Max',Ymax);set(handles.Yslider1,'SliderStep',[1/(Ymax-1) 10/(Ymax-1)]);
set(handles.X1value,'String',V1);
set(handles.Y1value,'String',W1);

I=(Z-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};%handles.img: original 2D data
%handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 1 1 Z Z]));
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');
imgcrop=imresize(handles.img(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);

handles.Blim=stretchlim(imgcrop,[Bthreshold/200 1-Bthreshold/200]);  %%
imgori=imadjust(handles.img,handles.Blim);%imgori: brightness adjusted 2D data
axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
preW=450;preH=240;
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Z)]);
Mark={'o','^','x'};Color={'r','g','b'};

axes(handles.axes8);imshow(imread('image002_10a.tif'));
axes(handles.axes9);imshow(imread('image003_10a.tif'));
axes(handles.axes10);imshow(imread('image006_10a.tif'));
axes(handles.axes11);imshow(imread('image012_10a.tif'));

set(handles.PCA,'Enable','off');
set(handles.eSVM,'Enable','off');
set(handles.save,'Enable','off');
set(handles.movie,'Enable','off');

% Choose default command line output for eval_columnPCP_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eval_columnPCP_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eval_columnPCP_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in lsmselect.
function lsmselect_Callback(hObject, eventdata, handles)
% hObject    handle to lsmselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori preW preH rot X Y Poly
contents = cellstr(get(hObject,'String'));
imgPath = fullfile(handles.home,contents{get(hObject,'Value')});
handles.imgpath = imgPath;
handles.ori=bfopen(handles.imgpath);
info=handles.ori{1}{1,2};
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Cmax=str2num(extractAfter(extractAfter(info,"C="),"/"))
if isempty(extractAfter(info,"C="))
    Cmax=1;
    Zmax=str2num(extractAfter(extractAfter(info,"Z="),"/"));
else
    Zmax=str2num(extractAfter(extractBefore(extractAfter(info,"Z="),";"),"/"));
end
if isempty(extractAfter(info,"Z="))
    Zmax=1;
end

%C=1;G=1;
rot=0;
Z=round(Zmax/2);
Zstart=Z-2;Zend=Z+2;
if Zstart<1
    Zstart=1;
end
if Zend>Zmax
    Zend=Zmax;
end

set(handles.Zslider,'Value',Z);
set(handles.Zedit,'Value',Z);
set(handles.Zedit,'String',Z);
set(handles.Zslider,'Min',1);
set(handles.Zslider,'Max',Zmax)
set(handles.minlabel,'String',1);
set(handles.maxlabel,'String',Zmax);
set(handles.Zslider,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);

set(handles.Zstart,'Value',Zstart);
set(handles.Zstart,'Min',1);
set(handles.Zstart,'Max',Zmax);
set(handles.Zstart,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);
set(handles.Zstartvalue,'Value',Zstart);
set(handles.Zstartvalue,'String',Zstart);

set(handles.Zend,'Value',Zend);
set(handles.Zend,'Min',1);
set(handles.Zend,'Max',Zmax);
set(handles.Zend,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);
set(handles.Zendvalue,'Value',Zend);
set(handles.Zendvalue,'String',Zend);

% C=get(handles.cvalue,'Value');
% G=get(handles.gvalue,'Value');
if Cmax==1
    set(handles.cslider,'SliderStep',[0 0]);
    set(handles.gslider,'SliderStep',[0 0]);
    C=1;G=1;
else
    set(handles.cslider,'SliderStep',[1/(Cmax-1) 1/(Cmax-1)]);
    set(handles.gslider,'SliderStep',[1/(Cmax-1) 1/(Cmax-1)]);
    C=1;G=2;
end
set(handles.cslider,'Value',C);
set(handles.cslider,'Min',1);
set(handles.cslider,'Max',Cmax);
set(handles.gslider,'Value',G);
set(handles.gslider,'Min',1);
set(handles.gslider,'Max',Cmax);
set(handles.cvalue,'Value',C);
set(handles.cvalue,'String',C);
set(handles.gvalue,'Value',G);
set(handles.gvalue,'String',G);

Poly=4;
set(handles.Vertex_slider,'Value',Poly);
set(handles.Vertex_value,'String',Poly);
X=zeros(1,Poly);Y=zeros(1,Poly);
for I=1:Poly
    theta=(I-1)*2*pi/Poly+pi/4;
    X(I)=round(100*cos(theta)+Xmax/2);
    Y(I)=round(100*sin(theta)+Ymax/2);
end
V1=min(X);W1=min(Y);
width=max(X)-min(X);height=max(Y)-min(Y);

set(handles.Xslider1,'Value',V1);set(handles.Xslider1,'Max',Xmax);set(handles.Xslider1,'SliderStep',[1/(Xmax-1) 10/(Xmax-1)]);
set(handles.Yslider1,'Value',W1);set(handles.Yslider1,'Max',Ymax);set(handles.Yslider1,'SliderStep',[1/(Ymax-1) 10/(Ymax-1)]);
set(handles.X1value,'String',V1);
set(handles.Y1value,'String',W1);

Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');
I=(Z-1)*Cmax+C;handles.img = handles.ori{1}{I,1};

imgcrop=imresize(handles.img(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
handles.Blim=stretchlim(imgcrop,[Bthreshold/200 1-Bthreshold/200]);  %%
imgori=imadjust(handles.img,handles.Blim);
axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Z)]);
guidata(hObject,handles);

set(handles.PCA,'Enable','off');
set(handles.eSVM,'Enable','off');
set(handles.save,'Enable','off');
set(handles.movie,'Enable','off');


% Hints: contents = cellstr(get(hObject,'String')) returns lsmselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lsmselect


% --- Executes during object creation, after setting all properties.
function lsmselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lsmselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in cpselect.
function cpselect_Callback(hObject, eventdata, handles)
% hObject    handle to cpselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contens = cellstr(get(hObject,'String'));
cpPath = fullfile('nnPCP',contens{get(hObject,'Value')});
handles.cppath = cpPath;

guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns cpselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cpselect


% --- Executes during object creation, after setting all properties.
function cpselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function Zslider_Callback(hObject, eventdata, handles)
% hObject    handle to Zslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori preW preH rot X Y
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Z = round(get(hObject,'Value'));
set(handles.Zslider,'Value',Z);set(handles.Zedit,'String',num2str(Z));
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');

C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

Cmax=handles.cslider.Max;I=(Z-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
%handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 C C Z Z]));
if rot~=0
    handles.img=rot90(handles.img,rot);
end

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
Left=V1;Right=V1+width;Bottom=W1;Top=W1+height;%%

imgcrop=imresize(handles.img(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
handles.Blim=stretchlim(imgcrop,[Bthreshold/200 1-Bthreshold/200]); %%
imgori=imadjust(handles.img,handles.Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Z)]);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Zslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in ZsectionJump.
function ZsectionJump_Callback(hObject, eventdata, handles)
% hObject    handle to ZsectionJump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori preW preH rot X Y
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Z=get(handles.Zslider,'Value');
C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

Cmax=handles.cslider.Max;I=(Z-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
%handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 C C Z Z]));
if rot~=0
    handles.img=rot90(handles.img,rot);
end

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
Left=V1;Right=V1+width;Bottom=W1;Top=W1+height;%%

imgcrop=imresize(handles.img(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
handles.Blim=stretchlim(imgcrop,[Bthreshold/200 1-Bthreshold/200]); %%
imgori=imadjust(handles.img,handles.Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Z)]);

function Zedit_Callback(hObject, eventdata, handles)
% hObject    handle to Zedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori preW preH rot X Y
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Z = round(str2num(get(hObject,'String')));
set(handles.Zslider,'String',num2str(Z));
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');

C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

Cmax=handles.cslider.Max;I=(Z-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
%handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 C C Z Z]));
if rot~=0
    handles.img=rot90(handles.img,rot);
end

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
Left=V1;Right=V1+width;Bottom=W1;Top=W1+height;%%

imgcrop=imresize(handles.img(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
handles.Blim=stretchlim(imgcrop,[Bthreshold/200 1-Bthreshold/200]);  %%
imgori=imadjust(handles.img,handles.Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Z)]);


% Hints: get(hObject,'String') returns contents of Zedit as text
%        str2double(get(hObject,'String')) returns contents of Zedit as a double

% --- Executes during object creation, after setting all properties.
function Zedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function Zstart_Callback(hObject, eventdata, handles)
% hObject    handle to Zstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH rot X Y
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zstart = round(get(hObject,'Value'));Zend=get(handles.Zend,'Value');
if Zstart>Zend
    Zstart=Zend;
end
set(handles.Zstart,'Value',Zstart);
set(handles.Zstartvalue,'String',num2str(Zstart));
C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');

Cmax=handles.cslider.Max;I=(Zstart-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
%handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 C C Zstart Zstart]));
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,handles.Blim);
guidata(hObject,handles);

axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Z start image=',num2str(Zstart)]);

% --- Executes during object creation, after setting all properties.
function Zstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in ZstartJump.
function ZstartJump_Callback(hObject, eventdata, handles)
% hObject    handle to ZstartJump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global preW preH rot X Y
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zstart=get(handles.Zstart,'Value');
C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');

Cmax=handles.cslider.Max;I=(Zstart-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
%handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 C C Zstart Zstart]));
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,handles.Blim);
guidata(hObject,handles);

axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Z start image=',num2str(Zstart)]);

% --- Executes on slider movement.
function Zend_Callback(hObject, eventdata, handles)
% hObject    handle to Zend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH rot X Y
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zend = round(get(hObject,'Value'));Zstart=get(handles.Zstart,'Value');
if Zstart>Zend
    Zend=Zstart;
end
set(handles.Zend,'Value',Zend);
set(handles.Zendvalue,'String',num2str(Zend));
C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');

Cmax=handles.cslider.Max;I=(Zend-1)*Cmax+C
handles.img = handles.ori{1}{I,1};
%handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 C C Zend Zend]));
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,handles.Blim);
guidata(hObject,handles);

axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Z end image=',num2str(Zend)]);


% --- Executes during object creation, after setting all properties.
function Zend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in ZendJump.
function ZendJump_Callback(hObject, eventdata, handles)
% hObject    handle to ZendJump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global preW preH rot X Y
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zend=get(handles.Zend,'Value');
C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');

Cmax=handles.cslider.Max;I=(Zend-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
%handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 C C Zend Zend]));
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,handles.Blim);
guidata(hObject,handles);

axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Z end image=',num2str(Zend)]);

% --- Executes on slider movement.
function Xslider1_Callback(hObject, eventdata, handles)
% hObject    handle to Xslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH X Y
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
if V1<1
    V1=1;
end
if V1+width>Xmax
    V1=Xmax-width;
end
set(handles.Xslider1,'Value',V1);set(handles.X1value,'String',V1);
Z=round(get(handles.Zslider,'Value'));
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
guidata(hObject,handles);

X=X-min(X)+V1;

imgori=imadjust(handles.img,handles.Blim);
axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);

hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Xslider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Yslider1_Callback(hObject, eventdata, handles)
% hObject    handle to Yslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH X Y
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
if W1<1
    W1=1;
end
if W1+height>Ymax
    W1=Ymax-height;
end
set(handles.Yslider1,'Value',W1);set(handles.Y1value,'String',W1);
Z=round(get(handles.Zslider,'Value'));
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
guidata(hObject,handles);

Y=Y-min(Y)+W1;

imgori=imadjust(handles.img,handles.Blim);
axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Yslider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in rotbutton.
function rotbutton_Callback(hObject, eventdata, handles)
% hObject    handle to rotbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rot preW preH X Y
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
handles.img = rot90(handles.img);
rot=rot+1;
if rot>3
    rot=0;
end
Xtemp=-Y+Xmax;Y=X;X=Xtemp;
width=max(X)-min(X);height=max(Y)-min(Y);
V1=min(X);W1=min(Y);

set(handles.Xslider1,'Value',V1);set(handles.Xslider1,'Max',Xmax);set(handles.Xslider1,'SliderStep',[1/(Xmax-1) 10/(Xmax-1)]);
set(handles.Yslider1,'Value',W1);set(handles.Yslider1,'Max',Ymax);set(handles.Yslider1,'SliderStep',[1/(Ymax-1) 10/(Ymax-1)]);
set(handles.X1value,'String',V1);
set(handles.Y1value,'String',W1);

imgori=imadjust(handles.img,handles.Blim);
axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

guidata(hObject,handles);


% --- Executes on slider movement.
function Dslider_Callback(hObject, eventdata, handles)
% hObject    handle to Dslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Dthreshold=round(get(hObject,'Value'),2);
set(handles.Dslider,'Value',Dthreshold);
set(handles.Dvalue,'String',Dthreshold);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Dslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Oslider_Callback(hObject, eventdata, handles)
% hObject    handle to Oslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Othreshold=round(get(hObject,'Value'),2);
set(handles.Oslider,'Value',Othreshold);
set(handles.Ovalue,'String',Othreshold);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Oslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Oslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Bslider_Callback(hObject, eventdata, handles)
% hObject    handle to Bslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH X Y
Bthreshold=round(get(hObject,'Value'),2);
set(handles.Bslider,'Value',Bthreshold);
set(handles.Bvalue,'String',Bthreshold);

%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
Left=V1;Right=V1+width;Bottom=W1;Top=W1+height;%%

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(handles.img(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);

handles.Blim=stretchlim(imgcrop,[Bthreshold/200 1-Bthreshold/200]);  %%
imgori=imadjust(handles.img,handles.Blim);
axes(handles.main_img);
imshow(imgori);
%imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Bslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Mslider_Callback(hObject, eventdata, handles)
% hObject    handle to Mslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH X Y
Mag=round(get(hObject,'Value'),2);
set(handles.Mslider,'Value',Mag);
set(handles.Mvalue,'String',Mag);
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');

imgori=imadjust(handles.img,handles.Blim);
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Mslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Lslider_Callback(hObject, eventdata, handles)
% hObject    handle to Lslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
L=round(get(hObject,'Value'));
set(handles.Lslider,'Value',L);
set(handles.Lvalue,'String',L);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Lslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function cslider_Callback(hObject, eventdata, handles)
% hObject    handle to cslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH rot X Y
C=round(get(hObject,'Value'));
set(handles.cslider,'Value',C);
set(handles.cvalue,'String',C);
set(handles.cvalue,'String',C);
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
Z = round(get(handles.Zslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
Left=V1;Right=V1+width;Bottom=W1;Top=W1+height;%%

Cmax=handles.cslider.Max;I=(Z-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
Mag=get(handles.Mslider,'Value');
imgcrop=imresize(handles.img(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);

handles.Blim=stretchlim(imgcrop,[Bthreshold/200 1-Bthreshold/200]); %%
imgori=imadjust(handles.img,handles.Blim);

axes(handles.main_img);
imshow(imgori);
hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function cslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function gslider_Callback(hObject, eventdata, handles)
% hObject    handle to gslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH rot X Y
G=round(get(hObject,'Value'));
set(handles.gslider,'Value',G);
set(handles.gvalue,'String',G);
set(handles.gvalue,'String',G);
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
Z = round(get(handles.Zslider,'Value'));
Left=V1;Right=V1+width;Bottom=V1;Top=V1+height;%%

Cmax=handles.cslider.Max;I=(Z-1)*Cmax+G;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
Mag=get(handles.Mslider,'Value');
imgori=imadjust(handles.img,handles.Blim);

axes(handles.main_img);
imshow(imgori);

hold on;
patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function gslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)%Survey
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global net imgori imgcropA rot X Y hex height width Poly Mark Color
global overlap count m n i j Flist I Zstart Zend scoreA wn hn ID FimgsA
disp('Survey start');
tic;
load(handles.cppath);
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
Left=V1;Right=V1+width;Bottom=W1;Top=W1+height;%%

Z=round(get(handles.Zslider,'Value'));
C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

ws = 32;
area = ws * ws;
cor = round(ws/2);
stride=get(handles.Lslider,'Value');
detectionthreshold=get(handles.Dslider,'Value');
overlapthreshold=get(handles.Oslider,'Value');

Zstart=get(handles.Zstart,'Value');Zend=get(handles.Zend,'Value');
Cmax=handles.cslider.Max;I=(Z-1)*Cmax+C;
imgori = handles.ori{1}{I,1};
if rot~=0
    imgori=rot90(imgori,rot);
end
imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
handles.Blim=stretchlim(imgcropA,[Bthreshold/200 1-Bthreshold/200]);  %%

wn = floor((width*Mag-ws)/stride+1);%161
hn = floor((height*Mag-ws)/stride+1);%161

imgsA = uint16(zeros(ws,ws,1,1));
ID=1;N=1;list=zeros(1,8);
disp('Classification start');
for Z=Zstart:Zend
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    if rot~=0
        imgori=rot90(imgori,rot);
    end
    hex=polyshape((X-V1)*Mag+1,(W1+height-Y)*Mag+1);
    imgcropA=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);%%
    imgcropA=imadjust(imgcropA,handles.Blim);%
    
    %list:1ID, 2X, 3Y, 4Z, 5Columness, 6Normal, 7Gap, 8Nohole
    for m=1:hn%161
        j=(m-1)*stride+1;%Y
        for n=1:wn%161
           i=(n-1)*stride+1;%X
           if isinterior(hex,i+cor,j+cor)==1%%%%%
                imgsA(:,:,1,ID) = imgcropA(j:j+ws-1,i:i+ws-1);%
                list(ID,1) = ID;%ID
                list(ID,2) = i+cor;%X axis
                list(ID,3) = j+cor;%Y axis
                list(ID,4) = Z-Zstart+1;%ID
                ID=ID+1;
           end
        end
    end
end
    
[~,scoreA] = classify(net,imgsA);%adjusted
list(:,5) = 1-scoreA(:,1);%columness
list((list(:,5)<detectionthreshold),:) = []; 
list = sortrows(list,5,'descend');%Columnessにしたがってソート
%list:1ID, 2X, 3Y, 4Z, 5Columness, 6Normal, 7Gap, 8Nohole
disp('Classification completed/Z-overlap being removed');

%Alist/list:1ID, 2X, 3Y, 4Z, 5Columness, 6Normal, 7Gap, 8Nohole
list = sortrows(list,5,'descend');%sort by Columness
count = 1;%count: 
while(count<size(list,1))%overlap removal between neighboring sections
    x = list(count,2);%
    y = list(count,3);%
    n = count+1;%n:
    while(n<=size(list,1))
        nx = list(n,2);%
        ny = list(n,3);%
        x1 = max([x nx])-ws/2;%
        y1 = max([y ny])-ws/2;%
        x2 = min([x nx])+ws/2;%
        y2 = min([y ny])+ws/2;%
        w = x2-x1+1;%
        h = y2-y1+1;%
        if (w>0) && (h>0)
            overlap = w*h / area;
            if overlap > overlapthreshold
               list(n,:) = [];%
                n = n-1;
            end
        end
        n = n+1;
    end
    count = count+1;
end

%Flist/list:1ID, 2X, 3Y, 4Z, 5Columness, 6Normal, 7Gap, 8Nohole
%imgsA: 1X, 2Y, 3blank, 4ID
Flist=sortrows(list,2,'ascend');
Flist=sortrows(Flist,3,'ascend');
Flist=sortrows(Flist,4,'ascend');%Flist: sort by XYZ / Final list
L=1/2;FimgsA=uint16(zeros(ws,ws,size(Flist,1)));%FimgsA: 1X, 2Y, 3ID
for J=1:size(Flist,1)
    FimgsA(:,:,J)=imgsA(:,:,1,Flist(J,1));
    E=activations(net,imgsA(:,:,1,Flist(J,1)),13);
    E1=exp(L*E(1));E2=exp(L*E(2));E3=exp(L*E(3));E4=exp(L*E(4));
    bunbo=E1+E2+E3+E4;
    Flist(J,6)=E2/bunbo;%norm
    Flist(J,7)=E3/bunbo;%gap
    Flist(J,8)=E4/bunbo;%nohole
end
Flist(:,1)=1:size(Flist,1);
toc;
disp('Z-overlap removed');

X3Dstart=Mag*(X-V1)+1;X3Dstart(1,Poly+1)=X3Dstart(1,1);
Y3Dstart=Mag*(W1+height-Y)+1;Y3Dstart(1,Poly+1)=Y3Dstart(1,1);
Z3Dstart=zeros(1,Poly+1);
X3Dend=Mag*(X-V1)+1;X3Dend(1,Poly+1)=X3Dend(1,1);
Y3Dend=Mag*(W1+height-Y)+1;Y3Dend(1,Poly+1)=Y3Dend(1,1);
Z3Dend=10*ones(1,Poly+1)*(Zend-Zstart+1);

figure;c=hsv(6);M=1;J=1;
hold on;%3次元プロット
plot3(X3Dstart,Y3Dstart,Z3Dstart,'Color',[0.5 0 0]);
plot3(X3Dend,Y3Dend,Z3Dend,'Color',[0 0.5 0]);
for I=1:Poly
    plot3([X3Dstart(I) X3Dend(I)],[Y3Dstart(I) Y3Dend(I)],[Z3Dstart(I) Z3Dend(I)],'Color',[0.5 0.5 0]);
end

%Flist(1ID, 2 X, 3 Y, 4 Z, 5 Columness, 6 Normal, 7 Gap, 8 Nohole)
%Clist(1ID, 2 X, 3 Y, 4 Z, 5 Type (1-3), 6 Likeliness)
Clist=zeros(size(Flist,1),6);
Clist=Flist(:,1:6);
Labels=Clist(:,1);Clist(:,4)=Clist(:,4)*10;
for I=1:size(Clist,1)
    [Clist(I,6), Clist(I,5)]=max([Flist(I,6) Flist(I,7) Flist(I,8)]);
end
for I=1:3
    list=Clist(Clist(:,5)==I,:);
    scatter3(list(:,2),list(:,3),list(:,4),24,Color{I},Mark{I});daspect([1 1 1]);
    text(list(:,2)+3,list(:,3),list(:,4),num2str(list(:,1)),'FontUnits','pixels','FontSize',10,'Color',Color{I});%
end
xlim([0 Mag*width+1]);ylim([0 Mag*height+1]);
set(gca,'Ydir','Reverse');set(gca,'Zdir','Reverse');set(gca,'Color','k');

handles.date=datestr(now, 'mmdd_HHMM');
set(handles.PCA,'Enable','on');
set(handles.eSVM,'Enable','off');
set(handles.save,'Enable','off');
set(handles.movie,'Enable','on');
guidata(hObject,handles);

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Excelist list list2

[a name c]=fileparts(handles.imgpath);
name=strcat(name,'_', handles.date, '.xls');

%Flist(1ID, 2 X, 3 Y, 4 Z, 5 Columness, 6 Normal, 7 Gap, 8 Nohole)
%list(1ID, 2Type (1-3), 3 Normal, 4 Gap, 5 Nohole)
%list2(1ID, 2Type (1-3), 3 PDratio, 4 Smoothness1, 5 Smoothness2)
%Excelist(1ID, 2Type_NGH(1-3), 3Normal, 4Gap, 5Nohole, 6Type_PDS(1-3), 7PDratio, 8Smoothness1, 9Smoothness2)
list=sortrows(list,1,'ascend');
list2=sortrows(list2,1,'ascend');
Excelist=list;
Excelist(:,6)=list2(:,2);%Type_PDS
Excelist(:,7)=list2(:,3);%PDratio
Excelist(:,8)=list2(:,4);%Smoothness1
Excelist(:,9)=list2(:,5);%Smoothness2

warning('off','MATLAB:xlswrite:AddSheet');
xlswrite(name, Excelist,1);%
set(handles.movie,'Enable','on');


% --- Executes on button press in movie.
function movie_Callback(hObject, eventdata, handles)
% hObject    handle to movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori imgcropA total Zstart Zend Flist I X Y rot Mark Color
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');
stride=get(handles.Lslider,'Value');
detectionthreshold=get(handles.Dslider,'Value');
overlapthreshold=get(handles.Oslider,'Value');
%Xmax=handles.iminf.dimX;Ymax=handles.iminf.dimY;
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Cmax=handles.cslider.Max;

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
Left=V1;Right=V1+width;Bottom=W1;Top=W1+height;%%

[a name1 c]=fileparts(handles.imgpath);
[a name2 c]=fileparts(handles.cppath);
mov=VideoWriter(strcat(name1,'_', handles.date), 'MPEG-4');
open(mov);

%Flist: カラム座標を全Z座標についてまとめたリスト(1ID, 2 X, 3 Y, 4 Z, 5 Columness, 6 Normal, 7 Gap, 8 Nohole)
Flist=sortrows(Flist,1,'ascend');
Flist=sortrows(Flist,4,'ascend');

figure('Position',[0 900 1000 400]);
for Z=Zstart:Zend
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    if rot~=0
        imgori=rot90(imgori,rot);
    end
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%%
    imgcropA=imadjust(imgcropA,handles.Blim);%
    I=Z-Zstart+1;
    list=Flist(Flist(:,4)==I,:);%list: Z=Iの情報のみ
    total=size(list,1);
    subplot(1,2,1);imshow(imgcropA);title(strcat(name1,' :',name2,' :Z=',num2str(Z), ' :Mag=',num2str(Mag)),'Interpreter','none');
    subplot(1,2,2);imshow(imgcropA);title(strcat('N=',num2str(total),' :Stride=',num2str(stride),' :Detection=',num2str(detectionthreshold),' :Overlap=',num2str(overlapthreshold),' :Brightness=',num2str(Bthreshold)),'Interpreter','none');
    Clist=zeros(1,6);
    if total~=0
        hold on;    
        Clist=list(:,1:6);%Clist(1ID, 2 X, 3 Y, 4 Z, 5 Type (1-3), 6 Likeliness)
        Labels=Clist(:,1);Clist(:,4)=Clist(:,4)*10;
        for I=1:size(Clist,1)
            [Clist(I,6), Clist(I,5)]=max([list(I,6) list(I,7) list(I,8)]);
        end
        for I=1:3
            Slist=Clist(Clist(:,5)==I,:);
            plot(Slist(:,2),Slist(:,3),Mark{I},'MarkerEdgeColor',Color{I});daspect([1 1 1]);
            text(Slist(:,2)+10,Slist(:,3)+6,num2str(Slist(:,1)),'FontUnits','pixels','FontSize',10,'Color',Color{I});%
        end    
        xlim([0 Mag*width+1]);ylim([0 Mag*height+1]);
        set(gca,'Ydir','Reverse');set(gca,'Zdir','Reverse');set(gca,'Color','k');

        hold off;
    end
    writeVideo(mov, getframe(gcf));
end
writeVideo(mov, getframe(gcf));
close(mov);

% --- Executes on button press in ROI.
function ROI_Callback(hObject, eventdata, handles)
% hObject    handle to ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global preW preH X Y Poly
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
set(handles.ROImessage,'String',['Please click ',num2str(Poly),' points to specify a ROI.']);
set(handles.startbutton,'Enable','off');
set(handles.PCA,'Enable','off');
set(handles.eSVM,'Enable','off');
set(handles.save,'Enable','off');
set(handles.movie,'Enable','off');

imgori=imadjust(handles.img,handles.Blim);
axes(handles.main_img);
imshow(imgori);
Xold=X;Yold=Y;
X=zeros(1,Poly);Y=zeros(1,Poly);
hold on;
for I=1:Poly
    set(handles.ROImessage,'String',['Please specify ' num2str(I) '-th point out of ' num2str(Poly)]);
    [x,y]=ginput(1);
    x=round(x);
    y=Ymax-round(y);
    if (x<1)||(x>Xmax)||(y<1)||(y>Ymax)
        break;
    end
    plot(x,Ymax-y+1,'r*');
    X(I)=x;Y(I)=y;
end
hold off;

hex=polyshape(X,Y);
V1=min(X);W1=min(Y);
width=max(X)-min(X);height=max(Y)-min(Y);
if (V1>=1)&&(V1+width<=Xmax)&&(W1>=1)&&(W1+height<=Ymax)&&(size(hex.Vertices,1)==Poly)&&(hex.NumRegions==1)&&(hex.NumHoles==0)
    set(handles.ROImessage,'String','A new ROI was appropriately speficied.');
    axes(handles.main_img);
    imshow(imgori);
    
    hold on;
    patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
    hold off;
    
    set(handles.Xslider1,'Value',V1);
    set(handles.X1value,'String',V1);
    set(handles.Yslider1,'Value',W1);
    set(handles.Y1value,'String',W1);

    Mag=get(handles.Mslider,'Value');
    imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
    [Ycrop Xcrop]=size(imgcrop);
    if Xcrop>preW
        V1=fix((Xcrop-preW)/2)+1;
        imgcrop=imgcrop(:,V1:V1+preW-1);
    end
    if Ycrop>preH
        W1=fix((Ycrop-preH)/2)+1;
        imgcrop=imgcrop(W1:W1+preH-1,:);
    end
    if Xcrop<preW
        imgcrop(:,Xcrop+1:preW)=0;
    end
    if Ycrop<preH
        imgcrop(Ycrop+1:preH,:)=0;
    end
    axes(handles.mag_img);imshow(imgcrop);

else
    set(handles.ROImessage,'String','Invalid ROI (the previous ROI being resumed).');
    X=Xold;Y=Yold;
    axes(handles.main_img);
    imshow(imgori);
    hold on;
    patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
    hold off;   
end
set(handles.startbutton,'Enable','on');
set(handles.PCA,'Enable','off');
set(handles.eSVM,'Enable','off');
set(handles.save,'Enable','off');
set(handles.movie,'Enable','off');

% --- Executes on slider movement.
function Vertex_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Vertex_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Poly
I=round(get(hObject,'Value'));
if I~=Poly
    Poly=I;
    set(handles.Vertex_slider,'Value',Poly);
    set(handles.Vertex_value,'String',Poly);
    set(handles.ROImessage,'String',['Please click ',num2str(Poly),' points to specify a ROI.']);
    set(handles.startbutton,'Enable','off');
    set(handles.save,'Enable','off');
    set(handles.movie,'Enable','off');
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Vertex_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vertex_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in PCA.
function PCA_Callback(hObject, eventdata, handles)
% hObject    handle to PCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Flist Glist FimgsA list imgs Nline Gline Hline coeff coeff2 rot
%Flist(1ID, 2 X, 3 Y, 4 Z, 5 Columness, 6 Normal, 7 Gap, 8 Nohole)
%list(1ID, 2Type (1-3), 3 Normal, 4 Gap, 5 Nohole)
list=Flist;list(:,2:4)=[];
for I=1:size(list,1)
    [a, list(I,2)]=max([list(I,3) list(I,4) list(I,5)]);
end
list=sortrows(list,1,'ascend');
list=sortrows(list,2,'ascend');
Type={'Normal','Gap','Nohole'};

Glist=cell(1);%Glist(1ID, 2Type (1-3), 3 Normal, 4 Gap, 5 Nohole) Typeごとのcell行列
Glist{1}=list(list(:,2)==1,:);%Normalのみのリスト
Glist{2}=list(list(:,2)==2,:);%Gapのみのリスト
Glist{3}=list(list(:,2)==3,:);%Noholeのみのリスト
% Glist{1}=sortrows(list(list(:,2)==1,:),3,'descend');%Normalのみのリスト
% Glist{2}=sortrows(list(list(:,2)==2,:),4,'descend');%Gapのみのリスト
% Glist{3}=sortrows(list(list(:,2)==3,:),5,'descend');%Noholeのみのリスト
Nline=ceil(size(Glist{1},1)/10);Gline=ceil(size(Glist{2},1)/10);Hline=ceil(size(Glist{3},1)/10);
line=Nline+Gline+Hline;
figure('Position',[1000 0 1200 line*100]);
x=9;y=32;h=8;
for NGH=1:3
    for I=1:ceil(size(Glist{NGH},1)/10)
        for J=1:10
            count=(I-1)*10+J;
            if count>size(Glist{NGH},1)
                break;
            end
            subplot(line,10,count+(NGH>1)*Nline*10+(NGH>2)*Gline*10);
            imagesc(FimgsA(:,:,Glist{NGH}(count,1)),[0 255]);colormap gray
            set(gca,'XTick',[]);set(gca,'YTick',[]);title([num2str(Glist{NGH}(count,1)) Type{NGH}]);
            Normal=Glist{NGH}(count,3);Gap=Glist{NGH}(count,4);Nohole=Glist{NGH}(count,5);
            hold on;
            patch([x-8 x-4 x-4 x-8],[y y y-round(Normal*h) y-round(Normal*h)],'r');
            patch([x-4 x x x-4],[y y y-round(Gap*h) y-round(Gap*h)],'g');
            patch([x x+4 x+4 x],[y y y-round(Nohole*h) y-round(Nohole*h)],'b');
            hold off;
        end
    end
end
imgs=zeros(32,32,size(list,1));
for I=1:size(list,1)
    imgs(:,:,list(I,1))=FimgsA(:,:,list(I,1));
end

figure;Color={'r', 'g', 'b'};
subplot(1,2,1);
hold on;
for I=1:3
    scatter3(list(list(:,2)==I,3),list(list(:,2)==I,4),list(list(:,2)==I,5),10,Color{I});
    text(list(list(:,2)==I,3)+0.02,list(list(:,2)==I,4)+0.01,list(list(:,2)==I,5),num2str(list(list(:,2)==I,1)),'Color',Color{I});
end
xlim([0 1]);ylim([0 1]);zlim([0 1]);
set(gca,'Xdir','Normal');set(gca,'Ydir','Normal');set(gca,'Zdir','Normal');
xlabel('Normal');ylabel('Gap');zlabel('Nohole');
hold off;

[coeff,score,latent,tsquared,explained,mu] = pca(list(:,3:5));
N=size(score,1);
coeff2=coeff;coeff2(3,:)=0;
list2=list;
list2(:,3:5)=score*coeff2'+repmat(mu,N,1);

subplot(1,2,2);
hold on;
for I=1:3
    scatter(list2(list2(:,2)==I,3),list2(list2(:,2)==I,4),10,Color{I});
    text(list2(list2(:,2)==I,3)+0.02,list2(list2(:,2)==I,4)+0.01,num2str(list2(list2(:,2)==I,1)),'Color',Color{I});
%     scatter3(list2(list2(:,2)==I,3),list2(list2(:,2)==I,4),list2(list2(:,2)==I,5),10,Color{I});
%     text(list2(list2(:,2)==I,3)+0.02,list2(list2(:,2)==I,4)+0.01,list2(list2(:,2)==I,5),num2str(list2(list2(:,2)==I,1)),'Color',Color{I});
end
xlim([0 1]);ylim([0 1]);zlim([0 1]);
set(gca,'Xdir','Normal');set(gca,'Ydir','Normal');%set(gca,'Zdir','Normal');
xlabel('First');ylabel('Second');%zlabel('Third');
hold off;
set(handles.eSVM,'Enable','on');


% --- Executes on button press in eSVM.
function eSVM_Callback(hObject, eventdata, handles)
% hObject    handle to eSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Flist FimgsA list list2 imgs Glist PDS1
%Flist(1ID, 2 X, 3 Y, 4 Z, 5 Columness, 6 Normal, 7 Gap, 8 Nohole)
%list(1ID, 2Type (1-3), 3 Normal, 4 Gap, 5 Nohole)
list=Flist;list(:,2:4)=[];Mag=20;
for I=1:size(list,1)
    [a, list(I,2)]=max([list(I,3) list(I,4) list(I,5)]);
end
list=sortrows(list,1,'ascend');
list=sortrows(list,2,'ascend');

imgs=zeros(32,32,size(list,1));
for I=1:size(list,1)
    imgs(:,:,list(I,1))=FimgsA(:,:,list(I,1));
end
imgs(1:4,:,:)=0;imgs(29:32,:,:)=0;imgs(:,1:4,:)=0;imgs(:,29:32,:)=0;

disp('PDratio/Smoothness calculation');
Num = size(list,1);%// 画像数の取得
%PDS1(Num,n):n=1 index, n=2 PD ratio, n=3 Smoothness, n=4 Rounghness
PDS1=zeros(Num,4);

%% ループ処理
for I = 1:Num
    Image = imgs(:,:,I);
    Image(1:2,:)=0;Image(31:32,:)=0;Image(:,1:2)=0;Image(:,31:32)=0;
    %% 解像度変更
    Rimg = imresize(Image,Mag,'lanczos3');  %// ランチョス法で解像度を上げている
    
    %% 【正規化】
    Rimg_double = double(Rimg);    %// double型に変換
    RimgMax = max(Rimg(:));%// 最大輝度値を探索
    RimgMax_double = double(RimgMax);%// double型に変換
    %// 正規化処理
    NRimg = Rimg_double./RimgMax_double;%//最大輝度値で全画素の除算

    M=zeros(100);
    for R=1:100   
        for T=1:100
            theta=pi*(T-1)/50;
            X=(R-1)*cos(theta)/100*16*Mag+16*Mag;
            Y=(R-1)*sin(theta)/100*16*Mag+16*Mag;
            M(R,T)=NRimg(ceil(Y),ceil(X));
        end
    end
    
    P=zeros(1,100);
    for R=1:100
%             N=M(R,M(R,:)>0);  %輝度0のピクセルは無視
%             P(R)=sum(N)/size(N,2);
            P(R)=mean(M(R,:));
    end
    [Bmax, Rmax]=max(P);
    [Bmin, Rmin]=min(P(1:Rmax));
    for R=Rmax:100
        if P(R)<0.5
            Rmed=R;
            Bmed=P(R);
            break
        end
    end
    Bstd=std(M(Rmed,:));

    %PDS1(n,Num):n=1 index, n=2 PD ratio, n=3 Smoothness, n=4 Rounghness
    PDS1(I,1) = I;
    PDS1(I,2)=Bmax/Bmin-1;%PD ratio
    if PDS1(I,2)<0
        PDS1(I,2)=0;
    end
    PDS1(I,3)=Bmax;%Smoothness
    PDS1(I,4)=Bstd;%Roughness
end

%list(1ID, 2Type (1-3), 3 Normal, 4 Gap, 5 Nohole)
%list2(1ID, 2Type (1-3), 3 PDratio, 4 Smoothness, 5 Rounghness)
%PDS1(1ID, 2 PDratio, 3 Smoothness, 4 Rounghness)
list2=list;list2(:,3:5)=0;
for I=1:Num
    list2(PDS1(I,1)==list2(:,1),3:5)=PDS1(I,2:4);
end
%CNN-based or PDS-based color coding
for I=1:size(list2,1)
    if list2(I,3)>0.25%PD
        if list2(I,4)>0.5%Smoothness
            list2(I,2)=1;%Normal
        else
            list2(I,2)=2;%Gap
        end
    else
        list2(I,2)=3;%Nohole
    end
end
list2=sortrows(list2,1,'ascend');
list2=sortrows(list2,2,'ascend');

figure('Position',[1200 500 1400 600]);
subplot(1,2,1);Color={'r', 'g', 'b'};
hold on;
for I=1:3
    scatter(list2(list2(:,2)==I,3),list2(list2(:,2)==I,4),10,Color{I});
    text(list2(list2(:,2)==I,3),list2(list2(:,2)==I,4)+0.02,num2str(list2(list2(:,2)==I,1)),'Color',Color{I});
end
plot(0.25*ones(1,11),0:0.1:1,':');
xlim([0 2]);ylim([0 1]);
set(gca,'Xdir','Normal');set(gca,'Ydir','Normal');
xlabel('PDratio');ylabel('Smoothness');title(strcat('Smoothness=',num2str(mean(list2(list2(:,2)~=3,4)))));
hold off;

subplot(1,2,2);Color={'r', 'g', 'b'};
hold on;
for I=1:3
    scatter(list2(list2(:,2)==I,3),list2(list2(:,2)==I,5),10,Color{I});
    text(list2(list2(:,2)==I,3),list2(list2(:,2)==I,5)+0.02,num2str(list2(list2(:,2)==I,1)),'Color',Color{I});
end
xlim([0 2]);ylim([0 1]);
set(gca,'Xdir','Normal');set(gca,'Ydir','Normal');
xlabel('PDratio');ylabel('Roughness');title(strcat('Roughness=',num2str(mean(list2(list2(:,2)==3,5)))));
hold off;

Type={'Normal','Gap','Nohole'};
%list(1ID, 2Type (1-3), 3 Normal, 4 Gap, 5 Nohole)
%list2(1ID, 2Type (1-3), 3 PDratio, 4 Smoothness, 5 Rounghness)
Glist=cell(1);%Glist(1ID, 2Type (1-3), 3 PDratio, 4 Smoothness, 5 Rounghness) Typeごとのcell行列
Glist{1}=list2(list2(:,2)==1,:);%Normalのみのリスト
Glist{2}=list2(list2(:,2)==2,:);%Gapのみのリスト
Glist{3}=list2(list2(:,2)==3,:);%Noholeのみのリスト
Nline=ceil(size(Glist{1},1)/10);Gline=ceil(size(Glist{2},1)/10);Hline=ceil(size(Glist{3},1)/10);
line=Nline+Gline+Hline;
figure('Position',[1000 0 1200 line*100]);
x=9;y=32;h=8;x2=28;
for NGH=1:3
    for I=1:ceil(size(Glist{NGH},1)/10)
        for J=1:10
            count=(I-1)*10+J;
            if count>size(Glist{NGH},1)
                break;
            end
            subplot(line,10,count+(NGH>1)*Nline*10+(NGH>2)*Gline*10);
            imagesc(imgs(:,:,Glist{NGH}(count,1)),[0 255]);colormap gray
            set(gca,'XTick',[]);set(gca,'YTick',[]);
            title([num2str(Glist{NGH}(count,1)) Type{NGH} '/' Type{list2(list2(:,1)==Glist{NGH}(count,1),2)}]);
            
            %list(1ID, 2Type (1-3), 3 Normal, 4 Gap, 5 Nohole)
            %list2(1ID, 2Type (1-3), 3 PDratio, 4 Smoothness, 5 Rounghness)
            PDratio=list2(list2(:,1)==Glist{NGH}(count,1),3);
            Smoothness=list2(list2(:,1)==Glist{NGH}(count,1),4);
            Roughness=list2(list2(:,1)==Glist{NGH}(count,1),5);
            Normal=Glist{NGH}(count,3);
            Gap=Glist{NGH}(count,4);
            Nohole=Glist{NGH}(count,5);
            hold on;
            patch([x-8 x-4 x-4 x-8],[y y y-round(Normal*h) y-round(Normal*h)],'r');
            patch([x-4 x x x-4],[y y y-round(Gap*h) y-round(Gap*h)],'g');
            patch([x x+4 x+4 x],[y y y-round(Nohole*h) y-round(Nohole*h)],'b');
            patch([x2-8 x2-4 x2-4 x2-8],[y y y-round(PDratio*h) y-round(PDratio*h)],'m');
            patch([x2-4 x2 x2 x2-4],[y y y-round(Smoothness*h) y-round(Smoothness*h)],'c');
            patch([x2 x2+4 x2+4 x2],[y y y-round(Roughness*h) y-round(Roughness*h)],'y');
            hold off;
        end
    end
end

set(handles.save,'Enable','on');
