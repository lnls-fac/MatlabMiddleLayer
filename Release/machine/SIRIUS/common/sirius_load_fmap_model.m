function [harms, model] = sirius_load_fmap_model(magnet)


[harmsP, modelP] = load_fmap_model([magnet, '-positive.txt']);
[harmsN, modelN] = load_fmap_model([magnet, '-negative.txt']);

check = all(harmsP == harmsN);
if ~check
    error('z-positive and z-negative analysis have different harmonics!');
else
    harms = harmsP;
end

model = [flipud(modelN); modelP];


function [harms, model] = load_fmap_model(filename)

fp = fopen(filename, 'rt');
text = textscan(fp, '%s', 'Delimiter', '\n');
text = text{1};
harms = [];
for i=1:length(text)
    line = text{i};
    if ~isempty(strfind(line, 'n=')) && ~isempty(strfind(line, ':'))
        words = strsplit(line);
        harms(end+1) = str2double(words{1}(3:4));
    elseif ~isempty(strfind(line, '--- model polynom_b'))
        model = str2num(cell2mat(text(i+2:end)));
        break;
    end
end