function simulatePendulo(X,T)
try
% 
% app.ed_Signal.Parent.Visible = 'off';
% app.lienzo.BackgroundColor = [1 1 1];
% drawnow;

disp('RUN SIMULATION')

 tic
tcur = toc;
t = length(X)*0.001;
while(tcur<max(t))

    i = round(tcur/0.001)+1;

    SetCanvas((-X(i)),(T(i)));
    drawnow

    tcur = toc;
end
toc
disp('END SIMULATION')
catch
    disp('Error simulando')
    disp('Reiniciando...')
    pause(2)
%     simulatePendulo(X,T)
end