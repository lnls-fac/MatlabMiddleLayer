function z = corrector(fname, L, kickangle, method)
%CORRECTOR('FAMILYNAME',LENGTH,ANGLE,'METHOD')
%	creates a new family in the FAMLIST - a structure with fields
%		FamName			family name
%		Length 			is set to 0 for  marker type 
%		KickAngle       [kickx, kicky] in radians (small) - unis of d(x,y)/ds
%       PassMethod		name of the function on disk to use for tracking
%
% returns assigned index in the FAMLIST that is uniquely identifies
% the family
if length(kickangle) == 2
    kickangle = reshape(kickangle,1,2);
else
    kickangle = [0, 0];
    warning(['Family: ',fname,' - KickAngle is not a 2-vector. Set both components to 0']);
end

if strcmp(method,'CorrectorPass')
    ElemData.FamName = fname;  % add check for identical family names
    ElemData.Length = L;
    ElemData.KickAngle = kickangle;
    ElemData.PassMethod = method;
    
elseif any(strcmp(method,{'StrMPoleSymplectic4Pass','StrMPoleSymplectic4RadPass'}))
    ElemData.FamName = fname;  % add check for existing identical family names
    ElemData.Length  = L;
    ElemData.MaxOrder    = 3;
    ElemData.NumIntSteps = 10;
    ElemData.PolynomA = zeros(1,4);
    ElemData.PolynomB = zeros(1,4);
    ElemData.PolynomB(1) = -kickangle(1)/L;
    ElemData.PolynomA(1) = kickangle(2)/L;
    ElemData.R1 = diag(ones(6,1));
    ElemData.R2 = diag(ones(6,1));
    ElemData.T1 = zeros(1,6);
    ElemData.T2 = zeros(1,6);
    ElemData.PassMethod=method;
elseif strcmp(method,'ThinMPolePass')
    ElemData.FamName = fname;  % add check for existing identical family names
    ElemData.Length  = 0;
    ElemData.MaxOrder    = 3;
    ElemData.NumIntSteps = 10;
    ElemData.PolynomA = zeros(1,4);
    ElemData.PolynomB = zeros(1,4);
    ElemData.PolynomB(1) = -kickangle(1);
    ElemData.PolynomA(1) = kickangle(2);
    ElemData.R1 = diag(ones(6,1));
    ElemData.R2 = diag(ones(6,1));
    ElemData.T1 = zeros(1,6);
    ElemData.T2 = zeros(1,6);
    ElemData.PassMethod=method;
else
    error('Invalid PassMethod for corrector.')
end

global FAMLIST
z = length(FAMLIST)+1; % number of declared families including this one
FAMLIST{z}.FamName = fname;
FAMLIST{z}.NumKids = 0;
FAMLIST{z}.KidsList= [];
FAMLIST{z}.ElemData= ElemData;

