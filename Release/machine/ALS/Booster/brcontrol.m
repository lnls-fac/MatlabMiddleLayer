function varargout = brcontrol(varargin)
%BRCONTROL M-file for brcontrol.fig
%      BRCONTROL, by itself, creates a new BRCONTROL or raises the existing
%      singleton*.
%
%      H = BRCONTROL returns the handle to a new BRCONTROL or the handle to
%      the existing singleton*.
%
%      BRCONTROL('Property','Value',...) creates a new BRCONTROL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to brcontrol_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      BRCONTROL('CALLBACK') and BRCONTROL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in BRCONTROL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help brcontrol

% Last Modified by GUIDE v2.5 02-Jan-2009 10:49:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @brcontrol_OpeningFcn, ...
    'gui_OutputFcn',  @brcontrol_OutputFcn, ...
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


% --- Executes just before brcontrol is made visible.
function brcontrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for brcontrol
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes brcontrol wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% ALS Initialization Below

% Check if the AO exists
checkforao;

% Update database channels
%CheckInputs(handles);


% --- Executes on button press in HWInit.
function HWInit_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'Initialize various parameter in the Booster',' ','Initialize the Booster hardware?'},'HWINIT','Yes','No','No');
if strcmp(StartFlag,'Yes')
   hwinit;
else
    fprintf('   Booster hardware initialization canceled.\n');
    return
end


