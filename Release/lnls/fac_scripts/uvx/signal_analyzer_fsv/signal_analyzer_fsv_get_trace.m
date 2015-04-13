function trace = signal_analyzer_fsv_get_trace(obj)

fprintf(obj, 'FORMAT ASCII');
data = query(obj, 'TRAC1? TRACE1');
data = textscan(data, '%f,');
trace = data{1};
