function [RoutTL RoutB varargout] = injection_simulation(the_ring, param, transfer_line)
% Simulation of the injection system in the booster

% First, we generate the bunch:

%particle's initial position:
Rin = param.Rin;

%bunch tracking or single particle?:
n_part= param.n_part;
cutoff = param.cutoff;
if n_part>1
    % lets take the initial betas of the transport line
    twiss(1) = param.IniCond.beta(1);       twiss(3) = param.IniCond.beta(2);
    twiss(2) = param.IniCond.alpha(1);      twiss(4) = param.IniCond.alpha(2); 
    twiss(5) = param.IniCond.Dispersion(1); twiss(7) = param.IniCond.Dispersion(2);
    twiss(6) = param.IniCond.Dispersion(3); twiss(8) = param.IniCond.Dispersion(4);
    
    % and generate the bunch.    
    bun = lnls_generate_bunch(param.emitx,param.emity,param.sigmae,...
                              param.sigmas,twiss,n_part,cutoff);
    
%     Rin = repmat(Rin,1,n_part) + bun;
    Rin = bsxfun(@plus,Rin,bun);
end

% We must set the septum parameters:
if param.sep_err ~= 0
    err_sep = lnls_generate_random_numbers(param.sep_err, 1,'norm',param.cutoff,0);
else
    err_sep = 0;
end
sep_ind = findcells(transfer_line,'FamName','sep');
sep_ang = transfer_line{sep_ind(1)}.BendingAngle;
sep_len = transfer_line{sep_ind(1)}.Length;
% Notice the minus sign! the input is the particle exit angle, not the
% septum field
sep_err = (sep_ang*err_sep - param.part_dang)/(length(sep_ind)*sep_len);
transfer_line = setcellstruct(transfer_line,'PolynomB',sep_ind,sep_err, 1);
% The next line is commented because after discussion with Liu, we decided
% to keep the 10 degrees deflection
% transfer_line = setcellstruct(transfer_line,'BendingAngle',sep_ind, sep_ang - param.xp_sep/length(sep_ind));

% Now, we track the beam through the transfer line:
RoutTL = linepass(transfer_line,Rin,1:length(transfer_line)+1);

%And we define the booster's incoming beam:
RinB  = RoutTL(:,(end-n_part+1):end);
x_sep = param.x_sep; %septum position
xp_sep = param.xp_sep;%septum angle
RinB(1,:) = RinB(1,:)*cos(xp_sep) + RinB(6,:)*sin(xp_sep);
RinB(6,:) = RinB(6,:)*cos(xp_sep) - RinB(1,:)*sin(xp_sep);
RinB = bsxfun(@plus,[x_sep;xp_sep;0;0;0;0],RinB);


% now, we shift the lattice to begin at the end of the septum
sep_ind = findcells(the_ring,'FamName','SEPT_IN');
ind = [(sep_ind+1):length(the_ring) 1:(sep_ind)];
the_ring = the_ring(ind);


% turn on the kicker
kick_ind = findcells(the_ring,'FamName','KICK_IN');
if param.kick_err ~= 0
    err_kick = lnls_generate_random_numbers(param.kick_err, 1,'norm',param.cutoff,0);
else
    err_kick = 0;
end
kick_ang = param.kick_ang*(1 + err_kick);
kick_in = corrector('KICK_IN', the_ring{kick_ind(1)}.Length, [kick_ang 0], 'CorrectorPass');
kick_in = buildlat(kick_in);
the_ring(kick_ind) = kick_in;


% Lets track only for the first 50m
spos = findspos(the_ring,1:length(the_ring));
ind = spos <= param.len2trackB;
sposB = spos(ind);
injection_section = the_ring(ind);

% And Track through the booster:
RoutB = linepass(injection_section,RinB,1:length(injection_section));

%% code to see the maching of the incoming beam at the end of the kicker:
% RoutBx = reshape(RoutB(1,:),param.n_part,length(sposB));
% RoutBxp = reshape(RoutB(2,:),param.n_part,length(sposB));
% the_ring2 = the_ring;
% the_ring2 = the_ring2([(kick_ind+1):end,1:kick_ind]);
% the_ring2{end}.KickAngle(1) = 0;
% r = ringpass(the_ring2,[2e-3;0;0;0;0;0],1000);
% figure; plot(r(1,:),r(2,:),'.');
% hold on
% plot(RoutBx(:,kick_ind+1),RoutBxp(:,kick_ind+1),'r.');

%%
% Finally, we build the output
sposTL = findspos(transfer_line,1:length(transfer_line)+1);
varargout{1} = sposTL;
varargout{2} = sposB;

