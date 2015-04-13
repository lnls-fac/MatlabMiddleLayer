file_to_open_handle = fopen('SB_Instavel.txt');
bbb_data_inst = fread(file_to_open_handle, [1,inf], 'int16');
fclose(file_to_open_handle);