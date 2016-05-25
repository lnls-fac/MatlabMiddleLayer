function aper = check_validity_of_chaos_indicator(lattices)

planes = {'x','y','ep','en'};
aper.ind0 = zeros(length(planes),length(lattices));
aper.ind1 = zeros(length(planes),length(lattices));
aper.ind2 = zeros(length(planes),length(lattices));
aper.ind3 = zeros(length(planes),length(lattices));
aper.trc_mean = zeros(length(planes),length(lattices));
aper.trc_std = zeros(length(planes),length(lattices));

for i = 1:length(lattices)
    si = lattices(i).lattice;
    if lattices(i).symmetry ~= 1
        mia = findcells(si,'FamName','mia');
        si  = si(1:mia(2));
    end
%     if mod(i,50), fprintf('.'); else fprintf('.\n'); end
    spos = findspos(si,1:length(si));
    maccep = findcells(si,'FamName','calc_mom_accep');
    pos = spos(maccep(6));
    fprintf('%04d     Symmetry: %3d\n',i,lattices(i).symmetry);
    for ii=1:length(planes)
%         aper.ind2(ii,i) = lnls_chaos_indicator2(si,planes{ii},lattices(i).symmetry,false);
        [aper.ind0(ii,i),aper.ind1(ii,i)] = ...
                    lnls_chaos_indicator(si,planes{ii},pos,true);
        [aper.trc_mean(ii,i),aper.trc_std(ii,i)] = aperture_from_tracking([lattices(i).folder,'trackcpp/'],planes{ii},pos);
        fprintf('%8s : %9.4f, %9.4f, %9.4f, %9.4f --> %9.4f\n',...
            upper(planes{ii}),aper.ind0(ii,i),aper.ind1(ii,i),aper.ind2(ii,i),aper.ind3(ii,i),aper.trc_mean(ii,i));
    end
end
fprintf('\n');


function [aper,rms] = aperture_from_tracking(folder,plane,pos)

a = zeros(1,20);
for i=1:20
    fullfolder = [folder,sprintf('rms%02d/',i)];
    if strcmpi(plane,'x')
        da = trackcpp_load_dynap_xy(fullfolder);
        if ~isempty(da)
            a(i) = da(find(da(1:end/2+1,2) == 0,1,'last'),1);
        end
    elseif strcmpi(plane,'y')
        da = trackcpp_load_dynap_xy(fullfolder);
        if ~isempty(da)
            a(i) = da(end/2+1,2);
        end
    elseif strcmpi(plane,'ep')
         [spos,accep] = trackcpp_load_ma_data(fullfolder);
         if ~isempty(accep)
             [~,ind] = min(abs(pos-spos));
             a(i) = accep(1,ind);
         end
    elseif strcmpi(plane,'en')
         [spos,accep] = trackcpp_load_ma_data(fullfolder);
         if ~isempty(accep)
             [~,ind] = min(abs(pos-spos));
             a(i) = accep(2,ind);
         end
    end
end
a = a(a~=0);
aper = mean(a);
rms = std(a);
