function [fcdata, expout, timestamp] = fcsend(ip, fcn, expinfo, npts_packet, stopat)

ncols = 50;
nmarker = 1;

if ischar(ip) || ~isfield(ip,'port')
    if ischar(ip)
        conninfo.address = ip;
    end
    conninfo.port = 3604;
else
    conninfo = ip;
end

if nargin < 4 || isempty(npts_packet)
    npts_packet = 1000;
end

if nargin < 5 || isempty(stopat)
    stopat = expinfo.duration;
end

[fcdata, expout] = fcn('init', npts_packet, expinfo);

i=0;
failure = false;
timestamp = 0;

buffer_filled = false;

conn = tcpip(conninfo.address, conninfo.port, 'OutputBufferSize', 10*npts_packet*(ncols+nmarker+1)*4);
fopen(conn);
while i < stopat
    if buffer_filled
        [packet, expinterval] = fcn(i, npts_packet, expinfo, fcdata);

        % Ensure data is encoded in 4-byte floating point representation
        packet = single(packet);

        if expinterval
            fcmode = fcbuildmode('');
        else
            fcmode = fcbuildmode(expinfo.mode);
        end
    else
        % Add dummy packets on beginning of data transmission to avoid gap
        % on FC data at the receiver end
        packet = zeros(npts_packet, ncols + nmarker, 'single');
        fcmode = fcbuildmode('');
        
        if i > 3
            buffer_filled = true;
            i = 0;
        end
    end
    
    while true
        try
            if fread(conn, 1, 'uint8')
                % FIXME
                %hi = fread(conn, 1, 'uint32');
                %lo = fread(conn, 1, 'uint32');
                hi=0; lo=0;
                if i == 0 && buffer_filled
                    timestamp = bitsll(uint64(hi), 32) + uint64(lo);
                end
                packet_ = [packet repmat(typecast(fcmode, 'single'), npts_packet, 1)];
                subdata = packet_';
                subdatainfo = whos('subdata');
                fwrite(conn, subdatainfo.bytes+8, 'uint32');
                fwrite(conn, uint32(size(packet_)), 'uint32');
                fwrite(conn, subdata(1:end), 'single');
                i=i+1;
                pause(0.001);
                break
            else
                %hi = fread(conn, 1, 'uint32');
                %lo = fread(conn, 1, 'uint32');
            end
        catch err
            failure = true;
            break
        end
    end
    
    if failure
        break
    end
end
fclose(conn);
