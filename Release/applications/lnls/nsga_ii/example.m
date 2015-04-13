%% EMITTANCE oPTIMIZATION USING NSGA II


% This script defines the ring and call the algorithm nsga II

%clear preceeding work and set path
clc;
% clear all;
%lnls1;
% Define variable THERING and load ring lnls_test
global THERING;
lnls_test;
setcavity('off');
setradiation('off');
lnls1_set_id_field('AON11',0.58);
lnls1_set_id_field('AWG09',3.5);
lnls1_set_id_field('AWG01',2.0);
global pqf pqd pqfc;
% find position of the three quadrupole families in the ring
pqf = findcells(THERING,'FamName','QF');
pqd = findcells(THERING,'FamName','QD');
pqfc = findcells(THERING,'FamName','QFC');

% Call the Algorithm
param = [];
param.gen = 50; %number of generations
param.pop = 200; % number of individuals in each generation
param.nObjectives = 3; % number of objective functions to minimize
param.nDeciVar  = 3; % number of decision variables
param.minValueDeciVar = [ 0 , -3.6,  0];
param.maxValueDeciVar = [3.6,   0 , 3.6];
param.objective_function = @example_obj_fun; 
param.folder = 'solution'; % folder to save the results

% Uncomment these lines to start from an specified initial population;
% param.initialPop = load('solution/initialgeneration.txt');
% param.initialPop = param.initialPop(:,1:param.nDeciVar);

nsga_2(param)

%clear workspace

clear pqf pqd pqfc gen pop g