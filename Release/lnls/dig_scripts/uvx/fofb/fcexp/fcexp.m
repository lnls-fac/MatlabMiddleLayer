function [fcdata, expout, timestamp] = fcexp(expinfo)

fclog_filename = '\\stnls02.lnls.br\CorrecaoOrbita\fc\fcsend_log.txt';
ip = '10.0.5.31';
npts_packet = 100;

% expinfo.profiles_2D(1,:,:) = diag([corr_steps(1:18); zeros(24,1)]);
% expinfo.profiles_2D(2,:,:) = diag([zeros(18,1); corr_steps(19:42)]);

stopat = (expinfo.duration + expinfo.pauselength)*(size(expinfo.profiles, 1));

if ~isempty(fclog_filename)
    fclog(fclog_filename, expinfo, npts_packet, stopat);
end

[fcdata, expout, timestamp] = fcsend(ip, @fcident, expinfo, npts_packet, stopat);

fileid = fopen(fclog_filename, 'a+');
fprintf(fileid, ['[' fatimestr(now) '] ']);
fprintf(fileid, '%d', timestamp);
fprintf(fileid, '\n');
fclose(fileid);