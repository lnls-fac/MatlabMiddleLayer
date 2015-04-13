function [HBPM, VBPM, HCM, VCM, HSV, VSV] = ocsinit(MethodName)
%OCSINIT - Corrector and BPM
% [HBPM, VBPM, HCM, VCM, HSV, VSV] = ocsinit(MethodName)
%
%  INPUTS
%  1. MethodName = 'TopOfFill'
%                  'SOFB'
%                  'FOFB'
%                  'Injection_TopOfFill'
%                  'Offset Orbit'
%
%  NOTE
%  1. This is a user operational file
%
%  See also setorbit, setorbitgui, setorbitsetup


if nargin == 0
    MethodName = 'TopOfFill';
end

switch(MethodName)

    case 'TopOfFill'

        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%

        % Bad BPM list
        RemoveHBPMDeviceList = [
            1  7;   % this BPM had large offset due to physics2hw gain error in MatlabML but hat was fixed 6-5-08 - now has strange orbit reading so leaving it out to track a bit - T.Scarvie
            %1 10;    %noisy in 2-bunch - 2008-08-07
            %2  7;    %noisy in 2-bunch - 2008-08-07
            %3 12;   % recabled during 5-08 long shutdown - T.Scarvie
            %8 10;
            %5 10; % fixed during the 9/08 shutdown - T.Scarvie
            9 5;    % may have made a huge change on 6/20/2009, took it out to observe it (GJP)
            ];
        RemoveVBPMDeviceList = RemoveHBPMDeviceList;

        HBPMList = getbpmlist('Bergoz');
        VBPMList = getbpmlist('Bergoz');

        i = findrowindex(RemoveHBPMDeviceList, HBPMList);
        if ~isempty(i)
            HBPMList(i,:) = [];
        end

        i = findrowindex(RemoveVBPMDeviceList, VBPMList);
        if ~isempty(i)
            VBPMList(i,:) = [];
        end

        
        %%%%%%%%%%%%%%%%%%%
        % Corrector Setup %
        %%%%%%%%%%%%%%%%%%%
        
        % Bad corrector list
        RemoveHCMDeviceList = [
            3 10
            5 10
            10 10
            ];
        
        RemoveVCMDeviceList = [
            3 10
            5 10
            10 10
            %1 8; This was removed when the corrector was not holding tolerance and AC changing spontaneously! 8/3/08-8/8/08 - has been behaving now since 8/11
            %5 10 %This PS seems to work fine as of 6-7-08 - T.Scarvie   % SR06U___VCM2 power supply is marginal with poor step response behavior - no spare yet - 10/12/07 - T.Scarvie
            ];

        HCMList = getcmlist('HCM', '2 3 6 7 10');
        VCMList = getcmlist('VCM', '1 4 5 8 10');
        VCMList = [1 2; VCMList; 12 7];  % Replacement for missing magnets in sectors 1 & 12

        i = findrowindex(RemoveHCMDeviceList, HCMList);
        if ~isempty(i)
            HCMList(i,:) = [];
        end

        i = findrowindex(RemoveVCMDeviceList, VCMList);
        if ~isempty(i)
            VCMList(i,:) = [];
        end

        
        % Structure setup
        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);

        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);
        

        % SVD orbit correction
        HSV = min([size(HCMList,1) size(HBPMList,1)])-1;
        VSV = min([size(VCMList,1) size(VBPMList,1)])-1;


    case 'SOFB'

        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%
        
        % Bad BPM list
        % Remove Bergoz BPMs in SR01 and SR03 for 2-bunch (noisy at low currents) and drop singular values
        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
            RemoveHBPMDeviceList = [RemoveHBPMDeviceList;
                1 2;
                2 7;
                2 1;
                2 7;
                2 9;
                3 2;
                8 10;
                9 5;   % may have made a huge change on 6/20/2008, took it out to observe it (GJP)
                12 9];
        else
            RemoveHBPMDeviceList = [
                % after replacing Bergoz crate PS sector 1 BPMs worked again (generally) - 2008-1-11
                % 1 2;
                % 1 4;
                % 1 5;
                % 1 6;
                1 7;   % LOCO gain fixed 6-5-08 but now has large orbit error -> leave out for now - T.Scarvie
                % 1 10;  % cable just fixed 10-30-07 - returned to OC service 11-27-07, started jumping again 12-4-07 - T.Scarvie
                % 3 12;  % this BPM went bad after 2/24/08 single bunch kicker / 2-bunch setup tests - T.Scarvie
                % 5 10; % fixed during the 9/08 shutdown - T.Scarvie
                6 5;   % BPM showed larger (1 mum rms with FFB on) noise than other ones 7/16/2007
                ];

        end
        RemoveVBPMDeviceList = RemoveHBPMDeviceList;

               
        % HBPMList = getbpmlist('Bergoz', '1 2 5 6 9 10 11 12');  % Don't use new Bergoz for now
        % VBPMList = getbpmlist('Bergoz', '1 2 5 6 9 10 11 12');  % Don't use new Bergoz for now
        HBPMList = getbpmlist('Bergoz');  % 2007-07-16 - start including new bergoz BPMs
        VBPMList = getbpmlist('Bergoz');  % looked overall fine on archivewr data


        i = findrowindex(RemoveHBPMDeviceList, HBPMList);
        if ~isempty(i)
            HBPMList(i,:) = [];
        end

        i = findrowindex(RemoveVBPMDeviceList, VBPMList);
        if ~isempty(i)
            VBPMList(i,:) = [];
        end

 
        %%%%%%%%%%%%%%%%%%%
        % Corrector Setup %
        %%%%%%%%%%%%%%%%%%%
        
        % Bad corrector list
        RemoveHCMDeviceList = [
            % With sector 1 BPMs working again, no need to keep corrector magnets disabled 2008-1-11
            %  1 2;
            %  1 8;
            %  3 10;
            %  5 10;
            % 10 10
            ];

        RemoveVCMDeviceList = [
            %  3 10;
            %  5 10;
             10 10
            ];


        HCMList = getcmlist('HCM', '1 8 10');
        HCMList = [1 2; HCMList; 12 7];  % Replacement for missing magnets in sectors 1 & 12
      
        %VCMList = getcmlist('VCM', '1 8 10');
        %VCMList = [1 2; VCMList; 12 7];  % Replacement for missing magnets in sectors 1 & 12

        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
            VCMList = [
                1 2;
                1 8;
                2 1;
                2 8;
                3 1;
                3 8;
                3 10; %SR04U_VCM2 (chicane trim)
                4 1;
                4 8;
                5 1;
                5 8;
                5 10; %SR06U_VCM2 (chicane trim)
                6 1;
                6 8;
                7 1;
                7 8;
                8 1;
                8 8;
                9 1;
                9 8;
                10 1;
                10 8;
                10 10; %SR11U_VCM2 (chicane trim)
                11 1;
                11 8;
                12 1;
                12 7];
        else
            VCMList = [
                1 2;
                1 8;
                2 1;
                2 8;
                3 1;
                3 2;
                3 7;
                3 8;
                3 10; %SR04U_VCM2 (chicane trim)
                4 1;
                4 2;
                4 7;
                4 8;
                5 1;
                5 2;
                5 7;
                5 8;
                5 10; %SR06U_VCM2 (chicane trim)
                6 1;
                6 2;
                6 7;
                6 8;
                7 1;
                7 2;
                7 7;
                7 8;
                8 1;
                8 2;
                8 7;
                8 8;
                9 1;
                9 2;
                9 7;
                9 8;
                10 1;
                10 2;
                10 7;
                10 8;
                10 10; %SR11U_VCM2 (chicane trim)
                11 1;
                11 2;
                11 7;
                11 8;
                12 1;
                12 2;
                12 7];
        end
        

        % Select out the HCMs
        i = findrowindex(RemoveHCMDeviceList, HCMList);
        if ~isempty(i)
