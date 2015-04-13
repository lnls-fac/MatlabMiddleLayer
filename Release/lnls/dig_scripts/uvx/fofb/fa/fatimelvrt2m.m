function time_matlab = fatimelvrt2m(time_labviewrt)

time_matlab = (cumsum([0; double(diff(time_labviewrt))]) + double(time_labviewrt(1)))/1e9/60/60/24 + datenum('1904/1/1') - java.util.Date().getTimezoneOffset()/60/24;
