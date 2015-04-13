function [dbpm, dcorr] = fastep(fadata, corr_index, threshold)

index1 = find(fadata.corr_readings(:,corr_index) < threshold);
index2 = find(fadata.corr_readings(:,corr_index) >= threshold);

bpm1 = mean(fadata.bpm_readings(index1,:));
bpm2 = mean(fadata.bpm_readings(index2,:));
dbpm = bpm2-bpm1;

corr1 = mean(fadata.corr_readings(index1,:));
corr2 = mean(fadata.corr_readings(index2,:));
dcorr = corr2-corr1;
