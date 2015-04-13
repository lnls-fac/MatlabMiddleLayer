 %sirius_booster;
 %global THERING;
clear all;

gamma = 150/0.511;
emit = 50e-6/gamma;
energysprd = 0.005;
varenergy = 0.0025;

folder = '/home/fac_files/data/sirius/bo/beam_dynamics/oficial/v901/multi.cod.tune/cod_matlab/';
% the_ring = load([folder 'CONFIG_the_ring.mat']);
% the_ring = the_ring.the_ring;

machine = load([folder 'CONFIG_machines_cod_corrected.mat']);
machine = machine.machine;

Ax = zeros(length(machine),length(machine{1}));
Ay = zeros(length(machine),length(machine{1}));
for i=1:length(machine)
    the_ring = machine{i};
    a = calctwiss(the_ring);
    a.etay = 0.01*a.etax;
    codx = abs(a.cox);
    cody = abs(a.coy);
    
    Ax(i,:) =   (3.0*sqrt(a.betax*1*emit+(a.etax).^2*energysprd^2)*1000 + ... 4*beamsize@injection +
                1*codx*1000 + ... 1mm(cod) +
                3*varenergy*a.etax*1000 + ... varenergylinac*dispersion +
                1*4.5)'; % 4mm(oscilacao residual injecao)
    
    Ay(i,:) =  (3.0*sqrt(a.betay*1*emit+a.etay.^2*energysprd^2)*1000 + ... 4*beamsize@injection +
                1*cody*1000 + ... 1mm(cod) +
                3*varenergy*a.etay*1000 + ... % varenergylinac*dispersion
                1*3.0)'; % (oscilacao residual injecao)
end
max_s = a.pos(end);
Ax = max(Ax)';
Ay = max(Ay)';

% Create figure
figure1 = figure('Position',[93,94,1239,461]) ;
axes1 = axes('Parent',figure1,'Position',[0.068 0.155 0.911 0.770],'FontSize',20);
box(axes1,'on'); grid(axes1,'on'); hold(axes1,'all');


% Create multiple lines using matrix input to plot
plot1 = plot(axes1,a.pos,[Ax,Ay]);
set(axes1,'XLim',[0 max_s]);
symmetry = 5;  offset = 2.5; no_print_names = true; scale = 2;
lnls_drawlattice(the_ring, symmetry, offset, no_print_names, scale);
% Create xlabel
xlabel({'s [m]'},'FontSize',20);
% Create ylabel
ylabel({'Aperture [mm]'},'FontSize',20);
legend1 = legend(plot1,'show',{'X';'Y'});
     set(legend1, 'Location','NorthEast');

maxx = max(Ax)
maxy = max(Ay)
       
