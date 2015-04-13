function gtbcycle(varargin)
%GTBCYCLE - Gun to booster ring cycle
%  gbtcycle(SuperBendFlag {'Yes'/'No'}, ChicaneAndSkewQuadFlag {'Yes'/'No'})
%
%  See also setmachineconfig


%%%%%%%%%%%%%%
% Initialize %
%%%%%%%%%%%%%%


% Input flags
DisplayFlag = 1;
FinalLattice = 'Injection';
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Injection')
        FinalLattice = 'Injection';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Production') || strcmpi(varargin{i},'Golden')
        FinalLattice = 'Production';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Present')
        FinalLattice = 'Present';
        varargin(i) = [];
    end
end


% Extra delay
ExtraDelay = 10;

% Final lattice
if strcmpi(FinalLattice, 'Present')
    [ConfigSetpoint, ConfigMonitor] = getmachineconfig;
elseif strcmpi(FinalLattice, 'Injection')
    [ConfigSetpoint, ConfigMonitor] = getinjectionlattice;
elseif strcmpi(FinalLattice,'Production') || strcmpi(FinalLattice,'Golden')
    [ConfigSetpoint, ConfigMonitor] = getproductionlattice;
end


HCM  = ConfigSetpoint.HCM.Setpoint;
VCM  = ConfigSetpoint.VCM.Setpoint;
BEND = ConfigSetpoint.BEND.Setpoint;
Q    = ConfigSetpoint.Q.Setpoint;

BENDmin = minpv(BEND, 'struct');
BENDmax = maxpv(BEND, 'struct');

Qmin = minpv(Q, 'struct');
Qmax = maxpv(Q, 'struct');

HCMmin = minpv(HCM, 'struct');
HCMmax = maxpv(HCM, 'struct');

VCMmin = minpv(VCM, 'struct');
VCMmax = maxpv(VCM, 'struct');

% Change corrector min to zero???
HCMmin.Data = HCMmin.Data*0;
VCMmin.Data = VCMmin.Data*0;

HCMmax.Data = HCMmax.Data * .8;
VCMmax.Data = VCMmax.Data * .8;


%%%%%%%%%%%%%%%%%%%
% Cycle if online %
%%%%%%%%%%%%%%%%%%%
if strcmpi(getmode('BEND'),'Online')
   % try
        fprintf('   Starting a cycle of the Gun, Linac, and LTB lattice.\n');
        
        % Set the correctors
        %setpv(ConfigSetpoint.HCM.Setpoint, 0);
        %setpv(ConfigSetpoint.VCM.Setpoint, 0);
        %setpv(ConfigSetpoint.HCM.Setpoint, -1);
        %setpv(ConfigSetpoint.VCM.Setpoint, -1);
        
        
        % Go to max
        fprintf('   Loading the maximum lattice   ...');
%         setpv(HCMmax,  0);
%         setpv(VCMmax,  0);
        setpv(BENDmax, 0);
        setpv(Qmax,    0);
%         setpv(HCMmax, -1);
%         setpv(VCMmax, -1);
        setpv(BENDmax,-1);
        setpv(Qmax,   -1);
        pause(ExtraDelay);
        a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        
        
        % Start at "min"
        fprintf('   Loading the minimum lattice   ...');
%         setpv(HCMmin,  0);
%         setpv(VCMmin,  0);
        setpv(BENDmin, 0);
        setpv(Qmin,    0);
%         setpv(HCMmin, -1);
%         setpv(VCMmin, -1);
        setpv(BENDmin,-1);
        setpv(Qmin,   -1);
        pause(ExtraDelay);
        a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

        
        % Go to final (set everything)
%         fprintf('   Loading the injection lattice   ...');
%         setmachineconfig(ConfigSetpoint, -1);
%         pause(2);
%         a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        
%     catch
%         fprintf('\n  **********************\n');
%         fprintf(  '  **  Cycle aborted!  **\n');
%         fprintf(  '  **********************\n\n');
%         sound tada
%         %fprintf('\n   %s\n', lasterr);
%         rethrow(lasterror);
%     end
    
else
    % Simulator
    setmachineconfig(ConfigSetpoint, -1);
end

