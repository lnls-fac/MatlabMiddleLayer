function [RFam, VOLTS] = setrf_hp(Family, Field, RFnew, DeviceList, WaitFlag, RampFlag)
%  [RFam, VOLTS] = setrf_hp(Family, Field, RFnew, DeviceList, WaitFlag, RampFlag);
%  [RFam, VOLTS] = setrf_hp(Family, RFnew, DeviceList, WaitFlag, RampFlag);
%  [RFam, VOLTS] = setrf_hp(RFnew, DeviceList, WaitFlag, RampFlag);
%
%  RFnew = new RF frequency [MHz]
%          if RFac is within 100 kHz of 499.64 MHz, it is interpreted as a frequency in MHz,
%          if RFac is between -2 and 2 it is interpreted as a voltage for the FM input
%                  of the user synthesizer (scaling factor is 1 V equals 4.988 kHz).
%  RFam = monitor value for the RF frequency  [MHz]
%  VOLTS = new EG HQMOFM voltage [V]
%
%  if RampFlag
%     Ramp the RF frequency slowly {Default}
%  else
%     Set the RF frequency in one step
%
%  Notes:  1.  The RF must be connected to the user synthesizer for this function to work
%          2.  The HQMOFM ILC must be connected to the user synthesizer for this function to work

% Tom Scarvie, Christoph Steier, November 2001

% 11-18-2002. T.Scarvie
% Added PauseFlag argument to allow ramping algorithm to set the RF frequency quickly (no 3 sec scasleep)


TolSP_AM = .00001;


if nargin < 1
    error('RF frequency input is required.');
end


% Family or Field maybe numeric
if isnumeric(Family)
    % RFnew, DeviceList, WaitFlag, RampFlag
    if nargin >= 4
        RampFlag = DeviceList; 
    else
        RampFlag = 1;
    end

    if nargin >= 3
        WaitFlag = RFnew; 
    else
        WaitFlag = 0;
    end
    
    if nargin >= 2
        DeviceList = Field;
    else
        DeviceList = [];
    end
    
    RFnew = Family;
elseif isnumeric(Field)
    % Family, RFnew, DeviceList, WaitFlag, RampFlag
    if nargin < 2
        error('RF frequency input is required.');
    end
    if nargin >= 5
        RampFlag = WaitFlag; 
    else
        RampFlag = 1;
    end

    if nargin >= 4
        WaitFlag = DeviceList; 
    else
        WaitFlag = 0;
    end
    
    if nargin >= 3
        DeviceList = RFnew;
    else
        DeviceList = [];
    end
    
    RFnew = Field;
else
    % Family, Field, RFnew, DeviceList, WaitFlag, RampFlag
    if nargin < 3
        error('RF frequency input is required.');
    end
    if nargin < 4
        DeviceList = [];
    end
    if nargin < 5
        WaitFlag = 0;
    end
    if nargin < 6
        RampFlag = 1;
    end
end



% if abs(RFnew-499.64) <= 0.1      % input is a frequency
%     deltarfHQMO = (RFnew-RFold)/4.988e-3;
% elseif abs(RFnew) <= 2    % input is a voltage
%     deltarfHQMO = RFnew-HQMOFMold;
% else
%     fprintf('Input must be either a frequency within 100 kHz of 499.640 MHz or a voltage between -2 and 2 Volts!');
%     return
% end


for i = 1:1
    HQMOFMold = getpv('EG______HQMOFM_AC01');
    RFold = getpv('SR01C___FREQB__AM00');

    deltarfHQMO = (RFnew-RFold) / 4.988e-3;
    
%     if abs(RFnew-499.64) <= 0.1      % input is a frequency
%         deltarfHQMO = (RFnew-RFold)/4.988e-3;
%     elseif abs(RFnew) <= 2    % input is a voltage
%         deltarfHQMO = RFnew-HQMOFMold;
%     else
%         fprintf('Input must be either a frequency within 100 kHz of 499.640 MHz or a voltage between -2 and 2 Volts!');
%         return
%     end
    
    % set rf or voltage
    setpv('EG______HQMOFM_AC01', '', HQMOFMold+deltarfHQMO, 0);

    %pause(.5);
end

% set rf or voltage with a WaitFlag
setpv('EG______HQMOFM_AC01', '', HQMOFMold+deltarfHQMO, WaitFlag);

    
% Ramping section below to be used when we are able to do larger steps
% Using synthesizer & EG HQMOFM
% MaxStep = .01;     % volts
%
%	HQMOFMac0 = getam('EG______HQMOFM_AC01')
%  	Nsteps = ceil(abs((HQMOFMac0-deltarfHQMO)/MaxStep));
%
%  	% For large setpoint changes, verify RampFlag=1
%   	if RampFlag==1 & abs(HQMOFMac0-deltarfHQMO) > 1
%   		RampFlag = questdlg(str1mat(sprintf('The RF change is %.5f MHz.',(HQMOFMac0-deltarfHQMO)*1.3661e-3),'How many steps do you want to make?'),'RF Synthesizer?','1 Step',sprintf('%d Steps',Nsteps),'1 Step');
%      	if strcmp(RampFlag,'1 Step')
%      		RampFlag = 0;
%      	else
%         	RampFlag = 1;
%      	end
%  	end
%
%   	if RampFlag
%   		for i = 1:Nsteps
%      		setsp('EG______HQMOFM_AC01', HQMOFMac0 + i*(deltarfHQMO-HQMOFMac0)/Nsteps);
%        	sleep(.03);
%     	end
%     	setsp('EG______HQMOFM_AC01', volts);
%  	else
%     	setsp('EG______HQMOFM_AC01', volts);
%  	end


% Extra wait to make sure the RF GPIB commands got there
if WaitFlag < 0
    pause(1.5);
end


% if nargout == 0
%   fprintf('                 RF Frequency Information \n');
%   fprintf('                  HP Counter = %.6f MHz\n', getam('SR01C___FREQB__AM00'));
%   fprintf(' FM voltage user synthesizer = %.6f V\n', getsp('EG______HQMOFM_AC01'));
% end

RFam  = getpv('SR01C___FREQB__AM00');

if nargout >= 2
    VOLTS = getpv('EG______HQMOFM_AC01');
end

