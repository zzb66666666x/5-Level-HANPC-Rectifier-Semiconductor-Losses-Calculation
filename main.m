%This script calculates the semiconductor losses of a 5-level HANPC rectifier.
%Current ripple and DT are not considered.
%All variables are in the form of SI Unit.

%Defining global variables
global Es_on_25;
global Es_off_25;
global Vds_18;
global Vsd_18;

%Initializing
name='result.csv';
file=fopen(name,'w');
fprintf(file,'Switch,f_switch,I_amplitude,Alpha,N_num1,N_num2,P_S_switch_25,P_S_conduct_25,Eta_25,\r\n');

%Configuring the kind of switches and the step of I for interpolation
switch_kind=["1700","3300","SIC1200","SIC1700"];
n=length(switch_kind);
switch_voltage=[1700,3300,1200,1700];
I_step=1;%A

%Enumerating
for i=1:1:n
    %Interpolating
    interpolating(switch_kind(i),I_step);
    %Calculating
    for f_switch=900:50:3600%Hz
        for I_amplitude=1:-0.1:0.2%Percentage
            for Alpha=-10:1:10%Angle, but radian is required by calculation.m
                [N_num1,N_num2,P_S_switch_25,P_S_conduct_25,Eta_25]=calculation(f_switch,I_amplitude,Alpha/180*pi,switch_voltage(i),I_step);%Angle is converted to radian
                fprintf(file,"%s,%d,%f,%d,%d,%d,%f,%f,%f,\r\n",switch_kind(i),f_switch,I_amplitude,Alpha,N_num1,N_num2,P_S_switch_25,P_S_conduct_25,Eta_25);
            end
        end
    end
end