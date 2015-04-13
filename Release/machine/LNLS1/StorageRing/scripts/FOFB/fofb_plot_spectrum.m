function haxis_out = fofb_plot_spectrum(signals, time, graph_type, amplitude_range, freq_range, window_fcn, color, log, signal_names, unit, dataset_name, haxis_in)
% haxis_out = fofb_plot_spectrum(signals, time, graph_type, amplitude_range, freq_range, window_fcn, color, log, signal_names, unit, dataset_name, haxis_in)

n_signals = size(signals, 2);

if nargin < 2 || isempty(time)
    time = 0:(size(signals, 1)-1);
end
npts = length(time);

if nargin < 3 || isempty(graph_type)
    graph_type = 'fft';
end

if (nargin < 5) || isempty(freq_range)
    freq_range = [0 1/(time(2)-time(1))/2];
end

if (nargin < 6) || isempty(window_fcn)
    window = [];
else
    n_win = 10000;
    PG_normalization = sum(feval(window_fcn, n_win))/n_win;
    window = feval(window_fcn, npts)/PG_normalization;
end

if (nargin < 7) || isempty(color)
    color = 'b';
end

if isscalar(color) || (size(color,1) ~= n_signals)
    color = repmat(color, n_signals, 1);
end

if (nargin < 8) || isempty(log)
    log = 1;
end

if (nargin < 9)
    signal_names = [];
end

if (nargin < 10) || isempty(unit)
    unit = 'a.u.';
end

if (nargin < 11) || isempty(unit)
    dataset_name = [];
end

% ============
% Calculations
% ============

if strcmpi(graph_type, 'fft')
    [spectra, freq] = fofb_fft(signals, time, [], [], 1, window);
    spectrum_ylabel = sprintf('Amplitude (%s)', unit);
elseif strcmpi(graph_type, 'psd')
    [spectra, freq] = fofb_psd(signals, time, 1, window);
    spectrum_ylabel = sprintf('PSD (%s/\\surdHz)', unit);
elseif strcmpi(graph_type, 'rms')
    [spectra, freq] = fofb_integrated_rms(signals, time, 1, window);
    spectrum_ylabel = sprintf('Integrated RMS (%s)', unit);
else
    error('Invalid value for ''graph_type'' parameter.');
end

if (nargin < 4) || isempty(amplitude_range)
    amplitude_range = [min(min(spectra(2:end,:))) max(max(spectra))];
end

% ===========
% Plot graphs
% ===========

if (nargin < 12) || isempty(haxis_in)
    haxis = zeros(n_signals, 1);
else
    haxis = haxis_in;
end

for i = 1:n_signals
    if (nargin < 12) || isempty(haxis_in)
        figure;
        haxis(i) = gca;
    else
        axes(haxis(i));
    end
    hnew = plot(freq, spectra(:,1,i), 'Color', color(i, :));
    hold on;
    grid on;
    if log
        set(haxis(i), 'YScale', 'log');
    else
        set(haxis(i), 'YScale', 'linear');
    end
    axis([freq_range amplitude_range])
    ylabel(spectrum_ylabel,'FontSize',14,'FontWeight','bold');
    xlabel('Frequency (Hz)','FontSize',14,'FontWeight','bold');    
    set(haxis(i), 'FontSize', 14);
    if ~isempty(signal_names)
        [~,~,outh,outm] = legend;
        n = length(outm);
        outm{n+1} = '';
        if ~isempty(signal_names)
            outm{n+1} = signal_names{i};
        end
        if ~isempty(dataset_name)
            outm{n+1} = [outm{n+1} ' - ' dataset_name];
        end
        
        legend([outh;hnew],outm, 'FontSize', 10);
    end
end

if nargout > 0
    haxis_out = haxis;
end
