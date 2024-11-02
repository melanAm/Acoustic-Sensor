close all;
clear all; 
clc;

addpath('E:\Dr. Anooshahpour project\sounds\Siren\anechoic\Day5_d_10cm')
addpath('E:\Dr. Anooshahpour project\Matlab\utility codes')
addpath('E:\Dr. Anooshahpour project\sounds\Siren\reverb\Day11')


siren_f0_fanposition3;
siren_f0_fanposition4;
siren_f0_fanposition5;
siren_f0_fanposition6;
siren_f0_fanposition7;
siren_f0_fanposition8;

pos3 = ones(length(f0_3),1)*3;
pos4 = ones(length(f0_4),1)*4;
pos5 = ones(length(f0_5),1)*5;
pos6 = ones(length(f0_6),1)*6;
pos7 = ones(length(f0_7),1)*7;
pos8 = ones(length(f0_8),1)*8;

figure(1)
stem(pos3,f0_3)
hold on;
stem(pos4,f0_4)
hold on;
stem(pos5,f0_5)
hold on;
stem(pos6,f0_6)
hold on;
stem(pos7,f0_7)
hold on;
stem(pos8,f0_8)
hold on;
xlim([1,10])

Pos = [pos3;pos4;pos5;pos6;pos7;pos8];
F0 = [f0_3;f0_4;f0_5;f0_6;f0_7;f0_8];

[pred,S] = polyfit(F0,Pos,1); 
[y_fit,delta] = polyval(pred,F0,S);

figure(2)
plot(F0,Pos,'bo')
hold on
plot(F0,y_fit,'r-')
plot(F0,y_fit+2*delta,'m--',F0,y_fit-2*delta,'m--')
title('Linear Fit of Siren Data with 95% Prediction Interval')
legend('Data','Linear Fit','95% Prediction Interval')
