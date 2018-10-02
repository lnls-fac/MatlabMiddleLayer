function [harms, model, nmpole, smpole, params] = sirius_load_fmap_model(magnet)


[harmsP, modelP, nmpoleP, smpoleP, paramsP] = load_fmap_model([magnet, '-positive.txt']);
[harmsN, modelN, nmpoleN, smpoleN, paramsN] = load_fmap_model([magnet, '-negative.txt']);

check = all(harmsP == harmsN);
if ~check
    error('z-positive and z-negative analysis have different harmonics!');
else
    harms = harmsP;
end

model = [flipud(modelN); modelP];
nmpole = nmpoleP + nmpoleN;
smpole = smpoleP + smpoleN;
params.current = paramsP.current;


function [harms, model, nmpole, smpole, params] = load_fmap_model(filename)

fp = fopen(filename, 'rt');
text = textscan(fp, '%s', 'Delimiter', '\n');
text = text{1};
harms = [];
nmpole = [];
smpole = [];
params = struct();
for i=1:length(text)
    line = text{i};
    if ~isempty(strfind(line, 'n=')) && ~isempty(strfind(line, ':'))
        words = strsplit(line);
        harms(end+1) = str2double(words{1}(3:4));
        if strcmpi(words{3}, '---')
            nmpole = [nmpole, 0.0];
        else
            nmpole = [nmpole, str2double(words{3})];
        end
        if strcmpi(words{7}, '---')
            smpole = [smpole, 0.0];
        else
            smpole = [smpole, str2double(words{7})];
        end
    elseif ~isempty(strfind(line, 'main_coil_current:'))
        words = strsplit(line);
        params.current = str2double(words{2});
    elseif ~isempty(strfind(line, '--- model polynom_b'))
        model = str2num(cell2mat(text(i+2:end)));
        break;
    end
end