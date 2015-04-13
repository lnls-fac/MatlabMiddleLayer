function r = findtiltrespm(RING, OBSINDEX, FamName, PVALUE, varargin)
%FINDCOUPLINGRESPM computes the change in the beam tilt due to parameter perturbations
% calling syntax
% FINDRESPM(RING, OBSINDEX, PERTURBINDEX, PVALUE, 'FIELD', M, N)
%
% RING      - ring lattice
% OBSINDEX  - indexes of elements where the orbit is observed (at the entrance)
% PERTURBINDEX  - Integer indexes of elements whose parameters are perturbed
%                 used with syntax 1 only. 
%             
% PERTURBGROUP  - cell array of AT paramgroups. See ATPARAMGROUP
%               used with syntax 2 only
%
% PVALUE    - amount of peturbation 
%             (Numeric array or scalar if all perturbations are the same magnitude) 
% 
% FIELD,M,N are only use with syntax 1. 
%
% FIELD     - field name of the parameter to perturb (string)
%
% M,N       - index in the matrix, if the field is a matrix
%             For example to perturb the quadrupole field in a
%             multipole element
%             FIELD = 'PolynomB', M = 1, N = 2
%
%
% Returns a 1-by-4 cell array of O-by-P matrixes 
% where O = length(OBSINDEX) and P = length(PERTURB)
% one for each of the close orbit components: X, PX, Y, PY
% See also ATPARAMGROUP, FINDORBIT, FINDORBIT4, FINDORBIT6, FINDSYNCORBIT

global THERING;

Families= {};
for i=1:length(FamName)
    Families = [Families; findmemberof(FamName{i})];
end
for i=1:length(Families);
    PERTURB{i} = family2atindex(Families{i});
    P(i) = size(PERTURB{i},1);
end



   

if nargin < 7
    error('Incorrect number of inputs');
end

if ~ischar(varargin{1}) % Check that the FIELD argument is a string
    error('The 5-th argument FIELD must be a string');
end
    
if ~isnumeric(varargin{2}) || length(varargin{2})>1 % Check that the M argument is a scalar
    error('The 6-th argument FIELD must be a scalar');
end
M = varargin{2}(1);

if ~isnumeric(varargin{3}) || length(varargin{3})>1 % Check that the M argument is a scalar
    error('The 7-th argument FIELD must be a scalar');
end
N = varargin{3}(1);

ElemField = varargin{1};
THERING_original = THERING;
THERING = RING;

RadiationElemIndex = getindex_radiationelements;

%[tilt eta epsx epsy emitratio env dp dl bsize] = calccoupling;
tilt = calctilt(RadiationElemIndex);

TILT = tilt(OBSINDEX);
%ORBIT = feval(orbit_function_handle,RING,orbit_function_args{:});



mn = {M,N};
idx = 1;
lnls_create_waitbar('Creating Tilt RM', 0.5, length(Families));
for j = 1:length(Families)
    for i = 1:P(j)
        %fprintf('calculating coupling matrix response, column #%03i\n', idx);
        oldvalues = getcellstruct(THERING, ElemField, PERTURB{j}(i,:));
        THERING = setcellstruct(THERING, ElemField, PERTURB{j}(i,:), oldvalues + PVALUE, M,N);
        tilt = calctilt(RadiationElemIndex);
        TILTPLUS = tilt(OBSINDEX);
        THERING = setcellstruct(THERING, ElemField, PERTURB{j}(i,:), oldvalues, M,N);
        DTILT = (TILTPLUS - TILT);
        C(:,idx) = DTILT;
        idx = idx + 1;
    end
    lnls_update_waitbar(j);
end

r.Families = Families;
r.FamName = FamName;
r.ElemField = ElemField;
r.ObsIndex = OBSINDEX;
r.PerturbIndex = PERTURB;
r.RM = C / PVALUE;

THERING = THERING_original;