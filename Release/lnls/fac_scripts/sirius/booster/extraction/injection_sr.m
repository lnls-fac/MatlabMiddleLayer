function [outSR, Pert] = injection_sr(storage_ring, transfer_line, inj_bun, param,err)

n_part= param.n_part;

sef_tl_ind = findcells(transfer_line,'FamName','sef');
sef_ang = transfer_line{sef_tl_ind(1)}.BendingAngle;
sef_len = transfer_line{sef_tl_ind(1)}.Length;
sef_polb= transfer_line{sef_tl_ind(1)}.PolynomB(1);


% first we set the thin septum leakage field:
sef_sr_ind = findcells(storage_ring,'FamName','sef');
sef_leakpolb   = (1+err.sef)*(sef_polb*sef_len + sef_ang)*param.sr.sef_leak/storage_ring{sef_sr_ind}.Length;
storage_ring{sef_sr_ind}.PolynomB = sef_leakpolb;


%Now we define the incoming beam:
RinSR  = inj_bun;
x_sef = param.ltba.sef_x; %septum position
xp_sef = param.ltba.sef_xp; %septum angle
RinSR(1,:) = RinSR(1,:)*cos(xp_sef) + RinSR(6,:)*sin(xp_sef);
RinSR(6,:) = RinSR(6,:)*cos(xp_sef) - RinSR(1,:)*sin(xp_sef);
RinSR = bsxfun(@plus,[x_sef;xp_sef;0;0;0;0],RinSR);

%shift the lattice to begin at the injection point:
inj_ind = findcells(storage_ring,'FamName','inj');
ind = [(inj_ind+1):length(storage_ring) 1:(inj_ind)];
storage_ring = storage_ring(ind);


% now, we determine which type of injection will be simulated
if strcmp(param.sr.mode,'4kickers')
    Rin = RinSR;
    RinSR = zeros(6,n_part,param.sr.nturns+1);
    RinSR(:,:,1) = Rin;
    
    % we set the kickers' angles
    k4_ind = findcells(storage_ring,'FamName','kick');
    kick_angles = [1, -1, -1, 1].*param.sr.kick.angle;
    kick_comp_angles = kick_angles.*(1+err.kick_amp).*cos(err.kick_pha);
    storage_ring = setcellstruct(storage_ring, 'KickAngle', k4_ind, kick_comp_angles, 1);
    
    Rout = zeros(6,n_part,param.sr.nturns+1);
    
    % inject the beam and track to the pmm exit
    pmm_ind = findcells(storage_ring,'FamName','pmm');
    Rout(:,:,1) = linepass(storage_ring(1:(pmm_ind+1)),RinSR(:,:,1));
    
    
    % Now we track for the desired number of turns;
    ind = [(pmm_ind+1):length(storage_ring) 1:(pmm_ind)];
    storage_ring = storage_ring(ind);
    k4_ind = findcells(storage_ring,'FamName','kick');
    kick_angles = kick_angles([3,4,1,2]);
    err.kick_amp = err.kick_amp([3,4,1,2]);
    err.kick_pha = err.kick_pha([3,4,1,2]);
    n_bump = param.sr.kick.nturns;
    inj_ind = findcells(storage_ring,'FamName','inj');
    for ii=1:param.sr.nturns
        %update the bump status
        if ii<n_bump/2
            kick_comp_angles = kick_angles.*(1+err.kick_amp).*cos(pi*ii/n_bump + err.kick_pha);
        else
            kick_comp_angles = 0;
        end
        storage_ring = setcellstruct(storage_ring, 'KickAngle', k4_ind, kick_comp_angles, 1);
        
         res = linepass(storage_ring,Rout(:,:,ii),[inj_ind (length(storage_ring)+1)]);
         Rout(:,:,ii+1) = res(:,(end-n_part+1:end));
         RinSR(:,:,ii+1) = res(:,1:n_part);
    end
    
    % Now we compute the perturbation felt by the stored beam, if desired.
    nt_pert = param.sr.nturns_pert;
    nt_sef  = param.sr.sef_width;
    Pert = zeros(6, length(storage_ring)+1, 2*floor(nt_sef/2) + nt_pert + 2);
    
    if param.sr.perturb_stored_beam     
        % here we will use single particle dynamics.
        % First we find the closed orbit before the septum to be turned on:
        
        sef_sr_ind = findcells(storage_ring,'FamName','sef');
        pert_polb = [0, 0, 0, 0];
        storage_ring{sef_sr_ind}.PolynomB = pert_polb;
        kick_comp_angles = 0;
        storage_ring = setcellstruct(storage_ring, 'KickAngle', k4_ind, kick_comp_angles, 1);
        orb = findorbit6(storage_ring);
        
        % now we track one turn in this situation:
        Pert(:,:,1) = linepass(storage_ring,orb, 1:length(storage_ring)+1);
        % and now we track for the other turns
        jj = 1;
        for ii=-floor(nt_sef/2):(floor(nt_sef/2)+nt_pert-1)
            % we begin by setting the correct septum and kickcers angles:
            if ii > nt_sef/2
                pert_polb = [0, 0, 0, 0];
            else
                pert_polb = sef_leakpolb*cos(pi*ii/nt_sef);
            end
            storage_ring{sef_sr_ind}.PolynomB = pert_polb;
            if abs(ii)<n_bump/2
                kick_comp_angles = kick_angles.*cos(pi*ii/n_bump + err.kick_pha).*(1+err.kick_amp) ...
                                   .*(1+err.kick_deform(((jj-1)*4+1):(jj*4)));  jj = jj+1;
            else
                kick_comp_angles = 0;
            end
            storage_ring = setcellstruct(storage_ring, 'KickAngle', k4_ind, kick_comp_angles, 1);
            
            % and we track the beam:
            turn = ii + floor(nt_sef/2) + 1;
            Pert(:,:,turn+1) = linepass(storage_ring,Pert(:,end,turn), 1:length(storage_ring)+1);
        end
    end
    
