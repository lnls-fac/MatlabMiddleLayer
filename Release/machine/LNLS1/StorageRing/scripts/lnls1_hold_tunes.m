function r = lnls1_hold_tunes(varargin)
%Rotina que lê e atua continuamente sobre shunts de quadrupolos de forma a manter as sintonias do anel paradas.
%
%History: 
%
%2010-09-13: comentários iniciais no código.


% default values for input paramaters
r.nrpts_tunes_stats = 1;
r.meas_tunes_delay  = 0.1;

if ~isempty(varargin)
    fnames = fieldnames(varargin{1});
    for i=1:length(fnames)
        r.(fnames{i}) = varargin{1}.(fnames{i});
    end
end

lnls1_quad_shunts_on;

r.actuator_family = findmemberof('Tune Corrector');
for i=1:length(r.actuator_family)
    r.QMS(i).QuadFamily = r.actuator_family{i};
    r.QMS(i).QuadDev = family2dev(r.actuator_family{i}); 
end

r.tuneresp        = gettuneresp;
r.measurements{1} = get_measurement(r);
r.shunts{1}       = getpv('QUADSHUNT', 'Setpoint');

[U, S, V]       = svd(r.tuneresp, 'econ');
MT              = diag(diag(S).^(-1)) * U';

r.measurements{1}.Tune = r.measurements{1}.Tune + [0.01; 0];

while ~evalin('base', 'exist(''abort_event'')') || ~evalin('base','abort_event')

    n = length(r.measurements);
    r.measurements{n+1} = get_measurement(r);
    delta_tune = r.measurements{1}.Tune - r.measurements{end}.Tune;
  %  delta_tune = delta_tune + 0.000001;
    
    if sum(abs(delta_tune)) == 0, continue; end 
    TUNECoef   = MT * delta_tune;
    quad_delta = V * TUNECoef;
    
    quad_delta = quad_delta * r.measurements{n+1}.GeV / r.measurements{1}.GeV;
    for i=1:length(r.actuator_family)
        setquad(r.QMS(i), r.measurements{n+1}.QuadValues{i} + quad_delta(i));
    end
    
    %shunts_delta_currents = get_shunts_delta_current(quad_delta, actuator_family);
    %steppv('QUADSHUNT', shunts_delta_currents);
    r.shunts{n+1} = getpv('QUADSHUNT', 'Setpoint');
    
    pause(0);
    drawnow;
end

[FileName,PathName,FilterIndex] = uiputfile({'*.mat'}, 'Gravar Dados', '');
if ~(FileName == 0)
    file_name = fullfile(PathName, FileName);
    save(file_name, r);
end

function r = get_measurement(rinit)
    r.TimeStamp = now;
    Amp         = getpv('BEND', 'Monitor', [1 1]);
    r.GeV       = bend2gev('BEND', 'Monitor', Amp, [1 1]);
    for i=1:length(rinit.actuator_family)
        r.QuadValues{i} = getsp(rinit.actuator_family{i});
    end
    r.Tune      = get_tune_stats(rinit);


function r = get_shunts_delta_current(quad_delta, actuator_family)

r = zeros(length(family2elem('QUADSHUNT')), 1);
for i=1:length(actuator_family)
    common_names  = family2common(actuator_family{i});
    device_number = common2dev(common_names, 'QUADSHUNT');
    element_index = dev2elem('QUADSHUNT', device_number);
    r(element_index) = quad_delta(i);
end



function r = get_tune_stats(p)

r = p;
tunes_meas = zeros(2,r.nrpts_tunes_stats);
for i=1:r.nrpts_tunes_stats
    tunes_meas(:,i) = gettune;
    pause(0);
    drawnow;
    if ((i<r.nrpts_tunes_stats) && strcmpi(getmode('BEND'), 'Online')), pause(r.meas_tunes_delay); end
end
r = median(tunes_meas,2);