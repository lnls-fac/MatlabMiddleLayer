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
    pl = planes{i};
    aux = [info(:).(pl)];
%     posx = mod(i-1,2);
%     posy = floor((i-1)/2);
    posx = 0;
    posy = 0;
    figure('OuterPosition',[633*posx,540*(1-posy),633, 540]);
    errorbar([aux(ind10).aper_stb],[aux(ind10).trc_mean],[aux(ind10).trc_std],'.b');
    hold all;
    errorbar([aux(ind05).aper_stb],[aux(ind05).trc_mean],[aux(ind05).trc_std],'.r');
    errorbar([aux(ind01).aper_stb],[aux(ind01).trc_mean],[aux(ind01).trc_std],'.g');
    title(upper(planes{i}));
    mini = min([[aux(:).aper_stb],[aux(:).trc_mean]-[aux(:).trc_std]]);
    maxi = max([[aux(:).aper_stb],[aux(:).trc_mean]+[aux(:).trc_std]]);
    plot([mini,maxi],[mini,maxi],'k');
    xlabel('stability');
    
    posx = 0;
    posy = 1;
    figure('OuterPosition',[633*posx,540*(1-posy),633, 540]);
    errorbar([aux(ind10).aper_adr],[aux(ind10).trc_mean],[aux(ind10).trc_std],'.b');
    hold all;
    errorbar([aux(ind05).aper_adr],[aux(ind05).trc_mean],[aux(ind05).trc_std],'.r');
    errorbar([aux(ind01).aper_adr],[aux(ind01).trc_mean],[aux(ind01).trc_std],'.g');
    title(upper(planes{i}));
    mini = min([[aux(:).aper_adr],[aux(:).trc_mean]-[aux(:).trc_std]]);
    maxi = max([[aux(:).aper_adr],[aux(:).trc_mean]+[aux(:).trc_std]]);
    plot([mini,maxi],[mini,maxi],'k');
    xlabel('average distance ratio');
    
    posx = 1;
    posy = 0;
    figure('OuterPosition',[633*posx,540*(1-posy),633, 540]);
    errorbar([aux(ind10).aper_dif],[aux(ind10).trc_mean],[aux(ind10).trc_std],'.b');
    hold all;
    errorbar([aux(ind05).aper_dif],[aux(ind05).trc_mean],[aux(ind05).trc_std],'.r');
    errorbar([aux(ind01).aper_dif],[aux(ind01).trc_mean],[aux(ind01).trc_std],'.g');
    title(upper(planes{i}));
    mini = min([[aux(:).aper_dif],[aux(:).trc_mean]-[aux(:).trc_std]]);
    maxi = max([[aux(:).aper_dif],[aux(:).trc_mean]+[aux(:).trc_std]]);
    plot([mini,maxi],[mini,maxi],'k');
    xlabel('diffusion');
    
    posx = 1;
    posy = 1;
    figure('OuterPosition',[633*posx,540*(1-posy),633, 540]);
    errorbar([aux(ind10).aper_win],[aux(ind10).trc_mean],[aux(ind10).trc_std],'.b');
    hold all;
    errorbar([aux(ind05).aper_win],[aux(ind05).trc_mean],[aux(ind05).trc_std],'.r');
    errorbar([aux(ind01).aper_win],[aux(ind01).trc_mean],[aux(ind01).trc_std],'.g');
    title(upper(planes{i}));
    mini = min([[aux(:).aper_win],[aux(:).trc_mean]-[aux(:).trc_std]]);
    maxi = max([[aux(:).aper_win],[aux(:).trc_mean]+[aux(:).trc_std]]);
    plot([mini,maxi],[mini,maxi],'k');
    xlabel('tune window');
end