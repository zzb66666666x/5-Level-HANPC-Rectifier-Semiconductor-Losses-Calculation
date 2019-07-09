function [N_num1,N_num2,Po,P_S_switch_25,P_S_conduct_25,Eta_25] = test_calculation(f_switch,switch_voltage,I_step)
% This is a function for calculating the loss.
% We choose to use the SI units.

% The output includes the conduct loss and the switch loss and the efficiency.

% The input includes the frequency of the switch, the amplitude of the
% current(I_amplitude),the type of the switches,the phase of the
% current(Alpha) and a matrix of functions.

%Defining global variables
% global Es_on_25;
% global Es_off_25;
% global Vds_18;
% global Vsd_18;

% Below is the basic information.
fs = 50; %HZ
%f_switch as input (HZ)
f0 = 2*f_switch; %HZ
V_bus = 15000; %V
f_sample = f0;
Ulrms = 10000; %V
Ts = 1/fs;%s
T0 = 1/f0; %s
Lo = 16.9e-3;%H
Uprms = Ulrms/(3)^0.5;%V
T_switch = 1/f_switch;%s
T_sample = 1/f_sample;%s
Um = 1;
N_num1 = ceil((V_bus*1.5*0.25)/switch_voltage);%The number of high frequency switches in the right.
N_num2 = ceil((V_bus*1.5*0.5)/switch_voltage);%The number of low frequency switches in the left.
Upm = Uprms * (2)^0.5;%V
Ud = V_bus/2;
Po = 2e6;
Iorms = Po/((3)^0.5 * Ulrms);%A
Uorms = (Uprms^2+(2*pi*fs*Iorms*Lo)^2)^0.5;
PF = 1;
Uom  = Uorms * (2)^0.5;%V
Uam = 1;
ma = Uom/Ud;
Usm  = Uam * ma;
Iom = (2)^0.5 * Iorms;%A
%calculate the phase
Alpha = atan(2*pi*fs*Iorms*Lo/Uprms);
%above: alpha
Gamma = (fs*2*pi)/(f_sample*2);
Beta = Alpha - Gamma;
%NO DT, the DT was supposed to be 4e-6 s.
%NO ripple.


%Below is the mode calculation part.
t = 0:5e-7:Ts;
Usa_ori = Usm * sin(2*pi*fs*t);
Usb_ori = Usm * sin(2*pi*fs*t-2*pi/3);
Usc_ori = Usm * sin(2*pi*fs*t+2*pi/3);
%disp(size(Usa_ori));disp(size(Usb_ori));disp(size(Usc_ori));
Uadd = (max(max(Usa_ori,Usb_ori),Usc_ori)+min(min(Usa_ori,Usb_ori),Usc_ori))/2;
Usa = Usa_ori - Uadd;
Usb = Usb_ori - Uadd;
Usc = Usc_ori - Uadd;
%This is the first check point.
%plot(t,Usa);

%calculate the carrier wave
%[Ua1_1,Ua1_2,Ua2_1,Ua2_2] = CarrierWave(t,T_switch);
% Ua1_1 = t;
% Ua1_2 = t;
% Ua2_1 = t;
% Ua2_2 = t;
% t_range = length(t);
% for i = 1:1:t_range
%    time = mod(t(i),T_switch);
%    if time>=0 && time< T_switch/2
%        temp1 = (2*Uam*time/T_switch);
%        temp2 = (-2*Uam*time/T_switch+Uam);
%        Ua1_1(i) = temp1;
%        Ua1_2(i) = temp2;
%        Ua2_1(i) = temp1 - Uam;
%        Ua2_2(i) = temp2 - Uam;
%    elseif time>=T_switch/2 && time<T_switch
%        temp1 = (-2*Uam*(time-T_switch/2)/T_switch) + Uam;
%        temp2 = (2*Uam*(time-T_switch/2)/T_switch); 
%        Ua1_1(i) = temp1;
%        Ua2_1(i) = temp1 - Uam;
%        Ua1_2(i) = temp2;
%        Ua2_2(i) = temp2 - Uam;
%    end
% end
time=mod(t,T_switch);
Ua1_1=(time<T_switch/2).*(2*Uam*time/T_switch)+(time>=T_switch/2).*((-2*Uam*(time-T_switch/2)/T_switch)+Uam);
Ua2_1=Ua1_1-Uam;
Ua1_2=(time<T_switch/2).*(-2*Uam*time/T_switch+Uam)+(time>=T_switch/2).*(2*Uam*(time-T_switch/2)/T_switch);
Ua2_2=Ua1_2-Uam;
%This is the second check point.
%plot(t,Ua1_2,t,Ua2_2,t,Usa);

