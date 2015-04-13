function signal_analyzer_fsv_configure(obj)

buffer_size = 16536;

% Configure instrument object, obj1.
set(obj, 'InputBufferSize',  buffer_size);
set(obj, 'OutputBufferSize', buffer_size);
