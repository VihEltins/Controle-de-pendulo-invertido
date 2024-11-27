function varargout = laboratorioControl(varargin)
% restoredefaultpath
% close_system('exemplo_bloco_modelo')
% close_system('exemplo_bloco_Main')
% close_system('exemplo_bloco_Sinal')

close_system(find_system())


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
function ed_painel_gravidade_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ed_painel_cump_haste_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ed_painel_iner_haste_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ed_painel_atrito_carro_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ed_painel_amort_haste_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ed_painel_ang_haste_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ed_painel_massa_carro_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ed_painel_Massa_haste_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ed_painel_tempo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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

O.isRUN = 0;
O.tempo_simulacao = 100;
O.tamano_painel = H.painel_controle.Position(3);
H.painel_controle.Position(1) = - O.tamano_painel+5;
H.ch_examples.Visible = 'off';

addpath('blocos');

axes(H.canvas)

imshow(('imgs/fundo_canvas.png'),'Reduce',0);
hold on

O.txt_time = text(10,720,'0');

O.bloco_controle = criar_bloco_guide('imgs/bloco_controle.png' ,350+40 , 170+40 ,@(a,b)(exemplo_bloco_controle_PID) ,@(a,b)(disp('bloco_controle : BLOCO')));
O.bloco_modelo   = criar_bloco_guide('imgs/bloco_modelo.png'   ,580+256, 170+40 ,@(a,b)(exemplo_bloco_modelo)       ,@(a,b)(disp('bloco_modelo : PLAY')));
O.bloco_sensor   = criar_bloco_guide('imgs/bloco_sensor.png'   ,800-186, 370+90 ,@(a,b)(exemplo_bloco_Sensor)       ,@(a,b)(disp('bloco_sensor : PLAY')));

O.bloco_setpoint = criar_bloco_guide('imgs/setpoint_img.png'   ,20, 246 ,@(a,b)(exemplo_bloco_Sinal),0,false);

[img_run  base2  alpha_img_run   ] = imread('imgs/RUN_img.png');
[img_wait  base2  alpha_img_wait ] = imread('imgs/WAIT_img.png');
[img_stop  base2  alpha_img_stop ] = imread('imgs/STOP_img.png');


O.btn_img_RUN = img_run;
O.btn_img_STOP = img_stop;
O.btn_img_WAIT = img_wait;

O.btn_RUN = image(O.btn_img_RUN, 'AlphaData', alpha_img_run);

O.btn_RUN.XData = O.btn_RUN.XData+1262;
O.btn_RUN.YData = O.btn_RUN.YData+640;
O.btn_RUN.ButtonDownFcn = @(a,b)(btn_RUN_callback(a,b));

function [varout] = criar_bloco_guide(path_img_bloco,X,Y,callback_bloco,callback_play,show_play)

if nargin == 5
  show_play = true;
end

global H 

[base1  base2  base3 ] = imread(path_img_bloco);

bloco_aux = image(base1, 'AlphaData', base3);
bloco_aux.XData = bloco_aux.XData+X;
bloco_aux.YData = bloco_aux.YData+Y;
bloco_aux.ButtonDownFcn = callback_bloco;

varout = {};
varout.bloco = bloco_aux;
if(show_play)
    [img_play  base2  alpha_img_play ] = imread('imgs/play_img.png');
    alpha_img_play = uint16(img_play);
    alpha_img_play = uint8(((alpha_img_play(:,:,1)+alpha_img_play(:,:,2)+alpha_img_play(:,:,3))~=255*3)*255);
    
    bloco_aux_play = image(img_play, 'AlphaData', alpha_img_play);
    bloco_aux_play.XData = bloco_aux_play.XData+X+290;
    bloco_aux_play.YData = bloco_aux_play.YData+Y+72;
    bloco_aux_play.ButtonDownFcn = callback_play;
    
    varout.play  = bloco_aux_play;    
end






function varargout = laboratorioControl_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
function ch_examples_Callback(hObject, eventdata, handles)

function btn_RUN_callback(a,b)
global O H
if(O.isRUN)
    O.isRUN = -1;
    return;
end
O.isRUN = 1;
O.txt_time.String = '0';
disp('RUN simulation')

