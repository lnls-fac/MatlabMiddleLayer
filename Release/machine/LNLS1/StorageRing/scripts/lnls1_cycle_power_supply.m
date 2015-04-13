function r = lnls1_cycle_power_supply(FamName,varargin)
%Faz ciclagens de fontes do anel.
%
%History: 
%
%2011-05-02:    alterado o time_step para 1.5s de forma a não sobrecarregar o OPR1...
%2010-10-20:    generalizada função para aceitar mais de um FamName (cells) e
%               DeviceList.
%2010-09-13:    comentários iniciais no código.

r.initial_phase             = 0;
r.nr_points_in_one_period   = 21;
r.nr_periods                = 8;
r.tau_over_period           = 2; 
r.time_step                 = 1.5;

if strcmpi(getmode('BEND'), 'simulator')
    r.time_step = 0;
end


pts  = 1:(r.nr_periods * r.nr_points_in_one_period);
r.ramp = exp(- pts / (r.tau_over_period * r.nr_points_in_one_period)) .* sin(r.initial_phase + 2 * pi * pts / r.nr_points_in_one_period); 
%figure;
%plot(r.ramp);

if ~isempty(varargin)
    devs_list = varargin{1};
    for i=1:length(devs_list) 
        r.DevList{i} = devs_list{i};
        r.MaxSP{i} = maxpv(FamName{i}, r.DevList{i});
    end
else
    r.DevList = family2dev(FamName);
    r.MaxSP = maxpv(FamName);
end



% zera as fontes
if iscell(FamName)
    for j=1:length(FamName)
        if ~isempty(r.DevList{j}), setsp(FamName{j}, 0, r.DevList{j}); end
    end
else
    if ~isempty(r.DevList), setsp(FamName, 0, r.DevList); end
end
sleep(r.time_step);

% loop de ciclagem
for i=1:length(r.ramp)
    if iscell(FamName)
        for j=1:length(FamName)
            if ~isempty(r.DevList{j}), setsp(FamName{j}, r.MaxSP{j} .* r.ramp(i), r.DevList{j}); end
        end
    else
        if ~isempty(r.DevList), setsp(FamName, r.MaxSP .* r.ramp(i), r.DevList); end
    end
    sleep(r.time_step);
    drawnow;
    fprintf('%04i ', i);
    if (mod(i,10) == 0), fprintf('\n'); end
end
fprintf('\n');

% zera as fontes
if iscell(FamName)
    for j=1:length(FamName)
        if ~isempty(r.DevList{j}), setsp(FamName{j}, 0, r.DevList{j}); end
    end
else
    if ~isempty(r.DevList), setsp(FamName, 0, r.DevList); end
end
sleep(r.time_step);