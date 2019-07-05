function [P_S_switch_25,P_S_conduct,Eta_25] = calculation(f_switch,I_amplitude,Alpha,switch_voltage,fit_functions)
% This is a function for calculating the loss.
% We choose to use the SI units.

% The output includes the conduct loss and the switch loss and the efficiency.

% The input includes the frequency of the switch, the amplitude of the
% current(I_amplitude),the type of the switches,the phase of the
% current(Alpha) and a matrix of functions.

% Below is the basic information.
fs = 50; %HZ
%f_switch as input (HZ)
f0 = 2*f_switch; %HZ
V_bus = 15000; %V
f_sample = f0;
Ulrms = 10000; %V
Ts = 1/fs;%s
T0 = 1/f0; %s
Lo = 16.9*e-3;%H
Uprms = Ulrms/(3)^0.5;%V
T_switch = 1/f_switch;%s
T_sample = 1/f_sample;%s
Um = 1;
N_num1 = ceil((V_bus*1.5*0.25)/switch_voltage);%The number of high frequency switches in the right.
N_num2 = ceil((V_bus*1.5*0.5)/switch_voltage);%The number of low frequency switches in the left.
Upm = Uprms * (2)^0.5;%V
Ud = V_bus/2;
Iorms = 115.47*I_amplitude;%A, the I_amplitude is a percentage.
Uorms = (Uprms^2+(2*pi*fs*Iorms*Lo)^2)^0.5;
Po = 3*Uorms*Iorms*cos(Alpha);%W, the Alpha has the unit "rad".
PF = 1;
Uom  = Uorms * (2)^0.5;%V
Uam = 1;
ma = Uom/Ud;
Usm  = Uam * ma;
Iom = (2)^0.5 * Iorms;%A
Gamma = (fs*2*pi)/(f_sample*2);
Beta = Alpha - Gamma;
%NO DT, the DT was supposed to be 4e-6 s.
%NO ripple.


%Below is the mode calculation part.























end
