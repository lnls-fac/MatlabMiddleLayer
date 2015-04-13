close all;

base_filepath = '\\centaurus\Repositorio\Grupos\DIG\Projetos\Ativos\DT_FOFB\LNLS\Experimentos\Aquisição rápida';

% exp_filenames = {'\20110618\1370MeV\modon\tune\altaenergia_modon_tuneX642kHz.mat',...
%                  '\20110618\1370MeV\modon\tune\altaenergia_modon_tuneX645kHz.mat',...
%                  '\20110618\1370MeV\modon\tune\altaenergia_modon_tuneX649kHz.mat',...
%                  '\20110618\1370MeV\modon\tune\altaenergia_modon_tuneX654kHz.mat',...
%                  '\20110618\1370MeV\modon\tune\altaenergia_modon_tuneX660kHz.mat'};
% 
% exp_filenames = {'\20110618\1370MeV\modon\bergoz\usuario_8kHz_1.mat',...
%                  '\20110618\1370MeV\modon\bergoz\usuario_10kHz_1.mat',...
%                  '\20110618\1370MeV\modon\bergoz\usuario_10.076kHz_1.mat',...
%                  '\20110618\1370MeV\modon\bergoz\usuario_10.152kHz_1.mat',...
%                  '\20110618\1370MeV\modon\bergoz\usuario_10.309kHz_1.mat',...
%                  '\20110618\1370MeV\modon\bergoz\usuario_10.610kHz_1.mat'};
%              
% exp_filenames = {'\20110618\1370MeV\modon\bergoz\usuario_8kHz_2.mat',...
%                  '\20110618\1370MeV\modon\bergoz\usuario_10kHz_2.mat',...
%                  '\20110618\1370MeV\modon\bergoz\usuario_10.076kHz_2.mat',...
%                  '\20110618\1370MeV\modon\bergoz\usuario_10.152kHz_2.mat',...
%                  '\20110618\1370MeV\modon\bergoz\usuario_10.309kHz_2.mat',...
%                  '\20110618\1370MeV\modon\bergoz\usuario_10.610kHz_2.mat'};
%
% exp_filenames = {'\20110618\500MeV\modoff\ps_1\baixaenergia_modoff_allpson.mat',...
%                  '\20110618\500MeV\modoff\ps_1\baixaenergia_modoff_ach06off.mat',...
%                  '\20110618\500MeV\modoff\ps_1\baixaenergia_modoff_ach06off_ach11boff.mat',...
%                  '\20110618\500MeV\modoff\ps_1\baixaenergia_modoff_ach06off_ach11boff_ach11aoff.mat',...
%                  '\20110618\500MeV\modoff\ps_1\baixaenergia_modoff_ach06off_ach11boff_ach11aoff_ach09aoff.mat',...
%                  '\20110618\500MeV\modoff\ps_1\baixaenergia_modoff_ach06off_ach11boff_ach11aoff_ach09aoff_ach05aoff.mat',...
%                  '\20110618\500MeV\modoff\ps_1\baixaenergia_modoff_ach06off_ach11boff_ach11aoff_ach09aoff_ach05aoff_allalvoff.mat'};
% 
% exp_filenames = {'\20110618\500MeV\modoff\ps_1\baixaenergia_modoff_allpson.mat',...
%                  '\20110618\500MeV\modoff\ps_2\baixaenergia_modoff_ach06off_ach12off.mat',...
%                  '\20110618\500MeV\modoff\ps_2\baixaenergia_modoff_ach06off_ach12off_ach02off_ach08off.mat',...
%                  '\20110618\500MeV\modoff\ps_2\baixaenergia_modoff_ach06off_ach12off_ach02off_ach08off_ach04off_ach10off.mat',...
%                  '\20110618\500MeV\modoff\ps_2\baixaenergia_modoff_allalvoff.mat'};
%              
%              
% exp_filenames = {'\20110618\500MeV\modoff\baixaenergia_modoff_1.mat',...
%                  '\20110618\500MeV\modoff\RFAoff\baixaenergia_modoff_RFAoff.mat',...
%                  '\20110618\500MeV\modoff\RFBoff\baixaenergia_modoff_RFBoff.mat'};
%              
%              
% exp_filenames = {'\20110618\500MeV\modoff\baixaenergia_modoff_1.mat',...
%                  '\20110618\500MeV\modoff\baixaenergia_modoff_2.mat',...
%                  '\20110618\500MeV\modoff\RFAoff\baixaenergia_modoff_RFAoff.mat',...
%                  '\20110618\500MeV\modoff\RFBoff\baixaenergia_modoff_RFBoff.mat'};
% 
% 
% exp_filenames = {'\20110618\500MeV\modoff\baixaenergia_modoff_1.mat',...
%                  '\20110618\500MeV\modoff\baixaenergia_modoff_2.mat',...
%                  '\20110618\500MeV\modon\baixaenergia_modon_1.mat',...
%                  '\20110618\500MeV\modon\baixaenergia_modon_2.mat'};
% 
% exp_filenames = {'\20110627\chassis1\03.mat'};
% exp_filenames = {'\20110627\chassis2\04.mat'};
% exp_filenames = {'\20110627\chassis3\07.mat'};
% exp_filenames = {'\20110627\chassis4\08.mat'};
% exp_filenames = {'\20110627\chassis5\10.mat'};
% exp_filenames = {'\20110627\chassis6\01-short.mat'};
% exp_filenames = {'\20110627\chassis6\12.mat'};

