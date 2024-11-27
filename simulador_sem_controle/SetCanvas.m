function SetCanvas(X,T)
    global objCarro objBarra objBola
    global xi_Carro xi_Barra 
    global Xc Tc

    Xc = X;
    Tc = T;

    if(X>0.4*5)
        X = 0.4*5;
    elseif(X<-0.4*5)
        X = -0.4*5;
    end
    X = X * 2500 / 5;
    objCarro.XData = xi_Carro+X;
    objBarra.XData = [ 0    sin(T) ] * 500 + X + xi_Barra;
    objBarra.YData = [ 0   -cos(T) ] * 500;
    objBola.XData =  [      sin(T) ] * 500 + X + xi_Barra;
    objBola.YData =  [     -cos(T) ] * 500;
    drawnow;
