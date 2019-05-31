function kick_fit = fit_kick_corrector(ring, plane, corr_num, plt, coupling, erro_in)

sirius_commis.common.initializations();
len = length(ring);
ring = shift_ring(ring, 'InjSept');
fam = sirius_bo_family_data(ring);
% ring = lnls_correct_tunes(ring, [19.204, 7.314 + 0.3], {'QF','QD'}, 'svd', 'add', 10, 1e-9)
mm = 1e-3;
mrad = 1e-3;
kick = 100e-6;

if ~exist('plt', 'var')
    flag_plot = false;
elseif strcmp(plt, 'plot')
    flag_plot = true;
elseif strcmp(plt, 'noplot')
    flag_plot = false;
else
    error('Set flag plot or noplot');
end

if ~exist('coupling', 'var')
    flag_coup = false;
elseif strcmp(coupling, 'coupling')
    flag_coup = true;
elseif strcmp(coupling, 'nocoupling')
    flag_coup = false;
else
    error('Set flag coupling or nocoupling');
end

if flag_coup
    config.fams.quads.labels     = {'QF', 'QD', 'QS'};
    config.fams.quads.sigma_roll = 4.65 * 0.800 * mrad;
    families = fieldnames(config.fams);
    for i=1:length(families)
        family = families{i};
        labels = config.fams.(family).labels;
        config.fams.(family).nrsegs = zeros(1,length(labels));
        for j=1:length(labels)
            config.fams.(family).nrsegs(j) = fam.(labels{j}).nr_segs;
        end
    end
    name = 'CONFIG';
    nr_machines   = 10;
    rndtype       = 'gaussian';
    cutoff_errors = 100;
    fractional_delta = 1;
    errors        = lnls_latt_err_generate_errors(name, ring, config, nr_machines, cutoff_errors, rndtype);
    errors.errors_roll(4, erro_in(1, :) == 0) = 0;
    errors.errors_roll(4, (abs(erro_in(1, :)) < 5e-3)) = 0;
    ring = lnls_latt_err_apply_errors(name, ring, errors, fractional_delta);
end

[file, path] = uigetfile('*.txt', '*.dat', '/home/murilo/Desktop/screens-iocs/');
fileid = fopen(strcat(path, file));
data = textscan(fileid, '%f %f', 'delimiter', '', 'HeaderLines', 2);
dif_orbx = data{1} * mm; dif_orby = data{2} * mm;

for i = 4
    the_ring = ring{i};

if strcmp(plane, 'x')
    ring_kick = lnls_set_kickangle(the_ring, kick, fam.CH.ATIndex(corr_num), plane);
    if flag_coup
        % ring_kick = lnls_set_kickangle(ring_kick, kick, fam.CH.ATIndex(corr_num), 'y');
    end 
elseif strcmp(plane, 'y')
    ring_kick = lnls_set_kickangle(the_ring, kick, fam.CV.ATIndex(corr_num), plane);
    if flag_coup
        % ring_kick = lnls_set_kickangle(ring_kick, kick, fam.CV.ATIndex(corr_num), 'x');
    end
end

% ring_kick = lnls_set_kickangle(ring_kick, kick, fam.CH.ATIndex(1), 'y');
cod = findorbit(the_ring, 0, 1:len+1);   
cod_kick = findorbit(ring_kick, 0, 1:len+1);

dif_cod = (cod - cod_kick)./ mm ;

if strcmp(plane, 'x')
    Ax = dot(dif_cod(1, fam.BPM.ATIndex)', dif_orbx);
    Bx = dot(dif_cod(1, fam.BPM.ATIndex), dif_cod(1, fam.BPM.ATIndex));
    scalex = Ax/Bx;
    kickx_fit = kick * scalex;
    
    if flag_coup
        
        Ay = dot(dif_cod(3, fam.BPM.ATIndex)', dif_orby);
        By = dot(dif_cod(3, fam.BPM.ATIndex), dif_cod(3, fam.BPM.ATIndex));
        scaley = Ay/By;
        % kicky_fit = kick * scaley;
        % k_fit = kicky_fit / kickx_fit;
        % fprintf('Fitted Coupling: %f %% \n', k_fit * 100);
        
    end
   
    if flag_plot
        figure; 
        plot(dif_orbx, '--o', 'LineWidth', 2);
        hold on;
        plot(dif_cod(1, fam.BPM.ATIndex) .* scalex, '-o', 'LineWidth', 2);
        legend('Measurement', 'Model');
        strx = {strcat('Horizontal - Fitted Kick =', num2str(kickx_fit * 1e6), 'urad')};
        title(strx{1})
        xlabel('BPM Index')
        ylabel('COD Diff [mm]')
        
        if flag_coup
            figure; 
            plot(dif_orby, '--o', 'LineWidth', 2);
            hold on;
            plot(dif_cod(3, fam.BPM.ATIndex), '-o', 'LineWidth', 2);
            legend('Measurement', 'Model');
            % stry = {strcat('Vertical - Fitted Kick = ', num2str(kicky_fit * 1e6), 'urad')};
            title('Vertical')
            xlabel('BPM Index')
            ylabel('COD Diff [mm]')
        end
    end

    kick_fit = kickx_fit;
end

if strcmp(plane, 'y')
    Ay = dot(dif_cod(3, fam.BPM.ATIndex)', dif_orby);
    By = dot(dif_cod(3, fam.BPM.ATIndex), dif_cod(3, fam.BPM.ATIndex));
    scaley = Ay/By;
    
    kicky_fit = kick * scaley;
    
    if flag_coup
        Ax = dot(dif_cod(3, fam.BPM.ATIndex)', dif_orby);
        Bx = dot(dif_cod(3, fam.BPM.ATIndex), dif_cod(3, fam.BPM.ATIndex));
        scalex = Ax/Bx;
        kickx_fit = kick * scalex;
        k_fit = kickx_fit / kicky_fit;
        fprintf('Fitted Coupling: %i %% \n', k_fit * 100);
    end
    
    if flag_plot
        figure; 
        plot(dif_orby, '--o', 'LineWidth', 2);
        hold on;
        plot(dif_cod(3, fam.BPM.ATIndex) .* scaley, '-o', 'LineWidth', 2);
        legend('Measurement', 'Model');
        stry = {strcat('Vertical - Fitted Kick = ', num2str(kicky_fit * 1e6), 'urad')};
        title(stry{1})
        xlabel('BPM Index')
        ylabel('COD Diff [mm]')
        
        if flag_coup
            figure; 
            plot(dif_orbx, '--o', 'LineWidth', 2);
            hold on;
            plot(dif_cod(1, fam.BPM.ATIndex) .* scalex, '-o', 'LineWidth', 2);
            legend('Measurement', 'Model');
            strx = {strcat('Horizontal - Fitted Kick = ', num2str(kickx_fit * 1e6), 'urad')};
            title(strx{1})
            xlabel('BPM Index')
            ylabel('COD Diff [mm]')
        end
    end
    
    kick_fit = kicky_fit;
end
end
end