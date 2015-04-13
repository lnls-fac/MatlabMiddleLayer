function [the_ring, PassMethodOld, ATIndexOld, FamNameOld, PassMethod, ATIndex, FamName] = setradiation(InputString, the_ring0)
%SETRADIATION - Sets the model PassMethod to include or exclude radiation ('On' / 'Off' {Default})
%  [PassMethod, ATIndex, FamName, PassMethodOld, ATIndexOld, FamNameOld, the_ring] = setradiation('On' or 'Off')
%
%  INPUTS
%  1. 'On' or 'Off'
%
%  OUTPUTS
%  Old AT model parameters
%  1. PassMethodOld - AT PassMethod field (cell array)
%  2. ATIndexOld    - AT index in THERING
%  3. FamNameOld    - AT family name (cell array)
%  New AT model parameters
%  4. PassMethod - AT PassMethod field (cell array)
%  5. ATIndex    - AT index in THERING
%  6. FamName    - AT family name (cell array)
%
%  NOTE
%  1. setpassmethod(ATIndexOld, PassMethodOld) can be used to restore old PassMethods.
%  2. This function is machine specific (Sirius).  All machine get the same passmethods
%     for radiation on. The potential confusion occurs when turning the radiation off.
%     
%
%  See also setpassmethod, getpassmethod, getcavity, setcavity

%  Written by Greg Portmann
%  modified by Ximenes (2013-04-17) so that user may specify a AT model
%  modified by Fernando (2015-01-29: the_ring is the first output, old
%     parameters come before new parameters as output, simplification of the
%     code.
%  other than THERING
global THERING

if nargin == 0
    InputString = 'Off';
end

if ~exist('the_ring0', 'var')
    the_ring = THERING; 
else
    the_ring = the_ring0;
end;
len = length(the_ring);
ATIndex = zeros(1,len);
PassMethod = cell(1,len);
FamName = cell(1,len);
ATIndexOld = zeros(1,len);
PassMethodOld = cell(1,len);
FamNameOld = cell(1,len);

% Main 
j = 0;
switch lower(InputString)
    case 'off'
        for i=1:length(the_ring)
            if strcmp(the_ring{i}.PassMethod,'StrMPoleSymplectic4RadPass')
                j = j+1;
                ATIndexOld(j) = i;
                PassMethodOld{j} = the_ring{i}.PassMethod;
                FamNameOld{j}    = the_ring{i}.FamName;
                the_ring{i}.PassMethod = 'StrMPoleSymplectic4Pass';
                ATIndex(j) = i;
                PassMethod{j} = the_ring{i}.PassMethod;
                FamName{j}    = the_ring{i}.FamName;
            elseif strcmp(the_ring{i}.PassMethod,'BndMPoleSymplectic4RadPass')
                j = j+1;
                ATIndexOld(j) = i;
                PassMethodOld{j} = the_ring{i}.PassMethod;
                FamNameOld{j}    = the_ring{i}.FamName;
                the_ring{i}.PassMethod = 'BndMPoleSymplectic4Pass';
                ATIndex(j) = i;
                PassMethod{j} = the_ring{i}.PassMethod;
                FamName{j}    = the_ring{i}.FamName;
            elseif any(strcmp(the_ring{i}.PassMethod,{'QuadLinearPass','StrMPoleSymplectic4Pass',...
                                                      'BendLinearPass','BndMPoleSymplectic4Pass'}))
                j = j+1;
                ATIndexOld(j) = i;
                PassMethodOld{j} = the_ring{i}.PassMethod;
                FamNameOld{j}    = the_ring{i}.FamName;
                ATIndex(j) = i;
                PassMethod{j} = the_ring{i}.PassMethod;
                FamName{j}    = the_ring{i}.FamName;
            end
        end
        
    case 'on'
        for i=1:length(the_ring)
            if any(strcmp(the_ring{i}.PassMethod,{'StrMPoleSymplectic4Pass','QuadLinearPass'}))
                j = j+1;
                ATIndexOld(j) = i;
                PassMethodOld{j} = the_ring{i}.PassMethod;
                FamNameOld{j}    = the_ring{i}.FamName;
                the_ring{i}.PassMethod = 'StrMPoleSymplectic4RadPass';
                ATIndex(j) = i;
                PassMethod{j} = the_ring{i}.PassMethod;
                FamName{j}    = the_ring{i}.FamName;
            elseif any(strcmp(the_ring{i}.PassMethod,{'BndMPoleSymplectic4Pass','BendLinearPass'}))
                j = j+1;
                ATIndexOld(j) = i;
                PassMethodOld{j} = the_ring{i}.PassMethod;
                FamNameOld{j}    = the_ring{i}.FamName;
                the_ring{i}.PassMethod = 'BndMPoleSymplectic4RadPass';
                ATIndex(j) = i;
                PassMethod{j} = the_ring{i}.PassMethod;
                FamName{j}    = the_ring{i}.FamName;
            elseif any(strcmp(the_ring{i}.PassMethod,{'StrMPoleSymplectic4RadPass',...
                                                      'BndMPoleSymplectic4RadPass'}))
                j = j+1;
                ATIndexOld(j) = i;
                PassMethodOld{j} = the_ring{i}.PassMethod;
                FamNameOld{j}    = the_ring{i}.FamName;
                ATIndex(j) = i;
                PassMethod{j} = the_ring{i}.PassMethod;
                FamName{j}    = the_ring{i}.FamName;
            end
        end
end

ATIndexOld = ATIndexOld(1:j)';
PassMethodOld = PassMethodOld(1:j);
FamNameOld    = FamNameOld(1:j);
ATIndex = ATIndex(1:j)';
PassMethod = PassMethod(1:j);
FamName    = FamName(1:j);

if ~exist('the_ring0', 'var')
    THERING = the_ring;
end;

