%This is for testing the code we have written.
test_switch_kind=["1700","3300","SIC1200","SIC1700"];
test_n=length(test_switch_kind);
test_switch_voltage=[1700,3300,1200,1700];
test_I_step=0.1;%A

%Change the device to be tested.
device_choice = 2;
f_switch = 600;%HZ
I_amplitude = 1;
Alpha = 0.106;

%call the function
interpolating(test_switch_kind(device_choice),test_I_step);
[N_num1,N_num2,Po,P_S_switch_25,P_S_conduct_25,Eta_25]=test_calculation(f_switch,I_amplitude,Alpha/180*pi,test_switch_voltage(device_choice),test_I_step);
disp([N_num1,N_num2,Po,P_S_switch_25/3,P_S_conduct_25/3,P_S_switch_25/3+P_S_conduct_25/3,Eta_25]');








