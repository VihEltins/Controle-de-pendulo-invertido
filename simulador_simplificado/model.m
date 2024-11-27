% Parâmetros do sistema
% g, In, M, m, l, b, xi, km
% 9.81, 0.099, 2.4, 0.23, 0.4, 0.05, 0.005, 8

global MODEL
MODEL = {};

clc, close all, clear all;

% Matriz A (5x5)
MODEL.A = [1 0 1.155e-06 -0.0002141 2.276e-05; 
           0.001 1 5.954e-10 -1.071e-07 1.138e-08; 
           0 0 1 0.006513 -0.000664; 
           0 0 0.001 1 -3.32e-07; 
           -0.01901 0 0.001262 -0.2141 0.02276];

% Matriz B (5x1)
MODEL.B = [0.003042;1.521e-06;0;0;3.042];

% Matriz C (2x5)
MODEL.C = [0 1 0 0 0; 0 0 0 -1 0];

% Matriz D (2x1)
MODEL.D = [0; 0];

% Construção da matriz aumentada (A_aug: 7x6)
disp('Matrizes aumentadas')
MODEL.A_aug = [MODEL.A zeros(size(MODEL.A, 1), 2); -MODEL.C zeros(size(MODEL.C, 1), 2)];
MODEL.B_aug = [MODEL.B; zeros(size(MODEL.C, 1), size(MODEL.B, 2))];
MODEL.C_aug = [MODEL.C, zeros(size(MODEL.C, 1), 1)];
MODEL.D_aug = [MODEL.D];

disp('Aa');
disp(MODEL.A_aug)
disp('Bb');
disp(MODEL.B_aug)
disp('Cc');
disp(MODEL.C_aug)
disp('Dd');
disp(MODEL.D_aug)
disp('---');

% Polos desejados (tempo de pico Tp = 2s e sobressinal 10%)
Tp = 4;            % Tempo de pico máximo (em segundos)
OS = 0.02;         % Sobressinal máximo (10%)

% Cálculo do coeficiente de amortecimento (zeta) e frequência natural (wn)
zeta = sqrt(log(OS)^2 / (pi^2 + log(OS)^2));  % Fórmula para zeta
wn = pi / (Tp * sqrt(1 - zeta^2));            % Fórmula para wn

% Polos dominantes
p1 = (-zeta*wn + 1i*wn*sqrt(1-zeta^2))*1
p2 = (-zeta*wn - 1i*wn*sqrt(1-zeta^2))*1

% Polos adicionais (escolhidos para estabilidade)
poles = [p1, p2, -3, -4, -5, -6];  % 6 polos para um sistema aumentado (6 estados)
disp(poles);
poles_2 = [p1, p2, -50, -80, -110, -140]; %polos observador

ctrb_aug = ctrb(MODEL.A_aug, MODEL.B_aug);
rank_ctrb = rank(ctrb_aug);

if rank_ctrb < size(MODEL.A_aug, 1)
    disp('O sistema aumentado não é controlável!');
    disp(MODEL.A_aug);
    disp(MODEL.B_aug);
    disp('---');
else
    disp('O sistema aumentado é controlável!');
    disp(MODEL.A_aug);
    disp(MODEL.B_aug);
    disp('---');
end

%[MODEL.A_ctr, MODEL.B_ctr, MODEL.C_ctr, ~, MODEL.T] = ctrbf(MODEL.A_aug, MODEL.B_aug, MODEL.C_aug);
% A_ctr, B_ctr, C_ctr representam a parte controlável.

%tranformar em controlável, matriz controlabilidade
MODEL.C_ctr = ctrb(MODEL.A_aug, MODEL.B_aug);

%calculo base controlavel
T = orth(MODEL.C_ctr);

%matrizes a e b controlaveis
MODEL.A_ctr = T \ MODEL.A_aug * T;
MODEL.B_ctr = T \ MODEL.B_aug;

Co = ctrb(MODEL.A_ctr, MODEL.B_ctr);
rank_Co = rank(Co);

if rank_Co < size(MODEL.A_ctr, 1)
    disp('O sistema aumentado não é controlável!');
    disp(MODEL.A_ctr);
    disp(MODEL.B_ctr);
    disp('---');
else
    disp('O sistema aumentado é controlável!');
    disp(MODEL.A_ctr);
    disp(MODEL.B_ctr);
    disp('---');
end

K_poles = real(poles); %melhorar os polos 

% Cálculo do ganho K utilizando a função 'acker',14
MODEL.K = (acker(MODEL.A_ctr, MODEL.B_ctr, poles)) / 1e+0;

%MODEL.K1_5 = MODEL.K(1:5);

% Exibição do ganho K
disp('Ganho do controlador K:');
%MODEL.K(1) = MODEL.K(1)
disp(MODEL.K);

% Observador (L) - Definindo polos mais rápidos para o observador
L_poles = 5 * real(poles_2);  % Polos do observador (mais rápidos)
MODEL.L = place(MODEL.A_ctr', MODEL.C_aug', L_poles)';  % Transposto devido ao cálculo dual

% Exibição do ganho do observador L
disp('Ganho do observador L:');
disp(MODEL.L);

% teste dos polos e zeros do sistema em malha fechada
sys_aug = ss(MODEL.A_ctr - (MODEL.B_ctr * MODEL.K), MODEL.B_ctr, MODEL.C_aug, MODEL.D_aug)
MODEL.A_exp = MODEL.A_ctr - (MODEL.B_ctr * MODEL.K);

step(sys_aug)

% zero
zeros_aug = tzero(sys_aug);

%polo
polos_aug = pole(sys_aug);

disp('Zeros do sistema controlado (com K):');
disp(zeros_aug);

disp('Polos do sistema controlado (com K):');
disp(polos_aug);

%Ganho Rastreador

a = (MODEL.A_ctr - (MODEL.B_ctr * MODEL.K))^-1;
b = MODEL.C_aug * a * MODEL.B_ctr;
MODEL.N = (-1/b)/1e+10;

disp('ganho rastreador');
disp(MODEL.N);