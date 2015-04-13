function [nux,nuy,diffu]=fmap_soleilnu(nx,ny,ax,ay)
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

pathold = path;

if (~findstr(pathold,'matlab\at\accelerator\simulator\element'))
    atinit;
end

soleilnu
radiationoff;
cavityoff;


%FitTune2([.25,.2],'QF','QD');
%FitChrom2([0.4,1.4],'SF','SD');
%FitTune2([.25,.2],'QF','QD');

plotbeta;

% [closeOrb] = findorbit6(THERING);
% closeOrb

fprintf('Type any key to continue ...\n');
pause;

NT = 1024;

T = ringpass(THERING,[0;0;0;0;0;0],1);

for i=1:nx
    ampx = ax*sqrt(i/nx);
    
    for j=1:ny
        ampy = ay*sqrt(j/ny);
        sampx = int2str(ampx);
        sampy = int2str(ampy);
        
        fprintf('amp_x=%g mm, amp_y=%g mm\n',ampx,ampy);
        
        X0=[ampx/1000 0 ampy/1000 0 0 0]';
        
        clear LOSSFLAG;
        cpustart=cputime;
        T = ringpass(THERING,X0,NT,'reuse');
        cpustop=cputime;
        fprintf('track time for 1024 turns : %g s\n',cpustop-cpustart);
        
        
        Tx = T(1,:);
        Txp = T(2,:);
        Ty = T(3,:);
        Typ = T(4,:);
        TE = T(5,:);
        Tphi = T(6,:);
        
        if (length(Ty)==1024) & (all(Ty<0.004)) ...
                & (~any(isnan(Ty))) & (LOSSFLAG==0)
            
            cpustart=cputime;
            [tmpnux1]=abs(calcnaff(Tx(1:512),Txp(1:512),1)/(2*pi));
            [tmpnuy1]=abs(calcnaff(Ty(1:512),Typ(1:512),1)/(2*pi));
            [tmpnux2]=abs(calcnaff(Tx(513:1024),Txp(513:1024),1)/(2*pi));
            [tmpnuy2]=abs(calcnaff(Ty(513:1024),Typ(513:1024),1)/(2*pi));
            
            cpustop=cputime;
            fprintf('NAFF CPU time (4*512 turns) : %g s\n',cpustop-cpustart);
            
            
            nux(i,j)=0.0; nuy(i,j) = 0.0;
            pampx(i,j)=-1;pampy(i,j)=-1;
            

     pampx(i,j)=ampx;
     pampy(i,j)=ampy;
    if ((abs(tmpnuy1(1))>0.001) & (abs(tmpnuy1(1)-tmpnux1(1))>0.001))
     nuy(i,j)=tmpnuy1(1);
      else
     nuy(i,j)=tmpnuy1(2);
      end         
    
      if (abs(tmpnux1(1))>0.001)
     nux(i,j)=tmpnux1(1);
      else
     nux(i,j)=tmpnux1(2);
      end            

     if ((abs(tmpnuy2(1))>0.001) & (abs(tmpnuy2(1)-tmpnux2(1))>0.001))
     nuy(i,j)=tmpnuy2(1);
      else
     nuy(i,j)=tmpnuy2(2);
      end         
    
      if (abs(tmpnux2(1))>0.001)
     nux(i,j)=tmpnux2(1);
      else
     nux(i,j)=tmpnux2(2);
      end            
            
           
            if (length(tmpnuy2)==1) & (length(tmpnux2)==1) & (length(nux(i,j))==1) & (length(nuy(i,j))==1)
                diffu(i,j)=log10(sqrt((tmpnuy2-nuy(i,j))^2+(tmpnux2-nux(i,j))^2)/512);
            else
                diffu(i,j) = -3;
            end
            
            if (diffu(i,j) < (-10))
                diffu(i,j) = -10;
            end
            
            taxi = ax*sqrt(i/nx);
            taxii = ax*sqrt((i-1)/nx);
            tayj = ay*sqrt(j/ny);
            tayjj = ay*sqrt((j-1)/ny);
            
            if (i>1) & (j>1)
                xpos(:,(i-1)*(ny)+j) = [taxii;taxii;taxi;taxi];
                ypos(:,(i-1)*(ny)+j) = [tayjj;tayj;tayj;tayjj];
            elseif (i>1)
                xpos(:,(i-1)*(ny)+j) = [taxii;taxii;taxi;taxi];
                ypos(:,(i-1)*(ny)+j) = [0;tayj;tayj;0];	
            elseif (j>1)	
                xpos(:,(i-1)*(ny)+j) = [0;0;taxi;taxi];
                ypos(:,(i-1)*(ny)+j) = [tayjj;tayj;tayj;tayjj];
            else
                xpos(:,(i-1)*(ny)+j) = [0;0;taxi;taxi];
                ypos(:,(i-1)*(ny)+j) = [0;tayj;tayj;0];
            end		
            
            nuxpos(:,(i-1)*(ny)+j) = ...
                [nux(i,j)-.0001;nux(i,j)-.0001;nux(i,j)+.0001;nux(i,j)+.0001];
            nuypos(:,(i-1)*(ny)+j) = ...
                [nuy(i,j)-.0006;nuy(i,j)+.0006;nuy(i,j)+.0006;nuy(i,j)-.0006];
            
            diffuvec(1:4,(i-1)*(ny)+j) = diffu(i,j);
            
            
        else
            nux(i,j)=0.0; nuy(i,j)=0.0;
            pampx(i,j)=-1;pampy(i,j)=-1;
            xpos(:,(i-1)*(ny)+j) = [0;0;0;0];			
            ypos(:,(i-1)*(ny)+j) = [0;0;0;0];			
            nuxpos(:,(i-1)*(ny)+j) = [0;0;0;0];
            nuypos(:,(i-1)*(ny)+j) = [0;0;0;0];
            diffu(i,j)=-10;
            diffuvec(1:4,(i-1)*(ny)+j) = [-10;-10;-10;-10];
        end
        
        if nux(i,j) & nuy(i,j)
            fprintf('nu_x=%g, nu_y=%g\n',14+nux(i,j),8+nuy(i,j));
        else
            fprintf('particle lost\n');
        end
        
    end
    
    save 'freqmap_new' nux nuy diffu nuxpos nuypos xpos ypos diffuvec pampx pampy
    
end

f1=figure;
plot(18+nux,10+nuy,'b.');
axis([18.2 18.5 10.0 10.5]);
title('SOLEIL lattice, calculated frequency map (NAFF)');
xlabel('\nu_x');
ylabel('\nu_y');
pause(0.1);

if min(size(diffu)) > 1
    
    figure;
    fill(xpos,ypos,diffuvec);
    axis([0 ax 0 ay]);
    caxis([-10 -3]);
    hold on;
    shading flat;
    colormap('jet');
    colorbar;
    title('SOLEIL lattice, calculated frequency map (NAFF)');
    xlabel('x position (mm) (injection straight)');
    ylabel('z position (mm)');
    hold off;
    
    figure;
    fill(18+nuxpos,10+nuypos,diffuvec);
    axis([18.2 18.5 10.0 10.5]);
    caxis([-10 -3]);
    hold on;
    shading flat;
    colormap('jet');
    colorbar;
    title('SOLEIL lattice, calculated frequency map (NAFF)');
    xlabel('\nu_x');
    ylabel('\nu_z');
    hold off;
    
end
