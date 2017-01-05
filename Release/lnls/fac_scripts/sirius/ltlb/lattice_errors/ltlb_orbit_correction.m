[ltlb, tit, Twiss0] = sirius_tb_lattice;

um = 1e-6;
mm = 1e-3;
mrad = 1e-3;
pc = 1e-2;

Path = mfilename('fullpath');
ip = strfind(Path,'/');
Path = Path(1:ip(end));

% Errors
rms_alix = 0.3 * mm;
rms_aliy = 0.3 * mm;
rms_roll = 0.4 * mrad;
rms_ex   = 0.1 * pc;
rms_x0   = 0.4 * mm;
rms_xp0  = 0.1 * mrad;
rms_y0   = 0.4 * mm;
rms_yp0  = 0.1 * mrad;
rms_dp0  = 0.5 * pc;
rms_bpm  = 0.5 * mm;
n_maquinas = 100;

t=twissline(ltlb,0.0,Twiss0,1:length(ltlb)+1,'chrom');

s=cat(1,t.SPos);
beta=cat(1,t.beta);
disp=[t.Dispersion];
d=disp(1,:)';

ind_bpm = sort([findcells(ltlb, 'FamName', 'bpm'), findcells(ltlb, 'FamName', 'bpm')]);
ind_ch = findcells(ltlb, 'FamName', 'hcm');
ind_cv = findcells(ltlb, 'FamName', 'vcm');

sBPM = s(ind_bpm);

nBPM = length(ind_bpm);
nch = length(ind_ch);
ncv = length(ind_cv);

%inicializa matrizes
dteta_ch = zeros(nch,n_maquinas);
dteta_cv = zeros(ncv,n_maquinas);
MH = zeros(nBPM,nch);
MV = zeros(nBPM,ncv);
orbx = zeros(length(ltlb)+1,n_maquinas);
orby = orbx;
orbcx = orbx;
orbcy = orbx;
x_BPM = zeros(nBPM,n_maquinas);
y_BPM = x_BPM;
xc_BPM = x_BPM;
yc_BPM = x_BPM;
orb_semcorr_fim = zeros(4,n_maquinas);

% Matriz resposta horizontal
for i=1:nch
    for j=1:nBPM
        %sub-linha de corretor a BPM
        if (ind_ch(i) < ind_bpm(j));
            line = ltlb(ind_ch(i):ind_bpm(j));
            t1=twissline(line,0,Twiss0,1:length(line));
            M=cat(1,t1.M44);
            MH(j,i)=M(end-3,2);
        end
    end
end

% Matriz resposta vertical
for i=1:ncv
    for j=1:nBPM
        %sublinha de corretor a BPM
        if (ind_cv(i)<ind_bpm(j))
            line = ltlb(ind_cv(i):ind_bpm(j));
            t1=twissline(line,0,Twiss0,1:length(line));
            M=cat(1,t1.M44);
            MV(j,i)=M(end-1,4);
        end
    end
end

% Matrizes de corre??o
[UH,SH,VH] = svd(MH);
MCH = -VH*inv(SH)*UH';

[UV,SV,VV] = svd(MV);
MCV = -VV*inv(SV)*UV';

% Erros de alinhamento e excita??o em dipolos e quadrupolos
idx = findcells(ltlb,'K');
ltlb_Ori = ltlb;

% Loop nas m?quinas aleatorias
for nmaq=1:n_maquinas
    ltlb = ltlb_Ori;
    % Distribui??o uniforme de erros
    errox = (-1+2*rand(1,length(idx))) * rms_alix;
    erroy = (-1+2*rand(1,length(idx))) * rms_aliy;
    erroex = (-1+2*rand(1,length(idx))) * rms_ex;
    erroroll = (-1+2*rand(1,length(idx))) * rms_roll;
    %erro de alinhamento de BPM
    ebpmx = (-1+2*rand(1,nBPM)) * rms_bpm;
    ebpmy = (-1+2*rand(1,nBPM)) * rms_bpm;

    ltlb = lnls_add_misalignmentX(errox, idx, ltlb);
    ltlb = lnls_add_misalignmentY(erroy, idx, ltlb);
    ltlb = lnls_add_rotation_ROLL(erroroll, idx, ltlb);
    ltlb = lnls_add_excitation(erroex, idx, ltlb);

