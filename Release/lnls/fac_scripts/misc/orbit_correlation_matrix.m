function p = orbit_correlation_matrix(fh_ring, inp)
% LATTICE_ERRORS_ANALYSIS 
% Authors: Liu Lin and Ximenes R. Resende @ LNLS
% Date : 2009-12-18


%% Initializations
p = inp;
global THERING;

%% Loads lattice model


fprintf('Loading lattice model ...\n');
THERING = fh_ring();
setradiation('Off');
setcavity('Off');
THERING_error_free = THERING;

%% Inits aux data structures


r = functions(fh_ring);
p.rede = r.function;
[p.latticepath, p.fname, ext, versn] = fileparts(r.file);
p.progversion = mfilename;
p.datahora = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
p.outfdata = [p.latticepath,filesep,p.fname,'_',p.progversion,'_dados','_',p.datahora,'.txt'];

p = generates_errors(p);
e1e2 = zeros(length(THERING), length(THERING));
    
for i=1:length(p.lattice_errors)
    
    lerror = p.lattice_errors{i};
    
    cluster_size =  lerror.cluster_size;
    distribution = lerror.distribution;
    ntrunc = lerror.trunc;
    
    for j=1:length(lerror.at_elements) 
    
        element = lerror.at_elements(j);
        % MISALIGNMENTS X and Z
        sigmax = lerror.sigma(2);
        sigmaz = lerror.sigma(3);
        if (sigmax ~= 0)
            set_alignment_error(element, cluster_size, sigmax/2, 0*sigmax, ntrunc, 0*sigmaz/2, 0*sigmaz, ntrunc, distribution);
            closed_orbit = findorbit4(THERING, 0, 1:length(THERING)) / (sigmax/2);
            t = closed_orbit(1,:)' * closed_orbit(1,:);
            e1e2 = e1e2 + t;
        end;
        
        
    end
    
    p.lattice_errors{i}.e1e2 = e1e2;
    
end

return;

%% Loops over random machines



fprintf('Looping over random machines ...\n');
for i=1:p.nr_machines
    
    p.random_machine_index = i;
    fprintf('[Machine #%i/%i]\n', i, p.nr_machines);
         
    % generate lattice errors
    fprintf('Generating lattice errors ...\n');
    THERING = THERING_error_free;

    
    % tries calculation
    try
        
        % Finds COD
        % ---------
        fprintf('Calculating closed orbit ...\n');
        closed_orbit = findsyncorbit(THERING, 0, 1:length(THERING));
        
        e1e2 = e1e2 + closed_orbit(1,:)' * closed_orbit(1,:);
        plot(e1e2(1,:)/max(max(abs(e1e2(1,:)))));
        pause(0);
        drawnow;
        
    catch
        
        p.unstable_machines = p.unstable_machines + 1;
    
    end
    
end

fprintf('\n');


        
function p = generates_errors(inp)

global THERING

p = inp;
for j=1:length(p.lattice_errors)
       
        lerror = p.lattice_errors{j};
        
        if ~isfield(lerror, 'at_elements')
        if isa(lerror.elements, 'char')
            families = findmemberof(lerror.elements);
            elements = [];
            for k=1:size(families,1)
                elements = [elements findcells(THERING,'FamName',char(families(k,:)))];
            end;
            if isfield(lerror, 'cluster_size')
                cluster_size = lerror.cluster_size;
            else
                cluster_size = 1;
            end;
        else
            elements = lerror.elements;
            cluster_size = length(elements);
        end;
        p.lattice_errors{j}.at_elements     = elements;
        p.lattice_errors{j}.cluster_size = cluster_size;
        else
           elements = p.lattice_errors{j}.at_elements;
           cluster_size =  p.lattice_errors{j}.cluster_size;
        end
        
       
        distribution = lerror.distribution;
        ntrunc = lerror.trunc;
          
        %{
        
        % STRENGTH
        sigma = lerror.sigma(1);
        if (sigma ~= 0)
            set_excitation_error(elements, cluster_size, sigma, ntrunc, distribution); 
        end;
      

            
        % MISALIGNMENTS X and Z
        sigmax = lerror.sigma(2);
        sigmaz = lerror.sigma(3);
        if (sigmax ~= 0 || sigmaz ~= 0)
            set_alignment_error(elements, cluster_size, sigmax, ntrunc, sigmaz, ntrunc, distribution);
        end;
        
             
        % ROTATION AROUND LONGITUDINAL DIRECTION
        sigma = lerror.sigma(4);
        if (sigma ~= 0)
            set_rotation_error(elements, cluster_size, sigma, ntrunc, distribution);
        end;
        %}
        
            
end;

