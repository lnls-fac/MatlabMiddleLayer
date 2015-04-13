function epu = lnls1_epu_set_config(epu0, gap_upstream, gap_downstream, phase_csd, phase_cie)

epu = epu0;

% interpola vetores de magnetização
[gap phase cphase] = lnls1_epu_project_configuration(gap_upstream, gap_downstream, phase_csd, phase_cie);
if (gap < 22)
    disp('Warning: gap smaller than minimum value....');
    gap = 22;
end

mags = zeros(length(epu.interpolation.phase_InterpF), 1);
if (abs(phase)>=abs(cphase))
    for i=1:length(mags)
        mags(i) = epu.interpolation.phase_InterpF{i}(gap, phase);
    end
else
    for i=1:length(mags)
        mags(i) = epu.interpolation.cphase_InterpF{i}(gap, cphase);
    end
end
mags = reshape(mags, 3, []);

% cria/ajusta modelo do EPU de acordo com config;
addpath('c:\Arq\MatlabMiddleLayer\Release\lnls\fac_scripts\epu');
if ~isfield(epu, 'model'), epu.model = epu.data(1).model; end
epu.model = epu_set_config(epu.model, gap_upstream, gap_downstream, phase_csd, phase_cie);
tags = epu_get_tags_list(epu.model);
epu.model = epu_set_mag(epu.model, tags, mags);