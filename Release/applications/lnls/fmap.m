function r = fmap(nx,ny,ax,ay)
% Simulates a frequency map using the tracking routine's out of Andrei Terebilos AT toolbox and Jacques Laskars NAFF algorithm 
%
% function [nux,nuy,diffu] = lnls1_fmap_soleil(nx,ny,ax,ay)
%
% simulates a frequency map using the tracking
% routine's out of Andrei Terebilos AT toolbox and
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
% Ximenes Resende, LNLS1 10-03-25
%
% adapted from fmap_soleilnu.m
% Laurent Nadolski, ALS 09/01/02


global THERING;


p.nr_turns       = 1024 + 2;
p.nx             = nx;
p.ny             = ny; 
p.ax             = ax;
p.ay             = ay;


%pathold = path;
%if (~findstr(pathold,'matlab\at\accelerator\simulator\element'))
%    atinit;
%end

setradiation('off');
setcavity('off');


%FitTune2([.25,.2],'QF','QD');
%FitChrom2([0.4,1.4],'SF','SD');
%FitTune2([.25,.2],'QF','QD');
%plotbeta;
% [closeOrb] = findorbit6(THERING);
% closeOrb
%T = ringpass(THERING,[0 0 0 0 0 0]',1);



r = [];

for i=1:p.nx
    
    ampx = p.ax*sqrt(i/p.nx);
    dx   = p.ax*sqrt((i-1)/p.nx) - ampx;
    
    for j=1:p.ny
        
        ampy = p.ay*sqrt(j/p.ny);
        dy   = p.ay*sqrt((j-1)/p.ny) - ampy;
        
        fprintf('\n');
        fprintf('Point #(%i,%i)\n', i,j);
        fprintf('PosX = %g mm, PosY = %g mm\n',ampx,ampy);
        
        cpustart=cputime;
        X0=[ampx/1000 0 ampy/1000 0 0 0]';
        T1 = ringpass(THERING,X0,p.nr_turns,'reuse');
        X0=[-ampx/1000 0 ampy/1000 0 0 0]';
        T2 = ringpass(THERING,X0,p.nr_turns,'reuse');
        X0=[-ampx/1000 0 -ampy/1000 0 0 0]';
        T3 = ringpass(THERING,X0,p.nr_turns,'reuse');
        X0=[ampx/1000 0 -ampy/1000 0 0 0]';
        T4 = ringpass(THERING,X0,p.nr_turns,'reuse');
        cpustop=cputime;
        fprintf('track time for 4 x %i turns : %g s\n',p.nr_turns,cpustop-cpustart);
        
        cpustart=cputime;
        [nux1 nuy1 diffu1] = get_freq(p, T1);
        [nux2 nuy2 diffu2] = get_freq(p, T2);
        [nux3 nuy3 diffu3] = get_freq(p, T3);
        [nux4 nuy4 diffu4] = get_freq(p, T4);
        cpustop=cputime;
        fprintf('NAFF time for 4 x %i turns : %g s\n',p.nr_turns,cpustop-cpustart);
        
        nux = nux1; nuy = nuy1; diffu = diffu1; sx = 1; sy = 1;
        if nux ~= 0 && nuy ~= 0
            fprintf('nuX = %g, nuY = %g\n',nux,nuy);
            r(size(r,1)+1,:) = [i j sx*ampx/1000 sy*ampy/1000 sx*dx/1000 sy*dy/1000 nux nuy diffu];
            
        else
            fprintf('particle lost\n');
        end
        
        nux = nux2; nuy = nuy2; diffu = diffu2; sx = -1; sy = 1;
        if nux ~= 0 && nuy ~= 0
            fprintf('nuX = %g, nuY = %g\n',nux,nuy);
            r(size(r,1)+1,:) = [i j sx*ampx/1000 sy*ampy/1000 sx*dx/1000 sy*dy/1000 nux nuy diffu];
            
        else
            fprintf('particle lost\n');
        end
        
        nux = nux3; nuy = nuy3; diffu = diffu3; sx = -1; sy = -1;
        if nux ~= 0 && nuy ~= 0
            fprintf('nuX = %g, nuY = %g\n',nux,nuy);
            r(size(r,1)+1,:) = [i j sx*ampx/1000 sy*ampy/1000 sx*dx/1000 sy*dy/1000 nux nuy diffu];
            
        else
            fprintf('particle lost\n');
        end
        
        nux = nux4; nuy = nuy4; diffu = diffu4; sx = 1; sy = -1;
        if nux ~= 0 && nuy ~= 0
            fprintf('nuX = %g, nuY = %g\n',nux,nuy);
            r(size(r,1)+1,:) = [i j sx*ampx/1000 sy*ampy/1000 sx*dx/1000 sy*dy/1000 nux nuy diffu];
            dlmwrite('fmap.txt', r, 'newline', 'pc', 'delimiter', ' '); 
        else
            fprintf('particle lost\n');
        end
       
        
       
        
        
        
    end
    
    
    
end



function  [nux nuy diffu] = get_freq(p, T)

Tx  = T(1,:);
Txp = T(2,:);
Ty  = T(3,:);
Typ = T(4,:);

nux   = 0.0; 
nuy   = 0.0;
diffu = -10; 
 
if (length(Ty)==p.nr_turns) && (~any(isnan(Ty))) && (length(Tx)==p.nr_turns) && (~any(isnan(Tx)))
    
    
    [tmpnux1]=abs(calcnaff(Tx(1:(p.nr_turns/2)),Txp(1:(p.nr_turns/2)),1)/(2*pi));
    [tmpnuy1]=abs(calcnaff(Ty(1:(p.nr_turns/2)),Typ(1:(p.nr_turns/2)),1)/(2*pi));
    [tmpnux2]=abs(calcnaff(Tx((1+p.nr_turns/2):p.nr_turns),Txp((1+p.nr_turns/2):p.nr_turns),1)/(2*pi));
    [tmpnuy2]=abs(calcnaff(Ty((1+p.nr_turns/2):p.nr_turns),Typ((1+p.nr_turns/2):p.nr_turns),1)/(2*pi));
    
    
    if ((abs(tmpnuy1(1))>0.001) && (abs(tmpnuy1(1)-tmpnux1(1))>0.001))
        nuy = tmpnuy1(1);
    else
        nuy = tmpnuy1(2);
    end
    
    if (abs(tmpnux1(1))>0.001)
        nux = tmpnux1(1);
    else
        nux = tmpnux1(2);
    end
    
    if ((abs(tmpnuy2(1))>0.001) && (abs(tmpnuy2(1)-tmpnux2(1))>0.001))
        nuy = tmpnuy2(1);
    else
        nuy = tmpnuy2(2);
    end
    
    if (abs(tmpnux2(1))>0.001)
        nux = tmpnux2(1);
    else
        nux = tmpnux2(2);
    end
    
    
    diffu=log10(sqrt((tmpnuy2(1)-tmpnuy1(1))^2+(tmpnux2(1)-tmpnux1(1))^2)/(p.nr_turns/2));
    
    
    if (diffu < (-10))
        diffu = -10;
    end
    if (diffu > -3) || isnan(diffu)
        diffu = -3;
    end
    
    
end
