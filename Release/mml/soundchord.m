function soundchord
%SOUNDCHORD - Makes a "chord" sound
%
%  See also soundtada, sounderror, soundquestion


VersionStr = version;
if strcmp(VersionStr(1),'4')
    % No sound
else
    [y, fs, bits] = wavread('Chord.wav');
    sound(y, fs, bits);
end

