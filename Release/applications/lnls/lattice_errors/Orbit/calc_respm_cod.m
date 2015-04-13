function r = calc_respm_cod(the_ring, bpm_idx, hcm_idx, vcm_idx, nper, print)
% making sure they are in order
bpm_idx = sort(bpm_idx);
hcm_idx = sort(hcm_idx);
vcm_idx = sort(vcm_idx);

if ~exist('print','var'), print=false; end
if ~exist('nper','var'), nper=1;end

nr_bpms = size(bpm_idx,1);
nr_hcms = size(hcm_idx,1);
nr_vcms = size(vcm_idx,1);

if print
    fprintf('   bpms:%03i, hcms:%03i, vcms:%03i\n', nr_bpms, nr_hcms, nr_vcms);
end

Mxx = zeros(nr_bpms, nr_hcms);
Myx = zeros(nr_bpms, nr_hcms);
Mxy = zeros(nr_bpms, nr_vcms);
Myy = zeros(nr_bpms, nr_vcms);

len_bpm = nr_bpms/nper;
len_hcm = nr_hcms/nper;
len_vcm = nr_vcms/nper;
if any(logical(mod([len_bpm,len_hcm,len_vcm],1))), 
    len_bpm = len_bpm*nper;
    len_hcm = len_hcm*nper;
    len_vcm = len_vcm*nper;
    nper = 1;
else
    hcm_idx = hcm_idx(1:len_hcm,:);
    vcm_idx = vcm_idx(1:len_vcm,:);
end

M = get_response_matrix(the_ring, bpm_idx, hcm_idx, vcm_idx);
M = mat2cell(M, [nr_bpms,nr_bpms],[len_hcm, len_vcm]);
mxx = M{1,1};
mxy = M{1,2};
myx = M{2,1};
myy = M{2,2};

for i=0:(nper-1)
    indcs = (i*len_hcm+1):((i+1)*len_hcm);
    Mxx(:,indcs) = circshift(mxx,len_bpm*i);
    Myx(:,indcs) = circshift(myx,len_bpm*i);

    indcs = (i*len_vcm+1):((i+1)*len_vcm);
    Mxy(:,indcs) = circshift(mxy,len_bpm*i); %the last bpm turns into the first
    Myy(:,indcs) = circshift(myy,len_bpm*i);
end

r.respm.mxx = Mxx;
r.respm.mxy = Mxy;
r.respm.myx = Myx;
r.respm.myy = Myy;

[U,S,V] = svd([Mxx Mxy; Myx Myy],'econ');
r.respm.U = U;
r.respm.V = V;
r.respm.S = S;

sv = diag(S);
if print
    fprintf('   number of singular values: %03i\n', size(S,1));
    fprintf('   singular values: %f,%f,%f ... %f,%f,%f\n', sv(1),sv(2),sv(3),sv(end-2),sv(end-1),sv(end));
end

