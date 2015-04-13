function [f, cond] = example_obj_fun(x, M)
%% function f = example_obj_fun(x, M)
% Function to evaluate the objective functions for the given input vector
% x. x is an array of decision variables and f(1), f(2), etc are the
% objective functions. The algorithm always minimizes the objective
% function hence if you would like to maximize the function then multiply
% the function by negative one. M is the numebr of objective functions and
% V is the number of decision variables. 
%
% This functions is basically written by the user who defines his/her own
% objective function. Make sure that the M and V matches your initial user
% input. Make sure that the 
%
%% Objective functions for emittance optimization
% The objective function are: emittance and betay and dispersion in
% straight sections

% global THERING %define the global variable which represents the ring
% global pqf pqd pqfc
% %set decision variable 1 as QF[K]
% THERING = setcellstruct(THERING,'K',pqf,x(1));
% %set decision variable 2 as QD[K]
% THERING = setcellstruct(THERING,'K',pqd,x(2));
% %set decision variable 3 as QFC[K]
% THERING = setcellstruct(THERING,'K',pqfc,x(3));

%evaluate emitance and twiss parameters of the ring
% a = calcemittance(THERING); %emit�ncia e nmrad
% b = calctwiss;
% The first objective function is emittance, the second and third are betay
% and etax in straight sections
global THERING pqf pqd pqfc; % The ring must be used within this function!
% This condition force the decision variables to generate stable orbits!!
THERING2 = setcellstruct(THERING,'PolynomB',pqf,x(1),1,2);
THERING2 = setcellstruct(THERING2,'PolynomB',pqd,x(2),1,2);
THERING2 = setcellstruct(THERING2,'PolynomB',pqfc,x(3),1,2);
% Calculate de transfer matrix of the ring
mat = findm44(THERING2,0);
% If the matrix refers to a stable orbit
cond = abs(mat(1,1)+mat(2,2))<=2 && abs(mat(3,3)+mat(4,4))<=2;
if ~cond
    f(1:M) = Inf;
    return;
end

a = calcemittance(THERING2);
cond = (a > 0);
if ~cond
    f(1:M) = Inf;
    return;
end

% Emitância Natural;
f(1) = a*1e9;

%maximum of beta functions;
twi = calctwiss;
f(2) = max(twi.betax);
f(3) = max(twi.betay);

%% Check for error
if length(f) ~= M
    error('The number of decision variables does not match you previous input. Kindly check your objective function');
end