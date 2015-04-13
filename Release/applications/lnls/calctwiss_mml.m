function calctwiss_mml

twiss = calctwiss;

ao = getao;
fnames = fieldnames(ao);
for i=1:length(fnames)
    fam = ao.(fnames{i});
    if isfield(fam, 'AT')
        idx = fam.AT.ATIndex;
        center_idx = ceil((size(idx,2)+1)/2);
        idx = idx(:,center_idx);
        fam.AT.betax = twiss.betax(idx);
        fam.AT.betay = twiss.betay(idx);
        fam.AT.etax  = twiss.etax(idx);
        fam.AT.mux  = twiss.mux(idx);
        fam.AT.muy  = twiss.muy(idx);
        ao.(fnames{i}) = fam;
    end
end
setao(ao);