%Output Current and Voltage
IL = Iom*sin(2*pi*fs*t+Beta);
Uoa = Uom*sin(2*pi*fs*t-Gamma);
Uob = Uom*sin(2*pi*fs*t-2*pi/3-Gamma);
Uoc = Uom*sin(2*pi*fs*t+2*pi/3-Gamma);
Uog = Upm*sin(2*pi*fs*t+Beta);
UL = Uog - Uoa;
Uooabc = (min(min(Uoa,Uob),Uoc)+max(max(Uoa,Uob),Uoc))/2;
Uooa = Uoa - Uooabc;
Uoob = Uob - Uooabc;
Uooc = Uoc - Uooabc;

%Switching time calculation.
Ka = floor(t/T_switch);%a matrix of all the results of Ka(t)
Ka_1 = floor(2*t/T_switch);
Usa_Input = Ka_1*T_switch/2;
Usa_ori_temp = Usm*sin(2*pi*fs*Usa_Input);
Usb_ori_temp = Usm*sin(2*pi*fs*Usa_Input-2*pi/3);
Usc_ori_temp = Usm*sin(2*pi*fs*Usa_Input+2*pi/3);
Uadd_temp = (max(max(Usa_ori_temp,Usb_ori_temp),Usc_ori_temp)+min(min(Usa_ori_temp,Usb_ori_temp),Usc_ori_temp))/2;
Usa_Value_Input = Usa_ori_temp-Uadd_temp;%This is a matrix of all results of Usa(Ka_1(t)*T_switch/2).
%This is the third check point.
%plot(t,Usa_Value_Input);

%Tona_1 = t;%Intialization
Ka_Input = t + T_switch/2;
Ka_Value_Input = floor(Ka_Input/T_switch);%We get the value of Ka(t+Tswitch/2).
%Generate the Tona_1
% for pointer = 1:1:length(t) 
%     if Usa(pointer)>=0
%         Tona_1(pointer)=abs((T_switch*Usa_Value_Input(pointer))/(2*Uam));
%     else 
%         Tona_1(pointer)=T_switch/2 - abs((T_switch*Usa_Value_Input(pointer))/(2*Uam));
%     end 
% end
Tona_1=(Usa>=0).*abs((T_switch*Usa_Value_Input)/(2*Uam))+(Usa<0).*(T_switch/2-abs((T_switch*Usa_Value_Input)/(2*Uam)));