%             if i==18; %this condition added since HCM(8,8) failed - remove when fixed - T.Scarvie - 20081022
%                 HCMList(i,:) = [8 7];
%             else
                HCMList(i,:) = [];
%             end
        end

        % Select out the VCMs
        i = findrowindex(RemoveVCMDeviceList, VCMList);
        if ~isempty(i)
            VCMList(i,:) = [];
        end


        
        % SVD orbit correction
        if size(HBPMList,1) < 78
            HSV = 29-2;
        else
            HSV = 30-2;
        end
        VSV = 45;

        if strcmp(getfamilydata('OperationalMode'), '1.5 GeV, Inject at 1.23') %higher values driving chicane correctors crazy in 1.5
           HSV = 12; %this number gets boosted by one somewhere else - rf?
           VSV = 24;
        end
        
        % Remove Bergoz BPMs in SR01 and SR03 for 2-bunch (noisy at low currents) and drop singular values
        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
            %     HBPMList = HBPMList(find(HBPMList(:,1)~=1),:);
            %     HBPMList = HBPMList(find(HBPMList(:,1)~=3),:);
            %     HSV = HSV - 4 - 3;
            %
            %     VBPMList = VBPMList(find(VBPMList(:,1)~=1),:);
            %     VBPMList = VBPMList(find(VBPMList(:,1)~=3),:);
            VSV = VSV - 1;
        end


        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);

        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);


    case 'FOFB'

        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%

        RemoveHBPMDeviceList = [
            6 5;   % BPM showed larger (1 mum rms with FFB on) noise than other ones 7/16/2007
            9 5;   % BPM showed stranged drift behavior on 7/15/2007
                   %     also may have made a huge change on 6/20/2008 (GJP)
            ];
        %RemoveHBPMDeviceList = [
        %    3 6;   % this BPM has not been used in old ML OC for a while - suspect it's drifting
        %    3 12;  % this BPM broke during the 11/28-29 maintenance - there was maintenance on the motor chicane...
        %    ];
        RemoveVBPMDeviceList = RemoveHBPMDeviceList;

        
        HBPMList = getbpmlist('OldBergoz');
        VBPMList = getbpmlist('OldBergoz');

        i = findrowindex(RemoveHBPMDeviceList, HBPMList);
        if ~isempty(i)
            HBPMList(i,:) = [];
        end

        i = findrowindex(RemoveVBPMDeviceList, VBPMList);
        if ~isempty(i)
            VBPMList(i,:) = [];
        end

        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);

        
        %%%%%%%%%%%%%%%%%%%
        % Corrector Setup %
        %%%%%%%%%%%%%%%%%%%
        
        % Corrector magnets
        HCMList = [
            1 8;
            2 1;
            2 8;
            3 1;
            3 8;
            4 1;
            4 8;
            5 1;
            5 8;
            6 1;
            6 8;
            7 1;
            7 8;
            8 1;
            8 8;
            9 1;
            9 8;
            10 1;
            10 8;
            11 1;
            11 8;
            12 1];

        VCMList = [
            1 8;
            2 1;
            2 8;
            3 1;
            3 8;
            4 1;
            4 8;
            5 1;
            5 8;
            6 1;
            6 8;
            7 1;
            7 8;
            8 1;
            8 8;
            9 1;
            9 8;
            10 1;
            10 8;
            11 1;
            11 8;
            12 1];

        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);


        % SVD orbit correction
        HSV = 11;
        VSV = 12;


        % Remove Bergoz BPMs in SR01 and SR03 for 2-bunch (noisy at low currents) and drop singular values
        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
            HBPMList = HBPMList(find(HBPMList(:,1)~=1),:);
            HBPMList = HBPMList(find(HBPMList(:,1)~=3),:);
            HSV = HSV - 4;

            VBPMList = VBPMList(find(VBPMList(:,1)~=1),:);
            VBPMList = VBPMList(find(VBPMList(:,1)~=3),:);
            VSV = VSV - 4;
        end


        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);

        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);


    case 'Measured Offsets'
        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%

        HBPMList = getbpmlist('HOffset');
        VBPMList = getbpmlist('VOffset');

        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);


        %%%%%%%%%%%%%%%%%%%
        % Corrector Setup %
        %%%%%%%%%%%%%%%%%%%
        HCMList = getcmlist('HCM','1 2 3 4 5 6 7 8');
        VCMList = getcmlist('VCM','1 2 3 4 5 6 7 8');

        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);


        % SVD orbit correction
        HSV = 24;
        VSV = 24;

        
    case 'Injection'
        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%

        % Remove BPMs inside chicane (except a few)
        RemoveHBPMDeviceList = [
            3 11;
            3 12;
            5 11;
            5 12;
            6  1;
            9  5;    % may have made a huge change on 6/20/2008, took it out to observe it (GJP)
            10 10;
            10 11;
            10 12;
            11  1;
            ];
        RemoveVBPMDeviceList = RemoveHBPMDeviceList;

        HBPMList = getbpmlist('BPMx');
        VBPMList = getbpmlist('BPMy');

        i = findrowindex(RemoveHBPMDeviceList, HBPMList);
        if ~isempty(i)
            HBPMList(i,:) = [];
        end

        i = findrowindex(RemoveVBPMDeviceList, VBPMList);
        if ~isempty(i)
            VBPMList(i,:) = [];
        end

        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);


        %%%%%%%%%%%%%%%%%%%
        % Corrector Setup %
        %%%%%%%%%%%%%%%%%%%
        HCMList = getcmlist('HCM','1 2 3 4 5 6 7 8');
        VCMList = getcmlist('VCM','1 2 3 4 5 6 7 8');

        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);

        % SVD orbit correction
        HSV = 24;
        VSV = 24;
        

    case 'Injection_TopOfFill'
        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%

        % Remove BPMs inside chicane (except a few)
        RemoveHBPMDeviceList = [
            3 11;
            3 12;
            5 11;
            5 12;
            6 1;
            10 10;
            10 11;
            10 12;
            11  1;
            ];
        RemoveVBPMDeviceList = RemoveHBPMDeviceList;


        [HBPM, VBPM, HCM, VCM, HSV, VSV] = ocsinit('TopOfFill');
        
        
        i = findrowindex(RemoveHBPMDeviceList, HBPM.DeviceList);
        if ~isempty(i)
            HBPM.Data(i,:) = [];
            HBPM.DeviceList(i,:) = [];
            HBPM.Status(i,:) = [];
        end

        i = findrowindex(RemoveVBPMDeviceList, VBPM.DeviceList);
        if ~isempty(i)
            VBPM.Data(i,:) = [];
            VBPM.DeviceList(i,:) = [];
            VBPM.Status(i,:) = [];
        end
        
        % SVD orbit correction
        HSV = HSV - 8;
        VSV = VSV - 8;

        
    otherwise
        fprintf('   Orbit correction set unknown.\n');
