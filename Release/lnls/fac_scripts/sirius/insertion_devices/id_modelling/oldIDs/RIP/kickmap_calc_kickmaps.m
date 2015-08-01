function kickmaps = kickmap_calc_kickmaps(id_model, id_def, kickmaps_def)

mm = 1;

% calcula máximos campo vertical e horizontal
posy  = linspace(-id_def.period/2,id_def.period/2,65);
pos   = zeros(3,length(posy)); pos(2,:) = posy;
field = epu_field(id_model, pos); 
figure;
plot(posy, field);
xlabel('Z Pos. [mm]');
ylabel('Fields [T]');
legend({'Bx','Bz','By'});
set(gcf, 'Name', 'Field Components Longitudinal Variation');
title('Field Components Longitudinal Variation');

[kickmaps.max_by idx] = max(field(3,:));
kickmaps.max_by_pos = posy(idx);
kickmaps.ky = 93.36 * kickmaps.max_by * (id_def.period/1000);
[kickmaps.max_bx idx] = max(field(1,:));
kickmaps.max_bx_pos = posy(idx);
kickmaps.kx = 93.36 * kickmaps.max_bx * (id_def.period/1000);
[kickmaps.max_bz idx] = max(field(2,:));
kickmaps.max_bz_pos = posy(idx);
kickmaps.kz = 93.36 * kickmaps.max_bz * (id_def.period/1000);

figure; hold all;
pos2 = pos;
pos2(1,:) = linspace(-40,40,65);

pos2(2,:) = kickmaps.max_bx_pos;
f2 = epu_field(id_model, pos2);
plot(pos2(1,:),f2(1,:));

pos2(2,:) = kickmaps.max_bz_pos;
f2 = epu_field(id_model, pos2);
plot(pos2(1,:),f2(2,:));

pos2(2,:) = kickmaps.max_by_pos;
f2 = epu_field(id_model, pos2);
plot(pos2(1,:),f2(3,:));

xlabel('X Pos. [mm]');
ylabel('Field Bx,By [T]');
legend({'Bx','Bz','By'});
set(gcf, 'Name', 'Max Field Components Rolloffs');
title('Max Field Components Rolloffs');


% parãmetros de cálculo de U em cada linha (x,y)
if false
    % calcula o menor numero de pontos em um periodo para que erro < 1% em todo grid (x,y).
    kickmaps.nr_pts_period = calc_nrpts(kickmap, kickmap.id_summary.max_by_pos);
else
    kickmaps.nr_pts_period = 65;
end
y1    = kickmaps.max_by_pos;
y2    = kickmaps.max_by_pos + id_def.period;

% parâmetros do grid do kickmap
lim_inf_x = kickmaps_def.kicktable_lim_inf_x;
lim_sup_x = kickmaps_def.kicktable_lim_sup_x;
npts_x    = kickmaps_def.kicktable_npts_x;
lim_inf_y = kickmaps_def.kicktable_lim_inf_y;
lim_sup_y = kickmaps_def.kicktable_lim_sup_y;
npts_y    = kickmaps_def.kicktable_npts_y;
posx = linspace(lim_inf_x,lim_sup_x,npts_x);
posy = linspace(lim_inf_y,lim_sup_y,npts_y);

lnls_create_waitbar('Construindo Função Potencial', 0.2, length(posy) * length(posx));
U = zeros(length(posy), length(posx));
counter = 0;
for i=1:length(posy)
    for j=1:length(posx)
        if ~kickmaps_def.symmetric_kickmap || ((posx(j) >= 0) && (posy(i) >= 0))
            U(i,j) = calc_U(posx(j), posy(i), y1, y2, kickmaps.nr_pts_period, id_model);    
        end
        counter = counter + 1;
        lnls_update_waitbar(counter); 
    end  
end
if kickmaps_def.symmetric_kickmap
    U_dr = U((end+1)/2:end,(end+1)/2:end);
    U_dl = fliplr(U_dr(:,2:end));
    U_d  = [U_dl U_dr];
    U_u  = flipud(U_d(2:end,:));
    Ut   = [U_u; U_d];
    U = Ut;
end

% interpola tabela de kicks (normalizada pelo quadrado da rigidez magnética)
[kickx kicky] = kickmap_calc_derivatives(-0.5 * id_def.nr_periods * U, posx, posy);
mm_2_m = 1e-3;
kickx = mm_2_m^2 * kickx;
kicky = mm_2_m^2 * kicky;