% PWMa_1_contrast=t;%Initialization
% PWMa_1=t;
% PWMa_2_contrast=t;
% PWMa_2=t;
% for pointer = 1:1:length(t)
%     TimeNow = t(pointer);
%     if Usa_Value_Input(pointer)>Ua1_1(pointer) && Usa(pointer)>=0
%         PWMa_1_contrast_temp1 = 1;
%     else
%         PWMa_1_contrast_temp1 = 0;
%     end 
%     if abs(Usa_Value_Input(pointer)) > abs(Ua2_1(pointer)) && Usa(pointer)<0
%          PWMa_1_contrast_temp2 = 1;
%     else
%          PWMa_1_contrast_temp2 = 0;
%     end 
%     if (2*Ka_Value_Input(pointer)-1)*T_switch/2 - Tona_1(pointer) + T_switch/2 <= TimeNow && TimeNow <= (2*Ka_Value_Input(pointer)-1)*T_switch/2 + Tona_1(pointer) + T_switch/2
%         PWMa_1_temp1 = 1;
%     else
%         PWMa_1_temp1 = 0;
%     end
%     if Usa_Value_Input(pointer)>Ua1_2(pointer) && Usa(pointer)>=0
%         PWMa_2_contrast_temp1 = 1;
%     else 
%         PWMa_2_contrast_temp1 = 0;
%     end
%     if abs(Usa_Value_Input(pointer)) > abs(Ua2_2(pointer)) && Usa(pointer)<0
%         PWMa_2_contrast_temp2 = 1;
%     else 
%         PWMa_2_contrast_temp2 = 0;
%     end
%     if TimeNow >= Ka(pointer)*T_switch-Tona_1(pointer)+T_switch/2 && TimeNow <= Ka(pointer)*T_switch+Tona_1(pointer)+T_switch/2
%         PWMa_2_temp1 = 1;
%     else
%         PWMa_2_temp1 = 0;
%     end    
%     PWMa_1_contrast(pointer) = PWMa_1_contrast_temp1 + PWMa_1_contrast_temp2;
%     PWMa_1(pointer) = PWMa_1_temp1;
%     PWMa_2_contrast(pointer) = PWMa_2_contrast_temp1 + PWMa_2_contrast_temp2;
%     PWMa_2(pointer) = PWMa_2_temp1;
% end
PWMa_1_contrast=((Usa_Value_Input>Ua1_1)&(Usa>=0))*1+((abs(Usa_Value_Input)>abs(Ua2_1))&(Usa<0))*1;
PWMa_1=(((2*Ka_Value_Input-1)*T_switch/2-Tona_1+ T_switch/2 <= t)&(t<=(2*Ka_Value_Input-1)*T_switch/2+Tona_1+T_switch/2))*1;
PWMa_2_contrast=((Usa_Value_Input>Ua1_2)&(Usa>=0))*1+((abs(Usa_Value_Input)>abs(Ua2_2))&(Usa<0))*1;
PWMa_2=((t>=Ka*T_switch-Tona_1+T_switch/2)&(t<=Ka*T_switch+Tona_1+T_switch/2))*1;
%We finished generating the PWM waves

%Generate the UA
% UA = t;
% for pointer = 1:1:length(t)
%     if PWMa_1(pointer)>0 && Usa(pointer)>=0
%         UA_temp1 = Ud/2;
%     else
%         UA_temp1 = 0;
%     end 
%     if PWMa_2(pointer)>0 && Usa(pointer)>=0
%         UA_temp2 = Ud/2;
%     else
%         UA_temp2 = 0;
%     end 
%     if PWMa_2(pointer)<=0 && Usa(pointer)< 0
%         UA_temp3 = -Ud/2;
%     else
%         UA_temp3 = 0;
%     end     
%     if PWMa_1(pointer)<=0 && Usa(pointer)<0
%         UA_temp4 = -Ud/2;
%     else
%         UA_temp4 = 0;
%     end 
%     UA(pointer) = UA_temp1 + UA_temp2 + UA_temp3 + UA_temp4;
% end
UA=((PWMa_1>0)&(Usa>=0))*Ud/2+((PWMa_2>0)&(Usa>=0))*Ud/2+((PWMa_2<=0)&(Usa<0))*(-Ud/2)+((PWMa_1<=0)&(Usa<0))*(-Ud/2);
%We finished generating the UA(t)
%This is the forth check point;
%plot(t,UA);

