[THERING,twiss]=readmad('twiss.out');
%    MAD output file: twiss.out
%    MAD file type:           TWISS
%    Symmetry flag:           0
%    Number of superperiods:  1
%    Number of elements :     459
%    Total length = 248.029999 m  
% 
% twiss = 
%     Alpha: [458x2 double]
%      Beta: [458x2 double]
%        Mu: [458x2 double]
%         d: [458x2 double]
%        dp: [458x2 double]
%         a: [458x1 double]
%        Px: [458x1 double]
%         y: [458x1 double]
%        Py: [458x1 double]
%         s: [458x1 double]

[bx, by] = modelbeta;

figure(1);
subplot(2,1,1);
plot(bx, 'b');
title('\beta Function');
ylabel('\beta_x [meters]');
hold on;
plot([NaN; twiss.Beta(:,1)],'r');
hold off;
legend('AT','MAD')

subplot(2,1,2);
plot(by, 'b');
ylabel('\beta_y [meters]');
hold on;
plot([NaN; twiss.Beta(:,2)],'r');
hold off;


figure(2);
subplot(2,1,1)
plot(mux/2/pi)
hold on
plot([NaN; twiss.Mu(:,1)],'r')
ylabel('Phase/(2pi)')
legend('AT','MAD')

subplot(2,1,2)
plot(mux(1:end-1)/2/pi - [NaN; twiss.Mu(:,1);], 'b');
ylabel('Phase Difference')
xlabel('AT Element #')

mux(end)/2/pi- twiss.Mu(end,1)

