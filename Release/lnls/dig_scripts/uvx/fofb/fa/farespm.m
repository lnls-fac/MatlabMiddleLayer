function [M, corr_steps, orb_std, corr_std] = farespm(fadata, npts_level)

%FIXME
fadata.bpm_readings = [fadata.bpm_readings; fadata.bpm_readings(1,:)];
fadata.corr_setpoints = [fadata.corr_setpoints; fadata.corr_setpoints(1,:)];

steps = diff(fadata.corr_setpoints,1,1);
posedge = find(steps > 0);
negedge = find(steps < 0);

corr_steps = double(steps(posedge));

[ipos, jpos] = ind2sub(size(steps), posedge);
[ineg, jneg] = ind2sub(size(steps), negedge);

ineg1 = ineg(1:2:end);
ineg2 = ineg(2:2:end);

orb_before_step = zeros(size(fadata.bpm_readings,2), length(ipos));
orb_after_step = zeros(size(fadata.bpm_readings,2), length(ipos));
orb_before_step_std = zeros(size(fadata.bpm_readings,2), length(ipos));
orb_after_step_std = zeros(size(fadata.bpm_readings,2), length(ipos));

corr_before_step = zeros(length(ipos),1);
corr_after_step = zeros(length(ipos),1);
corr_before_step_std = zeros(length(ipos),1);
corr_after_step_std = zeros(length(ipos),1);

for i=1:length(ipos)
    [orb_before_step(:,i), orb_before_step_std(:,i)] = levelmeanstd(fadata.bpm_readings, npts_level, ipos(i));
    [orb_after_step(:,i), orb_after_step_std(:,i)] = levelmeanstd(fadata.bpm_readings, npts_level, ineg2(i));

    [corr_before_step(i), corr_before_step_std(i)] = levelmeanstd(fadata.corr_setpoints(:,i), npts_level, ipos(i));
    [corr_after_step(i), corr_after_step_std(i)] = levelmeanstd(fadata.corr_setpoints(:,i), npts_level, ineg2(i));
end

orb_std = mean([mean(orb_before_step_std,2) mean(orb_after_step_std,2)], 2);
corr_std = mean([corr_before_step_std corr_after_step_std], 2);

M = double((orb_after_step-orb_before_step)./repmat(corr_steps', size(orb_before_step, 1), 1));


function [level_mean, level_std] = levelmeanstd(data, npts_level, idx)

level = data(idx+(-npts_level+1:0),:);
level_mean = mean(level);
level_std = std(level);
