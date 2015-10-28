function machine = lnls_latt_err_correct_cod(name, machine, orbit, goal_codx, goal_cody)
%
% function machine = lnls_latt_err_correct_cod(name, machine, orbit, goal_codx, goal_cody)
%
% Correct orbit of several machines.
%
% INPUTS:
%   name     : name of the file to which the inputs will be saved
%   machine  : cell array of lattice models to correct the orbit.
%   goal_codx: horizontal reference orbit to use in correction. May be a vector
%      defining the orbit for each bpm. In this case the reference will be the
%      same for all the machines. Or Can be a matrix with dimension
%      nr_machinesines X nr_bpms, to define different orbits among the machines.
%      If not passed a default of zero will be used;
%   goal_cody: same as goal_codx but for the vertical plane.
%   orbit    : structure with fields:
%      bpm_idx   - bpm indexes in the model;
%      hcm_idx   - horizontal correctors indexes in the model;
%      vcm_idx   - vertical correctors indexes in the model;
%      sext_ramp - If existent, must be a vector with components less than
%         one, denoting a fraction of sextupoles strengths used in each step
%         of the correction. For example, if sext_ramp = [0,1] the correction
%         algorithm will be called two times for each machine. In the first
%         time the sextupoles strengths will be zeroed and in the second
%         time they will be set to their correct value.
%      svs      - may be a number denoting how many singular values will be
%         used in the correction or the string 'all' to use all singular
%         values. Default: 'all';
%      max_nr_iter - maximum number of iteractions the correction
%         algortithm will perform at each call for each machine;
%      tolerance - if in two subsequent iteractions the relative difference
%         between the error function values is less than this value the
%         correction is considered to have converged and will terminate.
%      correct2bba_orbit - if true, the goal orbit will be set in relation
%         to the magnetic center of the quadrupole nearest to each bpm.
%      simul_bpm_err - if true, the Offset field defined in the bpms in the
%         lattice will be used to simulate an error in the determination of
%         the goal orbit. Notice that there must exist an Offset field defined
%         in the lattice models of the machine array for each bpm, in order to
%         this simulation work. Otherwise an error will occur.
%      respm - structure with fields M, S, V, U which are the response
%         matrix and its SVD decomposition. If NOT present, the function
%         WILL CALCULATE the response matrix for each machine in each step
%         defined by sext_ramp.
%
% OUTPUT:
%   machine : cell array of lattice models with the orbit corrected.
%      

% making sure they are in order
orbit.bpm_idx = sort(orbit.bpm_idx);
orbit.hcm_idx = sort(orbit.hcm_idx);
orbit.vcm_idx = sort(orbit.vcm_idx);

nr_machines = length(machine);

if ~exist('goal_codx','var')
    goal_codx = zeros(nr_machines,length(orbit.bpm_idx));
elseif size(goal_codx,1) == 1
    goal_codx = repmat(goal_codx,nr_machines,1);
end
if ~exist('goal_cody','var')
    goal_cody = zeros(nr_machines,length(orbit.bpm_idx));
elseif size(goal_cody,1) == 1
    goal_cody = repmat(goal_cody,nr_machines,1);
end

if ~isfield(orbit,'sext_ramp'), orbit.sext_ramp = 1; end;

save([name,'_correct_cod_input.mat'], 'orbit', 'goal_codx', 'goal_cody');

calc_respm = false;
if ~isfield(orbit,'respm'), calc_respm = true; end

fprintf('-  correcting closed-orbit distortions\n');
fprintf('   sextupole ramp: '); fprintf(' %4.2f', orbit.sext_ramp); fprintf('\n');
if isnumeric(orbit.svs), svs = num2str(orbit.svs);else svs = orbit.svs;end
fprintf('   selection of singular values: %4s\n',svs);
fprintf('   maximum number of orbit correction iterations: %i\n',orbit.max_nr_iter);
fprintf('   tolerance: %8.2e\n', orbit.tolerance);

fprintf('\n');
fprintf('    -----------------------------------------------------------------------------------------------  \n');
fprintf('   |           codx [um]           |           cody [um]           |  kickx[urad]     kicky[urad]  | (nr_iter|nr_refactor)\n');
fprintf('   |      all             bpm      |      all             bpm      |                               | [sextupole ramp]\n');
fprintf('   | (max)   (rms) | (max)   (rms) | (max)   (rms) | (max)   (rms) | (max)   (rms) | (max)   (rms) | ');
fprintf('%7.5f ', orbit.sext_ramp); fprintf('\n');
fprintf('---|---------------------------------------------------------------|-------------------------------| \n');
if orbit.correct2bba_orbit
    ind_bba = orbit.ind_bba;
    %ind_bba = get_bba_ind(machine{1});