%Then we calculate the time of turning on and off for all the four low
%frequency switches.They are S21, S32, S31, S22.
Ta2_1 = (2*Ka_Value_Input-1)*T_switch/2 - Tona_1 + T_switch/2;
Ta3_1 = (2*Ka_Value_Input-1)*T_switch/2 + Tona_1 + T_switch/2;
Ta2_2 = Ka*T_switch-Tona_1 + T_switch/2;
Ta3_2 = Ka*T_switch+Tona_1 + T_switch/2;
%Finished calculating the time needed.
%Calculate the loss. Note: IL = Iom*sin(2*pi*fs*t+Beta);
I_temp_Ta21 = Iom*sin(2*pi*fs*Ta2_1+Beta);
I_temp_Ta22 = Iom*sin(2*pi*fs*Ta2_2+Beta);
I_temp_Ta31 = Iom*sin(2*pi*fs*Ta3_1+Beta);
I_temp_Ta32 = Iom*sin(2*pi*fs*Ta3_2+Beta);
% %Intialize the I_positive and the I_negative.
% I_positive_Ta31 = I_temp_Ta31;
% I_positive_Ta32 = I_temp_Ta32;
% I_positive_Ta21 = I_temp_Ta21;
% I_positive_Ta22 = I_temp_Ta22;
% I_negative_Ta21 = I_temp_Ta21;
% I_negative_Ta22 = I_temp_Ta22;
% I_negative_Ta31 = I_temp_Ta31;
% I_negative_Ta32 = I_temp_Ta32;
% I_positive = IL;
% I_negative = IL;
% for pointer = 1:1:length(t)
%     if I_temp_Ta21(pointer)>0
%         I_positive_Ta21(pointer) = I_temp_Ta21(pointer);
%         I_negative_Ta21(pointer) = 0;
%     elseif I_temp_Ta21(pointer)<0
%         I_positive_Ta21(pointer) = 0;
%         I_negative_Ta21(pointer) = -I_temp_Ta21(pointer);
%     end
%     if I_temp_Ta22(pointer)>0
%         I_positive_Ta22(pointer) = I_temp_Ta22(pointer);
%         I_negative_Ta22(pointer) = 0;
%     elseif I_temp_Ta22(pointer)<0
%         I_positive_Ta22(pointer) = 0;
%         I_negative_Ta22(pointer) = -I_temp_Ta22(pointer);
%     end
%     if I_temp_Ta31(pointer)>0
%         I_positive_Ta31(pointer) = I_temp_Ta31(pointer);
%         I_negative_Ta31(pointer) = 0;
%     elseif I_temp_Ta31(pointer)<0
%         I_positive_Ta31(pointer) = 0;
%         I_negative_Ta31(pointer) = -I_temp_Ta31(pointer);
%     end
%     if I_temp_Ta32(pointer)>0
%         I_positive_Ta32(pointer) = I_temp_Ta32(pointer);
%         I_negative_Ta32(pointer) = 0;
%     elseif I_temp_Ta32(pointer)<0
%         I_positive_Ta32(pointer) = 0;
%         I_negative_Ta32(pointer) = -I_temp_Ta32(pointer);
%     end
%     if IL(pointer)>0
%         I_positive(pointer) = IL(pointer);
%         I_negative(pointer) = 0;
%     elseif IL(pointer)<0
%         I_positive(pointer) = 0;
%         I_negative(pointer) = -IL(pointer);
%     end
% end
I_positive_Ta21=max(I_temp_Ta21,0);
I_negative_Ta21=max(-I_temp_Ta21,0);
I_positive_Ta22=max(I_temp_Ta22,0);
I_negative_Ta22=max(-I_temp_Ta22,0);
I_positive_Ta31=max(I_temp_Ta31,0);
I_negative_Ta31=max(-I_temp_Ta31,0);
I_positive_Ta32=max(I_temp_Ta32,0);
I_negative_Ta32=max(-I_temp_Ta32,0);
I_positive=max(IL,0);
I_negative=max(-IL,0);

T_deno = Ts * T_switch/5e-7;

%Defining global variables
global data_Es_on_25;
global data_Es_off_25;
global data_Vds_18;
global data_Vsd_18;

