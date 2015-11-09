function [model, model_length] = sirius_bo_qd_segmented_model(energy, fam_name, passmethod, hardedge_KL)

% This script build an AT quadrupole model based on analysis of a fieldmap generated for a 3D magnetic model
% of the magnet and based on rotating coil measurement data for the constructed magnet.
%
% Input:
%
% energy [eV]       : beam energy
% hardedge_KL [1/m] : nominal integrated quadrupole strength
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
% 3. Merges the fieldmap and rotating coild data into one segmented structure.
%    It does so by making sure that each corresponding fieldmap integrated multipole 
%    matches the rotating coil integrated multipole. It keeps the
%    longitudinal multipole profile of the segmented model.

magnet_type = 1;  % 0:dipole, 1:quadrupole, 2:sextupole

types = {};
b = 1; types{end+1} = struct('fam_name', fam_name, 'passmethod', passmethod);


% ---------------------------------------------------------------
% QD model 2015-11-05
% ====================
% this (half) model is based on fieldmap
% /home/fac_files/data/sirius/bo/magnet_modelling/qd/fieldmaps/
% '2015-08-24 Quadrupolo_Booster_QD_Modelo 1_-20_20mm_-300_300mm_115A_extracao.txt'
fmap_monomials = [1,5,9,13];
fmap_model = [ ...
%len[m]              angle[deg]             PolynomB(n=1)           PolynomB(n=5)           PolynomB(n=9)          PolynomB(n=13)   
b  0.05050  +0.0000000000000000e+00 -5.0037880016612302e-01 +2.4871556929337290e+04 -6.8747285617449402e+10 -7.5279297084782300e+14
]; 

% ROTATING COIL MEASUREMENT
% =========================
% data based on quadrupole prototype
% Rescale multipolar profile according to rotating coild measurement
rcoil_monomials  = [];
rcoil_integrated_multipoles = [];
% ---------------------------------------------------------------



fmap_lens = fmap_model(:,2);


% rescale multipoles of the model according to nominal strength value passed as argument
% --------------------------------------------------------------------------------------
if exist('hardedge_KL','var')
    idx = find(fmap_monomials == magnet_type); 
    model_KL = 2*sum(fmap_model(:,3+idx) .* fmap_lens); 
    rescaling = hardedge_KL / model_KL;
    fmap_model(:,4:end) = fmap_model(:,4:end) * rescaling;
end

% rescale multipoles of the rotating coild data according to nominal strength value passed as argument
% ----------------------------------------------------------------------------------------------------
if ~isempty(rcoil_monomials)
    [~,~,brho] = lnls_beta_gamma(energy/1e9);
    rcoil_normalized_integrated_multipoles = -rcoil_integrated_multipoles / brho;
    rcoil_main_multipole_idx = find(rcoil_monomials == magnet_type, 1);
    rescaling = hardedge_KL / rcoil_normalized_integrated_multipoles(rcoil_main_multipole_idx);
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



% function [model, model_length] = sirius_bo_qd_segmented_model(fam_name, passmethod, strength)
% 
% types = {};
% quad   = 1; types{end+1} = struct('fam_name', fam_name, 'passmethod', passmethod);
% 
% % QD model 2015-11-05
% % ====================
% % this (half) model is based on fieldmap
% % /home/fac_files/data/sirius/bo/magnet_modelling/qd/fieldmaps/
% % '2015-08-24 Quadrupolo_Booster_QD_Modelo 1_-20_20mm_-300_300mm_115A_extracao.txt'
% monomials = [1,5,9,13];
% segmodel = [ ...
% %len[m]              angle[deg]             PolynomB(n=1)           PolynomB(n=5)           PolynomB(n=9)          PolynomB(n=13)   
% quad  0.05050  +0.0000000000000000e+00 -5.0037880016612302e-01 +2.4871556929337290e+04 -6.8747285617449402e+10 -7.5279297084782300e+14
% ];
% 
% % hardedge quadrupole strength of the fieldmap
% seg_lens = segmodel(:,2);
% model_length = 2*sum(seg_lens);
% hedge_strength = sum(2*segmodel(:,4) .* seg_lens) / model_length;
% rescale_current = strength / hedge_strength; % rescaling current because fieldmap is usually generated with maximum current, not nominal value.
% 
% % builds the magnet model 
% % (lattice_error scripts cannot yet deal with segmented quadrupole models)
% i = 1;
% maxorder = 1+max(monomials);
% PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
% PolyB(monomials+1) = segmodel(i,4:end) * rescale_current; 
% type = types{segmodel(i,1)};
% model = quadrupole_sirius(type.fam_name, 2*segmodel(i,2), PolyA, PolyB, passmethod);


