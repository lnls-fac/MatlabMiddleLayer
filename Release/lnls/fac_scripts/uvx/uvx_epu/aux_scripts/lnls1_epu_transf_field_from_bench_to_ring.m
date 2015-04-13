function epu_field_data = lnls1_epu_transf_field_from_bench_to_ring

% le dados de medidas em arquivo, se já não estão carregados.
epu_field_data = getappdata(0, 'EPU_FIELD_DATA');
if isempty(epu_field_data)
    epu_field_data = lnls1_epu_read_field_measurements;
elseif isfield(epu_field_data(1).bx, 'period')
    return;
end

% O EPU foi instalado no anel rotacionado em 180 graus em torno do eixo
% vertical com relação às medidas em bancada. Esta rotina se encarrega de
% fazer a conversão BENCH -> RING do sistema de coordenadas e dos campos.


for i=1:length(epu_field_data)
    % faz transformações de coordenadas
    
    % coordenadas longitudinais
    epu_field_data(i).bx.pos.data = flipud(-epu_field_data(i).bx.pos.data(:));
    epu_field_data(i).by.pos.data = flipud(-epu_field_data(i).by.pos.data(:));
    epu_field_data(i).bz.pos.data = flipud(-epu_field_data(i).bz.pos.data(:));
    
    % componentes de campo
    epu_field_data(i).bx.field.data = flipud(-epu_field_data(i).bx.field.data(:));
    epu_field_data(i).by.field.data = flipud(-epu_field_data(i).by.field.data(:)); 
    epu_field_data(i).bz.field.data = flipud(epu_field_data(i).bz.field.data(:)); 
    
    % calculo periodo e centro de cada componente de campo 
    [epu_field_data(i).bx.center epu_field_data(i).bx.period] =  get_center_and_period(epu_field_data(i).bx);
    [epu_field_data(i).by.center epu_field_data(i).by.period] =  get_center_and_period(epu_field_data(i).by);
    [epu_field_data(i).bz.center epu_field_data(i).bz.period] =  get_center_and_period(epu_field_data(i).bz);
    
    % muda sinal de fase dos cassetes
    % fase positiva em bancada significa fase negativa no anel.
    epu_field_data(i).phase_csd = -epu_field_data(i).phase_csd;
    epu_field_data(i).phase_cie = -epu_field_data(i).phase_cie;
    
    epu_field_data(i).ring_ref_system = true;
end

    
setappdata(0, 'EPU_FIELD_DATA', epu_field_data);

function [center period] = get_center_and_period(config)

pos      = config.pos.data;
field    = config.field.data;

% acha os indices dos pontos onde o campo muda de sinal.
% para evitar regiões onde o campo é composto de ruído consideram-se apenas
% pontos nos quais a variação de campo seja maior que 50% do rms.
idx_zeros = find((field(2:end) .* field(1:end-1) <= 0));
delta_field = field(idx_zeros+1) - field(idx_zeros);
rms = sqrt(sum(delta_field .^ 2)/length(delta_field));
selection = abs(delta_field) >= 0.5 * rms;
idx_zeros = idx_zeros(selection);

%plot(config.pos.data, config.field.data);
%hold all;
%scatter(config.pos.data(idx_zeros), config.field.data(idx_zeros));
%scatter(config.pos.data(idx_zeros+1), config.field.data(idx_zeros+1));

% a partir dos indices interpola posições onde campo se anula
p1 = pos(idx_zeros);
p2 = pos(idx_zeros+1);
f1 = field(idx_zeros);
f2 = field(idx_zeros+1);
centers = p1 - (p2 - p1) .* (f1 ./ (f2 - f1));
%f = f1 + (centers - p1) .* (f2 - f1) ./ (p2 - p1);
%scatter(centers, f);

% usa posição do ponto central como centro do ondulador.
idx_center = ceil(length(centers)/2);
center = centers(idx_center);


% para calculo do periodo usa subconjunto %50 mais centralizado
selection_centers = centers((idx_center - floor(length(centers)/4)):(idx_center + ceil(length(centers)/4)));
period = 2 * (selection_centers(end) - selection_centers(1))/(length(selection_centers)-1);


