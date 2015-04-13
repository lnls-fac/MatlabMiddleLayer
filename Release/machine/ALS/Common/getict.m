function [ICT, tout, DataTime, ErrorFlag] = getict(t)
%GETICT - Beam current as measured by the ICTs
%  [ICT, tout, DataTime, ErrorFlag] = getict(t)
%
%  INPUTS
%  1. t - Time vector {Default: 0, see getpv}
%
%  OUTPUTS
%  1. ICT - Beam current vector [LTB; BR BTS1 BTS2]
%  2-4. tout, DataTime, ErrorFlag - typical getpv outputs

%  Written by Greg Portmann


ChannelNames = [
    'LTB_____ICT01__AM02';
    'BR2_____ICT01__AM03'
    'BTS_____ICT01__AM00'
    'BTS_____ICT02__AM01'];


if nargin < 1
    t = 0;
end


[ICT, tout, DataTime, ErrorFlag] = getpv(ChannelNames, t);

