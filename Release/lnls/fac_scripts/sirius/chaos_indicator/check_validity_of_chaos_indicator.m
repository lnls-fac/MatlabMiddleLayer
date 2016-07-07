function info = check_validity_of_chaos_indicator(lattices)

planes = {'x','y','ep','en'};

info = struct('x', {}, 'y', {}, 'ep', {}, 'en', {});

flag_plot = false;

for i = 1:length(lattices)
    si = lattices(i).lattice;
    if lattices(i).symmetry ~= 1
        mia = findcells(si,'FamName','mia');
        si  = si(1:mia(2));
    end
    
    spos = findspos(si,1:length(si));
    maccep = findcells(si,'FamName','calc_mom_accep');
    
    fprintf('%04d     Symmetry: %3d\n',i,lattices(i).symmetry);
    fprintf('%8s   %9s  %9s  %9s  %9s     %9s\n',...
            'plane', 'stb', 'adr','dif','win', 'tracking');
    for ii = 1:length(planes);
        pl = planes{ii};
        if pl == 'x'
            pos = 0.0;
            offset = [0;0;5e-5;0;0;0];
        elseif pl == 'y'
            pos = 0.0;
            offset = [1e-4;0;0;0;0;0];
        else
            %pos = spos(maccep([1,3,6,10,12]));
            pos = spos(maccep(6));
            offset = [0;0;0;0;0;0];
        end
        info(i).(pl) = lnls_chaos_indicator(si,pl,pos,flag_plot,...
            calc_window(si,lattices(i).symmetry),offset);
        [info(i).(pl).trc_mean,info(i).(pl).trc_std] = ...
            aperture_from_tracking([lattices(i).folder,'trackcpp/'],pl,pos);
        fprintf('%8s : %9.4f, %9.4f, %9.4f, %9.4f --> %9.4f\n',...
            upper(pl),info(i).(pl).aper_stb(1),info(i).(pl).aper_adr(1),...
            info(i).(pl).aper_dif(1),info(i).(pl).aper_win(1),info(i).(pl).trc_mean);
    end
end
fprintf('\n');

function window = calc_window(ring, symmetry)

pos = 0.0;
offset = [0;0;0;0;0;0];
n = 7;
nturns = 2*(2^n + 6 - mod(2^n,6)) - 1;

offset([2,4]) = offset([2,4]) + 1e-6;

spos = findspos(ring,1:length(ring));
[~,point] = min(abs(pos-spos));
ring = ring([point:end,1:point-1]);

Rin = offset;
Rou = [Rin, ringpass(ring,Rin,nturns)];

x0  = reshape(Rou(1,:),[],nturns+1); % +1, because of initial condition
xl = reshape(Rou(2,:),[],nturns+1);
y0  = reshape(Rou(3,:),[],nturns+1);
yl = reshape(Rou(4,:),[],nturns+1);

tunex = lnls_calcnaff(x0, xl);
tuney = lnls_calcnaff(y0, yl);

side = 0.5/symmetry;
margem = 5e-3/symmetry;

kx = floor(tunex/side);
ky = floor(tuney/side);

window = [-1 0 kx*side+margem; 0 -1 ky*side+margem;...
            1 0 (kx+1)*side-margem; 0 1 (ky+1)*side-margem];



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