end








% HCMList = [];
% VCMList = [];
% for Sector = 1:12
%     if Sector == 1
%         VCMList = [VCMList;Sector 2;Sector 4;Sector 5;Sector 8];
%         HCMList = [HCMList;Sector 2;Sector 7];
%     elseif Sector == 3
%         VCMList = [VCMList;Sector 1;Sector 4;Sector 5;Sector 8;Sector 10];
%         HCMList = [HCMList;Sector 2;Sector 7;Sector 10];
%     elseif Sector == 5
%         VCMList = [VCMList;Sector 1;Sector 4;Sector 5;Sector 8;Sector 10];
%         HCMList = [HCMList;Sector 2;Sector 7;Sector 10];
%     elseif Sector == 10
%         VCMList = [VCMList;Sector 1;Sector 4;Sector 5;Sector 8;Sector 10];
%         HCMList = [HCMList;Sector 2;Sector 7;Sector 10];
%     elseif Sector == 12
%         VCMList = [VCMList;Sector 1;Sector 4;Sector 5;Sector 7];
%         HCMList = [HCMList;Sector 2;Sector 7];
%     else
%         VCMList = [VCMList;Sector 1;Sector 4;Sector 5;Sector 8];
%         HCMList = [HCMList;Sector 2;Sector 7];
%     end
% end
