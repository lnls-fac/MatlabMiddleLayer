function plot_comparisons(lattices,info)

planes = {'x','y','ep','en'};

% for i = 1:length(planes)
%     figure('OuterPosition',[633*0,540*(1-0),633, 540]);
%     errorbar(aper.ind1(i,:),aper.trc_mean(i,:),aper.trc_std(i,:),'.');
%     hold all;
%     title(upper(planes{i}));
%     mini = min([aper.ind1(i,:),aper.trc_mean(i,:)-aper.trc_std(i,:)]);
%     maxi = max([aper.ind1(i,:),aper.trc_mean(i,:)+aper.trc_std(i,:)]);
%     plot([mini,maxi],[mini,maxi]);
%     xlabel('ind1');
%     
%     figure('OuterPosition',[633*0,540*(1-1),633, 540]);
%     errorbar(aper.ind2(i,:),aper.trc_mean(i,:),aper.trc_std(i,:),'.');
%     hold all;
%     title(upper(planes{i}));
%     mini = min([aper.ind2(i,:),aper.trc_mean(i,:)-aper.trc_std(i,:)]);
%     maxi = max([aper.ind2(i,:),aper.trc_mean(i,:)+aper.trc_std(i,:)]);
%     plot([mini,maxi],[mini,maxi]);
%     xlabel('ind2');
% end


ind01 =  false(1,length(lattices));
ind05 =  false(1,length(lattices));
ind10 =  false(1,length(lattices));
for i=1:length(lattices)
    if lattices(i).symmetry == 10
        ind10(i) = true;
    elseif lattices(i).symmetry == 5
        ind05(i) = true;
    else
        ind01(i) = true;
    end
end

for i = 1:length(planes)
    posx = mod(i-1,2);
    posy = floor((i-1)/2);
    figure('OuterPosition',[633*posx,540*(1-posy),633, 540]);
    errorbar([info(i,ind10).aper0],[info(i,ind10).trc_mean],[info(i,ind10).trc_std],'.b');
    hold all;
    errorbar([info(i,ind05).aper0],[info(i,ind05).trc_mean],[info(i,ind05).trc_std],'.r');
    errorbar([info(i,ind01).aper0],[info(i,ind01).trc_mean],[info(i,ind01).trc_std],'.g');
    title(upper(planes{i}));
    mini = min([[info(i,:).aper0],[info(i,:).trc_mean]-[info(i,:).trc_std]]);
    maxi = max([[info(i,:).aper0],[info(i,:).trc_mean]+[info(i,:).trc_std]]);
    plot([mini,maxi],[mini,maxi],'k');
    xlabel('aper0');
    
    figure('OuterPosition',[633*posx,540*(1-posy),633, 540]);
    errorbar([info(i,ind10).aper1],[info(i,ind10).trc_mean],[info(i,ind10).trc_std],'.b');
    hold all;
    errorbar([info(i,ind05).aper1],[info(i,ind05).trc_mean],[info(i,ind05).trc_std],'.r');
    errorbar([info(i,ind01).aper1],[info(i,ind01).trc_mean],[info(i,ind01).trc_std],'.g');
    title(upper(planes{i}));
    mini = min([[info(i,:).aper1],[info(i,:).trc_mean]-[info(i,:).trc_std]]);
    maxi = max([[info(i,:).aper1],[info(i,:).trc_mean]+[info(i,:).trc_std]]);
    plot([mini,maxi],[mini,maxi],'k');
    xlabel('aper1');
    
    figure('OuterPosition',[633*posx,540*(1-posy),633, 540]);
    errorbar([info(i,ind10).aper2],[info(i,ind10).trc_mean],[info(i,ind10).trc_std],'.b');
    hold all;
    errorbar([info(i,ind05).aper2],[info(i,ind05).trc_mean],[info(i,ind05).trc_std],'.r');
    errorbar([info(i,ind01).aper2],[info(i,ind01).trc_mean],[info(i,ind01).trc_std],'.g');
    title(upper(planes{i}));
    mini = min([[info(i,:).aper2],[info(i,:).trc_mean]-[info(i,:).trc_std]]);
    maxi = max([[info(i,:).aper2],[info(i,:).trc_mean]+[info(i,:).trc_std]]);
    plot([mini,maxi],[mini,maxi],'k');
    xlabel('aper2');
    
    figure('OuterPosition',[633*posx,540*(1-posy),633, 540]);
    errorbar([info(i,ind10).aper3],[info(i,ind10).trc_mean],[info(i,ind10).trc_std],'.b');
    hold all;
    errorbar([info(i,ind05).aper3],[info(i,ind05).trc_mean],[info(i,ind05).trc_std],'.r');
    errorbar([info(i,ind01).aper3],[info(i,ind01).trc_mean],[info(i,ind01).trc_std],'.g');
    title(upper(planes{i}));
    mini = min([[info(i,:).aper3],[info(i,:).trc_mean]-[info(i,:).trc_std]]);
    maxi = max([[info(i,:).aper3],[info(i,:).trc_mean]+[info(i,:).trc_std]]);
    plot([mini,maxi],[mini,maxi],'k');
    xlabel('aper3');
end