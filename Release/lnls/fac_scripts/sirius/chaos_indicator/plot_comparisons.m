function plot_comparisons(lattices,aper)

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
    errorbar(aper.ind0(i,ind10),aper.trc_mean(i,ind10),aper.trc_std(i,ind10),'.b');
    hold all;
    errorbar(aper.ind0(i,ind05),aper.trc_mean(i,ind05),aper.trc_std(i,ind05),'.r');
    errorbar(aper.ind0(i,ind01),aper.trc_mean(i,ind01),aper.trc_std(i,ind01),'.g');
    title(upper(planes{i}));
    mini = min([aper.ind0(i,:),aper.trc_mean(i,:)-aper.trc_std(i,:)]);
    maxi = max([aper.ind0(i,:),aper.trc_mean(i,:)+aper.trc_std(i,:)]);
    plot([mini,maxi],[mini,maxi],'k');
    xlabel('ind1');
    
    figure('OuterPosition',[633*posx,540*(1-posy),633, 540]);
    errorbar(aper.ind1(i,ind10),aper.trc_mean(i,ind10),aper.trc_std(i,ind10),'.b');
    hold all;
    errorbar(aper.ind1(i,ind05),aper.trc_mean(i,ind05),aper.trc_std(i,ind05),'.r');
    errorbar(aper.ind1(i,ind01),aper.trc_mean(i,ind01),aper.trc_std(i,ind01),'.g');
    title(upper(planes{i}));
    mini = min([aper.ind1(i,:),aper.trc_mean(i,:)-aper.trc_std(i,:)]);
    maxi = max([aper.ind1(i,:),aper.trc_mean(i,:)+aper.trc_std(i,:)]);
    plot([mini,maxi],[mini,maxi],'k');
    xlabel('ind2');
end