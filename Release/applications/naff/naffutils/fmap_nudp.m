function [nux,nuy]=fmap_nudp(ndp,deltamax)
% function [nux,nuy]=sim_fmap_at_naff_diffu_3sb(nxmin,nxmax,nx,nymin,nymax,ny,ax,ay)
%
% simulates a frequency map using the tracking
% routine's out of Andrei Terebilos ATtoolbox and
% Jacques Laskars NAFF algorithm
% (calcnaff.mex or calcnaff.dll)
%
% nux, nuy 		are the returned betatron tune values
% diffu			is the returned diffusion rate
%
% nx		number of horizontal amplitudes
% ny		number of vertical amplitudes
% ax		maximum horizontal amplitude [mm]
% ay		maximum vertical amplitude [mm]
%
% Laurent Nadolski, ALS 09/01/02

global THERING

radiationoff;
cavityoff;

%plotbeta;

fprintf('Type any key to continue ...\n');
%pause;

NT = 1026;

T = ringpass(THERING,[0;0;0;0;0;0],1);

for i=1:ndp
    %fprintf('amp_x=%g mm, amp_y=%g mm\n',ampx,ampy);
    delta = i*deltamax/ndp;
    X0=[0 0 0 0 delta 0]';

    cpustart=cputime;
    [T LOSSFLAG] = ringpass(THERING,X0,NT,'reuse');
    cpustop=cputime;
    fprintf('track time for %d turns : %g s\n', NT, cpustop-cpustart);

    Tx = T(1,:);  Txp = T(2,:);
    Ty = T(3,:);  Typ = T(4,:);
    TE = T(5,:);  Tphi = T(6,:);

    if (length(Ty)==NT) & (all(Ty<0.004)) ...
            & (~any(isnan(Ty))) & (LOSSFLAG==0)

        cpustart = cputime;
        [tmpnux1] = abs(calcnaff(Tx(1:NT),Txp(1:NT),1)/(2*pi));
        [tmpnuy1] = abs(calcnaff(Ty(1:NT),Typ(1:NT),1)/(2*pi));

        cpustop=cputime;
        fprintf('NAFF CPU time (4*512 turns) : %g s\n',cpustop-cpustart);

        nux(i)=NaN; nuy(i) = NaN;
        
        if abs(tmpnux1(1)) > 1e-6
            nux(i) = tmpnux1(1);
        else
            nux(i) = tmpnux1(2);
        end

        if abs(tmpnuy1(1)) > 1e-6
            nuy(i) = tmpnuy1(1);
        else
            nuy(i) = tmpnuy1(2);
        end
    end
end

