function varargout = laboratorioControl(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @laboratorioControl_OpeningFcn, ...
                   'gui_OutputFcn',  @laboratorioControl_OutputFcn, ...
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

function laboratorioControl_OpeningFcn(hObject, eventdata, handles, varargin)

global H O
H = handles;
O = {};

handles.output = hObject;
guidata(hObject, handles);

carregar_variaveis_guide();



function carregar_variaveis_guide()

global H O

H.ch_examples.Visible = 'off';

addpath('blocos');

axes(H.canvas)
imshow('imgs/fundo_canvas.png');
hold on
O.bloco_controle = criar_bloco_guide('imgs/bloco_controle.png',350,170 ,@(a,b)(abrir_bloco_controle(a,b)),@(a,b)(testar_bloco_controle(a,b)));
O.bloco_sendsor  = criar_bloco_guide('imgs/bloco_sensor.png'  ,580,370 ,@(a,b)(disp('bloco_sensor : BLOCO')),@(a,b)(disp('bloco_sensor : PLAY')));
O.bloco_modelo   = criar_bloco_guide('imgs/bloco_modelo.png'  ,800,170 ,@(a,b)(disp('bloco_modelo : BLOCO')),@(a,b)(disp('bloco_modelo : PLAY')));



function [varout] = criar_bloco_guide(path_img_bloco,X,Y,callback_bloco,callback_play)
global H 
[base1  base2  base3 ] = imread(path_img_bloco);

[img_play  base2  alpha_img_play ] = imread('imgs/play_img.png');
alpha_img_play = uint16(img_play);
alpha_img_play = uint8(((alpha_img_play(:,:,1)+alpha_img_play(:,:,2)+alpha_img_play(:,:,3))~=255*3)*255);

bloco_aux = image(base1, 'AlphaData', base3);
bloco_aux.XData = bloco_aux.XData+X;
bloco_aux.YData = bloco_aux.YData+Y;
bloco_aux.ButtonDownFcn = callback_bloco;

bloco_aux_play = image(img_play, 'AlphaData', alpha_img_play);
bloco_aux_play.XData = bloco_aux_play.XData+X+290;
bloco_aux_play.YData = bloco_aux_play.YData+Y+72;
bloco_aux_play.ButtonDownFcn = callback_play;

varout = {};
varout.bloco = bloco_aux;
varout.play  = bloco_aux_play;


function abrir_bloco_controle(a,b)

global H
if(H.ch_examples.Value)
    exemplo_bloco_Controle
else
    bloco_Controle
end

function testar_bloco_controle(a,b)

global H
disp  'Testando bloco de controle';


function varargout = laboratorioControl_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function btn_testar_modelo_Callback(hObject, eventdata, handles)


function btn_testar_controle_Callback(hObject, eventdata, handles)

function ch_examples_Callback(hObject, eventdata, handles)


% --- Executes on button press in btn_testar_sensor.
function btn_testar_sensor_Callback(hObject, eventdata, handles)
% hObject    handle to btn_testar_sensor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
