function matlabtime = tango_tango2matlabtime(tangotime)
% TANGO_TANGO2MATLABTIME - Convert time given by TANGO to matlab time
%
%  INPUTS
%  1. tangotime - time given by TANGO
%
%  OUTPUTS
%  1. matlabtime - time in matlasb format
%
%  EXAMPLES
%  1. tangotime =1.269844680000000e+09
%     datestr(tango_tango2matlabtime(tangotime)) should be:
%     29-Mar-2010 07:38:00
%
%  See Also datestr

%  Written by Laurent S. Nadolski, March 2010
%  NOTES:
%  Source N. Leclercq
%  Still need to shift between winter and summer time

lk_time_reference = 719529; % 1 January 1970
lk_time_factor = 1.157407407407407E-5; 

matlabtime = lk_time_reference + lk_time_factor*tangotime;
matlabtime = tango_shift_time(matlabtime);