P_S21_Eon_25=N_num1 * sum(interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,I_negative_Ta21,'lienar','extrap'))/T_deno;
P_S22_Eon_25=N_num1 * sum(interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,I_negative_Ta22,'lienar','extrap'))/T_deno;
P_S21_Eoff_25=N_num1 * sum(interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,I_negative_Ta31,'lienar','extrap'))/T_deno;
P_S22_Eoff_25=N_num1 * sum(interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,I_negative_Ta32,'lienar','extrap'))/T_deno;
P_S32_Eon_25=N_num1 * sum(interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,I_negative_Ta31,'lienar','extrap'))/T_deno;
P_S31_Eon_25=N_num1 * sum(interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,I_negative_Ta32,'lienar','extrap'))/T_deno;
P_S32_Eoff_25=N_num1 * sum(interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,I_negative_Ta21,'lienar','extrap'))/T_deno;
P_S31_Eoff_25=N_num1 * sum(interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,I_negative_Ta22,'lienar','extrap'))/T_deno;
% P_S21_Eon_25 = N_num1 * sum(Es_on_25(round(I_negative_Ta21/I_step)+1))/T_deno;
% P_S22_Eon_25 = N_num1 * sum(Es_on_25(round(I_negative_Ta22/I_step)+1))/T_deno;
% P_S21_Eoff_25 = N_num1 * sum(Es_off_25(round(I_negative_Ta31/I_step)+1))/T_deno;
% P_S22_Eoff_25 = N_num1 * sum(Es_off_25(round(I_negative_Ta32/I_step)+1))/T_deno;
% P_S32_Eon_25 = N_num1 * sum(Es_on_25(round(I_positive_Ta31/I_step)+1))/T_deno;
% P_S31_Eon_25 = N_num1 * sum(Es_on_25(round(I_positive_Ta32/I_step)+1))/T_deno;
% P_S32_Eoff_25 = N_num1 * sum(Es_off_25(round(I_positive_Ta21/I_step)+1))/T_deno;
% P_S31_Eoff_25 = N_num1 * sum(Es_off_25(round(I_positive_Ta22/I_step)+1))/T_deno;

P_S21_switch_25 = P_S21_Eon_25 + P_S21_Eoff_25;
P_S32_switch_25 = P_S32_Eon_25 + P_S32_Eoff_25;
P_S22_switch_25 = P_S22_Eon_25 + P_S22_Eoff_25;
P_S31_switch_25 = P_S31_Eon_25 + P_S31_Eoff_25;

% %Innitialize the conduct loss.
% P_S21_conduct_25 = 0;
% P_S21D_conduct_25 = 0;
% P_S32_conduct_25 = 0;
% P_S32D_conduct_25 = 0;
% P_S22_conduct_25 = 0;
% P_S22D_conduct_25 = 0;
% P_S31_conduct_25 = 0;
% P_S31D_conduct_25 = 0;
% %Inititialize the loss of the low frequency region.
% P_S1Snp2_conduct_25 = 0;
% P_S1Snp2Snp1S4_switch_25 = 0;
% P_Snp1S4_conduct_25 = 0;

