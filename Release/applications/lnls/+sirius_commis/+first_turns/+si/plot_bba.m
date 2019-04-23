function bba_analy = plot_bba(bba_data, n_mach, loop, plt)

if loop
    for i = 1:n_mach
        bba_analy{i} = analy(bba_data, i, plt);
        bba_before(i, :) = bba_analy{i}.dif_nobba_std;
        bba_after(i, :) = bba_analy{i}.dif_bba_std;
    end
    bba_after_mx = squeeze(mean(bba_after(:, 1)));
    bba_after_my = squeeze(mean(bba_after(:, 2)));
    bba_before_mx = squeeze(mean(bba_before(:, 1)));
    bba_before_my = squeeze(mean(bba_before(:, 2)));
    
    fprintf('Machines Stat RMS Offset Before BBA X: %f um Y: %f um \n', bba_before_mx, bba_before_my);
    fprintf('Machines Stat RMS Offset After BBA X: %f um Y: %f um \n ', bba_after_mx, bba_after_my);
    fprintf('Machines Stat RMS Offset Reduction Factor X: %f Y: %f \n \n ', bba_before_mx / bba_after_mx, bba_before_my/ bba_after_my);
else
    bba_analy = analy(bba_data, n_mach, plt);
    bba_before = bba_analy.dif_nobba_std;
    bba_after = bba_analy.dif_bba_std;
    fprintf('Machines Stat RMS Offset Before BBA X: %f um Y: %f um \n', bba_before(1),  bba_before(2));
    fprintf('Machines Stat RMS Offset After BBA X: %f um Y: %f um \n ', bba_after(1),  bba_after(2));
    fprintf('Machines Stat RMS Offset Reduction Factor X: %f Y: %f \n \n', bba_before(1)/bba_after(1),  bba_before(2)/bba_after(2));
end
    
end

function bba_analy = analy(bba_data, n_mach, plt)
        % off1 = bba_data.off_bba1; off1 = off1{n_mach}; off1(off1 == 0) = NaN;
        % off2 = bba_data.off_bba2; off2 = off2{n_mach}; off2(off2 == 0) = NaN;
        off1f = bba_data.off_bba1f; off1f = off1f{n_mach}; off1f(off1f == 0) = NaN;
        % off2f = bba_data.off_bba2f; off2f = off2f{n_mach}; off2f(off2f == 0) = NaN;
        off_bpm = bba_data.off_bpm; off_bpm = off_bpm{n_mach}; 
        off_quad = bba_data.off_quad; off_quad = off_quad{n_mach};
        um = 1e6;


        bba_real = off_quad - off_bpm;
        bba_real(isnan(off1f)) = NaN;
        new_off_bpm = off_bpm + off1f;
        bba_obt = off_quad - new_off_bpm;
        bba_obt(isnan(off1f)) = NaN;
        
        if plt
            figure;
            subplot(2,1,1);
            % plot(off1(:, 1) * um, 'o');
            xlabel('BPM Number')
            ylabel('X Offset [um]');
            hold on
            plot(off1f(:, 1) * um, 'o');
            % plot(off2(:, 1) * um, 'o');
            % plot(off2f(:, 1) * um, 'o');
            plot(bba_real(:, 1) * um, '-o');
            % legend('Linear Tracking', 'Linear Fitting', 'Quadratic Tracking', 'Quadratic Fitting', 'Real Value');
            grid on

            subplot(2,1,2);
            % plot(off1(:, 2) * um, 'o');
            xlabel('BPM Number')
            ylabel('Y Offset [um]');
            hold on
            plot(off1f(:, 2) * um, 'o');
            % plot(off2(:, 2) * um, 'o');
            % plot(off2f(:, 2) * um, 'o');
            plot(bba_real(:, 2) * um, '-o');
            % legend('Linear Tracking', 'Linear Fitting', 'Quadratic Tracking', 'Quadratic Fitting', 'Real Value');
            grid on
        end

        % dif1 = abs(off1) - abs(bba_real);
        % dif2 = abs(off2) - abs(bba_real);
        dif1f = abs(off1f) - abs(bba_real);
        % dif2f = abs(off2f) - abs(bba_real);
        
        bba_analy.dif_nobba_mean = nanmean(bba_real)*um;
        bba_analy.dif_nobba_std = nanstd(bba_real)*um;
        
        bba_analy.dif_bba_mean = nanmean(bba_obt)*um;
        bba_analy.dif_bba_std = nanstd(bba_obt)*um;


        % bba_analy.dif1m = nanmean(dif1) * um; bba_analy.dif1r = nanstd(dif1) * um; 
        % bba_analy.dif2m = nanmean(dif2) * um; bba_analy.dif2r = nanstd(dif2) * um;
        bba_analy.dif1fm = nanmean(dif1f) * um; bba_analy.dif1fr = nanstd(dif1f) * um;
        % bba_analy.dif2fm = nanmean(dif2f) * um; bba_analy.dif2fr = nanstd(dif2f) * um;
        
        if plt
            figure;
            subplot(2,1,1);
            % plot(dif1(:, 1) * um, 'o');
            xlabel('BPM Number')
            ylabel('Diff X Offset [um]');
            hold on
            plot(dif1f(:, 1) * um, 'o');
            % plot(dif2(:, 1) * um, 'o');
            % plot(dif2f(:, 1) * um, 'o');
            % legend('Linear Tracking', 'Linear Fitting', 'Quadratic Tracking', 'Quadratic Fitting');
            grid on

            subplot(2,1,2);
            % plot(dif1(:, 2) * um, 'o');
            xlabel('BPM Number')
            ylabel('Diff Y Offset [um]');
            hold on
            plot(dif1f(:, 2) * um, 'o');
            % plot(dif2(:, 2) * um, 'o');
            % plot(dif2f(:, 2) * um, 'o');
            % legend('Linear Tracking', 'Linear Fitting', 'Quadratic Tracking', 'Quadratic Fitting');
            grid on
        end

end


