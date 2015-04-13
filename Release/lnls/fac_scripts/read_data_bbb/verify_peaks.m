%escolher arquivo
    [FILENAME, PATHNAME, FILTERINDEX] = uigetfile( ...
    {'*.txt','BBB Peak Verification (*.txt)'}, ...
    'Open single bunch data', 'SB_');

    if isstr(FILENAME)
        fid = fopen([PATHNAME FILENAME],'r');
        bbb_data = fread(fid, [1,inf], 'int16');
        fclose(fid);
        num_points = length(bbb_data);
        num_turns = floor(num_points/148);
        peaks_array = zeros(1,num_turns,'int16');     
        for i=0:1:(num_turns-1)
            bbb_data_148 = bbb_data((1+i*148):1:(i+1)*148);
            [Y,I] = max(bbb_data_148);
            peaks_array(i+1)=I;
        end
        plot(peaks_array);
    end