% for pointer = 1:1:length(t)
%    TimeNow = t(pointer);
%    if Ta2_1(pointer) <= TimeNow && TimeNow< Ta3_1(pointer)
%        P_S21_conduct_25 = P_S21_conduct_25 + fs*N_num1*(I_negative(pointer)*5e-7*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_negative(pointer),'lienar','extrap'));
%        P_S21D_conduct_25 = P_S21D_conduct_25 + fs*N_num1*(I_positive(pointer)*5e-7*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_positive(pointer),'lienar','extrap'));
%        %P_S21_conduct_25 = P_S21_conduct_25 + fs*N_num1*(I_negative(pointer)*5e-7*Vds_18(round(I_negative(pointer)/I_step)+1));
%        %P_S21D_conduct_25 = P_S21D_conduct_25 + fs*N_num1*(I_positive(pointer)*5e-7*Vsd_18(round(I_positive(pointer)/I_step)+1));
%    else
%        P_S32_conduct_25 = P_S32_conduct_25 + fs*N_num1*(I_positive(pointer)*5e-7*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_positive(pointer),'lienar','extrap'));
%        P_S32D_conduct_25 = P_S32D_conduct_25 + fs*N_num1*(I_negative(pointer)*5e-7*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_negative(pointer),'lienar','extrap'));
%        %P_S32_conduct_25 = P_S32_conduct_25 + fs*N_num1*(I_positive(pointer)*5e-7*Vds_18(round(I_positive(pointer)/I_step)+1));
%        %P_S32D_conduct_25 = P_S32D_conduct_25 + fs*N_num1*(I_negative(pointer)*5e-7*Vsd_18(round(I_negative(pointer)/I_step)+1));       
%    end
%    if Ta2_2(pointer) <= TimeNow && TimeNow< Ta3_2(pointer)
%        P_S22_conduct_25 = P_S22_conduct_25 + fs*N_num1*(I_negative(pointer)*5e-7*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_negative(pointer),'lienar','extrap'));
%        P_S22D_conduct_25 = P_S22D_conduct_25 + fs*N_num1*(I_positive(pointer)*5e-7*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_positive(pointer),'lienar','extrap'));      
%        %P_S22_conduct_25 = P_S22_conduct_25 + fs*N_num1*(I_negative(pointer)*5e-7*Vds_18(round(I_negative(pointer)/I_step)+1));
%        %P_S22D_conduct_25 = P_S22D_conduct_25 + fs*N_num1*(I_positive(pointer)*5e-7*Vsd_18(round(I_positive(pointer)/I_step)+1));
%    else
%        P_S31_conduct_25 = P_S31_conduct_25 + fs*N_num1*(I_positive(pointer)*5e-7*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_positive(pointer),'lienar','extrap'));
%        P_S31D_conduct_25 = P_S31D_conduct_25 + fs*N_num1*(I_negative(pointer)*5e-7*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_negative(pointer),'lienar','extrap'));
%        %P_S31_conduct_25 = P_S31_conduct_25 + fs*N_num1*(I_positive(pointer)*5e-7*Vds_18(round(I_positive(pointer)/I_step)+1));
%        %P_S31D_conduct_25 = P_S31D_conduct_25 + fs*N_num1*(I_negative(pointer)*5e-7*Vsd_18(round(I_negative(pointer)/I_step)+1));       
%    end   
%    if Usa(pointer)>=0
%        P_S1Snp2_conduct_25 = P_S1Snp2_conduct_25 + fs*N_num2 * (I_negative(pointer)*5e-7*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_negative(pointer),'lienar','extrap')+I_positive(pointer)*5e-7*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_positive(pointer),'lienar','extrap'));
%        %P_S1Snp2_conduct_25 = P_S1Snp2_conduct_25 + fs*N_num2 * (I_negative(pointer)*5e-7*Vds_18(round(I_negative(pointer)/I_step)+1)+I_positive(pointer)*5e-7*Vsd_18(round(I_positive(pointer)/I_step)+1));
%    else
%        P_Snp1S4_conduct_25 = P_Snp1S4_conduct_25 + fs*N_num2 * (I_negative(pointer)*5e-7*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_negative(pointer),'lienar','extrap')+I_positive(pointer)*5e-7*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_positive(pointer),'lienar','extrap'));
%        %P_Snp1S4_conduct_25 = P_Snp1S4_conduct_25 + fs*N_num2 * (I_negative(pointer)*5e-7*Vsd_18(round(I_negative(pointer)/I_step)+1)+I_positive(pointer)*5e-7*Vds_18(round(I_positive(pointer)/I_step)+1));
%    end
% end
P_S21_conduct_25=sum(((Ta2_1<=t)&(t<Ta3_1)).*(fs*N_num1*(I_negative*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_negative,'lienar','extrap'))));
P_S21D_conduct_25=sum(((Ta2_1<=t)&(t<Ta3_1)).*(fs*N_num1*(I_positive*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_positive,'lienar','extrap'))));
P_S32_conduct_25=sum((~((Ta2_1<=t)&(t<Ta3_1))).*(fs*N_num1*(I_positive*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_positive,'lienar','extrap'))));
P_S32D_conduct_25=sum((~((Ta2_1<=t)&(t<Ta3_1))).*(fs*N_num1*(I_negative*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_negative,'lienar','extrap'))));
P_S22_conduct_25=sum(((Ta2_2<=t)&(t<Ta3_2)).*(fs*N_num1*(I_negative*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_negative,'lienar','extrap'))));
P_S22D_conduct_25=sum(((Ta2_2<=t)&(t<Ta3_2)).*(fs*N_num1*(I_positive*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_positive,'lienar','extrap'))));
P_S31_conduct_25=sum((~((Ta2_2<=t)&(t<Ta3_2))).*(fs*N_num1*(I_positive*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_positive,'lienar','extrap'))));
P_S31D_conduct_25=sum((~((Ta2_2<=t)&(t<Ta3_2))).*(fs*N_num1*(I_negative*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_negative,'lienar','extrap'))));
P_S1Snp2_conduct_25=sum((Usa>=0).*(fs*N_num2*(I_negative*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_negative,'lienar','extrap')+I_positive*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_positive,'lienar','extrap'))));
P_Snp1S4_conduct_25=sum((Usa<0).*(fs*N_num2*(I_negative*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_negative,'lienar','extrap')+I_positive*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_positive,'lienar','extrap'))));

