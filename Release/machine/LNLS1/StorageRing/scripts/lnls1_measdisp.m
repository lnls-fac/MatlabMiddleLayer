function lnls1_measdisp(varargin)
%Medida de fun??o dispers?o.
%
%Hist?ria:
%
%2011-04-05: comentada linha que coloca MML no modo online.
%2010-09-13: coment?rios iniciais no c?digo.
%

%if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end

disp([get_date_str ': inicio da medida de funcao de dispersao']);

if strcmpi(getmode('BEND'), 'Online')
    lnls1_slow_orbcorr_off;  % turn auto orbit correction at OPR1 off
    lnls1_fast_orbcorr_off;  % turn auto orbit correction at OPR1 off
    lnls1_grff02_set_on; % set RF Generator Tandem on machine experiment mode
end

nr_points = 5;
reading_interval = 0.5;
setbpmaverages(reading_interval,nr_points);

if isempty(varargin)
    measdisp('Archive');
else
    measdisp(varargin{:});
end

disp([get_date_str ': fim da medida de funcao de dispersao']);
