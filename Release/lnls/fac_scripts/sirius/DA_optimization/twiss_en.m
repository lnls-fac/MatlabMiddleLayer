
den=linspace(-2,2,7)*1e-2;

for i=1:length(den), twi{i} = calctwiss(the_ring,den(i),1:length(the_ring));end;

mux = []; for i=1:length(den), mux(i,:) = twi{i}.betax;end;
chromx = []; for i = 1:size(mux,2), chromx(:,i) = lnls_polyfit(den,mux(:,i),[0,1,2,3,4,5]); end

muy = []; for i=1:length(den), muy(i,:) = twi{i}.betay;end;
chromy = []; for i = 1:size(muy,2), chromy(:,i) = lnls_polyfit(den,muy(:,i),[0,1,2,3,4,5]); end


figure; axes; hold all;
plot(twi{1}.pos,[chromx(1,:);chromy(1,:)]);
% lnls_drawlattice(the_ring,5,-2,true,0.1,false,false);

figure; axes; hold all;
plot(twi{1}.pos,[chromx(2,:);chromy(2,:)]);
% lnls_drawlattice(the_ring,5,-1e4,true,1e4,false,false);

figure; axes; hold all;
plot(twi{1}.pos,[chromx(3,:);chromy(3,:)]);
% lnls_drawlattice(the_ring,5,300,true,100,false,false);