function [Po,N_num1,N_num2,P_S_switch_25,P_S_conduct_25,Eta_25]=calculatingA(Lo,f_switch,I_amplitude,Alpha,switch_voltage)
%This function calculates the semiconductor losses of a 5-level HANPC rectifier for a specific case.
%Current ripple and DT are not considered.
%Linear method is used for interpolation.
%All variables are in the form of SI Units.
%For version A, free variables includes switch_kind (switch_voltage), Lo, f_switch, I_amplitude and Alpha.

%Defining global variables
global data_Es_on_25;
global data_Es_off_25;
global data_Vds_18;
global data_Vsd_18;

%Basic Information
fs=50;%HZ
%Input f_switch (HZ)
f0=2*f_switch;
V_bus=15000;%V
f_sample=f0;
Ulrms=10000;%V
Ts=1/fs;
T0=1/f0;
%Input Lo (H)
Uprms=Ulrms/(3)^0.5;
T_switch=1/f_switch;
T_sample=1/f_sample;
Um=1;%V
N_num1=ceil((V_bus*1.5*0.25)/switch_voltage);%The number of high frequency switches in the right of topology; Input switch_voltage (V)
N_num2=ceil((V_bus*1.5*0.5)/switch_voltage);%The number of low frequency switches in the left of topology; Input switch_voltage (V)
Upm=Uprms*(2)^0.5;
Ud=V_bus/2;
Iorms=115.47*I_amplitude;%A; Input I_amplitude (proportion in decimal)
Uorms=(Uprms^2+(2*pi*fs*Iorms*Lo)^2)^0.5;
Po=3*Uorms*Iorms*cos(Alpha);%W; Input Alpha (radian)
PF=1;
Uom=Uorms*(2)^0.5;
Uam=1;%V
ma=Uom/Ud;
Usm=Uam*ma;
Iom=(2)^0.5*Iorms;
%Input Alpha (radian)
Gamma=(fs*2*pi)/(f_sample*2);
Beta=Alpha-Gamma;
%NO DT
%DT=4e-6;%s
%NO Current ripple
%Current_ripple=1;

%Mode Calculation
t=0:5e-7:Ts;

%Modulation Waveform
Usa_ori=Usm*sin(2*pi*fs*t);
Usb_ori=Usm*sin(2*pi*fs*t-2*pi/3);
Usc_ori=Usm*sin(2*pi*fs*t+2*pi/3);
Uadd = (max(max(Usa_ori,Usb_ori),Usc_ori)+min(min(Usa_ori,Usb_ori),Usc_ori))/2;
Usa = Usa_ori - Uadd;
Usb = Usb_ori - Uadd;
Usc = Usc_ori - Uadd;

%Carrier Waveform
time=mod(t,T_switch);
Ua1_1=(time<T_switch/2).*(2*Uam*time/T_switch)+(time>=T_switch/2).*((-2*Uam*(time-T_switch/2)/T_switch)+Uam);
Ua2_1=Ua1_1-Uam;
Ua1_2=(time<T_switch/2).*(-2*Uam*time/T_switch+Uam)+(time>=T_switch/2).*(2*Uam*(time-T_switch/2)/T_switch);
Ua2_2=Ua1_2-Uam;

%Output Current and Voltage
IL=Iom*sin(2*pi*fs*t+Beta);
Uoa=Uom*sin(2*pi*fs*t-Gamma);
Uob=Uom*sin(2*pi*fs*t-2*pi/3-Gamma);
Uoc=Uom*sin(2*pi*fs*t+2*pi/3-Gamma);
Uog=Upm*sin(2*pi*fs*t+Beta);
UL=Uog-Uoa;
Uooabc=(min(min(Uoa,Uob),Uoc)+max(max(Uoa,Uob),Uoc))/2;
Uooa=Uoa-Uooabc;
Uoob=Uob-Uooabc;
Uooc=Uoc-Uooabc;

%Switching Time Calculation Phase A
Ka=floor(t/T_switch);
Ka_1=floor(2*t/T_switch);

