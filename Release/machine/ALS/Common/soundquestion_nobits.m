function soundquestion
%SOUNDQUESTION - Makes a "question" sound
%
%  See also soundchord, soundtada, sounderror


VersionStr = version;
if strcmp(VersionStr(1),'4')
    % No sound
else
    [y, fs, bits] = wavread('UtopiaQuestion.wav');
    sound(y(1:2:end));
end

