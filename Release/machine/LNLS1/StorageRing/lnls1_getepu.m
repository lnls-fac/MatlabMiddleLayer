function [AM, tout, DataTime, ErrorFlag] = lnls1_getepu(FamilyName, Field, DeviceList, t)
%LNLS1_GETEPU - Returns AON11 gap value.
%
%História
%
% 2011-04-28: adicionada leitura das fases isoladas do CSD e CIE
% 2010-09-13: código fonte com comentários iniciais.


tout = [];
DataTime = [];
ErrorFlag = 0;

if strcmpi(Field, 'Monitor')
    AM = getpv('AON11GAP_AM');
elseif strcmpi(Field, 'Setpoint')
    AM = getpv('AON11GAP_SP');
elseif strcmpi(Field, 'CSDPhaseAM')
    AM = getpv('AON11FASECSD_AM');
elseif strcmpi(Field, 'CSDPhaseSP')
    AM = getpv('AON11FASECSD_SP');
elseif strcmpi(Field, 'CIEPhaseAM')
    AM = getpv('AON11FASECIE_AM');
elseif strcmpi(Field, 'CIEPhaseSP')
    AM = getpv('AON11FASECIE_SP');
end