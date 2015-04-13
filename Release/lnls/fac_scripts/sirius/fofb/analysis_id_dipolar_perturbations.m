function r = analysis_id_dipolar_perturbations



% flags that control calculation flow and options
flags = {'cod6d', 'gaussian'};

% parameters
nr_kicks = 10;

% inits
RandStream.setDefaultStream(RandStream('mt19937ar','seed', 131071));

% loads initial lattice model
the_ring = load_lattice_model(flags);

% adds kick elements that will simulate ID dipolar field errors
the_ring = add_kick_elements_at_id_locations(the_ring, nr_kicks);

the_ring = set_random_dipolar_field_error_for_id(the_ring, 3, nr_kicks);

% calculates orbit responde matrix
bpm_ind = get_elements_indices_from_selection(the_ring, 'BPM', [1 0 0 0  1  0 0 0 1]);
hcm_ind = get_elements_indices_from_selection(the_ring, 'hcm', [1 0 0 1     0 0 0 1]);
vcm_ind = get_elements_indices_from_selection(the_ring, 'vcm', [1 0 1         0 0 1]);
respm   = calc_orbit_response_matrix(the_ring, hcm_ind, vcm_ind, bpm_ind, flags);




function the_ring = set_random_dipolar_field_error_for_id(the_ring_original, id_indices, nr_kicks, int1bx, int1by)

the_ring = the_ring_original;

% finds element indices of id kicks: each i-th column corresponds to i-th id.
nr_kicks = ceil(nr_kicks); if ((nr_kicks/2) ~= floor(nr_kicks/2)), nr_kicks = nr_kicks + 1; end; % nr_kicks -> even int
idx = intersect(findcells(the_ring, 'FamName', 'IDKICKS'), findcells(the_ring, 'KickAngle'));
idx = reshape(idx, nr_kicks/2, []);
idx = [idx(:,end) idx(:,1:end-1)];
idx = reshape(idx, nr_kicks, []);

for i=id_indices
    id_idx = idx(:,i);
    r = generate_random_numbers(0,1,length(id_idx),'gaussian',1.0);
    




