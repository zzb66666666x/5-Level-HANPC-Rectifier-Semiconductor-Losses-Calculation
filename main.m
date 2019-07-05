%This script calculates the semiconductor losses of a 5-level HANPC rectifier.
%Current ripple and DT are not considered.
%All variables are in the form of SI Unit.

%Initializing
name='result.csv';
file=fopen(name,'w');
fprintf(file,",\r\n");
