function Paug = lqgfofb(sys)

% Sampling time
Ts = sys.Ts;

% Dimensions
nx = size(sys.a,1);
nu = size(sys.b,2);
ny = size(sys.c,1);
nz = ny;
nd = nu;

% Sate-space models
Wd = ss([],[],[],randn(ny,nd),Ts,'InputName',buildnames('d',nd),'OutputName',buildnames('y',ny));
Wy = ss([],[],[],eye(ny),Ts,'InputName',buildnames('y',ny),'OutputName',buildnames('yw',ny));
Wn = ss([],[],[],eye(nz),Ts,'InputName',buildnames('n',nz),'OutputName',buildnames('z',nz));
P = sys; set(P,'InputName',buildnames('u',nu),'OutputName',buildnames('y',nz));
S = ss([],[],[],eye(nz),Ts,'InputName',buildnames('y',ny),'OutputName',buildnames('z',nz)); % FIXME

P_Wd = parallel(P,Wd,[],[],1:ny,1:ny);
S_Wy = parallel(S,Wy,1:ny,1:ny,[],[]);
P_Wd_S_Wy = S_Wy*P_Wd;
Paug = parallel(P_Wd_S_Wy, Wn, [], [], 1:nz, 1:nz);

set(Paug,'InputGroup',struct('u',1:nu,'d',nu+(1:nd),'n',nu+nd+(1:nz)),...
         'OutputGroup',struct('yw',1:ny,'z',ny+(1:nz)));

Q = blkdiag(eye(nx),eye(ny));
R = eye(nu);
Qn = eye(nd+nz);
Rn = eye(nz);

K = lqi(P,Q,R);
kest = kalman(Paug,Qn,Rn,[],ny+(1:nz),1:nu);
C = lqgtrack(kest,K);
     
function names = buildnames(basename, n)

for i=1:n
    names{i} = [basename num2str(i)];
end