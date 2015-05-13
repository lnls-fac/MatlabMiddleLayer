function r = lnls1_cycle_correctors(varargin)
%Faz ciclagens de corretoras de �rbita do anel.
%
%History: 
%
%2011-05-02: alterado o time_step para 1.5s de forma a n�o sobrecarregar o OPR1...
%2010-09-13: coment�rios iniciais no c�digo.


if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end

r.initial_phase             = 0;
r.nr_points_in_one_period   = 21;
r.nr_periods                = 8;
r.tau_over_period           = 2; 
r.time_step                 = 1.5;
r.HCM_excluded              = [];
r.VCM_excluded              = [ ...
    'ALV02A'; 'ALV02B'; ...
    'ALV04A'; 'ALV04B'; ...
    'ALV06A'; 'ALV06B'; ...
    'ALV08A'; 'ALV08B'; ...
    'ALV10A'; 'ALV10B'; ...
    'ALV12A'; 'ALV12B'; ...
    'ACV03B' ...
];


for i=1:length(varargin)
    if ischar(varargin{i}) && strcmpi(varargin{i},'ExcludedHCM')
        r.HCM_excluded = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'ExcludedVCM')
        r.VCM_excluded = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'NrPointsInOnePeriod')
        r.nr_points_in_one_period = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'NrPeriods')
        r.nr_periods = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'TauOverPeriod')
        r.tau_over_period = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'InitialPhase')
        r.initial_phase = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'TimeStep')
        r.time_step = varargin{i+1};
    elseif ischar(varargin{i})
    end 
end


if strcmpi(getmode('BEND'), 'simulator')
    r.time_step = 0;
end

pts  = 1:(r.nr_periods * r.nr_points_in_one_period);
r.ramp = exp(- pts / (r.tau_over_period * r.nr_points_in_one_period)) .* sin(r.initial_phase + 2 * pi * pts / r.nr_points_in_one_period); 
figure;
plot(r.ramp);

r.HCMMaxSP = maxpv('HCM');
r.HCMDevList = family2dev('HCM');
idx = [];
for i=1:size(r.HCM_excluded,1)
    dev = common2dev(r.HCM_excluded(i,:));
    idx = [idx dev2elem('HCM', dev)];
end
idx = unique(idx);
if ~isempty(idx)
    r.HCMDevList(idx,:) = [];
    r.HCMMaxSP(idx) = [];
end

r.VCMMaxSP = maxpv('VCM');
r.VCMDevList = family2dev('VCM');
idx = [];
for i=1:size(r.VCM_excluded,1)
    dev = common2dev(r.VCM_excluded(i,:));
    idx = [idx dev2elem('VCM', dev)];
end
idx = unique(idx);
if ~isempty(idx)
    r.VCMDevList(idx,:) = [];
    r.VCMMaxSP(idx) = [];
end


if ~isempty(r.HCMDevList)
    r.HCM_names = cellstr(dev2common('HCM', r.HCMDevList));
else
    r.HCM_names = {};
end
if ~isempty(r.VCMDevList)
    r.VCM_names = cellstr(dev2common('VCM', r.VCMDevList));
else
    r.VCM_names = {};
end

disp([get_date_str ': in�cio da ciclagem de corretotas']);

fprintf('Par�metros de ciclagem\n\n');
disp(r);
fprintf('\n');

fprintf('Corretoras:\n');
for i=1:length(r.HCM_names)
    fprintf('%s ',r.HCM_names{i});
end
fprintf('\n');
for i=1:length(r.VCM_names)
    fprintf('%s ',r.VCM_names{i});
end
fprintf('\n');
fprintf('N�mero total de pontos: %i\n', length(r.ramp));



fprintf('Ciclando ...\n');
tic;


% zera as corretoras
if ~isempty(r.HCMDevList), setsp('HCM', 0, r.HCMDevList); end
if ~isempty(r.VCMDevList), setsp('VCM', 0, r.VCMDevList); end
sleep(r.time_step);


% loop de ciclagem
for i=1:length(r.ramp)
    if ~isempty(r.HCMDevList), setsp('HCM', r.HCMMaxSP .* r.ramp(i), r.HCMDevList); end
    if ~isempty(r.VCMDevList), setsp('VCM', r.VCMMaxSP .* r.ramp(i), r.VCMDevList); end
    sleep(r.time_step);
    drawnow;
    fprintf('%04i ', i);
    if (mod(i,10) == 0), fprintf('\n'); end
end
fprintf('\n');

% zera as corretoras
if ~isempty(r.HCMDevList), setsp('HCM', 0, r.HCMDevList); end
if ~isempty(r.VCMDevList), setsp('VCM', 0, r.VCMDevList); end
sleep(r.time_step);

toc;

disp([get_date_str ': fim da ciclagem de corretotas']);

function r = get_date_str
r = datestr(now, 'yyyy-mm-dd_HH-MM-SS'); 

