function meas = fcexpprocmap(filenames)

%filenames = fafind('\\stnls02.lnls.br\CorrecaoOrbita', '2015/04/11 16:33:0', '2015/04/11 17:23:00');
%filenames = fafind('\\stnls02.lnls.br\CorrecaoOrbita', '2015/04/11 18:40:0', '2015/04/11 21:00:00');

% Experiments mapping
j = 0;
last_marker = int32(0);
fprintf('\n');
for i=1:length(filenames)
    data = faload(filenames(i),0,0);
    diffmarker = diff([last_marker; int32(data.marker)]);
    idx_ini = find(diffmarker > 0);
    idx_fin = find(diffmarker < 0) - 1;
    

    last_marker = int32(data.marker(end));
   
    %Case the experiment begins in the previous file and ends in the next
    %files:
    if isempty(idx_ini) &&  isempty(idx_fin)
        if j ~= 0 || i == length(filenames)
            meas{j}.idx{end+1}  = 1:length(data.marker);
            meas{j}.file(end+1) = i;
        end
    elseif ~isempty(idx_ini) &&  isempty(idx_fin)
        j = j+1;
        meas{j}.idx    =  {idx_ini(end):length(data.marker)};
        meas{j}.file   = i;
    elseif  isempty(idx_ini) && ~isempty(idx_fin)
        if j ~= 0
            meas{j}.idx{end+1}  = 1:idx_fin(1);
            meas{j}.file(end+1) = i;
        end
    else
        % case the experiment begins in the previous file and ends in this
        % file:
        if (idx_fin(1) < idx_ini(1)) && j ~= 0
            meas{j}.idx{end+1}  = 1:idx_fin(1);
            meas{j}.file(end+1) = i;
            idx_fin = idx_fin(2:end);
        end
        
        % Case the experiments begin and end in this file:
        for ii =1:length(idx_fin)
            j = j+1;
            meas{j}.idx = {idx_ini(ii):idx_fin(ii)};
            meas{j}.file = i;
        end
        
        % Case the experiment begins in this file but ends in the next
        % files:
        if isempty(idx_fin) || (idx_ini(end) > idx_fin(end))
            j = j+1;
            meas{j}.idx  =  {idx_ini(end):length(data.marker)};
            meas{j}.file = i;
            idx_ini = idx_ini(1:end-1);
        end
    end
    if ~mod(i,50), fprintf('\n');end
    fprintf('.');
end
fprintf('\n%d files mapped.\n%d experiments loaded\n',i,j);

% 
% i=1;
% 
% dataset(i).respmsin = facutdata(data, idx);
% 
% idx = find(diffmarker > 200 & diffmarker < 300);
% dataset(i).respm = facutdata(data, idx);
% 
% idx = find(diffmarker == 300);
% dataset(i).disp = facutdata(data, idx);