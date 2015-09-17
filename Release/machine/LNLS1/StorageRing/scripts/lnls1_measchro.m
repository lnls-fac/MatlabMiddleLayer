function lnls1_measchro(varargin)
% Medida de cromaticidade
%
% História:
%
% 2015-09-17: versão inicial.
%

disp([get_date_str ': início da medida de cromaticidade']);

if strcmpi(getmode('BEND'), 'Online')
    lnls1_slow_orbcorr_off; % turn auto orbit correction at OPR1 off
    lnls1_fast_orbcorr_off; % turn auto orbit correction at OPR1 off
    lnls1_grff02_set_on; % set RF Generator Tandem on machine experiment mode
end

if isempty(varargin)
    measchro('Archive');
else
    measchro(varargin{:});
end

disp([get_date_str ': fim da medida de cromaticidade']);

function r = get_date_str
r = datestr(now, 'yyyy-mm-dd_HH-MM-SS'); 
