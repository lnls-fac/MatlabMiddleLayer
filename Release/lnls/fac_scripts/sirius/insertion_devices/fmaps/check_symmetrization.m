function check_symmetrization(folder1, folder2)

dnames{1} = 'bare';
dnames{2} = folder1;
dnames{3} = folder2;

data = {};
for i=1:length(dnames)
    d = importdata(fullfile(dnames{i}, 'linlat.out'), ' ', 4);
    data{i} = d.data;
end



maxbetay1 = max(data{1}(:,8));
sel{1} = (data{1}(:,8) > (1 - 0.01) * maxbetay1) & (data{1}(:,8) < (1 + 0.01) * maxbetay1);

maxbetay3 = max(data{3}(:,8));
sel{3} = (data{3}(:,8) > (1 - 0.01) * maxbetay3) & (data{3}(:,8) < (1 + 0.01) * maxbetay3);
sel{2} = sel{3};


circ     = data{1}(end,1); 
pos{1}   = data{1}(sel{1},1); betay{1} = data{1}(sel{1},8); 
pos{2}   = data{2}(sel{2},1); betay{2} = data{2}(sel{2},8);
pos{3}   = data{3}(sel{3},1); betay{3} = data{3}(sel{3},8);

allbetay = [betay{1}; betay{2}; betay{3}];
betay_wd = [min(allbetay) max(allbetay)];

leg{1} = [strrep(dnames{1}, '_', '-') ' (' num2str(std(betay{1})*100/mean(betay{1}), '%5.3f') '%)'];
leg{2} = [strrep(dnames{2}, '_', '-') ' (' num2str(std(betay{2})*100/mean(betay{2}), '%5.3f') '%)'];
leg{3} = [strrep(dnames{3}, '_', '-') ' (' num2str(std(betay{3})*100/mean(betay{3}), '%5.3f') '%)'];

figure; 
axis([0 circ betay_wd]);
xlabel('Pos [m]');
ylabel('\beta_y [m]');
hold all;
for i=1:length(dnames)
    scatter(pos{i}, betay{i}, 50, 'filled');
end
legend(leg);

