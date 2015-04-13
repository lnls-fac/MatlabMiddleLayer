function time_labviewrt = fatimem2lvrt(time_matlab)

time_matlab = time_matlab - datenum('1904/1/1') + java.util.Date().getTimezoneOffset()/60/24 ;

time_labviewrt = uint64(time_matlab*24*60*60*1e9);
