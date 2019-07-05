function [Ua1_1,Ua1_2,Ua2_1,Ua2_2] = CarrierWave(t,T_switch)
%define some variables
Uam = 1;
Ua1_1 = t;
Ua1_2 = t;
Ua2_1 = t;
Ua2_2 = t;
t_range = length(t);
for i = 1:1:t_range
   time = mod(t(i),T_switch);
   if time>=0 && time< T_switch/2
       temp = (2*Uam*time/T_switch);
       Ua1_1(i) = temp;
       Ua2_1(i) = temp - Uam;
   elseif time>=T_switch/2 && time<T_switch
       temp = (-2*Uam*(time-T_switch/2)/T_switch) + Uam;
       Ua1_2(i) = temp;
       Ua2_2(i) = temp - Uam;
   end     
end
end