function the_ring = lnls_latt_err_generate_apply_bpmcorr_errors(name, the_ring, control, cutoff, rndtype)
% function the_ring = lnls_latt_err_generate_apply_bpmcorr_errors(name, the_ring, control, cutoff, rndtype)
%
% Generates and apply errors to bpms and correctors in the_ring:
%  - For every bpm defined in control, two fields will be created: Offsets and
%    Gains. The first may be used in the orbit correction algorithm to
%    denote the position uncertainty related to the goal orbit to which one
%    desires to correct. The second may be used in the optics and coupling
%    correction algorithms to denote a general linear coupling of
%    horizontal and vertical position readings due to bpm imperfections. If
%    no error in BPMs exist, this matrix is the 2-d identity matrix.
%  - For every corrector defined in control, a field will be created: Gain.
%    It may be used in the optics and coupling correction algorithm to
%    denote the ratio of the corrector strength felt by the electron to the
%    one sent to the magnet.
%
% INPUTS:
%   name    : name of the file which will be saved with the inputs of this
%             function;
%   the_ring: may be one lattice model or an array of lattice models;
%   cutoff  : cutoff in unities of sigma for the errors. Default: infinity;
%   rndtype : distribution to be used: 'gauss' for gaussian and 'uni' for
%             uniform. Default: gaussian.
%   control : a structure with three optional fields:
%     bpm: a structure with fields: 
%          idx - the indexes of bpms in the_ring 
%          sigma_offsetx - the rms of the offset in x direction
%          sigma_offsety - the rms of the offset in x direction
%          sigma_matrix  - a 2x2 matrix with rms values of the linear errors
%     hcm: a structure with fiels:
%          idx - the indexes of horizontal correctors in the_ring 
%          sigma_gain - the rms of the errors in unity gain.
%     vcm: a structure with the same fields and interpretation of hcm, but
%          for the vertical correctors.
%
% OUTPUTS:
%   the_ring : the lattice model or the cell array of lattice models with
%              the errors applied.
%
if ~exist('cutoff','var'), cutoff = inf; end
if ~exist('rndtype','var'), rndtype = 'gaussian'; end;


save([name,'_bpmcorr_errors_input.mat'],'control','cutoff','rndtype');

is_ring=false;
if ~iscell(the_ring{1}) 
    the_ring = {the_ring};
    is_ring=true;
end

if isfield(control,'bpm')
    bpm = control.bpm;
    for i = 1:length(the_ring)
        if isfield(bpm,'sigma_offsetx') && any(bpm.sigma_offsetx) && ...
           isfield(bpm,'sigma_offsety') && any(bpm.sigma_offsety)
            % Set offsets replacing old values
            errorsx = get_random_numbers(bpm.sigma_offsetx,length(bpm.idx),cutoff,rndtype);
            errorsy = get_random_numbers(bpm.sigma_offsety,length(bpm.idx),cutoff,rndtype);
            offsets = [errorsx,errorsy];
            errors = mat2cell(offsets,ones(1,length(offsets)),2);
            the_ring{i} = setcellstruct(the_ring{i},'Offsets',bpm.idx,errors);
        end
        
        % Set gain-matrix replacing old values
        if isfield(bpm,'sigma_matrix') && any(any(bpm.sigma_matrix))
            bxx = get_random_numbers(bpm.sigma_matrix(1,1),length(bpm.idx),cutoff,rndtype);
            bxy = get_random_numbers(bpm.sigma_matrix(1,2),length(bpm.idx),cutoff,rndtype);
            byx = get_random_numbers(bpm.sigma_matrix(2,1),length(bpm.idx),cutoff,rndtype);
            byy = get_random_numbers(bpm.sigma_matrix(2,2),length(bpm.idx),cutoff,rndtype);
            mats = mat2cell(reshape([1+bxx,byx,bxy,1+byy]',2,2*length(bxx)),2,(2+0*bxx));
            the_ring{i} = setcellstruct(the_ring{i},'Gains',bpm.idx,mats);
        end
    end
end

if isfield(control,'hcm') && isfield(control.hcm,'sigma_gain') && any(control.hcm.sigma_gain)
    hcm = control.hcm;
    for i = 1:length(the_ring)
        % Set gains replacing old values
        if any(hcm.sigma_gain)
            errors = get_random_numbers(hcm.sigma_gain,length(hcm.idx),cutoff,rndtype);
            the_ring{i} = setcellstruct(the_ring{i},'Gain', hcm.idx, 1 + errors);
        end
    end
end

if isfield(control,'vcm') && isfield(control.vcm,'sigma_gain') && any(control.vcm.sigma_gain)
    vcm = control.vcm;
    for i = 1:length(the_ring)
        % Set gains replacing old values
        if any(vcm.sigma_gain)
            errors = get_random_numbers(vcm.sigma_gain,length(vcm.idx),cutoff,rndtype);
            the_ring{i} = setcellstruct(the_ring{i},'Gain', vcm.idx, 1 + errors);
        end
    end
end

if is_ring, the_ring = the_ring{1}; end


function rndnr = get_random_numbers(sigma, nrels, cutoff, type)
max_value = cutoff;
rndnr = zeros(nrels,1);
sel = 1:nrels;
if any(strcmpi(type, {'gaussian','gauss','norm', 'normal'}))
    while ~isempty(sel)
        rndnr(sel) = randn(1,length(sel));
        sel = find(abs(rndnr) > max_value);
    end
elseif any(strcmpi(type, {'sin','vibration','ripple', 'cos','time-average'}))
    rndnr(sel) = sin(2*pi*rand(1,length(sel)));
end
rndnr = sigma * rndnr;