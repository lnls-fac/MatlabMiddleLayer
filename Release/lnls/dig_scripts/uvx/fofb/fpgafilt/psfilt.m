function [sys, g] = psfilt(sys)

sys = sys*tf([1 -1],[1 0],-1);
sys = minreal(sys);
g = dcgain(sys);
sys = sys/dcgain(sys);
