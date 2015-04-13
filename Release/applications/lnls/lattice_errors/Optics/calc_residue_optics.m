function v = calc_residue_optics(Mxx, Myy, Dispx, tune, tune0, bpms, hcms, vcms, Tsym, Msym)

nr_bpms = size(bpms,1);
nr_hcms = size(hcms,1);
nr_vcms = size(vcms,1);

% Total lenght of the residue vector is 219182
TRANSWEIGHT = 1/(180*(160 + 120))      * 1e2; % order of centimeters
MIRWEIGHT   = 1/(10*120*(160 + 120)/2) * 1e2; % order of centimeters
DISPWEIGHT  = 1/(180 + 10*120/2)       * 1e4; % order of tenth of milimeters
TUNEWEIGHT  = 1/2                      * 1e2; % order of 10^-2

v = [];

%Values imposed by the model:
%Dispersion in the straights must be 0
indcs = logical(repmat([1,0,0,0,0,0,0,0,1],1,20));
A = DISPWEIGHT * Dispx(indcs);
v = [v; A(:)];
%Tunes must be the ones specified
A = TUNEWEIGHT * (tune-tune0);
v = [v;A(:)];


%Translational Symmetries:
sym = length(Tsym);
A = circshift(Mxx,[nr_bpms, nr_hcms]/sym);
A = A - Mxx;
v = [v; TRANSWEIGHT * A(:)];
A = circshift(Myy,[nr_bpms, nr_vcms]/sym); %the last bpm turns into the first
A = A - Myy;
v = [v; TRANSWEIGHT * A(:)];
indcs = ~indcs;
A = circshift(Dispx(indcs),sum(indcs)/sym);
A = A - Dispx(indcs);
v = [v; DISPWEIGHT * A(:)];

% Mirror Symetries:
bpm_idx = logical(repmat([1,1,0,1,0,1,1,0,1],1,20));
hcm_idx = logical(repmat([1,1,1,1,1,1,1,1],1,20));
vcm_idx = logical(repmat([1,1,1,1,1,1],1,20));
Mxx = Mxx(bpm_idx,hcm_idx);
Myy = Myy(bpm_idx,vcm_idx);
Dispx = Dispx(bpm_idx);
bpm_idx = bpms(bpm_idx,1); lenB = length(bpm_idx);
hcm_idx = hcms(hcm_idx,1); lenH = length(hcm_idx);
vcm_idx = vcms(vcm_idx,1); lenV = length(vcm_idx);
for i1=Msym
    shift_bpm = sum(bpm_idx < i1);
    shift_hcm = sum(hcm_idx < i1);
    shift_vcm = sum(vcm_idx < i1);
    Ax = circshift(Mxx,-[shift_bpm,shift_hcm]);
    Ay = circshift(Myy,-[shift_bpm,shift_vcm]);
    D  = circshift(Dispx,-shift_bpm);
    Ax = mat2cell(Ax,lenB/2*[1 1], lenH);
    Ay = mat2cell(Ay,lenB/2*[1 1], lenV);
    D = mat2cell(D,  1, lenB/2*[1 1]);
    Ax = MIRWEIGHT*(Ax{1} - rot90(Ax{2},2))';
    Ay = MIRWEIGHT*(Ay{1} - rot90(Ay{2},2))';
    D = DISPWEIGHT * (D{1} - fliplr(D{2}));
    A = [Ax;Ay;D];
    v = [v;A(:)];
end

