function epu_field_data = lnls1_epu_calc_field_parameters


epu_field_data = getappdata(0, 'EPU_FIELD_DATA');
if isempty(epu_field_data) || ~isfield(epu_field_data, 'ring_ref_system')
    epu_field_data = lnls1_epu_transf_field_from_bench_to_ring;
end

for i=1:length(epu_field_data)
    epu_field_data(i).bx = calc_parameters(epu_field_data(i).bx);
    epu_field_data(i).by = calc_parameters(epu_field_data(i).by);
    epu_field_data(i).bz = calc_parameters(epu_field_data(i).bz);
    % baseado nas amplitudes define periodo do campo a partir da componente principal
    amps = [epu_field_data(i).bx.amplitude epu_field_data(i).by.amplitude epu_field_data(i).bz.amplitude];
    peri = [epu_field_data(i).bx.period epu_field_data(i).by.period epu_field_data(i).bz.period];
    [~,idx] = max(amps);
    epu_field_data(i).main_component_idx = idx;
    epu_field_data(i).period = peri(idx);
    
end

% redefine origem do sistema de coordenadas e define periodo da componente
% principal
center = NaN;
max_amplitude = 0;
for i=1:length(epu_field_data)
    amps = [epu_field_data(i).bx.amplitude epu_field_data(i).by.amplitude epu_field_data(i).bz.amplitude];
    cens = [epu_field_data(i).bx.center epu_field_data(i).by.center epu_field_data(i).bz.center];
    [maxa,idx] = max(amps);
    if maxa > max_amplitude
        max_amplitude = maxa;
        center = cens(idx);
    end
end
for i=1:length(epu_field_data)
    epu_field_data(i).bx.center = epu_field_data(i).bx.center - center;
    epu_field_data(i).by.center = epu_field_data(i).by.center - center;
    epu_field_data(i).bz.center = epu_field_data(i).bz.center - center;
    epu_field_data(i).bx.pos.data = epu_field_data(i).bx.pos.data - center;
    epu_field_data(i).by.pos.data = epu_field_data(i).by.pos.data - center;
    epu_field_data(i).bz.pos.data = epu_field_data(i).bz.pos.data - center;
end

setappdata(0, 'EPU_FIELD_DATA', epu_field_data);




function field = calc_parameters(field0)

field = field0;

period = field.period;
p = field.pos.data;
f = field.field.data;

field.pos.min   = min(p);
field.pos.max   = max(p);
field.field.min = min(f);
field.field.max = max(f);

% seleciona apenas 50% do campo mais proximo ao centro do ondulador para
% analise posterior.
selection = (abs(p - field.center) <= 0.25 * (field.pos.max - field.pos.min));

p = p(selection)';
f = f(selection)';

s = sin(2*pi*p/period);
c = cos(2*pi*p/period);
m = [s*s' s*c'; c*s' c*c'];
b = [s*f'; c*f'];
field.amplitude = norm(m \ b);
