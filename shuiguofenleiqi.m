function varargout = shuiguofenleiqi(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 20-Dec-2017 20:24:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @shuiguofenleiqi_OpeningFcn, ...
                   'gui_OutputFcn',  @shuiguofenleiqi_OutputFcn, ...
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


% --- Executes just before shuiguofenleiqi is made visible.
function shuiguofenleiqi_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to shuiguofenleiqi (see VARARGIN)

% Choose default command line output for shuiguofenleiqi
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes shuiguofenleiqi wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axis equal;
axis tight;
axis off;

% --- Outputs from this function are returned to the command line.
function varargout = shuiguofenleiqi_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bt1.
function bt1_Callback(hObject, eventdata, handles)
% hObject    handle to bt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;

[filename,filepath]=uigetfile('dw.bmp','    ');
if ~isequal(filename,0)
path=strcat(filepath,filename);
img=imread(path);
axes(handles.orgim);
imshow(img);
axis equal;
axis tight;
axis off;
end
% --- Executes on button press in bt3.
function bt3_Callback(hObject, eventdata, handles)
% hObject    handle to bt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global jpg;
[filename,filepath]=uiputfile('dw.bmp','');
if ~isequal(filename,0)
path=strcat(filepath,filename);
imwrite(img,path);
end
% --- Executes on button press in bt2.
function bt2_Callback(hObject, eventdata, handles)
% hObject    handle to bt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path;
global img;
delete(path);
imwrite(img,path);

% --- Executes on button press in bt4.
function bt4_Callback(hObject, eventdata, handles)
% hObject    handle to bt4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% --- Executes on button press in bt5.
function bt5_Callback(hObject, eventdata, handles)
% hObject    handle to bt5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
global path;

I2=rgb2gray(img);
BW=im2bw(I2,0.9);
axes(handles.orgim);
imshow(BW);

axis equal;
axis tight;
axis off;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
global path;
I2=rgb2gray(img);    
BW=im2bw(I2,0.9);   
SE=strel('rectangle',[40 30]);   
J2=imopen(BW,SE);               
SE=strel('square',3);       
J=imerode(~J2,SE);            
BW2=(~J2)-J;                 

B = imfill(BW2,'holes');        
B = bwmorph(B,'remove');          
imshow(B);

axis equal;
axis tight;
axis off;


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
global path;

I2=rgb2gray(img);     
BW=im2bw(I2,0.9);     
SE=strel('rectangle',[40 30]);    
J2=imopen(BW,SE);               
SE=strel('square',3);              
J=imerode(~J2,SE);                
BW2=(~J2)-J;                       



B = imfill(BW2,'holes');           
B = bwmorph(B,'remove');       



[Label,num] = bwlabel(B);        
for i = 1 : num
    Area(i) = 0;
end
Label = imfill(Label,'holes');  




HSV = rgb2hsv(img);                

[row,col] = size(Label);           
MeanHue = zeros(1,num);           
    for i = 1 : num
        Hue = zeros(Area(i),1);    
        nPoint = 0;                
        for j = 1 : row
            for k = 1 : col
                if(Label(j,k) == i)
                    nPoint = nPoint + 1;          
                    Hue(nPoint,1) = HSV(j,k,1);    
                end
            end
        end
        
        Hue(:,i) = sort(Hue(:,1));
        for j = floor(nPoint*0.1) : floor(nPoint*0.9)
            MeanHue(i) = MeanHue(i) + Hue(j,1);    
        end
        MeanHue(i) = MeanHue(i) / (0.8*nPoint);   
    end

%regionprops
[L,num]=bwlabel(BW2);                              
stats= regionprops(L, 'ALL');                       %regionprops
for i= 1:num
longth(i)=stats(i).MajorAxisLength;               
width(i)=stats(i).MinorAxisLength;                
end

R2=0;
G2=0;
B2=0;
x=0;
y=0;

for i=1:num
    r(i)=0;
    g(i)=0;
    b(i)=0;
    yuan(i)=longth(i)/width(i);
end


for i=1:num
    for j=(round(stats(i).Centroid(1))-15):(round(stats(i).Centroid(1))+15)
        for k=(round(stats(i).Centroid(2))-15):(round(stats(i).Centroid(2))+15)
            R2=im2double(img(j,k,1));
            G2=im2double(img(j,k,2));
            B2=im2double(img(j,k,3));
            r(i)=r(i)+R2;
            g(i)=g(i)+G2;
            b(i)=b(i)+B2;
        end
    end
    r(i)=r(i)/900;
    g(i)=g(i)/900;
    b(i)=b(i)/900;
end


for i=1:num
    if(stats(i,1).Area>x)
        x=stats(i,1).Area;
    end
end

y=MeanHue(1);
for i=1:num
    if(y>MeanHue(i))
        y=MeanHue(i);
    end
end


axes(handles.orgim);
imshow(img);
hold on;

for i=1:num
    if(MeanHue(i)==y && yuan(i)>1.3 && r(i)>0.7 && g(i)>0.7)
        text(stats(i).Centroid(1),stats(i).Centroid(2),'类别：梨子');
    end
end

for i=1:num
    if(r(i)>0.75 && yuan(i)<1.15  && g(i)<0.4 && b(i)<0.3)
         text(stats(i).Centroid(1),stats(i).Centroid(2),'类别：苹果');
    end
end

for i=1:num
    if(MeanHue(i)<0.6 && yuan(i)<1.25 && r(i)>0.7 &&b(i)>0.1)
        text(stats(i).Centroid(1),stats(i).Centroid(2),'类别：桃子');
    end
end

for i=1:num
    if(MeanHue(i)<0.2 && yuan(i)>1.7)
         text(stats(i).Centroid(1),stats(i).Centroid(2),'类别：香蕉');
    end
end

for i=1:num
    if(MeanHue(i)<0.3 && yuan(i)>1.4&& r(i)<0.8 )
        text(stats(i).Centroid(1)-30,stats(i).Centroid(2)+40,'类别：菠萝');
    end
end

for i=1:num
    if( stats(i,1).Area==x && yuan(i)<1.25&& r(i)<0.4)
        text(stats(i).Centroid(1),stats(i).Centroid(2),'类别：西瓜');
    end
end
axis equal;
axis tight;
axis off;


