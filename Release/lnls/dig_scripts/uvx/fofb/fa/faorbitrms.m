function fadata_rms = faorbitrms(fadata, selected_bpm, nbpm)

if nargin < 2 || isempty(selected_bpm)
    selected_bpm = [1:5 7:25];
end

if nargin < 3 || isempty(nbpm)
    nbpm = 25;
end

fadata_rms = fadata;

fadata_rms.bpm_readings = [std(fadata.bpm_readings(:,selected_bpm), [], 2) std(fadata.bpm_readings(:, nbpm + selected_bpm), [], 2)];
fadata_rms.bpm_names = {'Horizontal RMS Orbit', 'Vertical RMS Orbit'};
