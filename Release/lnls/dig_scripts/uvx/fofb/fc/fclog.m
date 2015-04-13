function fclog(filename, expinfo, npts_packet, stopat)

fileid = fopen(filename, 'a+');
fprintf(fileid, ['[' fatimestr(now) '] ']);
fprintf(fileid, 'excitation = %s; amplitude = %g; duration = %d; mode = %s; npts_packet = %d; stopat = %d', expinfo.excitation, expinfo.amplitude, expinfo.duration, expinfo.mode, npts_packet, stopat);
fprintf(fileid, '\n');
fclose(fileid);