function uvxgenzpk(path_filters, sysarray, type)

if strcmpi(type, 'bpm')
    mapping = struct('name', {'AMP02AH','AMP02AV','AMP02BH','AMP02BV','AMP03AH','AMP03AV','AMP03BH','AMP03BV','AMP03CH','AMP03CV','AMP04AH','AMP04AV','AMP04BH','AMP04BV','AMP05AH','AMP05AV','AMP05BH','AMP05BV','SPARE','SPARE','AMP06AH','AMP06AV','AMP06BH','AMP06BV','AMP07AH','AMP07AV','AMP07BH','AMP07BV','SPARE','SPARE','AMP08AH','AMP08AV','AMP08BH','AMP08BV','AMP09AH','AMP09AV','AMP09BH','AMP09BV','SPARE','SPARE','AMP10AH','AMP10AV','AMP10BH','AMP10BV','AMU11AH','AMU11AV','AMU11BH','AMU11BV','SPARE','SPARE','AMP12AH','AMP12AV','AMP12BH','AMP12BV','AMP01AH','AMP01AV','AMP01BH','AMP01BV','SPARE','SPARE'}, 'chassis',{'BPM-Chassis01','BPM-Chassis01','BPM-Chassis01','BPM-Chassis01','BPM-Chassis01','BPM-Chassis01','BPM-Chassis01','BPM-Chassis01','BPM-Chassis01','BPM-Chassis01','BPM-Chassis02','BPM-Chassis02','BPM-Chassis02','BPM-Chassis02','BPM-Chassis02','BPM-Chassis02','BPM-Chassis02','BPM-Chassis02','BPM-Chassis02','BPM-Chassis02','BPM-Chassis03','BPM-Chassis03','BPM-Chassis03','BPM-Chassis03','BPM-Chassis03','BPM-Chassis03','BPM-Chassis03','BPM-Chassis03','BPM-Chassis03','BPM-Chassis03','BPM-Chassis04','BPM-Chassis04','BPM-Chassis04','BPM-Chassis04','BPM-Chassis04','BPM-Chassis04','BPM-Chassis04','BPM-Chassis04','BPM-Chassis04','BPM-Chassis04','BPM-Chassis05','BPM-Chassis05','BPM-Chassis05','BPM-Chassis05','BPM-Chassis05','BPM-Chassis05','BPM-Chassis05','BPM-Chassis05','BPM-Chassis05','BPM-Chassis05','BPM-Chassis06','BPM-Chassis06','BPM-Chassis06','BPM-Chassis06','BPM-Chassis06','BPM-Chassis06','BPM-Chassis06','BPM-Chassis06','BPM-Chassis06','BPM-Chassis06'},'order',num2cell([1:10 1:10 1:10 1:10 1:10 1:10]));
elseif strcmpi(type, 'corr')
    mapping = struct('name', {'ACH02','RRA01B','ALV02A','ALV02B','ACH03A','ACV03A','ACH01B','ACV01B','ACH04','RRA02B','ALV04A','ALV04B','ACH05A','ACV05A','ACH03B','ACV03B','ACH06','RRA03B','ALV06A','ALV06B','ACH07A','ACV07A','ACH05B','ACV05B','ACH08','RRA04B','ALV08A','ALV08B','ACH09A','ACV09A','ACH07B','ACV07B','ACH10','RRA05B','ALV10A','ALV10B','ACH11A','ACV11A','ACH09B','ACV09B','ACH12','RRA06B','ALV12A','ALV12B','ACH01A','ACV01A','ACH11B','ACV11B'}, 'chassis', {'PS-RA01B','PS-RA01B','PS-RA01B','PS-RA01B','PS-RA01B','PS-RA01B','PS-RA01B','PS-RA01B','PS-RA02B','PS-RA02B','PS-RA02B','PS-RA02B','PS-RA02B','PS-RA02B','PS-RA02B','PS-RA02B','PS-RA03B','PS-RA03B','PS-RA03B','PS-RA03B','PS-RA03B','PS-RA03B','PS-RA03B','PS-RA03B','PS-RA04B','PS-RA04B','PS-RA04B','PS-RA04B','PS-RA04B','PS-RA04B','PS-RA04B','PS-RA04B','PS-RA05B','PS-RA05B','PS-RA05B','PS-RA05B','PS-RA05B','PS-RA05B','PS-RA05B','PS-RA05B','PS-RA06B','PS-RA06B','PS-RA06B','PS-RA06B','PS-RA06B','PS-RA06B','PS-RA06B','PS-RA06B'}, 'order', num2cell([1:8 1:8 1:8 1:8 1:8 1:8]));
end

mapnames = {mapping.name};

if length(sysarray) > 0
    for i=1:length(sysarray)
        sysnames{i} = sysarray{i}.name;
    end
else
    sysnames = {};
end

for i=1:length(mapnames)
    index = find(strcmpi(mapnames(i),sysnames));
    variable = mapping(i);
    chassis_name = variable.chassis;
    order = variable.order;

    if ~isempty(index)
        sys = zpk(sysarray{index});
    else
        sys = zpk([],[],1,-1,'name',variable.name);
    end

    dirname = fullfile(path_filters,chassis_name,[sprintf('%0.2d_',order) sys.name]);
    [s,mess,messid] = mkdir(dirname);
    if ~s
        error('');
    end
    zeros = [real(sys.z{1}) imag(sys.z{1})];
    poles = [real(sys.p{1}) imag(sys.p{1})];
    gain = sys.k;
    save(fullfile(dirname, 'zeroes.txt'), 'zeros', '-ascii','-tabs','-double');
    save(fullfile(dirname, 'poles.txt'), 'poles', '-ascii','-tabs','-double');
    save(fullfile(dirname, 'gain.txt'), 'gain', '-ascii','-tabs','-double');
end