%Usa(Ka_1(t)*T_switch/2)
Usa_Input=Ka_1*T_switch/2;
Usa_ori_temp=Usm*sin(2*pi*fs*Usa_Input);
Usb_ori_temp=Usm*sin(2*pi*fs*Usa_Input-2*pi/3);
Usc_ori_temp=Usm*sin(2*pi*fs*Usa_Input+2*pi/3);
Uadd_temp=(max(max(Usa_ori_temp,Usb_ori_temp),Usc_ori_temp)+min(min(Usa_ori_temp,Usb_ori_temp),Usc_ori_temp))/2;
Usa_Value_Input=Usa_ori_temp-Uadd_temp;

%Ka(t+Tswitch/2)
Ka_Input=t+T_switch/2;
Ka_Value_Input=floor(Ka_Input/T_switch);

Tona_1=(Usa>=0).*abs((T_switch*Usa_Value_Input)/(2*Uam))+(Usa<0).*(T_switch/2-abs((T_switch*Usa_Value_Input)/(2*Uam)));

PWMa_1_contrast=((Usa_Value_Input>Ua1_1)&(Usa>=0))*1+((abs(Usa_Value_Input)>abs(Ua2_1))&(Usa<0))*1;
PWMa_1=(((2*Ka_Value_Input-1)*T_switch/2-Tona_1+ T_switch/2 <= t)&(t<=(2*Ka_Value_Input-1)*T_switch/2+Tona_1+T_switch/2))*1;
PWMa_2_contrast=((Usa_Value_Input>Ua1_2)&(Usa>=0))*1+((abs(Usa_Value_Input)>abs(Ua2_2))&(Usa<0))*1;
PWMa_2=((t>=Ka*T_switch-Tona_1+T_switch/2)&(t<=Ka*T_switch+Tona_1+T_switch/2))*1;

UA=((PWMa_1>0)&(Usa>=0))*Ud/2+((PWMa_2>0)&(Usa>=0))*Ud/2+((PWMa_2<=0)&(Usa<0))*(-Ud/2)+((PWMa_1<=0)&(Usa<0))*(-Ud/2);

%Time to turn on and off for all four low frequency switches, S21, S32, S31, S22
Ta2_1=(2*Ka_Value_Input-1)*T_switch/2-Tona_1+T_switch/2;
Ta3_1=(2*Ka_Value_Input-1)*T_switch/2+Tona_1+T_switch/2;
Ta2_2=Ka*T_switch-Tona_1+T_switch/2;
Ta3_2=Ka*T_switch+Tona_1+T_switch/2;

%No DT Losses
I_temp_Ta21 = Iom*sin(2*pi*fs*Ta2_1+Beta);
I_temp_Ta22 = Iom*sin(2*pi*fs*Ta2_2+Beta);
I_temp_Ta31 = Iom*sin(2*pi*fs*Ta3_1+Beta);
I_temp_Ta32 = Iom*sin(2*pi*fs*Ta3_2+Beta);

I_positive_Ta21=max(I_temp_Ta21,0);
I_negative_Ta21=max(-I_temp_Ta21,0);
I_positive_Ta22=max(I_temp_Ta22,0);
I_negative_Ta22=max(-I_temp_Ta22,0);
I_positive_Ta31=max(I_temp_Ta31,0);
I_negative_Ta31=max(-I_temp_Ta31,0);
I_positive_Ta32=max(I_temp_Ta32,0);
I_negative_Ta32=max(-I_temp_Ta32,0);
I_positive=max(IL,0);%IL=Iom*sin(2*pi*fs*t+Beta);
I_negative=max(-IL,0);

T_deno = Ts * T_switch/5e-7;

P_S21_Eon_25=N_num1 * sum(interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,I_negative_Ta21,'linear','extrap'))/T_deno;
P_S22_Eon_25=N_num1 * sum(interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,I_negative_Ta22,'linear','extrap'))/T_deno;
P_S21_Eoff_25=N_num1 * sum(interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,I_negative_Ta31,'linear','extrap'))/T_deno;
P_S22_Eoff_25=N_num1 * sum(interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,I_negative_Ta32,'linear','extrap'))/T_deno;
P_S32_Eon_25=N_num1 * sum(interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,I_negative_Ta31,'linear','extrap'))/T_deno;
P_S31_Eon_25=N_num1 * sum(interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,I_negative_Ta32,'linear','extrap'))/T_deno;
P_S32_Eoff_25=N_num1 * sum(interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,I_negative_Ta21,'linear','extrap'))/T_deno;
P_S31_Eoff_25=N_num1 * sum(interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,I_negative_Ta22,'linear','extrap'))/T_deno;

