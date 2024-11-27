function varargout = GUI_pendulo(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_pendulo_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_pendulo_OutputFcn, ...
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

function GUI_pendulo_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
global H_P
H_P = handles;
drawFigure()
SetCanvas(0,deg2rad(0))

function varargout = GUI_pendulo_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function drawFigure() 
    global objBase objCarro objBarra objBola
    global xi_Carro xi_Barra 
    global H_P

    
    
    [base1  base2  base3 ] = imread('Res/base_1.png');
    [carro1 carro2 carro3] = imread('Res/carro_1.png');
    [barra1 barra2 barra3] = imread('Res/barra_1.png');
    
    axes(H_P.lienzo);
    
    hold on
    
    objBase  = image(base1, 'AlphaData', base3);
    objCarro = image(carro1, 'AlphaData', carro3);
    % objBarra = image(barra1, 'AlphaData', barra3);
    objBarra = plot([0 0],[0 500],'linewidth',5,'color',[.2 .2 .2]);
    objBola  = plot(0,500,'o','MarkerFaceColor',[.2 .2 .2],'MarkerEdgeColor',[.2 .2 .2],'MarkerSize',10);

    objBase.YData = objBase.YData + 50;
    objBase.YData = objBase.YData - 35;
    objCarro.YData = objCarro.YData - 35;
    objCarro.XData = objCarro.XData + 1506;
    objBarra.XData = objBarra.XData + 1699 ;
    objBola.XData  = objBola.XData + 1699; 

    xi_Carro = objCarro.XData;
    xi_Barra = 1699;

    axis('equal')
    ylim([-500 1250])
    xlim([0 3300])
    %     objBase.ButtonDownFcn = @(~,e) PenduloCallback(app,e.IntersectionPoint);
    imshow([0])

function SetCanvas_GUI(X,T)
    global objCarro objBarra objBola
    global xi_Carro xi_Barra 
    global Xc Tc

    Xc = X;
    Tc = T;

    if(X>0.4)
        X = 0.4;
    elseif(X<-0.4)
        X = -0.4;
    end
    X = X * 2500;
    objCarro.XData = xi_Carro+X;
    objBarra.XData = [ 0    sin(T) ] * 500 + X + xi_Barra;
    objBarra.YData = [ 0   -cos(T) ] * 500;
    objBola.XData =  [      sin(T) ] * 500 + X + xi_Barra;
    objBola.YData =  [     -cos(T) ] * 500;
    drawnow;
