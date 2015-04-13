function soundtada
%SOUNDTADA - Makes a "tada" sound
%
%  See also soundchord, sounderror, soundquestion


VersionStr = version;
if strcmp(VersionStr(1),'4')
    % No sound
else
    [y, fs, bits] = wavread('Tada.wav');
    sound(y, fs, bits);
end

