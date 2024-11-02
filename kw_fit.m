close all;
clear all; 
clc;

addpath('E:\Dr. Anooshahpour project\sounds\Kettle Whistle\anechoic\Day10')
addpath('E:\Dr. Anooshahpour project\sounds\Kettle Whistle\reverb\Day12')
addpath('E:\Dr. Anooshahpour project\Matlab\utility codes')
addpath('E:\Dr. Anooshahpour project\Matlab\data')

load('kw_top3fpks_fanposition1.mat');
load('kw_top3fpks_fanposition2.mat');
load('kw_top3fpks_fanposition3.mat');
load('kw_top3fpks_fanposition4.mat');
load('kw_top3fpks_fanposition5.mat');
load('kw_top3fpks_fanposition6.mat');
load('kw_top3fpks_fanposition7.mat');
load('kw_top3fpks_fanposition8.mat');

fpks_1 = sort(top3pks_1,'descend');
fpks_2 = sort(top3pks_2,'descend');
fpks_3 = sort(top3pks_3,'descend');
fpks_4 = sort(top3pks_4,'descend');
fpks_5 = sort(top3pks_5,'descend');
fpks_6 = sort(top3pks_6,'descend');
fpks_7 = sort(top3pks_7,'descend');
fpks_8 = sort(top3pks_8,'descend');


pos1 = ones(size(fpks_1,1),1)*1;
pos2 = ones(size(fpks_2,1),1)*2;
pos3 = ones(size(fpks_3,1),1)*3;
pos4 = ones(size(fpks_4,1),1)*4;
pos5 = ones(size(fpks_5,1),1)*5;
pos6 = ones(size(fpks_6,1),1)*6;
pos7 = ones(size(fpks_7,1),1)*7;
pos8 = ones(size(fpks_8,1),1)*8;

% Load sample data (for example: Fisher's iris dataset)  
% load fisheriris  
% X = meas; % Features  
% Y = species; % Classes  

X = [fpks_1;fpks_2;fpks_3;fpks_4;fpks_5;fpks_6;fpks_7;fpks_8]; % Features  
Y = [pos1;pos2;pos3;pos4;pos5;pos6;pos7;pos8];; % Classes  

% Create a One-vs-All SVM classifier  
% Use fitcecoc to create a multi-class SVM model  
SVMModel = fitcecoc(X, Y); 

% Display the trained model  
disp(SVMModel);  

% Test the model with a new sample  
newSample = [1803.50,3573.07,1052.76]; % Example input  
predictedClass = predict(SVMModel, newSample);  

error = resubLoss(SVMModel)
% Display the predicted class  
fprintf('Predicted class: %s\n', predictedClass);
fprintf('Error: %s\n', error);
 

