function ChannelNames = getname_bts(Family, Field)


if strcmpi(Family, 'BPMx') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BTS_____BPM1_X_AM00'
        'BTS_____BPM2_X_AM00'
        'BTS_____BPM3_X_AM00'
        'BTS_____BPM4_X_AM00'
        'BTS_____BPM5_X_AM00'
        'BTS_____BPM6_X_AM00'
        ];
elseif strcmpi(Family, 'BPMy') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BTS_____BPM1_Y_AM01'
        'BTS_____BPM2_Y_AM01'
        'BTS_____BPM3_Y_AM01'
        'BTS_____BPM4_Y_AM01'
        'BTS_____BPM5_Y_AM01'
        'BTS_____BPM6_Y_AM01'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BTS_____HCM1___AM00'
        'BTS_____HCM2___AM01'
        'BTS_____HCM3___AM02'
        'BTS_____HCM4___AM03'
        'BTS_____HCM5___AM00'
        'BTS_____HCM6___AM01'
        'BTS_____HCM7___AM02'
        'BTS_____HCM8___AM03'
        'BTS_____HCM9___AM00'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'BTS_____HCM1___AC00'
        'BTS_____HCM2___AC01'
        'BTS_____HCM3___AC02'
        'BTS_____HCM4___AC03'
        'BTS_____HCM5___AC00'
        'BTS_____HCM6___AC01'
        'BTS_____HCM7___AC02'
        'BTS_____HCM8___AC03'
        'BTS_____HCM9___AC00'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'On')
    ChannelNames = [
        'BTS_____HCM1___BM01'
        'BTS_____HCM2___BM03'
        'BTS_____HCM3___BM05'
        'BTS_____HCM4___BM07'
        'BTS_____HCM5___BM01'
        'BTS_____HCM6___BM03'
        'BTS_____HCM7___BM05'
        'BTS_____HCM8___BM07'
        'BTS_____HCM9___BM01'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'BTS_____HCM1___BC16'
        'BTS_____HCM2___BC17'
        'BTS_____HCM3___BC18'
        'BTS_____HCM4___BC19'
        'BTS_____HCM5___BC16'
        'BTS_____HCM6___BC17'
        'BTS_____HCM7___BC18'
        'BTS_____HCM8___BC19'
        'BTS_____HCM9___BC16'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Reset')
    ChannelNames = [
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'BTS_____HCM1___BM00'
        'BTS_____HCM2___BM02'
        'BTS_____HCM3___BM04'
        'BTS_____HCM4___BM06'
        'BTS_____HCM5___BM00'
        'BTS_____HCM6___BM02'
        'BTS_____HCM7___BM04'
        'BTS_____HCM8___BM06'
        'BTS_____HCM9___BM00'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BTS_____VCM1___AM00'
        'BTS_____VCM2___AM01'
        'BTS_____VCM3___AM02'
        'BTS_____VCM4___AM03'
        'BTS_____VCM5___AM00'
        'BTS_____VCM6___AM01'
        'BTS_____VCM7___AM02'
        'BTS_____VCM8___AM03'
        'BTS_____VCM9___AM01'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'BTS_____VCM1___AC00'
        'BTS_____VCM2___AC01'
        'BTS_____VCM3___AC02'
        'BTS_____VCM4___AC03'
        'BTS_____VCM5___AC00'
        'BTS_____VCM6___AC01'
        'BTS_____VCM7___AC02'
        'BTS_____VCM8___AC03'
        'BTS_____VCM9___AC01'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'On')
    ChannelNames = [
        'BTS_____VCM1___BM01'
        'BTS_____VCM2___BM03'
        'BTS_____VCM3___BM05'
        'BTS_____VCM4___BM07'
        'BTS_____VCM5___BM01'
        'BTS_____VCM6___BM03'
        'BTS_____VCM7___BM05'
        'BTS_____VCM8___BM07'
        'BTS_____VCM9___BM03'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'BTS_____VCM1___BC20'
        'BTS_____VCM2___BC21'
        'BTS_____VCM3___BC22'
        'BTS_____VCM4___BC23'
        'BTS_____VCM5___BC20'
        'BTS_____VCM6___BC21'
        'BTS_____VCM7___BC22'
        'BTS_____VCM8___BC23'
        'BTS_____VCM9___BC17'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Reset')
    ChannelNames = [
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'BTS_____VCM1___BM00'
        'BTS_____VCM2___BM02'
        'BTS_____VCM3___BM04'
        'BTS_____VCM4___BM06'
        'BTS_____VCM5___BM00'
        'BTS_____VCM6___BM02'
        'BTS_____VCM7___BM04'
        'BTS_____VCM8___BM06'
        'BTS_____VCM9___BM02'
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BTS_____Q1_____AM00'
        'BTS_____Q2,1___AM01'
        'BTS_____Q2,2___AM00'
        'BTS_____Q3,1___AM01'
        'BTS_____Q3,2___AM02'
        'BTS_____Q4_____AM00'
        'BTS_____Q5,1___AM01'
        'BTS_____Q5,2___AM02'
        'BTS_____Q6,1___AM00'
        'BTS_____Q6,2___AM01'
        'BTS_____Q7_____AM02'
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'BTS_____Q1_____AC00'
        'BTS_____Q2,1___AC01'
        'BTS_____Q2,2___AC00'
        'BTS_____Q3,1___AC01'
        'BTS_____Q3,2___AC02'
        'BTS_____Q4_____AC00'
        'BTS_____Q5,1___AC01'
        'BTS_____Q5,2___AC02'
        'BTS_____Q6,1___AC00'
        'BTS_____Q6,2___AC01'
        'BTS_____Q7_____AC02'
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'On')
    ChannelNames = [
        'BTS_____Q1_____BM02'
        'BTS_____Q2,1___BM05'
        'BTS_____Q2,2___BM04'
        'BTS_____Q3,1___BM09'
        'BTS_____Q3,2___BM08'
        'BTS_____Q4_____BM02'
        'BTS_____Q5,1___BM05'
        'BTS_____Q5,2___BM08'
        'BTS_____Q6,1___BM02'
        'BTS_____Q6,2___BM05'
        'BTS_____Q7_____BM08'
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'BTS_____Q1_____BC16'
        'BTS_____Q2,1___BC18'
        'BTS_____Q2,2___BC23'
        'BTS_____Q3,1___BC22'
        'BTS_____Q3,2___BC20'
        'BTS_____Q4_____BC16'
        'BTS_____Q5,1___BC18'
        'BTS_____Q5,2___BC20'
        'BTS_____Q6,1___BC16'
        'BTS_____Q6,2___BC18'
        'BTS_____Q7_____BC20'
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'Reset')
    ChannelNames = [
        'BTS_____Q1___R_BC17'
        'BTS_____Q2,1_R_BC19'
        'BTS_____Q3,2_R_BC21'
        'BTS_____Q4___R_BC17'
        'BTS_____Q5,1_R_BC19'
        'BTS_____Q5,2_R_BC21'
        'BTS_____Q6,1_R_BC17'
        'BTS_____Q6,2_R_BC19'
        'BTS_____Q7___R_BC21'
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'BTS_____Q1_____BM01'
        'BTS_____Q2,1___BM04'
        'BTS_____Q2,2___BM03'
        'BTS_____Q3,1___BM08'
        'BTS_____Q3,2___BM07'
        'BTS_____Q4_____BM01'
        'BTS_____Q5,1___BM04'
        'BTS_____Q5,2___BM07'
        'BTS_____Q6,1___BM01'
        'BTS_____Q6,2___BM04'
        'BTS_____Q7_____BM07'
        ];


elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BTS_____B1_____AM00'
        'BTS_____B2_____AM00'
        'BTS_____B3_____AM00'
        'BTS_____B4_____AM00'
        ];

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'BTS_____B1_____AC00'
        'BTS_____B2_____AC00'
        'BTS_____B3_____AC00'
        'BTS_____B4_____AC00'
        ];

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'On')
    ChannelNames = [
        'BTS_____B1_____BM18'
        'BTS_____B2_____BM18'
        'BTS_____B3_____BM18'
        'BTS_____B4_____BM18'
        ];

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'BTS_____B1_____BC22'
        'BTS_____B2_____BC22'
        'BTS_____B3_____BC22'
        'BTS_____B4_____BC22'
        ];

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Reset')
    ChannelNames = [
        'BTS_____B1___R_BC23'
        'BTS_____B2___R_BC23'
        'BTS_____B3___R_BC23'
        'BTS_____B4___R_BC23'
        ];

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'BTS_____B1_____BM17'
        'BTS_____B2_____BM17'
        'BTS_____B3_____BM17'
        'BTS_____B4_____BM17'
        ];