elseif strcmp(param.sr.mode,'pmm')
    
    Rin = RinSR;
    RinSR = zeros(6,n_part,1);
    RinSR(:,:,1) = Rin;
    
    % we set the pmm' angle
    pmm_ind = findcells(storage_ring,'FamName','pmm');
    pmm_polB = param.sr.pmm.polb*(1+err.pmm_amp);
    storage_ring{pmm_ind}.PolynomB = pmm_polB;
    storage_ring{pmm_ind}.PolynomA = pmm_polB*0;
    storage_ring{pmm_ind}.MaxOrder = length(pmm_polB)+1;
    
    Rout = zeros(6,n_part,param.sr.nturns+2);
    
    % inject the beam and track to the pmm exit
    Rout(:,:,[1 2]) = reshape(linepass(storage_ring(1:(pmm_ind)),RinSR(:,:,1), [pmm_ind,pmm_ind+1]),6,n_part,2);
    
    
    % Now we track for the desired number of turns;
    ind = [(pmm_ind+1):length(storage_ring) 1:(pmm_ind)];
    storage_ring = storage_ring(ind);
    n_bump = param.sr.pmm.nturns;
    for ii=1:param.sr.nturns
        %update the bump status
        if ii<n_bump/2
            pmm_comp_polB = pmm_polB*cos(pi*ii/n_bump);
        else
            pmm_comp_polB = zeros(1,length(pmm_polB));
        end
        storage_ring{end}.PolynomB = pmm_comp_polB;
        
        Rout(:,:,ii+2) = ringpass(storage_ring,Rout(:,:,ii+1));
    end
    
    
    % Now we compute the perturbation felt by the stored beam, if desired.
    nt_pert = param.sr.nturns_pert;
    nt_sef  = param.sr.sef_width;
    Pert = zeros(6, length(storage_ring)+1, 2*floor(nt_sef/2) + nt_pert + 2);
    
    if param.sr.perturb_stored_beam     
        % here we will use single particle dynamics.
        % First we find the closed orbit before the septum to be turned on:
        
        sef_sr_ind = findcells(storage_ring,'FamName','sef');
        pert_polb = [0, 0, 0, 0];
        storage_ring{sef_sr_ind}.PolynomB = pert_polb;
        pmm_comp_polB = zeros(1,length(pmm_polB));
        storage_ring{pmm_ind}.PolynomB = pmm_comp_polB;
        orb = findorbit6(storage_ring);
        
        % now we track one turn in this situation:
        Pert(:,:,1) = linepass(storage_ring,orb, 1:length(storage_ring)+1);
        % and now we track for the other turns
        for ii=-floor(nt_sef/2):(floor(nt_sef/2)+nt_pert-1)
            % we begin by setting the correct septum and kickcers angles:
            if ii > nt_sef/2
                pert_polb = [0, 0, 0, 0];
            else
                pert_polb = sef_leakpolb*cos(pi*ii/nt_sef);
            end
            storage_ring{sef_sr_ind}.PolynomB = pert_polb;
            if abs(ii)<n_bump/2
                pmm_comp_polB = pmm_polB*cos(pi*ii/n_bump);
            else
                pmm_comp_polB = zeros(1,length(pmm_polB));
            end
            storage_ring{pmm_ind}.PolynomB = pmm_comp_polB;
            
            % and we track the beam:
            turn = ii + floor(nt_sef/2) + 1;
            Pert(:,:,turn+1) = linepass(storage_ring,Pert(:,end,turn), 1:length(storage_ring)+1);
        end
    end    
else
    error('Type of injection not recognized');
end

% Finally, we prepare the output:
outSR.Rout = Rout;
outSR.Rin  = RinSR;