exp_filenames = {'\20110618\1370MeV\modon\bergoz\usuario_10kHz_1.mat'};




npoints_window = 2^12+1;

% Selected BPM indexes
selected_bpms = 1:25;

% Frequency range (Hz) (for visualization)
freq_range = [0 1000];


bpm_poistion_spectral_data = struct('psd', [], 'integrated_rms' , [], 'frequencies', []);
spectral_data(length(exp_filenames)).bpm_position_psd = [];
for i=1:length(exp_filenames)

    load([base_filepath exp_filenames{i}]);
    
    % Number of BPMs in the dataset (consider dataset has concatenated
    % horizontal and vertical BPM readings)
    n_bpms = size(data.orb,2)/2;

    % Sample time (ms)
    Ts = data.time(2)-data.time(1);

    % Sampling frequency (Hz)
    Fs = 1000/Ts;

    % Convert BPM data from mm to um
    bpm_position = 1e3*data.orb(:, [selected_bpms selected_bpms+n_bpms]);
    data.bpm_names = data.bpm_names([selected_bpms selected_bpms+n_bpms]);

    % Remove DC component
    bpm_position_dc = mean(bpm_position);
    bpm_position_ac = bpm_position - repmat(bpm_position_dc, size(bpm_position,1), 1);    

%     % Apply windowing on data for FFT
%     bpm_position_ac_windowed = bpm_position_ac.*repmat(hann(size(bpm_position_ac,1)), 1,  size(bpm_position_ac,2));
%     
%     % Compute FFT
%     bpm_position_psd{i} = 2/size(bpm_position_ac_windowed,1)*abs(fft(bpm_position_ac_windowed));    
    
    % Compute PSD
    aux2 = zeros(npoints_window, 2*length(selected_bpms));
    for j=1:size(bpm_position_ac,2)
        actual_npoints_window = min(npoints_window,size(bpm_position_ac,1));
        [aux1, f] = pwelch(bpm_position_ac(:,j), hann(actual_npoints_window), floor(0.8*actual_npoints_window), [], Fs);
        aux2(:,j) = aux1;
    end
    bpm_position_spectral_data(i).psd = aux2;
    bpm_position_spectral_data(i).integrated_rms = sqrt(cumtrapz(f,aux2));
    bpm_position_spectral_data(i).frequencies = f;
end

plot_bpm_spectra(bpm_position_spectral_data, data.bpm_names, freq_range);