% --- Outputs from this function are returned to the command line.
function varargout = brcontrol_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in TurnOff.
function TurnOff_Callback(hObject, eventdata, handles)
fprintf('\n');
fprintf('   ********************************\n');
fprintf('   **  Turn Booster Magnets Off  **\n');
fprintf('   ********************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

StartFlag = questdlg({'This function will stop the ramp, zero,','and turn off the booster magnets.',' ','Turn off the BR magnet power supplies?'},'Turn Off','Yes','No','No');

if strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   ******************************************\n');
    fprintf('   **  Turning Booster Power Supplies Off  **\n');
    fprintf('   ******************************************\n');
    a = clock; 
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

    % Set SF & SD on
    try
        fprintf('   1. Turning SF off ... ');
        %OnFlag = getpv('SF', 'On');
        %if any(OnFlag==1)
            setpv('SF', 'EnableRamp', 0);  % Disable the ramp before turning off
            pause(1);
            setpv('SF', 'Setpoint',  0);
            setpv('SF', 'OnControl', 0);
        %end
        
        fprintf('   2. Turning SD off ... ');
        %OnFlag = getpv('SD', 'On');
        %if any(OnFlag==1)
            setpv('SD', 'EnableRamp', 0);  % Disable the ramp before turning off
            pause(1);
            setpv('SD', 'Setpoint',  0);
            setpv('SD', 'OnControl', 0);
        %end
        fprintf('Done\n');

        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        fprintf('   **************************************\n');
        fprintf('   **  Booster Power Supplies Are Off  **\n');
        fprintf('   **************************************\n\n');
    catch
        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        fprintf('   *****************************************************************\n');
        fprintf('   **  A Problem Occurred Turning Off the Booster Power Supplies  **\n');
        fprintf('   *****************************************************************\n\n');
    end

else
    fprintf('   *****************************************************\n');
    fprintf('   **  Booster magnet power supply turn off canceled  **\n');
    fprintf('   *****************************************************\n');
    return
end



% --- Executes on button press in TurnOn.
function TurnOn_Callback(hObject, eventdata, handles)
fprintf('\n');
fprintf('   *******************************\n');
fprintf('   **  Turn Booster Magnets On  **\n');
fprintf('   *******************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

StartFlag = questdlg({'This function will turn on and enable','the ramping of the booster magnets.',' ','Turn on the BR magnet power supplies?'},'Turn Off','Yes','No','No');

if strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   *****************************************\n');
    fprintf('   **  Turning Booster Power Supplies On  **\n');
    fprintf('   *****************************************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

    % Set SF & SD on
    try
        fprintf('   1. Turning SF on (if necessary) ... ');
        OnFlag = getpv('SF', 'On');
        if any(OnFlag==0)
            setpv('SF', 'EnableRamp', 0);  % Disable the ramp before turning on or it could glitch
            pause(1);
            setpv('SF', 'Setpoint',  0);
            setpv('SF', 'OnControl', 1);
        end
        fprintf('   2. Turning SD on (if necessary) ... ');

        OnFlag = getpv('SD', 'On');
        if any(OnFlag==0)
            setpv('SD', 'EnableRamp', 0);  % Disable the ramp before turning on or it could glitch
            pause(1);
            setpv('SD', 'Setpoint',  0);
            setpv('SD', 'OnControl', 1);
        end
        fprintf('Done\n');

        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        fprintf('   *************************************\n');
        fprintf('   **  Booster Power Supplies Are On  **\n');
        fprintf('   *************************************\n\n');
    catch
        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        fprintf('   ****************************************************************\n');
        fprintf('   **  A Problem Occurred Turning On the Booster Power Supplies  **\n');
        fprintf('   ****************************************************************\n\n');
    end

else
    fprintf('   ****************************************************\n');
    fprintf('   **  Booster magnet power supply turn on canceled  **\n');
    fprintf('   ****************************************************\n');
    return
end



% --- Executes on button press in RFRampTable.
function RFRampTable_Callback(hObject, eventdata, handles)
fprintf('\n');
fprintf('   *************************************\n');
fprintf('   **  Loading Booster RF Ramp Table  **\n');
fprintf('   *************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

StartFlag = questdlg(sprintf('Start the RF Ramp Table Load?'),'RF Ramp Table Load','Yes','Cancel','Cancel');

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster RF ramp table ... ');
    setboosterramprf;

    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster RF ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  Error loading the booster RF ramp table  **\n');
    fprintf('   ***********************************************\n\n');
end



% --- Executes on button press in SFRampTable.
function SFRampTable_Callback(hObject, eventdata, handles)
fprintf('\n');
fprintf('   *************************************\n');
fprintf('   **  Loading Booster SF Ramp Table  **\n');
fprintf('   *************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

StartFlag = questdlg(sprintf('Start the SF Ramp Table Load?'),'SF Ramp Table Load','Yes','Cancel','Cancel');

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster SF ramp table ... ');
    setboosterrampsf;

    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster SF ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  Error loading the booster SF ramp table  **\n');
    fprintf('   ***********************************************\n\n');
end


% --- Executes on button press in SDRampTable.
function SDRampTable_Callback(hObject, eventdata, handles)
fprintf('\n');
fprintf('   *************************************\n');
fprintf('   **  Loading Booster SD Ramp Table  **\n');
fprintf('   *************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

StartFlag = questdlg(sprintf('Start the SD Ramp Table Load?'),'SD Ramp Table Load','Yes','Cancel','Cancel');

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster SD ramp table ... ');
    setboosterrampsd;

    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster SD ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  Error loading the booster SD ramp table  **\n');
    fprintf('   ***********************************************\n\n');
end


% --- Executes on button press in BENDRampTable.
function BENDRampTable_Callback(hObject, eventdata, handles)
fprintf('\n');
fprintf('   ***************************************\n');
fprintf('   **  Loading Booster BEND Ramp Table  **\n');
fprintf('   ***************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

StartFlag = questdlg(sprintf('Start the BEND Ramp Table Load?'),'BEND Ramp Table Load','Yes','Cancel','Cancel');

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster BEND ramp table ... ');
    setboosterrampbend;

    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster BEND ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   *************************************************\n');
    fprintf('   **  Error loading the booster BEND ramp table  **\n');
    fprintf('   *************************************************\n\n');
end


% --- Executes on button press in QFRampTable.
function QFRampTable_Callback(hObject, eventdata, handles)
fprintf('\n');
fprintf('   *************************************\n');
fprintf('   **  Loading Booster QF Ramp Table  **\n');
fprintf('   *************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

StartFlag = questdlg(sprintf('Start the QF Ramp Table Load?'),'QF Ramp Table Load','Yes','Cancel','Cancel');

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster QF ramp table ... ');
    setboosterrampqd;

    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster QF ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  Error loading the booster QF ramp table  **\n');
    fprintf('   ***********************************************\n\n');
end


% --- Executes on button press in QDRampTable.
function QDRampTable_Callback(hObject, eventdata, handles)
fprintf('\n');
fprintf('   *************************************\n');
fprintf('   **  Loading Booster QD Ramp Table  **\n');
fprintf('   *************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

StartFlag = questdlg(sprintf('Start the QD Ramp Table Load?'),'QD Ramp Table Load','Yes','Cancel','Cancel');

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster QD ramp table ... ');
    setboosterrampqd;

    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster QD ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  Error loading the booster QD ramp table  **\n');
    fprintf('   ***********************************************\n\n');
end


