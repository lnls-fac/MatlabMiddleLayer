function lnls1_simulation_mode_injection_500MeV

lnls1_set_id_field('AWG01', 0.0);
lnls1_set_id_field('AWG09', 0.2);
lnls1_set_id_field('AON11', 0.0);
lnls1_set_id_field('AWS07', 0.0);

setpv('QD',      'Physics',  -2.966760294677084);
setpv('A2QD07',  'Physics',  -2.967524313348996);
setpv('QF',      'Physics',   2.770024386714366);
setpv('A2QF07',  'Physics',   2.770462765879043);
setpv('QFC',     'Physics',   1.960547029161874);
setpv('SD',      'Physics', -39.860455880296364);
setpv('SF',      'Physics', 56.844346161490897);



%{

  ******** AT Lattice Summary ********
   Energy: 			0.49000 [GeV]
   Gamma: 			958.90612 
   Circumference: 		93.19991 [m]
   Revolution time: 		310.88143 [ns] (3.21666 [MHz]) 
   Betatron tune H: 		5.27008 (868.74894 [kHz])
                 V: 		4.16990 (546.50071 [kHz])
   Momentum Compaction Factor: 	0.00830
   Chromaticity H: 		-0.11091
                V: 		-0.16966
   Synchrotron Integral 1: 	0.83946 [m]
                        2: 	2.57492 [m^-1]
                        3: 	0.84199 [m^-2]
                        4: 	0.26947 [m^-1]
                        5: 	0.07799 [m^-1]
                        6: 	0.00000 [m^-1]
   Damping Partition H: 	0.89535
                     V: 	1.00000
                     E: 	2.10465
   Radiation Loss: 		2.08985 [keV]
   Natural Energy Spread: 	0.02340 [%]
   Natural Emittance: 		11.91950 [nm.rad]
   Radiation Damping H: 	162.61204 [ms]
                     V: 	145.59411 [ms]
                     E: 	69.17723 [ms]
   Slip factor : 	-0.00829

   Assuming cavities Voltage: 500.00000 [kV]
                   Frequency: 476.06568 [MHz]
             Harmonic Number: 147.99998
   Overvoltage factor: 239.25180
   Synchronous Phase:  3.13741 [rad] (179.76052 [deg])
   Linear Energy Acceptance:  2.29278 %
   Synchrotron Tune:   0.01412 (45.41898 kHz or 70.82 turns) 
   Bunch Length:       2.03776 [mm]
   ************************************

%}