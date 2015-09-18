function lnls1_monbpm(varargin)
%Mede flutuação dos BPMs
%
%História:
%
%2010-09-13: comentários iniciais no código.
%

nr_points = 1;
reading_interval = 0.0;

%if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end

if strcmpi(getmode('BEND'), 'Online')
    lnls1_slow_orbcorr_off;
    lnls1_fast_orbcorr_off;
end
setbpmaverages(reading_interval,nr_points);

disp([get_date_str ': início da medida de flutuação dos bpms']);

if isempty(varargin)
    monbpm([], 'Archive', '');
else
    monbpm(varargin{:});
end

disp([get_date_str ': fim da medida de flutuação dos bpms']);
