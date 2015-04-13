function r = analisa_imagem(image)
% ANALISA_IMAGEM: script que calcula parâmetros do feixe a partir da imagem da camera.
% INPUT:  	image:	matriz com padrão de inrtensidade da imagem
% OUTPUT: 	xc: 	posição horizontal do centróide (em pixel)
%			yc: 	posição vertical do centróide (em pixel)
%			sx2:	segundo momento <x^2> (em pixel^2)
%			sxy:	segundo momento <x*y> (em pixel^2)
%			sy2:	segundo momento <y^2> (em pixel^2)
%			theta:	ângulo da imagem
%			s1:		tamanho principal 1 (horizontal) (em pixel)
%			s2:		tamanho principal 2 (vertical) (em pixel)
%			i0:		intensidade integrada da imagem
%			height:	altura da imagem (em pixel)
%			width:	largura da imagem (em pixel)
%           rms:    valor rms entre imagem e curva ajustada
%           amp:    amplitude da gaussiana fitada.

im = cast(image, 'double');
[height width] = size(im);


% calcula intensidade integrada e centroide da imagem
[xc yc i0] = calc_center(im);

% calcula segundos momentos
[sx2 sxy sy2 amp] = calc_m2m(im,width,height,xc,yc);

% calcula rms
rms = calc_rms(im, width, height, xc, yc, sx2, sxy, sy2, amp);

% calcula angulo de rotacao e dimensões nos eixos principais.
[theta s1 s2] = calc_parameters(sx2, sxy, sy2);

% constroi parâmetros de saída
r.image  = im;
r.width  = width;
r.height = height;
r.i0     = i0;
r.xc     = xc;
r.yc     = yc;
r.sx2    = sx2;
r.sy2    = sy2;
r.sxy    = sxy;
r.theta  = theta;
r.s1     = s1;
r.s2     = s2;
r.rms    = rms;
r.amp    = amp;

function [xc yc i0] = calc_center(im)

% calcula XC
x   = 1:size(im,2);
y   = sum(im,1);
idx =  find(y>=1);
p = polyfit(x(idx),log(y(idx)),2);
sigma=sqrt(-1/(2*p(1))); 
xc=p(2)*sigma^2;

% calcula YC
x   = 1:size(im,1);
y   = sum(im,2)';
idx =  find(y>=1);
p = polyfit(x(idx),log(y(idx)),2);
sigma=sqrt(-1/(2*p(1))); 
yc=p(2)*sigma^2;

% calcula I0
i0 = sum(sum(im));

function [sx2 sxy sy2 amp] = calc_m2m(im,width,height,xc,yc)

sel = find(im > 0.1*sum(sum(im.^2))/numel(im));
[x y] = meshgrid((1:width)-xc, (1:height)-yc);
mij = log(im(sel));
oij = -0.5*x(sel).^2;
pij = -0.5*x(sel).*y(sel);
qij = -0.5*y(sel).^2;
MM = [...
        length(sel)/2 sum(oij) sum(pij) sum(qij); ...
        0 sum(oij.*oij)/2 sum(oij.*pij) sum(oij.*qij); ...
        0 0 sum(pij.*pij)/2 sum(pij.*qij); ...
        0 0 0 sum(qij.*qij)/2 ...
     ];
 MM = MM + MM';
 v = [sum(mij); sum(oij.*mij); sum(pij.*mij); sum(qij.*mij)];
 t = MM \ v;
 M2M = inv([t(2) t(3)/2; t(3)/2 t(4)]);
 amp = exp(t(1));
 sx2 = M2M(1,1);
 sxy = M2M(1,2);
 sy2 = M2M(2,2);

 function rms = calc_rms(im, width, height, xc, yc, sx2, sxy, sy2, amp)

invM = inv([sx2 sxy; sxy sy2]);
[x y] = meshgrid(1:width, 1:height);
x = x - xc;
y = y - yc;
MT = amp * exp(-0.5*(invM(1,1)*x.^2 + (invM(1,2)+invM(2,1))*x.*y + invM(2,2)*y.^2));
ME = im;
rms = sqrt(sum(sum((MT - ME).^2))/(width*height));

function [theta s1 s2] = calc_parameters(sx2, sxy, sy2)

if (sx2 ~= sy2)
    theta = 0.5 * atan(2 * sxy / (sx2 - sy2));
    s1 = sqrt(sx2 * cos(theta)^2 + 2 * sxy * cos(theta) * sin(theta) + sy2 * sin(theta)^2);
    s2 = sqrt(sx2 * sin(theta)^2 - 2 * sxy * cos(theta) * sin(theta) + sy2 * cos(theta)^2);
else
    if (sxy == 0)
        theta = 0;
        s1 = sqrt(sx2);
        s2 = sqrt(sy2);
    elseif (sxy > 0)
        theta = -pi/4;
        s1 = sqrt(0.5*(sx2 + 2*sxy + sy2));
        s2 = sqrt(0.5*(sx2 - 2*sxy + sy2));
    else
        theta = pi/4;
        s1 = sqrt(0.5*(sx2 + 2*sxy + sy2));
        s2 = sqrt(0.5*(sx2 - 2*sxy + sy2));
    end
end








