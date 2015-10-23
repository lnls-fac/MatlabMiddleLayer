function [matrix, beam_energy, row_names, column_names] = uvxmatload(filename)

file_d = fopen(filename);

beam_energy = textscan(fgetl(file_d), '%*s%f', 'delimiter', '\t');
beam_energy = beam_energy{1};

column_names = textscan(fgetl(file_d), '%s', 'delimiter', '\t');
column_names = column_names{1};

% Remove empty string of first cell array element
column_names = column_names(2:end);

% Store file position indicator just after first line of numeric data
position = ftell(file_d);

try
    % With the number of columns, build the format string for data
    formatstr = '%*s';
    for i=1:length(column_names)
        formatstr = [formatstr '%f'];
    end

    % Read matrix data
    matrix = textscan(file_d, formatstr, 'delimiter', '\t', 'CollectOutput', 1);
    matrix = matrix{1};

    % Recover file position indicator just after first line
    frewind(file_d);
    fseek(file_d,position,0);

    % Read row names
    row_names = textscan(file_d, '%s%*[^\n]', 'delimiter', '\t', 'CollectOutput', 1);
    row_names = row_names{1};
end

fclose(file_d);
