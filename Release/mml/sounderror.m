function sounderror
%SOUNDERROR - Makes a "error" sound
%
%  See also soundchord, soundtada, soundquestion


VersionStr = version;
if strcmp(VersionStr(1),'4')
    % No sound
else
    [y, fs, bits] = wavread('UtopiaError.wav');
    sound(y, fs, bits);
end

