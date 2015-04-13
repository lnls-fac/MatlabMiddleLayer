function [gap phase counter_phase] = lnls1_epu_project_configuration(gapu, gapd, pcsd, pcie)

gap = (gapu + gapd)/2;
phase = (pcsd + pcie)/2;
counter_phase = (pcsd - pcie)/2;