g  = str2num(H.ed_painel_gravidade.String);
In = str2num(H.ed_painel_iner_haste.String);
M  = str2num(H.ed_painel_massa_carro.String);
m  = str2num(H.ed_painel_Massa_haste.String);
l  = str2num(H.ed_painel_cump_haste.String);
b  = str2num(H.ed_painel_atrito_carro.String);
xi = str2num(H.ed_painel_amort_haste.String);
km = 8;
global MODEL
MODEL = getModel(g ,In,M ,m ,l ,b ,xi,km);
assignin('base','MODEL',MODEL)
cd blocos
drawnow;
load_system('exemplo_bloco_modelo')
%set_param('exemplo_bloco_modelo/MODELO','A','MODEL.A_exp')
%set_param('exemplo_bloco_modelo/MODELO','B','MODEL.B_ctr')
%set_param('exemplo_bloco_modelo/MODELO','C','MODEL.C_aug')
%set_param('exemplo_bloco_modelo/MODELO','D','MODEL.D_aug')
cd ..



drawnow;
O.btn_RUN.CData = O.btn_img_WAIT;
global H_P

try
    ishandle(H_P.figure1);
    SetCanvas(0,0);
    disp 'seteando'
catch
    GUI_pendulo
    disp 'borrado'
end


drawnow;

[T X Y ]= sim('blocos/exemplo_bloco_Main',[0 O.tempo_simulacao]);
whos X
whos Y
O.T = T;
O.X = X;
O.Y = Y;
figure(1);
clf
subplot 311
hold on
grid
plot(T,Y(:,1),'r')
plot(T,Y(:,3),'--')
ylabel('Ângulo [rad] ')
xlabel('Tempo [s]')


subplot 312
hold on
grid
plot(T,Y(:,2),'r')
plot(T,Y(:,4),'--')
ylabel('Deslocamento [m] ')
xlabel('Tempo [s]')
legend('Medida','Desejada');


subplot 313
hold on
grid
plot(T,Y(:,5),'r')
ylabel('Sinal de controle [V] ')
xlabel('Tempo [s]')



X =  Y(:,2);
T = Y(:,1);

O.btn_RUN.CData = O.btn_img_STOP;

disp('RUN SIMULATION')

tic
tcur = toc;
t = length(X)*0.01;
while(tcur<max(t) & O.isRUN ~= -1)

    i = round(tcur/0.01)+1;
    
    SetCanvas((-X(i)),(T(i)));
 
    O.txt_time.String = [num2str(tcur) ' s'];
    
    drawnow

    tcur = toc;
end
toc
disp('END SIMULATION')




O.btn_RUN.CData = O.btn_img_RUN;
disp ('END simulation')
O.isRUN = 0;


function painel_controle_ButtonDownFcn(hObject, eventdata, handles)
global H O
if(H.painel_controle.Position(1) == 0)
    H.painel_controle.Position(1) = - O.tamano_painel+5;
else
    H.painel_controle.Position(1) = 0;
end



function ed_painel_tempo_Callback(hObject, eventdata, handles)
global O
N = validar_ed_guide(hObject,100);
O.tempo_simulacao = N;

function N = validar_ed_guide(hObject,valor_defecto)

N = str2num(hObject.String);

if(length(N)~=0)
    if(N<=0)
        hObject.String = num2str(valor_defecto);
    else
        N = N(1);
    end
    
else
    hObject.String = num2str(valor_defecto);
end



function ed_painel_Massa_haste_Callback(hObject, eventdata, handles)
validar_ed_guide(hObject,0.23);
function ed_painel_massa_carro_Callback(hObject, eventdata, handles)
validar_ed_guide(hObject,2.4);
function ed_painel_cump_haste_Callback(hObject, eventdata, handles)
validar_ed_guide(hObject,0.4);
function ed_painel_iner_haste_Callback(hObject, eventdata, handles)
validar_ed_guide(hObject,0.2);
function ed_painel_atrito_carro_Callback(hObject, eventdata, handles)
validar_ed_guide(hObject,0.05);
function ed_painel_amort_haste_Callback(hObject, eventdata, handles)
validar_ed_guide(hObject,0.099);
function ed_painel_ang_haste_Callback(hObject, eventdata, handles)
validar_ed_guide(hObject,0.2);
function ed_painel_gravidade_Callback(hObject, eventdata, handles)
validar_ed_guide(hObject,9.81);
