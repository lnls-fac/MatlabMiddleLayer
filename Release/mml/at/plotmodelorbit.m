function varargout = plotmodelorbit
%PLOTMODELORBIT - Plot closed orbit distortion

%  Written by Eugene Tan


%[x, y, sx, sy] = modeltwiss('x','All','All');
[varargout{1}, varargout{2}, varargout{3},varargout{4}] = modeltwiss('x', gethbpmfamily, getvbpmfamily, 'Drawlattice');


% h(1,1) = subplot(2,1,1);
% 
% plot(sx, 1000*x,'b');
% a = axis;
% 
% drawlattice((a(4)+a(3))/2, (a(4)-a(3))/15);
% hold on
% plot(sx, 1000*x,'b');
% axis(a);
% 
% title('Closed Orbit');
% ylabel('Horizontal [mm]');
% 
% %plot(sBPMx, 1000*BPMx,'.b');
% hold off
% 
% 
% h(2,1) = subplot(2,1,2);
% 
% plot(sx, 1000*y,'b');
% a = axis;
% 
% drawlattice((a(4)+a(3))/2, (a(4)-a(3))/15);
% hold on
% plot(sx, 1000*y,'b');
% axis(a);
% 
% ylabel('Vertical [mm]');
% xlabel('Position [m]');
% 
% %plot(sBPMy, 1000*BPMy,'.b');
% hold off
% 
% 
% % Link the x-axes
% linkaxes(h, 'x');
% 
% orient tall
% 
% 
% if nargout >= 1
%     varargout{1} = h;
% end
% 
