%% ASDR

planes = {'x','y','ep','en'};
for sym = [5]
lim_ADR = .7:1e-2:1.49;
error_ADR = zeros(length(planes),length(lim_ADR));
for j = 1:length(lim_ADR)
	for i = 1:length(planes)
		pl = planes{i}; aux = [info_07_05(:).(pl)];
		k = 0;
		for ii = 1:length(lattices)
			ind0 = find(aux(ii).adr > lim_ADR(j),1,'first');if isempty(ind0), ind0 = length(aux(ii).x_adr); end;
			aper(ii) = aux(ii).x_adr(ind0);
			if and(~isnan(aux(ii).trc_mean),lattices(ii).symmetry == sym)
				error_ADR(i,j) = error_ADR(i,j) + (aux(ii).trc_mean - aper(ii))^2;
				k = k+1;
			end
		end
		error_ADR(i,j) = error_ADR(i,j)/k/nanmean([aux(:).trc_mean])^2;
	end
end
error_ADR = sqrt(error_ADR);
figure; subplot(1,2,1)
plot(lim_ADR, error_ADR, 'LineWidth', 3);
grid on; legend('x','y','ep','en');
str=sprintf('Relative MSE of ASDR (sym = %d)', sym); title(str)
ylim([0, 0.5])
xlim([.7,1.5])
end

%% Difusion

planes = {'x','y','ep','en'};
for sym = [5]
t = 1:500;
lim_DIF = 1.e-6*10.^(t/100);
error_DIF = zeros(length(planes),length(lim_DIF));
for j = 1:length(lim_DIF)
	for i = 1:length(planes)
		pl = planes{i}; aux = [info_07_05(:).(pl)];
		k = 0;
		for ii = 1:length(lattices)
			ind0 = find(aux(ii).dif > lim_DIF(j),1,'first');if isempty(ind0), ind0 = length(aux(ii).x_dif); end;
			aper(ii) = aux(ii).x_dif(ind0);
			if and(~isnan(aux(ii).trc_mean),lattices(ii).symmetry == sym)
				error_DIF(i,j) = error_DIF(i,j) + (aux(ii).trc_mean - aper(ii))^2;
				k = k+1;
			end
		end
		error_DIF(i,j) = error_DIF(i,j)/k/nanmean([aux(:).trc_mean])^2;
	end
end
error_DIF = sqrt(error_DIF);
subplot(1,2,2);
semilogx(lim_DIF, error_DIF, 'LineWidth', 3);
grid on; legend('x','y','ep','en');
str=sprintf('Relative MSE of Diffusion (sym = %d)', sym); title(str)
ylim([0, 0.5])
end
