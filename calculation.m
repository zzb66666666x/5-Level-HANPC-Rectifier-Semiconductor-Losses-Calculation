function [N_num1,N_num2,P_S_switch_25,P_S_conduct,Eta_25] = calculation(f_switch,I_amplitude,Alpha,switch_voltage,I_step)
% This is a function for calculating the loss.
% We choose to use the SI units.

% The output includes the conduct loss and the switch loss and the efficiency.

% The input includes the frequency of the switch, the amplitude of the
% current(I_amplitude),the type of the switches,the phase of the
% current(Alpha) and a matrix of functions.

%Defining global variables
global Es_on_25
global Es_off_25
global Vds_18
global Vsd_18

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
t = 0:5e-7:Ts;
Usa_ori = Usm * sin(2*pi*fs*t);
Usb_ori = Usm * sin(2*pi*fs*t-2*pi/3);
Usc_ori = Usm * sin(2*pi*fs*t+2*pi/3);
Uadd = (max(Usa_ori,Usb_ori,Usc_ori)+min(Usa_ori,Usb_ori,Usc_ori))/2;
Usa = Usa_ori - Uadd;
Usb = Usb_ori - Uadd;
Usc = Usc_ori - Uadd;

%calculate the carrier wave

[Ua1_1,Ua1_2,Ua2_1,Ua2_2] = CarrierWave(t,T_switch);

%Output Current and Voltage
IL = Iom*sin(2*pi*fs*t+Beta);
Uoa = Uom*sin(2*pi*fs*t-Gamma);
Uob = Uom*sin(2*pi*fs*t-2*pi/3-Gamma);
Uoc = Uom*sin(2*pi*fs*t+2*pi/3-Gamma);
Uog = Upm*sin(2*pi*fs*t+Beta);
UL = Uog - Uoa;
Uooa = Uoa - (min(Uoa,Uob,Uoc)+max(Uoa,Uob,Uoc))/2;
Uoob = Uob - (min(Uoa,Uob,Uoc)+max(Uoa,Uob,Uoc))/2;
Uooc = Uoc - (min(Uoa,Uob,Uoc)+max(Uoa,Uob,Uoc))/2;

%Switching time calculation.
Ka = floor(t/T_switch);%a matrix of all the results of Ka(t)
Ka_1 = floor(2*t/T_switch);
Usa_Input = Ka_1*T_switch/2;
Usa_ori_temp = Usm*sin(2*pi*fs*Usa_Input);
Usb_ori_temp = Usm*sin(2*pi*fs*Usa_Input-2*pi/3);
Usc_ori_temp = Usm*sin(2*pi*fs*Usa_Input+2*pi/3);
Uadd_temp = (max(Usa_ori_temp,Usb_ori_temp,Usc_ori_temp)+min(Usa_ori_temp,Usb_ori_temp,Usc_ori_temp))/2;
Usa_Value_Input = Usa_ori_temp-Uadd_temp;%This is a matrix of all results of Usa(Ka_1(t)*T_switch/2).
Tona_1 = t;%Intialization
Ka_Input = t + T_switch/2;
Ka_Value_Input = floor(Ka_Input/T_switch);%We get the value of Ka(t+Tswitch/2).
%Generate the Tona_1
for pointer = 1:1:length(t) 
    if Usa(pointer)>=0
        Tona_1(pointer)=abs((T_switch*Usa_Value_Input(pointer))/(2*Uam));
    else 
        Tona_1(pointer)=T_switch/2 - abs((T_switch*Usa_Value_Input(pointer))/(2*Uam));
    end 
end
PWMa_1_contrast=t;%Initialization
PWMa_1=t;
PWMa_2_contrast=t;
PWMa_2=t;
for pointer = 1:1:length(t)
    TimeNow = t(pointer);
    if Usa_Value_Input(pointer)>Ua1_1(pointer) && Usa(pointer)>=0
        PWMa_1_contrast_temp1 = 1;
    else
        PWMa_1_contrast_temp1 = 0;
    end 
    if abs(Usa_Value_Input(pointer)) > abs(Ua2_1(pointer)) && Usa(pointer)<0
         PWMa_1_contrast_temp2 = 1;
    else
         PWMa_1_contrast_temp2 = 0;
    end 
    if (2*Ka_Value_Input(pointer)-1)*T_switch/2 - Tona(pointer) + T_switch/2 <= TimeNow && TimeNow <= (2*Ka_Value_Input(pointer)-1)*T_switch/2 + Tona(pointer) + T_switch/2
        PWMa_1_temp1 = 1;
    else
        PWMa_1_temp1 = 0;
    end
    if Usa_Value_Input(pointer)>Ua1_2(pointer) && Usa(pointer)>=0
        PWMa_2_contrast_temp1 = 1;
    else 
        PWMa_2_contrast_temp1 = 0;
    end
    if abs(Usa_Value_Input(pointer)) > abs(Ua2_2(pointer)) && Usa(pointer)<0
        PWMa_2_contrast_temp2 = 1;
    else 
        PWMa_2_contrast_temp2 = 0;
    end
    if TimeNow >= Ka(pointer)*T_switch/2-Tona_1(pointer)+T_switch/2 && TimeNow <= Ka(pointer)*T_switch/2+Tona_1(pointer)+T_switch/2
        PWMa_2_temp1 = 1;
    else
        PWMa_2_temp1 = 0;
    end    
    PWMa_1_contrast(pointer) = PWMa_1_contrast_temp1 + PWMa_1_contrast_temp2;
    PWMa_1(pointer) = PWMa_1_temp1;
    PWMa_2_contrast(pointer) = PWMa_2_contrast_temp1 + PWMa_2_contrast_temp2;
    PWMa_2(pointer) = PWMa_2_temp1;
end
%We finished generating the PWM waves

%Generate the UA











end
