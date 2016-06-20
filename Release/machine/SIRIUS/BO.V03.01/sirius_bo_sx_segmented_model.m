function [model, model_length] = sirius_bo_sx_segmented_model(energy, fam_name, passmethod, hardedge_SL)

% This script build an AT sextupole model based on analysis of a fieldmap generated for a 3D magnetic model
% of the magnet and based on rotating coil measurement data for the constructed magnet.
%
% Input:
%
% energy [eV]         : beam energy
% hardedge_SL [1/m^2] : nominal integrated sextupole strength
%
% Output:
%
% model            : AT segmented model
% model_length [m] : total model length
%
% Procedure:
%
% 1. Renormalizes all multipoles of the fieldmap segmented model so that
%    its main integrated multipole matches the nominal one.
% 2. Takes the rotating coild integrated multipoles and divides them by 
%    the magnetic rigidity corresponding to the beam energy. This yields
%    the normalized integrated multipolar strengths (PolynomB) for the model
% 3. Merges the fieldmap and rotating coil data into one segmented structure.
%    It does so by making sure that each corresponding fieldmap integrated multipole 
%    matches the rotating coil integrated multipole. It keeps the
%    longitudinal multipole profile of the segmented model.

magnet_type = 2;  % 0:dipole, 1:quadrupole, 2:sextupole

types = {};
b = 1; types{end+1} = struct('fam_name', fam_name, 'passmethod', passmethod);


% ---------------------------------------------------------------
% SX model 2015-11-09
% ====================
% this (half) model is based on fieldmap
% /home/fac_files/data/sirius/bo/magnet_modelling/sx/fieldmaps/
% '2015-08-28 Sextupolo_Booster_S_Modelo 1_-20_20mm_-300_300mm_135A_extracao.txt'
fmap_monomials = [2,8,14];
fmap_model = [ ...
%len[m]        angle[deg]             PolynomB(n=2)           PolynomB(n=8)          PolynomB(n=14)      
b  0.05250  +0.0000000000000000e+00 +1.9010451096983513e+01 -1.6319594457349304e+10 -3.5644305893270920e+20
]; 

% ROTATING COIL MEASUREMENT
% =========================
% data based on quadrupole prototype
% Rescale multipolar profile according to rotating coild measurement
% rcoil_monomials  = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
% rcoil_integrated_multipoles  = [+2.5e-05,-7.8e-04,-2.1e+01,-1.5e-01,+1.3e+02,-1.1e+02,+6.2e+04,+2.4e+04,+1.6e+10,-4.2e+09,-5.2e+11,-1.5e+13,-2.7e+14,+1.5e+17,+4.3e+20];
% skew   = [+9.3e-06, +1.2e-03, +1.8e-02, +1.4e+00, -2.8e+00, +2.7e+02, +8.1e+03, -4.8e+06, +3.2e+07, +1.2e+08, +1.9e+11, +6.7e+12, +5.8e+14, -1.9e+17, +2.9e+17];

rcoil_monomials  = [];
rcoil_integrated_multipoles  = [];

% ---------------------------------------------------------------



fmap_lens = fmap_model(:,2);


% rescale multipoles of the model according to nominal strength value passed as argument
% --------------------------------------------------------------------------------------
if exist('hardedge_SL','var')
    idx = find(fmap_monomials == magnet_type); 
    model_SL = 2*sum(fmap_model(:,3+idx) .* fmap_lens); 
    rescaling = hardedge_SL / model_SL;
    fmap_model(:,4:end) = fmap_model(:,4:end) * rescaling;
end


% rescale multipoles of the rotating coil data according to nominal strength value passed as argument
% ----------------------------------------------------------------------------------------------------
if ~isempty(rcoil_monomials)
    [~,~,brho] = lnls_beta_gamma(energy/1e9);
    rcoil_normalized_integrated_multipoles = -rcoil_integrated_multipoles / brho;
    rcoil_main_multipole_idx = find(rcoil_monomials == magnet_type, 2);
    rescaling = hardedge_SL / rcoil_normalized_integrated_multipoles(rcoil_main_multipole_idx);
    rcoil_normalized_integrated_multipoles = rcoil_normalized_integrated_multipoles * rescaling;
end
        

% builds final model with fieldmap and rotating coild measurements
% ----------------------------------------------------------------

monomials = unique([fmap_monomials rcoil_monomials]);
segmodel = zeros(size(fmap_model,1),length(monomials));
segmodel(:,1:3) = fmap_model(:,1:3);
for i=1:length(monomials)
    rcoil_idx = find(rcoil_monomials == monomials(i), 1);
    fmap_idx  = find(fmap_monomials == monomials(i), 1);
    if isempty(rcoil_idx)
        % this multipole is not in rotating coil data: does nothing then.
        segmodel(:,i+3) = fmap_model(:,fmap_idx+3);
    else
        if isempty(fmap_idx)
            % if this multipole is not in fmap model then uses main
            % multipole to build a multipolar profile
            fmap_integrated_multipole = 2*sum(fmap_model(:,magnet_type+3) .* fmap_lens);
        else
            fmap_integrated_multipole = 2*sum(fmap_model(:,fmap_idx+3) .* fmap_lens);
        end    
        rescaling = rcoil_normalized_integrated_multipoles(rcoil_idx) / fmap_integrated_multipole;
        segmodel(:,i+3) = fmap_model(:,fmap_idx+3) * rescaling;
    end
end

% converts deflection angle from degress to radians
segmodel(:,3) = segmodel(:,3) * (pi/180.0);

% turns deflection angle error off (convenient for having a nominal model with zero 4d closed orbit)
sel = (monomials == 0);
segmodel(:,sel) = 0;

% builds half of the magnet model
b = zeros(1,size(segmodel,1));
maxorder = 1+max(monomials);
for i=1:size(segmodel,1)
    type = types{segmodel(i,1)};
    if strcmpi(type.passmethod, 'IdentityPass')
        b(i) = marker(type.fam_name, 'IdentityPass');
    else
        PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
        PolyB(monomials+1) = segmodel(i,4:end); 
        b(i) = quadrupole_sirius(type.fam_name, 2*segmodel(i,2), PolyA, PolyB, passmethod); % factor 2 in length for one-segment model
    end
end

model_length = 2*sum(segmodel(:,2));
model = b;



