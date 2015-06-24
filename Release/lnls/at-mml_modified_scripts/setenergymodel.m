function setenergymodel(GeV)
%SETENERGYMODEL - Set the energy of the model
%  setenergymodel(GeV)
%
%  INPUTS
%  1. GeV - Energy in GeV
%
%  Keyword can be:
%  'Production' - Energy of the production lattice
%  'Injection'  - Energy of the injection lattice
%
%  See also getenergymodel

%  Written by Greg Portmann
%  2011-10-26: Mudado para acomodar dependencia dos parametros dos modelos de IDs em fun��o da energia do feixe (Ximenes 2011-10-

if ischar(GeV)
    if strcmpi(GeV, 'Production')
        GeV = getfamilydata('Energy');
    elseif strcmpi(GeV, 'Injection')
        GeV = getfamilydata('InjectionEnergy');
    else
        GeV = getfamilydata(GeV);
        if isempty(GeV) || ~isnumeric(GeV)
            error('Production, Injection, or something getfamilydata recognizes are the only allowable string inputs.');
        end
    end
end


% GLOBVAL will be obsolete soon
if ~isempty(whos('global','GLOBVAL'))
    global GLOBVAL
    GLOBVAL.E0 = 1e+009 * GeV(end);
end

global THERING;

% Newer AT versions require 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), 1e+009 * GeV(end));

% IDs with HE modelling
idx1 = findcells(THERING, 'Field');
idx2 = findcells(THERING, 'BendingAngle');
at_idx = intersect(idx1, idx2);
if ~isempty(at_idx)
    [fname, m, n] = unique(getcellstruct(THERING, 'FamName', at_idx));
    fields = getcellstruct(THERING, 'Field', at_idx);
    fields = fields(m);
    for i=1:length(fname)
        lnls1_set_id_field(fname{i}, fields(i));
    end
end

% sets RF voltage for Sirius Booster
ad = getad();
if strfind(ad.SubMachine, 'BO.V')
    idx = findcells(THERING, 'Voltage');
    voltage = sirius_bo_rf_voltage(GeV*1e9);
    THERING{idx}.Voltage = voltage;
    fprintf('  Adjusting RF voltage: %f MV\n', voltage/1e6);
end
