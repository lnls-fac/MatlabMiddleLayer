%ibs_id: calculates the values of final vertical and horizontal emittances
%and energy spread due to IBS effect. The natural emittances and energy
%spread depends on the operation phase chosen.
%
%INPUT  data_atsum: struct with ring parameters (atsummary)
%       I         : Current per bunch vector    [A]
%       K         : Coupling between vertical and horizontal emittances [%]
%       phase: set the operational phase (0, 1 or 2)
%
%OUTPUT fCIMP: final values (vertical and horizontal emittance, energy
%spread and bunch length) after IBS calcuations with CIMP model
%       fBane: same as above but with Bane model
% 
% April, 2018
%==========================================================================
function [fCIMP,fBANE] = ibs_id(data_atsum,I,K,phase)

data_id = data_atsum;
data_getad.NrBunches = 1; %Evaluate IBS effect with current per bunch 

nint = length(I);
fBANE = zeros(nint, 4);
fCIMP = zeros(nint, 4);

[data_id] = lnls_effect_emittance(data_atsum,phase);

%For each j, assigns a value of current to the function that calculates the
%effect of ibs on final emittances
for j=1:nint
    if ~mod(j, 20)
        fprintf('.\n');
    else
        fprintf('.');
    end
    [fBANE(j,:),~,fCIMP(j,:),~] = lnls_calc_ibs_bane_cimp(data_id,I(j),K);
end
fprintf('\n');



