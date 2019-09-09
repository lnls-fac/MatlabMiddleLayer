function CommisData = RunCommis(THERING)
    %%%%% SHIFT THE RING TO BEGIN AT INJECTION SEPTUM %%%%%
    
    THERING = shift_ring(THERING, 'InjSeptF');
    
    %%%%% INITIALIZATION OF RANDOM MACHINE %%%%%%%%
    
    MDInit = SiComm.injection.si.Init(THERING);
    
    %%%%% INJECTION CORRECTION WITH PSO ALGORITHM %%%%%%%%
    
    MDInit.Beam.NPart = 1000;
    MDInit.Inj.NPulses = 1;
    MDInit.Inj.NTurns = 1;
    NumIter = 10;
    MDInjPSO = SiComm.injection.si.InjCorrectionPSO(MDInit, NumIter);
    
    %%%%% INJECTION CORRECTION BASED ON BPM READING %%%%%%%%
    
    MDInjPSO.Beam.NPart = 500;
    MDInjPSO.Inj.NPulses = 1;
    MDInjPSO.Inj.NTurns = 1;
    MDInj = SiComm.injection.si.InjCorrection(MDInjPSO);
    
    %%%%% FIRST TURN CORRECTION WITH TRAJECTORY MATRIX %%%%%%%%
    
    MDInj.Beam.NPart = 500;
    MDInj.Inj.NPulses = 1;
    MDInj.Inj.NTurns = 10;
    NumSingValues = 5;
    TrajMatrix = SiComm.injection.si.CalcTrajMatrix(THERING);
    FirstTurnKicks = SiComm.injection.si.TrajectoryCorrection(MDInj, TrajMatrix, NumSingValues);
    MDFirstTurn = SiComm.injection.si.KickAnalysis(FirstTurnKicks, MDInj);
    
    %%%%% SINGLE PASS BBA %%%%%%%%
    
    MDFirstTurn.Beam.NPart = 1;
    MDFirstTurn.Inj.NPulses = 1;
    MDFirstTurn.Inj.NTurns = 5;
    BBAResults = SiComm.injection.si.BBASinglePass(MDFirstTurn, TrajMatrix);
    MDBBA = SiComm.injection.si.BBAInfo(MDFirstTurn, BBAResults);
    
    %%%%% FIRST TURN CORRECTION AGAIN WITH NEW OFFSETS %%%%%%%
    
    MDBBA.Beam.NPart = 500;
    MDBBA.Inj.NPulses = 1;
    MDBBA.Inj.NTurns = 5;
    NumSingValues = 5;
    FirstTurnKicksBBA = SiComm.injection.si.TrajectoryCorrection(MDBBA, TrajMatrix, NumSingValues);
    MDFirstTurnBBA = SiComm.injection.si.KickAnalysis(FirstTurnKicksBBA, MDBBA);
    
    %%%%%%% COMISSIONING SIMULATION DATA %%%%%%%
    
    CommisData.Injection.PSO = MDInjPSO;
    CommisData.Injection.BPM = MDInj;
    CommisData.FirstTurn.NoBBA = MDFirstTurn;
    CommisData.FirstTurn.WithBBA = MDFirstTurnBBA;
    CommisData.BBAResults = BBAResults;
    CommisData.FirstTurnKicks = FirstTurnKicks;
    CommisData.FirstTurnKicksBBA = FirstTurnKicksBBA;
end