end

sext_idx = findcells(machine{1},'PolynomB');
random_cod = zeros(2,length(orbit.bpm_idx));
ids_idx = findcells(machine{1}, 'PassMethod', 'LNLSThickEPUPass');

for i=1:nr_machines
    
    %sext_str = getcellstruct(machine{i}, 'PolynomB', sext_idx, 1, 3);
    polynomb_orig = getcellstruct(machine{i}, 'PolynomB', sext_idx);
    
    if orbit.simul_bpm_err
        random_cod = getcellstruct(machine{i},'Offsets',orbit.bpm_idx);
        random_cod = cell2mat(random_cod)';
    end
    if orbit.correct2bba_orbit
        T1 = getcellstruct(machine{i},'T1',ind_bba,1,1);
        T2 = getcellstruct(machine{i},'T2',ind_bba,1,1);
        bba_codx = (T2-T1)'/2;
        T1 = getcellstruct(machine{i},'T1',ind_bba,1,3);
        T2 = getcellstruct(machine{i},'T2',ind_bba,1,3);
        bba_cody = (T2-T1)'/2;
    else
        bba_codx = 0;
        bba_cody = 0;
    end
    gcodx = goal_codx(i,:) + random_cod(1,:) + bba_codx;
    gcody = goal_cody(i,:) + random_cod(2,:) + bba_cody;
    
    niter = zeros(1,length(orbit.sext_ramp));
    ntimes = niter;

    machine{i} = turn_ids_off(machine{i}, ids_idx);
    for j=1:length(orbit.sext_ramp)
        if (j == length(orbit.sext_ramp))
            machine{i} = turn_ids_on(machine{i}, ids_idx);
        end
        
        %machine{i} = setcellstruct(machine{i},'PolynomB',sext_idx,orbit.sext_ramp(j)*sext_str, 1, 3);
        for k=1:length(polynomb_orig);
            PolyB = machine{i}{sext_idx(k)}.PolynomB; % necessary so that correctors kicks are not lost
            PolyB(3:end) = polynomb_orig{k}(3:end) * orbit.sext_ramp(j);
            machine{i} = setcellstruct(machine{i},'PolynomB',sext_idx(k),{PolyB});
        end
        
        if calc_respm
            orbit.respm = calc_respm_cod(machine{i}, orbit.bpm_idx, orbit.hcm_idx, orbit.vcm_idx, 1, false);
            orbit.respm = orbit.respm.respm;
        end
        [machine{i},hkck,vkck,codx,cody,niter(j),ntimes(j)] = cod_sg(orbit, machine{i}, gcodx, gcody);
        if any(isnan([codx,cody]))
            fprintf('Machine %03i unstable @ sextupole ramp = %5.1f %%\n',i,sextupole_ramp(j)*100);
            machine{i} = setcellstruct(machine{i},'PolynomB',sext_idx, sext_str, 1, 3);
            break;
        end
    end
     
    [x_max_all,x_rms_all] = get_max_rms(codx,1e6);
    [x_max_bpm,x_rms_bpm] = get_max_rms(codx(orbit.bpm_idx),1e6);
    [y_max_all,y_rms_all] = get_max_rms(cody,1e6);
    [y_max_bpm,y_rms_bpm] = get_max_rms(cody(orbit.bpm_idx),1e6);
    [kickx_max,kickx_rms] = get_max_rms(hkck,1e6);
    [kicky_max,kicky_rms] = get_max_rms(vkck,1e6);
    fprintf('%03i| %5.1f   %5.1f | %5.1f   %5.1f | %5.1f   %5.1f | %5.1f   %5.1f |  %3.0f     %3.0f  |  %3.0f     %3.0f  | ', i, ...
        x_max_all,x_rms_all,x_max_bpm,x_rms_bpm,y_max_all,y_rms_all,y_max_bpm,y_rms_bpm, ...
        kickx_max,kickx_rms,kicky_max,kicky_rms);
    fprintf('(%02i|%02i) ', [niter(:) ntimes(:)]'); fprintf('\n');
    
end
fprintf('--------------------------------------------------------------------------------------------------- \n');

function the_ring = turn_ids_off(the_ring_original, idx)
the_ring = the_ring_original;
for i=idx
    the_ring{i}.PassMethod = 'DriftPass';
end


function the_ring = turn_ids_on(the_ring_original, idx)
the_ring = the_ring_original;
for i=idx
    the_ring{i}.PassMethod = 'LNLSThickEPUPass';
end


 
function [maxv,rmsv] = get_max_rms(v,f)
    
maxv = f*max(abs(v));
rmsv = f*sqrt(sum(v.^2)/length(v));
