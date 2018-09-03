function [machine, r_bpms] = set_medidas(machine, par, r, name_bpm, name_scrn, n_scrn)

if name_scrn
    [machine, r_scrn] = screen(machine, r, n_scrn, par.sigma_scrn);
end

if name_bpm
    [r_bpms, bpm] = bpms(machine, r, par.sigma_bpm);
end

    function [machine, r_scrn] = screen(machine, r, n_scrn, sigma_scrn)
            if n_scrn > 3
                error('Existem apenas 3 screens no booster!')
            end
            scrn = findcells(machine, 'FamName', 'Scrn');
            scrn = scrn(n_scrn);
            r_scrn = r([1,3], :, scrn);
            sigma_scrn_x = lnls_generate_random_numbers(sigma_scrn, 1, 'norm');
            sigma_scrn_y = lnls_generate_random_numbers(sigma_scrn, 1, 'norm'); 
            sigma_scrn = [sigma_scrn_x; sigma_scrn_y];
            r_scrn = nanmean(r_scrn, 2) + sigma_scrn;
            machine = setcellstruct(machine, 'VChamber', scrn:length(machine), 0, 1, 1);
            fprintf('Posicao x da Screen: %f mm\n', r_scrn(1)*1e3);
            fprintf('Posicao y da Screen: %f mm\n', r_scrn(2)*1e3);
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

            VChamb = cell2mat(getcellstruct(machine, 'VChamber', bpm))';
            VChamb = VChamb([1, 2], :);

            %For each element compares if x or y position ir greater than the vacuum
            %chamber limits
            ind_bpm = bsxfun(@gt, abs(r_bpms), VChamb);

            or = ind_bpm(1, :) | ind_bpm(2, :);
            ind_bpm(1, :) = or;
            ind_bpm(2, :) = or;
            ind_bpm = cumsum(ind_bpm, 2);
            % r_bpms(ind_bpm >= 1) = NaN;
    end
end

