%   LNLS_CALCULA_ACEITANCIAS calcula as aceitancias horizontal e vertical
%   devido a camara de vacuo.
%
%   [EA_x,EA_y,R,err] = LNLS_CALCULA_ACEITANCIAS(r,Bx,By,vacc) com vacc do
%   tipo string usa o perfil de c�mara de vacuo cujo arquivo (caminho e
%   nome) � vacc; com vacc = [Vx Vy], considera um perfil de c�mara de
%   v�cuo constante com valores de meia abertura horizontal e vertical
%   iguais a Vx e Vy, respectivamente; com vacc vazio, abre uma interface
%   para sele��o de um arquivo; com vacc==-1, usa os valores de perfil de
%   c�mara de v�cuo no modelo (VChamber em THERING), sem interpola��o.
%
%   ENTRADA
%       r       posicao [m]
%       Bx      funcao betatron horizontal [m]
%       By      funcao betatron vertical [m]
%       vacc    nome do arquivo .txt com o perfil da c�mara de v�cuo ou
%               valores m�dios de meia abertura [Vx Vy] ou -1 para valores
%               fornecidos no modelo (VChamber em THERING) [m]
%   SA�DA
%       EA_x    aceitancia horizontal [mm mrad]
%       EA_y    aceitancia vertical [mm mrad]
%       R       razao entre os angulos maximos de espalhamento vertical e
%               horizontal
%       err     verdadeiro se ocorreu erro

function [EA_x,EA_y,theta_x,theta_y,err] = lnls_calcula_aceitancias(the_ring,r,Bx,By,vacc)

err = false;

idx_fim = length(r);

% Seleciona o perfil de c�mara de vacuo
if(vacc == -1)
    flag_interp = 0;
    N = length(the_ring);
%     s_V = cumsum(getcellstruct(THERING,'Length',1:N)) - THERING{1}.Length;
    Vx = Inf(N,1);
    Vy = Vx;
    idx = findcells(the_ring,'VChamber');
    if(isempty(idx) || (N~=idx_fim)) %|| (sum(r==s_V)~=N))
        err = true;
        EA_x = 0;
        EA_y = 0;
        R = 0;
        return;
    end
    Vx(idx) = getcellstruct(the_ring,'VChamber',idx,1,1);
    Vy(idx) = getcellstruct(the_ring,'VChamber',idx,1,2);    
elseif(isempty(vacc))
    flag_interp = 1;
    [arquivo,caminho] = uigetfile('*.txt','Select vacuum chamber profile');
    if(~arquivo)
        err = true;
        EA_x = 0;
        EA_y = 0;
        R = 0;
        return;
    end
    nome = fullfile(caminho,arquivo);
elseif(ischar(vacc))
    flag_interp = 1;
    nome = vacc;
elseif(isnumeric(vacc))
    flag_interp = 0;
    Vx = zeros(idx_fim,1) + vacc(1);
    Vy = zeros(idx_fim,1) + vacc(2);
else
    error('No vacuum chamber profile.');
end

% Interpola
if(flag_interp)
    [s_V,Vx1,Vy1] = lnls_importa_perfil_camara(nome);
    
    [s_V,idx] = unique(s_V);
    Vx1 = Vx1(idx);
    Vy1 = Vy1(idx);
    
    % Normaliza a posi��o
    s_V = s_V - s_V(1);
    s_V = s_V / s_V(length(s_V)) * r(idx_fim);
    
    Vx = interp1(s_V,Vx1,r,'linear');
    Vy = interp1(s_V,Vy1,r,'linear');
end

% Calcula aceit�ncias com os valores de beta no in�cio e final do elemento
Bx2   = [Bx(2:idx_fim);Bx(1)]; % desloca beta x
EA_x1 = 1e6*Vx.^2 ./ Bx;
EA_x2 = 1e6*Vx.^2 ./ Bx2;
EA_x  = min([EA_x1;EA_x2]);
By2   = [By(2:idx_fim);By(1)]; % desloca beta y
EA_y1 = 1e6*Vy.^2 ./ By;
EA_y2 = 1e6*Vy.^2 ./ By2;
EA_y  = min([EA_y1;EA_y2]);

% Calcula R
%d = r(idx_fim) - r(1);
%Bx_media = trapz(r,Bx) / d;
%By_media = trapz(r,By) / d;
%theta_x = sqrt(EA_x / Bx_media);
%theta_y = sqrt(EA_y / By_media);
theta_x = sqrt(EA_x ./Bx);
theta_y = sqrt(EA_y ./By);
%theta_x = trapz(r,theta_x)/d;
%theta_y = trapz(r,theta_y)/d;
%R = theta_y / theta_x;
