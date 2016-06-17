function info = check_validity_of_chaos_indicator(lattices)

planes = {'x','y','ep','en'};
info = struct('aper0', {}, 'aper1', {}, 'aper2', {}, 'aper3', {}, ...
    'trc_mean', {}, 'trc_std', {}, 'nmlam', {}, 'ratio_lam', {}, ...
    'x_chaos', {}, 'diff_ind', {}, 'x_diff', {});

flag_plot = false;

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
        [info(ii,i).aper0,info(ii,i).aper1,info(ii,i).nmlam, ...
            info(ii,i).ratio_lam,info(ii,i).x_chaos] = ...
        	lnls_chaos_indicator(si,planes{ii},pos,flag_plot);
        [info(ii,i).aper2,info(ii,i).aper3,info(ii,i).diff_ind,info(ii,i).x_diff] = ...
        	lnls_diffusion_indicator(si,planes{ii},pos,...
            flag_plot,calc_window(si,lattices(i).symmetry));
        [info(ii,i).trc_mean,info(ii,i).trc_std] = ...
            aperture_from_tracking([lattices(i).folder,'trackcpp/'],planes{ii},pos);
        fprintf('%8s : %9.4f, %9.4f, %9.4f, %9.4f --> %9.4f\n',...
            upper(planes{ii}),info(ii,i).aper0,info(ii,i).aper1,...
            info(ii,i).aper2,info(ii,i).aper3,info(ii,i).trc_mean);
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