P_S21_switch_25 = P_S21_Eon_25 + P_S21_Eoff_25;
P_S32_switch_25 = P_S32_Eon_25 + P_S32_Eoff_25;
P_S22_switch_25 = P_S22_Eon_25 + P_S22_Eoff_25;
P_S31_switch_25 = P_S31_Eon_25 + P_S31_Eoff_25;

P_S21_conduct_25=sum(((Ta2_1<=t)&(t<Ta3_1)).*(fs*N_num1*(I_negative*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_negative,'linear','extrap'))));
P_S21D_conduct_25=sum(((Ta2_1<=t)&(t<Ta3_1)).*(fs*N_num1*(I_positive*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_positive,'linear','extrap'))));
P_S32_conduct_25=sum((~((Ta2_1<=t)&(t<Ta3_1))).*(fs*N_num1*(I_positive*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_positive,'linear','extrap'))));
P_S32D_conduct_25=sum((~((Ta2_1<=t)&(t<Ta3_1))).*(fs*N_num1*(I_negative*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_negative,'linear','extrap'))));
P_S22_conduct_25=sum(((Ta2_2<=t)&(t<Ta3_2)).*(fs*N_num1*(I_negative*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_negative,'linear','extrap'))));
P_S22D_conduct_25=sum(((Ta2_2<=t)&(t<Ta3_2)).*(fs*N_num1*(I_positive*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_positive,'linear','extrap'))));
P_S31_conduct_25=sum((~((Ta2_2<=t)&(t<Ta3_2))).*(fs*N_num1*(I_positive*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_positive,'linear','extrap'))));
P_S31D_conduct_25=sum((~((Ta2_2<=t)&(t<Ta3_2))).*(fs*N_num1*(I_negative*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_negative,'linear','extrap'))));
P_S1Snp2_conduct_25=sum((Usa>=0).*(fs*N_num2*(I_negative*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_negative,'linear','extrap')+I_positive*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_positive,'linear','extrap'))));
P_Snp1S4_conduct_25=sum((Usa<0).*(fs*N_num2*(I_negative*5e-7.*interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_negative,'linear','extrap')+I_positive*5e-7.*interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_positive,'linear','extrap'))));

IL_0=Iom*sin(Beta);
if IL_0 >= 0
    P_S1Snp2Snp1S4_switch_25_temp1=interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,IL_0,'linear','extrap');
else
    P_S1Snp2Snp1S4_switch_25_temp1=interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,-IL_0,'linear','extrap');
end
if Iom*sin(2*pi*fs*Ts/2+Beta)>=0
    P_S1Snp2Snp1S4_switch_25_temp2=interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,max(IL_0,0),'linear','extrap');
else
    P_S1Snp2Snp1S4_switch_25_temp2=interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,max(-IL_0,0),'linear','extrap');
end
P_S1Snp2Snp1S4_switch_25=N_num2/Ts * (P_S1Snp2Snp1S4_switch_25_temp1 + P_S1Snp2Snp1S4_switch_25_temp2);

%Results
P_S_switch_25=P_S21_switch_25+P_S32_switch_25+P_S22_switch_25+P_S31_switch_25+P_S1Snp2Snp1S4_switch_25;
P_S_switch_25=3*P_S_switch_25;
P_S_conduct_25=P_S21_conduct_25+P_S21D_conduct_25+P_S32_conduct_25+P_S32D_conduct_25+P_S22_conduct_25+P_S22D_conduct_25+P_S31_conduct_25+P_S31D_conduct_25+P_S1Snp2_conduct_25+P_Snp1S4_conduct_25;
P_S_conduct_25=3*P_S_conduct_25;
P_Loss_25=P_S_switch_25+P_S_conduct_25;
Eta_25=1-P_Loss_25/Po;

end
