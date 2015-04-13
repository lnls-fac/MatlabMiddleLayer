function Pos = getBPMFromIOC(Family, Field, DeviceList)
    
    %-------------------------------------------------
    %index      | description
    %------------------------------------------------
    %  0 - 127  | vertical position   bpm nr. 0 - 112 
    %128 - 255  | horizontal position bpm nr. 0 - 112
    %256 - 383  | intensity Z         bpm nr. 0 - 112
    %384 - 511  | intensity S         bpm nr. 0 - 112
    %512 - 639  | status              bpm nr. 0 - 112
    %640 - 767  | input gain          bpm nr. 0 - 112
    %768 - 895  | rms H               bpm nr. 0 - 112
    %896 -1023  | rms V               bpm nr. 0 - 112
    %------------------------------------------------
    % name:BPMZxDyR    -->    index = [112 + 14*(y-1) + (x-5)]%112
    %      BPMZxTyR    -->    index = [112 + 14*(y-1) + 7 + (x-5)]%112
    %                         e.g., BPMZ4D5R leads to index= 55
    %                               BPMZ4T5R leads to index= 62
    %                               BPMZ1D1R leads to index=108
    %                               BPMZ5D1R leads to index=  0
    
    %Family='BPMx';
    %Field='Monitor';
    %DeviceList=[1 5];
    %global BPMIOCDaten;
    %global BPMIOCcounter;
    
    
    Channelname = getfamilydata(Family, Field, 'CNParam', DeviceList);
    Channelname = 'BPMZ1D1R:rdX ';
    %myreg =   '^(([A-Z]+)(([0-9]+)(-([0-9]+))?)?)((([BCFGHIKLMNOPQRVWYZ])([0-9]*)([BDSTUX][0-9]*)?([BIMRTCGLV])):rd[XY]';
    myreg = '([A-Z]+)([0-9])([TD])([0-9])([A-Z]+)(:rd)([YX])';
    t = regexp(deblank(Channelname),myreg,'tokens')
    BPMcounter     = str2double(t{1,1}{1,2});
    BPMsubdomain   = t{1,1}{1,3};
    BPMsubdomainnr = str2double(t{1,1}{1,4});

   
    Calibrationfactor = 0.2666666e-3;
    
    onlineBPMIOCcounter  = getpvonline('MDIZ2T5G:count');
    if (onlineBPMIOCcounter == BPMIOCcounter)
    else
        BPMIOCDaten    = getpvonline('MDIZ2T5G:bdata');
        BPMIOCcounter  = onlineBPMIOCcounter;
    end;
    
    if (strcmp(BPMsubdomain,'D'))
     index = mod((112+ 14*(BPMsubdomainnr-1) + (BPMcounter-5)),112);
    else
     index = mod((112 + 14*(BPMsubdomainnr-1) + 7 + (BPMcounter-5)),112);
     
    end
   
    if(strcmp(Family,'BPMy'))
       index = index+128;
    end
    Pos = BPMIOCDaten(index+1)* Calibrationfactor ;
