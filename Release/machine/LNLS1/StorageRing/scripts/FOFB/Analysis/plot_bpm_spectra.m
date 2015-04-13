function plot_bpm_spectra(bpm_position_spectral_data, bpm_names, freq_range)

n_bpms = size(bpm_position_spectral_data(1).psd, 2)/2;

colors = copper(length(bpm_position_spectral_data));
colors = [0 0 1];

% PSD amplitude range (um^2/Hz) (for visualization
aux = [bpm_position_spectral_data.psd];
aux = aux((bpm_position_spectral_data(1).frequencies <= freq_range(2)),:);
amplitude_range_psd = [10^floor(log10((min(min(aux))))) 10^ceil(log10((max(max([bpm_position_spectral_data.psd])))))];

% Integrated RMS amplitude range (um) (for visualization)
amplitude_range_integrated_rms = [0 ceil((max(max([bpm_position_spectral_data.integrated_rms]))))+10];

for i=1:n_bpms
    fig = figure;
    set(fig,'Name',[bpm_names{i} ' - ' bpm_names{i+n_bpms}],'NumberTitle','off');

    subplot(221);
    for j=1:length(bpm_position_spectral_data)
        semilogy(bpm_position_spectral_data(j).frequencies, bpm_position_spectral_data(j).psd(:,i), 'Color', colors(j,:));
        hold on;
    end
    axis([freq_range amplitude_range_psd])
    grid on;
    title(bpm_names{i},'FontSize',12,'FontWeight','bold');
    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');
    ylabel('Position PSD (um^2/Hz)','FontSize',12,'FontWeight','bold');

    subplot(222);
    for j=1:length(bpm_position_spectral_data)
        plot(bpm_position_spectral_data(j).frequencies, bpm_position_spectral_data(j).integrated_rms(:,i), 'Color', colors(j,:));
        hold on;
    end
    axis([freq_range amplitude_range_integrated_rms]);
    grid on;
    title(bpm_names{i},'FontSize',12,'FontWeight','bold');
    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');
    ylabel('Position RMS (um)','FontSize',12,'FontWeight','bold');    
    
    subplot(223);
    for j=1:length(bpm_position_spectral_data)
        semilogy(bpm_position_spectral_data(j).frequencies, bpm_position_spectral_data(j).psd(:,i+n_bpms), 'Color', colors(j,:));
        hold on;
    end
    axis([freq_range amplitude_range_psd])
    grid on;
    title(bpm_names{i+n_bpms},'FontSize',12,'FontWeight','bold');
    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');
    ylabel('Position PSD (um^2/Hz)','FontSize',12,'FontWeight','bold');
    
    subplot(224);
    for j=1:length(bpm_position_spectral_data)
        plot(bpm_position_spectral_data(j).frequencies, bpm_position_spectral_data(j).integrated_rms(:,i+n_bpms), 'Color', colors(j,:));
        hold on;
    end
    axis([freq_range amplitude_range_integrated_rms]);
    grid on;
    title(bpm_names{i+n_bpms},'FontSize',12,'FontWeight','bold');
    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');
    ylabel('Position RMS (um)','FontSize',12,'FontWeight','bold');    
end