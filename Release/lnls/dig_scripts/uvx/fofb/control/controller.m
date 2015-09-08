function [CL,fSoft,gHard,info] = lqgfofb(G, S, Wd, Wz, Wn)

order_comp_bpm = 1;
order_comp_corr = 1;
corr_factor = 2e-4;

if ~strcmpi(class(G),'ss')
    G = ss(G);
end

% Sampling time
Ts = G.Ts;

% Dimensions
nx = size(G.a,1);
nu = size(G.b,2);
nz = size(G.c,1);
ny = nz;
nd = size(Wd,2);
nn = ny;

u = buildnames('u',nu);
uout = buildnames('uout',nu);
d = buildnames('d',ny);
dw = buildnames('dw',nd);
n = buildnames('n',nn);
z = buildnames('z',nz);
y = buildnames('y',ny);
yp = buildnames('yp',ny);
yd = buildnames('yd',ny);
ydw = buildnames('ydw',ny);
ys = buildnames('ys',ny);
ym = buildnames('ym',ny);
ymx = buildnames('ymx',ny);
yn = buildnames('yn',ny);
e = buildnames('e',ny);
r = buildnames('r',ny);
rout = buildnames('rout',ny);

% Sate-space models (bypasses)
D = ss([],[],[],eye(ny),Ts); set(D,'InputName',d,'OutputName',yd);
U = ss([],[],[],eye(nu),Ts); set(U,'InputName',u,'OutputName',uout);

set(Wd,'InputName',dw,'OutputName',ydw);
set(Wz,'InputName',y,'OutputName',z);
set(Wn,'InputName',n,'OutputName',yn);
set(G,'InputName',u,'OutputName',yp);
set(S,'InputName',ym,'OutputName',ys);

sum_y = sumblk('y = yp + ydw + yd',ny);
sum_ym = sumblk('ym = y + yn',ny);

Paug = connect(G,S,D,Wd,Wn,Wz,U,sum_y,sum_ym,[u d dw n],[ys y z uout]);

% Controller

% Static gain matrix
M = dcgain(G);
[bpm_vec,sv,corr_vec] = svd(M,'econ');

% Pseudo-inverse regularization
for i=1:length(sv)
%     invsv(i,i) = genss(1/sv(i,i));
%     if i ~= 1
%         invsv(i,i) = genss(invsv(i,i))*realp(['sv_weight_' num2str(i)], 1);
%     end
    
    
    
    
    
    
    invsv(i,i) = 1/sv(i,i);
    
    
    
end

%invsv = diag(1./diag(sv));

% BPM compensators
for i=1:ny
    if order_comp_bpm > 1
        comp_bpm{i} = ltiblock.tf(['compbpm_' num2str(i)],tf([1 zeros(1,order_comp_bpm-1)],[1 zeros(1,order_comp_bpm-1)],Ts));
        %comp_bpm{i} = ltiblock.tf(['compbpm_' num2str(i)],order_comp_bpm,order_comp_bpm,Ts);
    else
        comp_bpm{i} = ss([],[],[],1,Ts);
    end

end
comp_bpm = blkdiag(comp_bpm{:});





        fsin = [60 360];
        bwsin = 1/60*[60 360];
        
        tfs = 0;
        for i=1:length(fsin)
            [b,a] = iirpeak(fsin(i)*Ts*2, bwsin(i)*Ts*2);
            
            for j=1:ny
                if j == 1
                    harmonic_supressor(j,j) = realp(['gharm_general_' num2str(i)], 1);
                else
                    harmonic_supressor(j,j) = realp(['gharm_' num2str(i) '_' num2str(j)], 1);
                end
            end

            tfs = tfs + tf(b,a,Ts)*harmonic_supressor;
        end

comp_bpm = tfs;

sigma(comp_bpm)
size(comp_bpm)

% Corrector compensators
for i=1:nu
    if order_comp_corr > 1
        comp_corr{i} = ltiblock.tf(['compcorr_' num2str(i)],tf([1 zeros(1,order_comp_corr-1)],[1 zeros(1,order_comp_corr-1)],Ts));
        %comp_corr{i} = ltiblock.tf(['compcorr_' num2str(i)],order_comp_corr,order_comp_corr,Ts);
    else
        comp_corr{i} = ss([],[],[],1,Ts);
    end
end
comp_corr = blkdiag(comp_corr{:});

% Accumulator
accumulator = tf(1,[1 -1],Ts)*realp('K',corr_factor)*eye(ny);

% Build controller model
Mpinv = corr_vec*invsv*bpm_vec';
% C = accumulator*comp_corr*Mpinv*comp_bpm;
C = comp_corr*Mpinv*(accumulator+comp_bpm);
C = set(C,'InputName',e,'OutputName',u);

% Loop openings
opening1 = loopswitch('opening1',ny);
set(opening1,'InputName',ym,'OutputName',ymx);

sum_e = sumblk('e = rout - ymx',ny);

ref = ss([],[],[],eye(ny),Ts,'InputName',r,'OutputName',rout);

CL0 = connect(ref,Paug,C,opening1,sum_e,[r d dw n],[ym y z uout]);

% Optimization criteria
SoftReqs = TuningGoal.Variance([dw n],z,1/sqrt(Ts));
HardReqs = TuningGoal.Margins('opening1',10,50);
%HardReqs(2) = TuningGoal.Gain(u,uw,1);
Options = systuneOptions('RandomStart',2);

% Run controller optimization
tic
[CL,fSoft,gHard,info] = systune(CL0, SoftReqs, HardReqs, Options);
toc

% %1e6*eye(nz)
% %1e-1*eye(nu)
% Q = blkdiag(zeros(nx),1e3*1e6*eye(nz));
% R = 1e-1*eye(nu);
% Qn = eye(nd+ny);
% Rn = eye(ny);
% 
% K = lqi(P,Q,R);
% kest = kalman(Paug,Qn,Rn,[],nz+(1:ny),1:nu);
% C = lqgtrack(kest,K,'1dof');

%% 2dof
%OL = series(C,Paug,C.OutputGroup.Controls,Paug.InputGroup.u);
%CL = feedback(OL,eye(ny),C.InputGroup.Measurement,Paug.OutputGroup.y,1);
%CL = CL('y','Setpoint');
%OL = OL('y','Setpoint');

% CL = feedback(OL,eye(ny));


function names = buildnames(basename, n)

if n == 0
    names = {};
elseif n == 1
    names = {basename};
else
    for i=1:n
        names{i} = [basename '(' num2str(i) ')'];
    end
end
