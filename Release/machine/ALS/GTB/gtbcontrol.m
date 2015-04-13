function varargout = gtbcontrol(varargin)
%GTBCONTROL M-file for gtbcontrol.fig
%      GTBCONTROL, by itself, creates a new GTBCONTROL or raises the existing
%      singleton*.
%
%      H = GTBCONTROL returns the handle to a new GTBCONTROL or the handle to
%      the existing singleton*.
%
%      GTBCONTROL('Property','Value',...) creates a new GTBCONTROL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to gtbcontrol_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GTBCONTROL('CALLBACK') and GTBCONTROL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GTBCONTROL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gtbcontrol

% Last Modified by GUIDE v2.5 23-Dec-2008 15:50:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gtbcontrol_OpeningFcn, ...
    'gui_OutputFcn',  @gtbcontrol_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% Revision History
% 2009-01-04 - Creation date


% For the compiler
%#function goldenpage, setoperationalmode


% --- Executes just before gtbcontrol is made visible.
function gtbcontrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for gtbcontrol
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gtbcontrol wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% ALS Initialization Below

% Check if the AO exists
checkforao;

% Update database channels
%CheckInputs(handles);


% --- Executes on button press in HWInit.
function HWInit_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'Initialize various parameter in the GTB',' ','Initialize the GTB hardware?'},'HWINIT','Yes','No','No');
if strcmp(StartFlag,'Yes')
   hwinit;
else
    fprintf('   GTB hardware initialization canceled.\n');
    return
end


% --- Outputs from this function are returned to the command line.
function varargout = gtbcontrol_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in TurnOff.
function TurnOff_Callback(hObject, eventdata, handles)
% To do: add sector turn off
StartFlag = questdlg({'This function will slowly ramp down','all the GTB magnets then turn them off.',' ','Turn off the GTB magnet power supplies?'},'Turn Off','Yes','No','No');
if strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   **************************************\n');
    fprintf('   **  Turning GTB Power Supplies Off  **\n');
    fprintf('   **************************************\n');
    a = clock; 
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

    try
        turnoffmps;
    catch
    end

    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   **********************************\n');
    fprintf('   **  GTB Power Supplies Are Off  **\n');
    fprintf('   **********************************\n\n');
else
    fprintf('   GTB magnet power supply turn off canceled.\n');
    return
end



% --- Executes on button press in TurnOn.
function TurnOn_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'This function will turn on with zero setpoint [and reset if necessary]','all the GTB magnets power supplies that are not presently on.',' ','Turn on the GTB magnet power supplies?'},'Turn Off','Yes','No','No');
if strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   *************************************\n');
    fprintf('   **  Turning GTB Power Supplies On  **\n');
    fprintf('   *************************************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

    try
        turnonmps;
    catch
    end

    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   *********************************\n');
    fprintf('   **  GTB Power Supplies Are On  **\n');
    fprintf('   *********************************\n\n');
else
    fprintf('   GTB magnet power supply turn on canceled.\n');
    return
end



% --- Executes on button press in Cycle.
function Cycle_Callback(hObject, eventdata, handles)

fprintf('\n');
fprintf('   *****************\n');
fprintf('   **  GTB Cycle  **\n');
fprintf('   *****************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

InjectionEnergy = getfamilydata('InjectionEnergy');
StartFlag = questdlg(sprintf('Start setup for injection, %.2f GeV?',InjectionEnergy),'Injection Setup','Yes','Cancel','Cancel');

if strcmp(StartFlag,'No')
    fprintf('   **************************\n');
    fprintf('   **    Cycle  Canceled   **\n');
    fprintf('   **************************\n\n');
    return
end

try

    gtbcycle(BSCFlag, ChicSQFlag, FullCycleFlag);

    fprintf('   Loading the injection lattice   ...');
    [ConfigSetpoint, ConfigMonitor] = getinjectionlattice;
    setmachineconfig(ConfigSetpoint, -1);
    
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  GTB Cycle complete, ready for injection  **\n');
    fprintf('   ***********************************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Cycle failed due to error condition! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************\n');
    fprintf('   **  Problem cycling GTB lattice  **\n');
    fprintf('   ***********************************\n\n');
end




% --- Executes on button press in Injection.
function Injection_Callback(hObject, eventdata, handles)
%GTB_Mode = getfamilydata('OperationalMode');
InjectionEnergy = getfamilydata('InjectionEnergy');

fprintf('\n');
fprintf('   *************************************************\n');
fprintf('   **  Setup For On Energy Injection at %.2f GeV  **\n', InjectionEnergy);
fprintf('   *************************************************\n');
StartFlag = questdlg(sprintf('Start setup for injection, %.2f GeV?',InjectionEnergy),'Injection Setup','Yes','Cancel','Cancel');
a = clock;
fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
if strcmp(StartFlag,'Cancel')
    fprintf('   ********************************\n');
    fprintf('   **  Injection Setup Canceled  **\n');
    fprintf('   ********************************\n\n');
    return
end

try
    % Load injection lattice
    fprintf('   Loading the injection lattice   ...');
    [ConfigSetpoint, ConfigMonitor] = getinjectionlattice;
    setmachineconfig(ConfigSetpoint, -1);
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Injection lattice setup failed due to error condition! \n\n');
end

a = clock;
fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
if StateNumber >= 0
    fprintf('   *********************************************************\n');
    fprintf('   **  Function complete:  the GTB is setup for injection **\n');
    fprintf('   *********************************************************\n');
else
    fprintf('   ****************************************\n');
    fprintf('   **  Problem with GTB injection setup  **\n');
    fprintf('   ****************************************\n\n');
end



% --- Executes on button press in CheckForProblems.
function CheckForProblems_Callback(hObject, eventdata, handles)
% fprintf('\n');
% disp('   ***********************************');
% disp('   **  Checking Storage Ring State  **');
% disp('   ***********************************');
% a = clock;
% fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
% 
% NumErrors = 0;
% 
% [ConfigSetpoint, ConfigMonitor, FileName] = getinjectionlattice;
% 
% % Check all SR magnets
% if isempty(FileName)
%     fprintf('   Goal setpoints will not be checked since the last lattice load is unknown.\n');
%     NumErrors1 = checksrmags('');
% else
%     %NumErrors1 = checksrmags([getfamilydata('Directory','OpsData') FileName]);
%     NumErrors1 = checksrmags(FileName);
% end
% if NumErrors1 == 0
%     fprintf('   SR magnets power supplies are OK.\n');
% end
% NumErrors = NumErrors + NumErrors1;
% 
% 
% a = clock;
% fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
% if NumErrors
%     disp('   ************************');
%     disp('   **  GTB Has Problems  **');
%     disp('   ************************');
% else
%     disp('   *************************');
%     disp('   **  GTB Lattice is OK  **');
%     disp('   *************************');
% end
% fprintf('   \n');



% --- Executes on button press in GoldenPage.
function GoldenPage_Callback(hObject, eventdata, handles)
goldenpage;

