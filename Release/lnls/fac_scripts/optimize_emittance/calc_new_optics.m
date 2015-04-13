function [valid new_optics] = calc_new_optics(r)

global THERING;

% calcula estabilidade
new_optics = atsummary;
tmp = calc_constraints_LowEmittanceTunes;
new_optics.asymmetry = sum(tmp(3:end).^2);
new_optics.THERING = THERING;

valid = false;

% something very wrong
fnames = fieldnames(new_optics);
for i=1:length(fnames)
    data = new_optics.(fnames{i});
    if isstruct(data)
        fnames2 = fieldnames(data);
        for j=1:length(fnames2)
            if any(isnan(data.(fnames2{j}))) | any(imag(data.(fnames2{j})))
                return;
            end
        end
    elseif iscell(data)
    else
        if any(isnan(new_optics.(fnames{i}))) | any(imag(new_optics.(fnames{i})))
            return;
        end
    end
end

% sintonias reais
if any(imag(new_optics.tunes))    
    return;
end

% betas máximos
if any(new_optics.twiss.beta(:,1) > r.constraints.beta.max_betax)
    return;
end
if any(new_optics.twiss.beta(:,2) > r.constraints.beta.max_betay)
    return;
end

% eta maximo
if any(abs(new_optics.twiss.Dispersion(:,1)) > r.constraints.eta.max)
    return;
end

% eta nos centros dos trechos retos
ML = findcells(THERING, 'FamName', 'ML');
MM = findcells(THERING, 'FamName', 'MM');
MS = findcells(THERING, 'FamName', 'MS');
eta_max = max(abs(new_optics.twiss.Dispersion([ML MM MS],1)));
if eta_max > r.constraints.eta.max_at_straight_center
    return;
end

% K máximo
idx = findcells(new_optics.THERING, 'K');
K = getcellstruct(new_optics.THERING, 'K', idx);
if max(abs(K)) > r.constraints.K.max
    return;
end;


% chegou até aqui então nova ótica é válida
valid = true;
