function get_trace_example


obj = signal_analyzer_fsv_create_object('10.0.5.76');
signal_analyzer_fsv_configure_trace_acquisition(obj);
signal_analyzer_fsv_connect(obj);
trace = signal_analyzer_fsv_get_trace(obj);
signal_analyzer_fsv_disconnect(obj);

plot(trace);
