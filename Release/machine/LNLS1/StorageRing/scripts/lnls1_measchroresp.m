function lnls1_measchroresp
% Medida de matriz resposta de cromaticidade
%
% História:
%
% 2015-09-18: versão inicial.
%

disp([get_date_str ': início da medida de matriz resposta de cromaticidade']);

if strcmpi(getmode('BEND'), 'Online')
    lnls1_slow_orbcorr_off; % turn auto orbit correction at OPR1 off
    lnls1_fast_orbcorr_off; % turn auto orbit correction at OPR1 off
    lnls1_grff02_set_on; % set RF Generator Tandem on machine experiment mode
end

measchroresp;

disp([get_date_str ': fim da medida de matriz resposta de cromaticidade']);
