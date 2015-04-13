function [Tune, tout, DataTime, ErrorFlag] = bfreq2tune(Family, Field, DeviceList, varargin)
% [Tune, tout, DataTime, ErrorFlag] = bfreq2tune(Family, Field, DeviceList)
%

tout = [];
DataTime = [];
ErrorFlag = 0;

nharm = getharmonicnumber;
rfreq_ref = 476065.68;
revfreq_ref = rfreq_ref / nharm;
harmonic_ref = 36 * revfreq_ref;

rfreq = 1000*getpvonline('GRFF02_FREQ_AM');
[Tunes, tout, DataTime, ErrorFlag] = getpvonline(['ASINT_H'; 'ASINT_V']);
revfreq = rfreq / nharm;
harmonic = 36 * revfreq;

freq = harmonic_ref + Tunes;
Tune = (freq - harmonic) / revfreq;