%% Parametros y espec. del sistema
%% Carga mecanica

% Momento de inercia con +- 0.1260 [kg.m^2]
Jl = 0.2520;

% Amortiguamiento viscoso con +- 0.063 [(N.m) / (rad/s)]
bl = 0;

% Torque de carga con +- 6.28 [N.m] (asumir escalon)
Tl = 0;
%% Tren de transmision

% Relacion de transmision 
r = 314.3008;

% Velocidad nominal de salida [rpm], wnominal = 2.2 [rad/s]
n = 21;

% Torque nominal de salida [N.m] en regimen continuo
Tq = 7.26;

% Torque pico de salida [N.m], corta duracion, aceleracion
Tq_max = 29.42;

%% Maquina electrica

% Momento de inercia (motor y caja) [kg.m^2]
Jm = 3.1e-6;

% Coef de friccion viscosa [(N.m)/(rad/s)]
bm = 1.5e-5;

% Pares de polos magneticos
Pp = 3;

% Flujo magnetico equivalente [Wb] o [V/(rad/s)]
lambda_m = 0.01546;

% Inductancias del estator [H]
Lq = 5.8e-3;
Ld = 6.6e-3;
L_ls = 0.8e-3;

% Resistencia de estator, por fase [Ohm] (1.02 a 40ºC // 1.32 a 115ºC)
% Rs = linspace(1.02,1.32,5);
Rs = 1.02;
Rref = Rs;

% Coef de aumento de Rs con Ts(t) [1/ºC]
alpha_Cu = 3.9e-3;

% Capacitancia termica del estator [W/(ºC/s)]
Cts = 0.818;

% Resistencia termica estator-ambiente [ºC/W]
Rts_amb = 146.7;
% ctte de tiempo termica [s]
Tauts_amb = Rts_amb * Cts;



% Velocidad nominal del rotor [rpm] con w_m = 691,15 [rad/s]
n_m = 6600;

% Tension nominal de linea [V] (corriente alterna) y tension nominal de fase
Vsl = 24;
Vsf = Vsl/3^(0.5);

% Corriente nominal [A] (corriente alterna) en regimen continuo
Is = 0.4;

% Corriente maxima [A], corta duracion -> aceleracion
Is_max = 2;

% Temperatura maxima del bobinado ºC
Temp_max = 115;



% Rango de temperatura ambiente
T_amb = 40;
Tref = T_amb;
%% Sintesis del subsistema mecanico

beq = bm + (1/r^2) * bl;
Jeq = Jm + (1/r^2) * Jl;
%% Ganancias de los lazos de control de iqd0 en el modulador de torque
% Se busca polo en p = -5000 rad/s (BW = 796Hz)

pos_polo = -5000;
Rq = Lq * -(pos_polo);
Rd = Ld * -(pos_polo);
R0 = L_ls * -(pos_polo);

%% Controlador PID

% Valores dados como consigna
n_pid = 2.5;
w_pos = 800;


Ba = Jeq * n_pid * w_pos;
Ksa = Jeq * n_pid * (w_pos)^2;
Ksia = Jeq * (w_pos)^3;

%% Observador de estado reducido

pos_polo_obs = 3200;
Ke_theta = 2*pos_polo_obs;
Ke_w = pos_polo_obs^2;

%% Observador de estado mejorado

Ke_theta_m = 3*pos_polo_obs;
Ke_w_m = 3*pos_polo_obs^2;
Ke_int = pos_polo_obs^3;
%% 
% 
%% Ancho de banda de sensores

sensor_pos = 2000;
sensor_i = 6000;
sensor_temp = 1/20;