function disturbance = generate_disturbance(disturbance_config, sim_time, n_bpm)

if strcmp(disturbance_config.selected_disturbance, 'no_disturbance')
    disturbance = [[0; sim_time] zeros(2, n_bpm)];   
else
    switch disturbance_config.selected_disturbance
        case 'vib'
            [time, data_] = build_disturbance_vib(disturbance_config.vib_frequencies, disturbance_config.vib_rms, sim_time);
        case 'id'
            [time, data_] = build_disturbance_id(disturbance_config.id_stoptime, disturbance_config.id_amplitude, sim_time);
        case 'therm'
            [time, data_] = build_disturbance_therm(disturbance_config.therm_tconstant, disturbance_config.therm_amplitude, sim_time);
    end

    switch disturbance_config.selected_scaling
        case 'all'
            if n_bpm == length(disturbance_config.scale_amplitude)
                data = repmat(data_, 1, n_bpm).*repmat(disturbance_config.scale_amplitude, length(data_), 1);
            else
                throw(MException('fofbsim:generate_disturbance_data:wrong_number_of_scaling_amplitudes', 'Amplitude scaling vector must have the same number of elements as the number of BPM readings.'));
            end

        case 'one_bpm'
            data = zeros(length(data_), n_bpm);
            data(:, disturbance_config.selected_bpm) = data_;
    end
    
    disturbance = [time data];
end