% Orbit without correction
    % Error in lauching conditions
    ex0 = (-1+2*rand(1)) * rms_x0;
    exp0 = (-1+2*rand(1)) * rms_xp0;
    ey0 = (-1+2*rand(1)) * rms_y0;
    eyp0 = (-1+2*rand(1)) * rms_yp0;
    Twiss0.ClosedOrbit=[ex0; exp0; ey0; eyp0];
    dp0 = (-1+2*rand(1)) * rms_dp0;

    t=twissline(ltlb,dp0,Twiss0,1:length(ltlb)+1);
    for i=1:length(t)
        orbx(i,nmaq)=t(i).ClosedOrbit(1);
        orby(i,nmaq)=t(i).ClosedOrbit(3);
    end
    orb_semcorr_fim(:,nmaq)=t(end).ClosedOrbit;


% Orbita nos BPMs
    x_BPM(:,nmaq) = orbx(ind_bpm,nmaq);
    y_BPM(:,nmaq) = orby(ind_bpm,nmaq);

    xc_BPM(:,nmaq) = x_BPM(:,nmaq);
    yc_BPM(:,nmaq) = y_BPM(:,nmaq);

    %Itera

    dteta_ch(:,nmaq) = MCH * (xc_BPM(:,nmaq) + ebpmx');
    dteta_cv(:,nmaq) = MCV * (yc_BPM(:,nmaq) + ebpmy');

    for i=1:nch
        tetaori=ltlb{ind_ch(i)}.KickAngle(1);
        ltlb{ind_ch(i)}.KickAngle = [tetaori+dteta_ch(i,nmaq) 0];
    end

    for i=1:ncv
        tetaori=ltlb{ind_cv(i)}.KickAngle(2);
        ltlb{ind_cv(i)}.KickAngle = [0 dteta_cv(i,nmaq)+tetaori];
    end

% Orbita corrigida
    t=twissline(ltlb,dp0,Twiss0,1:length(ltlb)+1);
    for i=1:length(t)
        orbcx(i,nmaq)=t(i).ClosedOrbit(1);
        orbcy(i,nmaq)=t(i).ClosedOrbit(3);
    end
    orb_corr_fim(:,nmaq)=t(end).ClosedOrbit;

% Orbita corrigida nos BPMs
    xc_BPM(:,nmaq) = orbcx(ind_bpm,nmaq);
    yc_BPM(:,nmaq) = orbcy(ind_bpm,nmaq);

%    erroex = (-1+2*rand(1,length(idx))) * 1/1000;
%    ltlb = lnls_add_excitation(erroex, idx, ltlb);
%    t=twissline(ltlb,dp0,Twiss0,1:length(ltlb)+1);
%    orb_ripple_fim(:,nmaq)=t(end).ClosedOrbit - orb_corr_fim(:,nmaq);

end

for i=1:n_maquinas
    orbx_ptp(i) = max(orbx(:,i)) - min(orbx(:,i));
    orby_ptp(i) = max(orby(:,i)) - min(orby(:,i));
    orbcx_ptp(i) = max(orbcx(:,i)) - min(orbcx(:,i));
    orbcy_ptp(i) = max(orbcy(:,i)) - min(orbcy(:,i));
end

orbx_rms = std(orbx,0,2);
orby_rms = std(orby,0,2);
orbcx_rms = std(orbcx,0,2);
orbcy_rms = std(orbcy,0,2);
x_BPM_rms = std(x_BPM,0,2);
y_BPM_rms = std(y_BPM,0,2);
xc_BPM_rms = std(xc_BPM,0,2);
yc_BPM_rms = std(yc_BPM,0,2);
orb_semcorr_fim_rms = std(orb_semcorr_fim,0,2);
%orb_ripple_fim_rms = std(orb_ripple_fim,0,2);

%separando ch e septum
dteta_sep = dteta_ch(end,:);       %ultimo
dteta_cch = dteta_ch(1:end-1,:);   %todos outros
teta_cch_rms = std(dteta_cch(:));
teta_sep_rms = std(dteta_sep(:));
teta_cv_rms = std(dteta_cv(:));
teta_cch_max = max(abs(dteta_cch(:)));
teta_sep_max = max(abs(dteta_sep(:)));
teta_cv_max = max(abs(dteta_cv(:)));

% Correction summary
% Before correction
Xmax = max(orbx_rms);
Ymax = max(orby_rms);
XBPMmax = max(x_BPM_rms);
YBPMmax = max(y_BPM_rms);
Xptp_mean = mean(orbx_ptp);
Yptp_mean = mean(orby_ptp);
Xptp_max = max(orbx_ptp);
Yptp_max = max(orby_ptp);

%After correction
Xcmax = max(orbcx_rms);
Ycmax = max(orbcy_rms);
XcBPMmax = max(xc_BPM_rms);
YcBPMmax = max(yc_BPM_rms);
Xcptp_mean = mean(orbcx_ptp);
Ycptp_mean = mean(orbcy_ptp);
Xcptp_max = max(orbcx_ptp);
Ycptp_max = max(orbcy_ptp);

fout = fopen([Path 'Correction_summary_' tit '.out'], 'w');
fprintf(fout,'Correction_summary\n');
fprintf(fout,['BTS Transfer Line - ' tit '\n']);
fprintf(fout,'Uniform random errors for all dipoles, septa and quadrupoles\n');
fmt = 'x alignment = +-%g mm\n'; fprintf(fout,fmt,rms_alix/mm);
fmt = 'y alignment = +-%g mm\n'; fprintf(fout,fmt,rms_aliy/mm);
fmt = 'roll = +-%g mrad\n'; fprintf(fout,fmt,rms_roll/mrad);
fmt = 'relative excitation = +-%g %%\n'; fprintf(fout,fmt,rms_ex/pc);
fmt = 'x and y bpm offset = +-%g mm\n'; fprintf(fout,fmt,rms_bpm/mm);
fmt = 'x launching condition = +-%g mm\n'; fprintf(fout,fmt,rms_x0/mm);
fmt = 'xp launching condition = +-%g mrad\n'; fprintf(fout,fmt,rms_xp0/mrad);
fmt = 'y launching condition = +-%g mm\n'; fprintf(fout,fmt,rms_y0/mm);
fmt = 'yp launching condition = +-%g mrad\n'; fprintf(fout,fmt,rms_yp0/mrad);
fmt = 'dp/p launching condition = +-%g %%\n'; fprintf(fout,fmt,rms_dp0/pc);
fmt = 'number of machines = %i\n\n'; fprintf(fout,fmt,n_maquinas);

fmt = '                          before   after \n'; fprintf(fout,fmt);
fmt = '                          (mm)     (mm)  \n'; fprintf(fout,fmt);
fmt = 'Max. rms H orbit          %5.3f    %5.3f \n'; fprintf(fout,fmt,Xmax/mm,Xcmax/mm);
fmt = 'Max. rms V orbit          %5.3f    %5.3f \n'; fprintf(fout,fmt,Ymax/mm,Ycmax/mm);
fmt = 'Max. rms H orbit @ BPMs   %5.3f    %5.3f \n'; fprintf(fout,fmt,XBPMmax/mm,XcBPMmax/mm);
fmt = 'Max. rms V orbit @ BPMs   %5.3f    %5.3f \n'; fprintf(fout,fmt,YBPMmax/mm,YcBPMmax/mm);
fmt = 'Average H peak-to-peak    %5.3f    %5.3f \n'; fprintf(fout,fmt,Xptp_mean/mm,Xcptp_mean/mm);
fmt = 'Average V peak-to-peak    %5.3f    %5.3f \n'; fprintf(fout,fmt,Yptp_mean/mm,Ycptp_mean/mm);
fmt = 'Max. H peak-to-peak       %5.3f    %5.3f \n'; fprintf(fout,fmt,Xptp_max/mm,Xcptp_max/mm);
fmt = 'Max. V peak-to-peak       %5.3f    %5.3f \n\n'; fprintf(fout,fmt,Yptp_max/mm,Ycptp_max/mm);

fmt = '                        CH      CV      septa \n'; fprintf(fout,fmt);
fmt = '                       (mrad)  (mrad)  (mrad) \n'; fprintf(fout,fmt);
fmt = 'rms corrector strength  %5.3f   %5.3f   %5.3f  \n'; fprintf(fout,fmt,teta_cch_rms/mrad,teta_cv_rms/mrad,teta_sep_rms/mrad);
fmt = 'Max corrector strength  %5.3f   %5.3f   %5.3f  \n\n'; fprintf(fout,fmt,teta_cch_max/mrad,teta_cv_max/mrad,teta_sep_max/mrad);

tetai_ch_rms = std(dteta_ch,0,2);
tetai_cv_rms = std(dteta_cv,0,2);
tetai_ch_max = max(abs(dteta_ch),[],2);
tetai_cv_max = max(abs(dteta_cv),[],2);
fmt = '      rms     max \n'; fprintf(fout,fmt);
fmt = '     (mrad)  (mrad) \n'; fprintf(fout,fmt);

for i=1:nch
    fmt = 'CH%i  %5.3f   %5.3f  \n'; fprintf(fout,fmt,i,tetai_ch_rms(i)/mrad,tetai_ch_max(i)/mrad);
end
for i=1:ncv
    fmt = 'CV%i  %5.3f   %5.3f  \n'; fprintf(fout,fmt,i,tetai_cv_rms(i)/mrad,tetai_cv_max(i)/mrad);
end

%fmt = '\n Vibration study - rms position at line end without correction\n'; fprintf(fout,fmt);
%fmt = 'rms_x : %5.3f mm\n'; fprintf(fout,fmt,orb_semcorr_fim_rms(1)/mm);
%fmt = 'rms_xp: %5.3f mrad\n'; fprintf(fout,fmt,orb_semcorr_fim_rms(2)/mrad);
%fmt = 'rms_y : %5.3f mm\n'; fprintf(fout,fmt,orb_semcorr_fim_rms(3)/mm);
%fmt = 'rms_yp: %5.3f mrad\n'; fprintf(fout,fmt,orb_semcorr_fim_rms(4)/mrad);

%fmt = '\n Ripple study \n'; fprintf(fout,fmt);
%fmt = 'rms_x : %5.3f mm\n'; fprintf(fout,fmt,orb_ripple_fim_rms(1)/mm);
%fmt = 'rms_xp: %5.3f mrad\n'; fprintf(fout,fmt,orb_ripple_fim_rms(2)/mrad);
%fmt = 'rms_y : %5.3f mm\n'; fprintf(fout,fmt,orb_ripple_fim_rms(3)/mm);
%fmt = 'rms_yp: %5.3f mrad\n'; fprintf(fout,fmt,orb_ripple_fim_rms(4)/mrad);

fclose(fout);


%Create Figure Horizontal correction
figure1 = figure('Color',[1 1 1]);
annotation('textbox', [0.3,0.88,0.1,0.1],...
           'FontSize',14,...
           'FontWeight','bold',...
           'LineStyle','none',...
           'String', ['LTB Transfer Line - ' tit]);

%Plot before correction
%subplot(5,1,[1,2],'FontSize',14);
xlimit=[0 s(end)];
subplot('position',[0.1 0.58 0.85 0.32],'FontSize',14);
hold all;
for i=1:n_maquinas
    plot(s,1e3*abs(orbx(:,i)),'Color',[0.8 0.8 1]);   %horizontal
    plot(s,-1e3*abs(orby(:,i)),'Color',[1 0.8 0.8]);  %vertical
end
plot(s,1e3*orbx_rms,'b','LineWidth',1.5);
plot(s,-1e3*orby_rms,'r','LineWidth',1.5);
ylabel('x,y [mm]', 'FontSize',14);
ylimit=ylim;
xlim(xlimit);
text(1,0.8*ylimit(2),'X before correction', 'FontSize',14,'Color','b');
text(1,ylimit(1)+0.2*ylimit(2),'Y before correction', 'FontSize',14,'Color','r');
grid on;
box on;

%Plot lattice
%subplot(5,1,3);
subplot('position',[0.1 0.47 0.85 0.07]);
lnls_drawlattice(ltlb, 1, 0, 1, 1, 1);
xlim(xlimit);
axis off;

%Plot after correction
%subplot(5,1,[4,5],'FontSize',14);
subplot('position',[0.1 0.12 0.85 0.32],'FontSize',14);
hold all;
for i=1:n_maquinas
    plot(s,1e3*abs(orbcx(:,i)),'Color',[0.8 0.8 1]);
    plot(s,-1e3*abs(orbcy(:,i)),'Color',[1 0.8 0.8]);
end
plot(s,1e3*orbcx_rms,'b','LineWidth',1.5);
plot(s,-1e3*orbcy_rms,'r','LineWidth',1.5);
xlabel('s [m]', 'FontSize',14);
ylabel('x,y [mm]', 'FontSize',14);
ylimit=ylim;
xlim(xlimit);
text(1,0.8*ylimit(2),'X after correction', 'FontSize',14,'Color','b');
text(1,ylimit(1)+0.2*ylimit(2),'Y after correction', 'FontSize',14,'Color','r');
grid on;
box on;

plot2svg([tit '_Orbit.svg'],figure1);