kickmaps.posx = posx;
kickmaps.posy = posy;
kickmaps.U = U;
kickmaps.kickx = kickx;
kickmaps.kicky = kicky;



function nr_pts = calc_nrpts(kickmap, max_by_pos)

params = kickmap.Params;

level = 0.01;
npts  = 17;
z1    = max_by_pos;
z2    = max_by_pos + params.period;

x    = 0;
y    = 0;
iphi1 = calc_iphi(x,y,z1,z2,npts,kickmap);
fprintf('%i %f\n', npts, iphi1);
not_converged = true;
while not_converged
    npts = 2*(npts - 1) + 1;
    iphi2 = calc_iphi(x,y,z1,z2,2*(npts-1)+1,kickmap);
    if (abs(iphi2-iphi1)/iphi1 < level), not_converged = false; end
    iphi1 = iphi2;
    %fprintf('%i %f\n', npts, iphi1);
end
npts = (npts - 1)/2 + 1;


x    = max(abs([params.kicktable_lim_sup_x params.kicktable_lim_inf_x]));
y    = 0;
iphi1 = calc_iphi(x,y,z1,z2,npts,kickmap);
fprintf('%i %f\n', npts, iphi1);
not_converged = true;
while not_converged
    npts = 2*(npts - 1) + 1;
    iphi2 = calc_iphi(x,y,z1,z2,2*(npts-1)+1,kickmap);
    if (abs(iphi2-iphi1)/iphi1 < level), not_converged = false; end
    iphi1 = iphi2;
    fprintf('%i %f\n', npts, iphi1);
end
npts = (npts - 1)/2 + 1;

x    = max(abs([params.kicktable_lim_sup_x params.kicktable_lim_inf_x]));
y    = max(abs([params.kicktable_lim_sup_z params.kicktable_lim_inf_z]));
iphi1 = calc_iphi(x,y,z1,z2,npts,kickmap);
fprintf('%i %f\n', npts, iphi1);
not_converged = true;
while not_converged
    npts = 2*(npts - 1) + 1;
    iphi2 = calc_iphi(x,y,z1,z2,2*(npts-1)+1,kickmap);
    if (abs(iphi2-iphi1)/iphi1 < level), not_converged = false; end
    iphi1 = iphi2;
    %fprintf('%i %f\n', npts, iphi1);
end
npts = (npts - 1)/2 + 1;

x    = 0;
y    = max(abs([params.kicktable_lim_sup_z params.kicktable_lim_inf_z]));
iphi1 = calc_iphi(x,y,z1,z2,npts,kickmap);
fprintf('%i %f\n', npts, iphi1);
not_converged = true;
while not_converged
    npts = 2*(npts - 1) + 1;
    iphi2 = calc_iphi(x,y,z1,z2,2*(npts-1)+1,kickmap);
    if (abs(iphi2-iphi1)/iphi1 < level), not_converged = false; end
    iphi1 = iphi2;
    %fprintf('%i %f\n', npts, iphi1);
end
npts = (npts - 1)/2 + 1;

x    = max(abs([params.kicktable_lim_sup_x params.kicktable_lim_inf_x]))/2;
y    = max(abs([params.kicktable_lim_sup_z params.kicktable_lim_inf_z]))/2;
iphi1 = calc_iphi(x,y,z1,z2,npts,kickmap);
fprintf('%i %f\n', npts, iphi1);
not_converged = true;
while not_converged
    npts = 2*(npts - 1) + 1;
    iphi2 = calc_iphi(x,y,z1,z2,2*(npts-1)+1,kickmap);
    if (abs(iphi2-iphi1)/iphi1 < level), not_converged = false; end
    iphi1 = iphi2;
    %fprintf('%i %f\n', npts, iphi1);
end
npts = (npts - 1)/2 + 1;

nr_pts = npts;


     
function U = calc_U(x,y,z1,z2,npts,model)

posy1 = linspace(z1,z2,npts);
posy = posy1;
pos  = zeros(3,length(posy));
pos(1,:) = x;
pos(2,:) = posy; 
pos(3,:) = y;
field = epu_field(model, pos); 
bx1 = field(1,:);
b = 0.5*(bx1(1:end-1) + bx1(2:end));
ibx1 = [0 cumsum(b)] * (posy(2) - posy(1));
by1 = field(3,:);
b = 0.5*(by1(1:end-1) + by1(2:end));
iby1 = [0 cumsum(b)] * (posy(2) - posy(1));
phi  = (ibx1.^2 + iby1.^2);
U = sum(0.5 * (phi(1:end-1) + phi(2:end)) .* diff(posy));


