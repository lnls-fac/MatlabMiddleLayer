function fasave(filename, data, timestamp, header, mode, prefix)

if nargin < 5 || isempty(mode)
    mode = 'bin';
end

if nargin < 6 || isempty(prefix)
    prefix = '';
end

if ischar(filename)
    try
        for i=1:length(header)
            header{i} = [prefix header{i}];
        end
        header = [[prefix 'DataHora']; header(:)];
        
        
        fileid = fopen(filename, 'w+');
        fprintf(fileid, '%s\t', header{:});
        fprintf(fileid, '\n');

        if strcmpi(mode, 'bin')
            data = [data timestamp];
            dim = uint32(size(data));
            fwrite(fileid, dim, 'uint32', 0, 'l');
            fwrite(fileid, data, 'double', 0, 'l');
        elseif strcmpi(mode, 'text')
            for i=1:size(data,1)
                fprintf(fileid, fatimestr(timestamp(i)));
                fprintf(fileid, '\t');
                fprintf(fileid, '%0.10f\t', data(i, :));
                fprintf(fileid, '\n');
            end
        else
            error('Unknown mode.');
        end
    catch err
        fclose(fileid);
        rethrow(err);
    end

    fclose(fileid);
end