elseif strcmpi(Family, 'TV') && (strcmpi(Field, 'Setpoint') || strcmpi(Field, 'InControl'))
    ChannelNames = [
        'BTS_____TV1____BC16'
        'BTS_____TV2____BC18'
        'BTS_____TV3____BC18'
        'BTS_____TV4____BC16'
        'BTS_____TV5____BC18'
        'BTS_____TV6____BC20'
        ];

elseif strcmpi(Family, 'TV') && strcmpi(Field, 'Lamp')
    ChannelNames = [
        'BTS_____TV1LIT_BC17'
        'BTS_____TV2LIT_BC19'
        'BTS_____TV3LIT_BC19'
        'BTS_____TV4LIT_BC17'
        'BTS_____TV5LIT_BC19'
        'BTS_____TV6LIT_BC21'
    ];

elseif strcmpi(Family, 'TV') && (strcmpi(Field, 'Monitor') || strcmpi(Field, 'In'))
    ChannelNames = [
        'BTS_____TV1____BM00'
        'BTS_____TV2____BM06'
        'BTS_____TV3____BM06'
        'BTS_____TV4____BM00'
        'BTS_____TV5____BM06'
        'BTS_____TV6____BM00'
    ];

elseif strcmpi(Family, 'TV') && strcmpi(Field, 'Out')
    ChannelNames = [
        'BTS_____TV1____BM01'
        'BTS_____TV2____BM07'
        'BTS_____TV3____BM07'
        'BTS_____TV4____BM01'
        'BTS_____TV5____BM07'
        'BTS_____TV6____BM01'
    ];

else
    ChannelNames = '';
end
