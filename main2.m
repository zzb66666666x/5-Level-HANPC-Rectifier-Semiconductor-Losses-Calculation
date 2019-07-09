%This script calculates the semiconductor losses of a 5-level HANPC rectifier.
%Current ripple and DT are not considered.
%All variables are in the form of SI Unit.

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%For this version,we give the Po and Lo and calculate a specific Alpha.
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%Defining global variables
global data_Es_on_25;
global data_Es_off_25;
global data_Vds_18;
global data_Vsd_18;

%Initializing
name='result2.csv';
file=fopen(name,'w');
fprintf(file,'Switch,f_switch,I_amplitude,Alpha,N_num1,N_num2,Po,P_S_switch_25,P_S_conduct_25,Efficiency,\r\n');

%Configuring the kind of switches and the step of I for interpolation
switch_kind=["1700","3300","SIC1200","SIC1700"];
n=length(switch_kind);
switch_voltage=[1700,3300,1200,1700];
Lo = 16.9e-3;%H
Po = 2e6;

%Enumerating
for i=1:1:1
    %Interpolating
    interpolating(switch_kind(i));
    %Calculating
    for f_switch=900:50:3600%Hz
        for I_amplitude=1:-0.1:0.2%Percentage
            [N_num1,N_num2,Po,P_S_switch_25,P_S_conduct_25,Eta_25,Alpha]=calculation2(f_switch,I_amplitude,Po,switch_voltage(i),Lo);%Angle is converted to radian
            fprintf(file,"%s,%d,%f,%d,%d,%d,%f,%f,%f,%f,\r\n",switch_kind(i),f_switch,I_amplitude,Alpha,N_num1,N_num2,Po,P_S_switch_25,P_S_conduct_25,Eta_25);
        end
    end
end
fclose(file);