IL_0=Iom*sin(Beta);
if IL_0 >= 0
    P_S1Snp2Snp1S4_switch_25_temp1 = interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,IL_0,'lienar','extrap');
    %P_S1Snp2Snp1S4_switch_25_temp1 = Es_off_25(round(Iom*sin(Beta)/I_step)+1);
else
    P_S1Snp2Snp1S4_switch_25_temp1 = interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,-IL_0,'lienar','extrap');
    %P_S1Snp2Snp1S4_switch_25_temp1 = Es_on_25(round(-Iom*sin(Beta)/I_step)+1);
end
if Iom*sin(2*pi*fs*Ts/2+Beta)>=0
%     if Iom*sin(Beta) >= 0
%         I_positive_0 = Iom*sin(Beta);
%     else
%         I_positive_0 = 0;
%     end
%     I_positive_0=max(IL_0,0);
    P_S1Snp2Snp1S4_switch_25_temp2 = interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,max(IL_0,0),'lienar','extrap');
    %P_S1Snp2Snp1S4_switch_25_temp2 = Es_on_25(round(I_positive_0/I_step)+1);
else
%     if Iom*sin(Beta) < 0
%         I_negative_0 = -Iom*sin(Beta);
%     else
%         I_negative_0 = 0;
%     end
%     I_negative_0=max(-IL_0,0);
    P_S1Snp2Snp1S4_switch_25_temp2 = interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,max(-IL_0,0),'lienar','extrap');
    %P_S1Snp2Snp1S4_switch_25_temp2 = Es_off_25(round(I_negative_0/I_step)+1);
end
P_S1Snp2Snp1S4_switch_25 = N_num2/Ts * (P_S1Snp2Snp1S4_switch_25_temp1 + P_S1Snp2Snp1S4_switch_25_temp2);

%Get the final output
P_S_switch_25 = P_S21_switch_25 + P_S32_switch_25 + P_S22_switch_25 + P_S31_switch_25 + P_S1Snp2Snp1S4_switch_25;
P_S_switch_25 = 3*P_S_switch_25;
P_S_conduct_25 = P_S21_conduct_25 + P_S21D_conduct_25 + P_S32_conduct_25 + P_S32D_conduct_25 + P_S22_conduct_25 + P_S22D_conduct_25 + P_S31_conduct_25 + P_S31D_conduct_25 + P_S1Snp2_conduct_25 + P_Snp1S4_conduct_25;
P_S_conduct_25 = 3*P_S_conduct_25;
P_Loss_25 = P_S_switch_25 + P_S_conduct_25;
Eta_25 = 1- P_Loss_25/Po;

end
