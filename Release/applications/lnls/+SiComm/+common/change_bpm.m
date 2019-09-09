function new_respm = change_bpm(n1, n2, respm)
    new_respm = respm;
    new_respm([n1 n2], :) = new_respm([n2 n1], :);
    ind1 = n1 + size(respm, 1)/2;
    ind2 = n2 + size(respm, 1)/2;
    new_respm([ind1 ind2], :) = new_respm([ind2 ind1], :);
    %{
    bpmx1 = respm(n1 - 1, :);
    bpmy1 = respm(size(respm, 1)/2 + n1 - 1, :);
    bpmx2 = respm(n2 - 1, :);
    bpmy2 = respm(size(respm, 1)/2 + n2 - 1, :);

    new_respm(n1 - 1, :) = bpmx2;
    new_respm(size(respm, 1)/2 + n1 - 1, :) = bpmy2;
    new_respm(n2 - 1, :) = bpmx1;
    new_respm(size(respm, 1)/2 + n2 - 1, :) = bpmy1;
    %}
end