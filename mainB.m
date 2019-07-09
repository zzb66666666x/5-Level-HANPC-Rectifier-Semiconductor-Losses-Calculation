%This script calculates the semiconductor losses of a 5-level HANPC rectifier.
%Current ripple and DT are not considered.
%Linear method is used for interpolation.
%All variables are in the form of SI Units.
%For version B, free variables includes switch_kind (switch_voltage), Lo, f_switch and Po.

%Defining global variables
global data_Es_on_25;
global data_Es_off_25;
global data_Vds_18;
global data_Vsd_18;

%Initializing
name='resultsB.csv';
file=fopen(name,'w');
fprintf(file,'Switch,Lo,f_switch,Po,Iorms,Alpha,N_num1,N_num2,P_S_switch_25,P_S_conduct_25,Efficiency,\r\n');

%Configuring free variables for functions
switch_kind=["1700","3300","SIC1200","SIC1700"];
n=length(switch_kind);
switch_voltage=[1700,3300,1200,1700];
Lo=16.9e-3;%H

%Enumerating
for i=1:1:n
    %Interpolating
    importingData(switch_kind(i));
    %Calculating
    for f_switch=900:50:3600%Hz
        for Po=0.6e6:0.2e6:2e6%W
            [Iorms,Alpha,N_num1,N_num2,P_S_switch_25,P_S_conduct_25,Eta_25]=calculatingB(f_switch,Lo,Po,switch_voltage(i));
            fprintf(file,"%s,%f,%d,%f,%f,%f,%d,%d,%f,%f,%f,\r\n",switch_kind(i),Lo,f_switch,Po,Iorms,Alpha,N_num1,N_num2,P_S_switch_25,P_S_conduct_25,Eta_25);
        end
    end
end
fclose(file);