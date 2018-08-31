function simulate_injection_booster(ring, n_part, name_bpm, name_scrn, n_scrn)

[machine, param, s]  = set_machine(ring);

% r_final = sirius_booster_injection(machine, param, n_part);
if ~exist('name_bpm','var'), name_bpm = 0; end
if ~exist('name_scrn','var'), name_scrn = 0; n_scrn = 0; end
if ~exist('n_scrn','var'), error('Escolha uma screen entre 1, 2 e 3 \n'); end

if name_scrn
    
    if n_scrn > 3
                error('Existem apenas 3 screens no booster! \n')
    end
    
    scrn = findcells(machine, 'FamName', 'Scrn');
    scrn = scrn(n_scrn);
    
    machine = setcellstruct(machine, 'VChamber', scrn:length(machine), 0, 1, 1);
    machine = setcellstruct(machine, 'VChamber', scrn:length(machine), 0, 1, 2);
    
    r_final = sirius_booster_injection(machine, param, n_part);
    
    sigma_scrn = param.sigma_scrn;    
    r_scrn = r_final([1,3], :, scrn);
    sigma_scrn_x = lnls_generate_random_numbers(sigma_scrn, 1, 'norm');
    sigma_scrn_y = lnls_generate_random_numbers(sigma_scrn, 1, 'norm'); 
    sigma_scrn = [sigma_scrn_x; sigma_scrn_y];
    r_scrn = nanmean(r_scrn, 2) + sigma_scrn;

    fprintf('Posicao x da Screen: %f mm\n', r_scrn(1)*1e3);
    fprintf('Posicao y da Screen: %f mm\n', r_scrn(2)*1e3);
end

if name_bpm
    [r_bpms, bpm] = bpms(machine, r_final, param.sigma_bpm);
end
 
    function [r_bpms, bpm] = bpms(machine, r, sigma0)
            bpm = findcells(machine, 'FamName', 'BPM');
            r_bpms = r(:, :, bpm);

            N_t = size(r, 2);
            N_loss = squeeze(sum(isnan(r(1,:, bpm))));
            Rate = (N_t - N_loss) / N_t;
            sigma = ( sigma0 ./ Rate )';
            sigma_bpm_x = lnls_generate_random_numbers(1, length(sigma), 'norm') .* sigma;   
            sigma_bpm_y = lnls_generate_random_numbers(1, length(sigma), 'norm') .* sigma;  

            errors_bpm = [sigma_bpm_x; sigma_bpm_y];

            r_bpms = squeeze(nanmean(r_bpms, 2)) + errors_bpm;
          
            x_bpm = squeeze(nanmean(r_bpms(1, :), 2));
            
            VChamb_bpm = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
            VChamb_bpm = VChamb_bpm([1, 2], :);
            VChamb_bpm = reshape(VChamb_bpm, 2, [], length(machine));
    
            figure;
            plot(s, (x_bpm), '.-r');
            hold all
            plot(s, VChamb_bpm(1,:),'k');
            plot(s, -VChamb_bpm(1,:),'k');
    end

r_final = sirius_booster_injection(machine, param, n_part);

VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
VChamb = VChamb([1, 2], :);
VChamb = reshape(VChamb, 2, [], length(machine));

xy_final = r_final([1, 3], :, :);
ind = bsxfun(@gt, abs(xy_final), VChamb);

or = ind(1, :, :) | ind(2, :, :);
ind(1, :, :) = or;
ind(2, :, :) = or;
ind_sum = cumsum(ind, 3);

xy_final(ind_sum >= 1) = NaN;

r_final([1, 3], :, :) = xy_final;

xx = squeeze(nanmean(r_final(1, :, :), 2));
% xx = squeeze(r_final(1, :, :));
% xx = squeeze(nanstd(r_final(1, :, :), 0, 2));

%plot(s, (xx+sxx)', 'r --');
%hold all
%plot(s, (xx-sxx)', 'r --');

% x = squeeze(nanmean(r_final(1, :, bpm), 2));
% x_bpm = r_bpms(1,:);


    
% figure;
plot(s, (xx)', '.-r');
hold all
% plot(s, (x_bpm), '.-r');
plot(s, VChamb(1,:),'k');
plot(s, -VChamb(1,:),'k');
    
n_perdida = sum(isnan(r_final(1,:, end)));
fprintf('%i particulas perdidas de %i (%g %%) \n', n_perdida, n_part, (n_perdida / n_part)*100);

end

