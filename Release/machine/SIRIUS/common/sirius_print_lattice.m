function sirius_print_lattice(machine)

    switch lower(machine)
        case 'si'
            [ring, titulo]=sirius_si_lattice;
            titulo = regexprep(titulo,'_','-');
            tw = calctwiss(ring);
        case 'bo'
            [ring, titulo]=sirius_bo_lattice;
            titulo = regexprep(titulo,'_','-');
            %Calcula parametros de twiss da rede
            tw = calctwiss(ring);
         case 'tb'
            [ring, titulo, Twiss0] = sirius_tb_lattice;
            titulo = regexprep(titulo,'_','-');
            %Calcula parametros de twiss da rede
            twiss = twissline(ring,0.0,Twiss0,1:length(ring)+1,'chrom');
            %Redefine a estrutura de twiss
            tw.pos = cat(1, twiss.SPos);
            beta = cat(1,twiss.beta);
            tw.betax = beta(:,1);
            tw.betay = beta(:,2);
            alpha = cat(1,twiss.alpha);
            tw.alphax = alpha(:,1);
            tw.alphay = alpha(:,2);
            disp = [twiss.Dispersion];
            tw.etax = disp(1,:)';
            tw.etay = disp(3,:)';
        case 'ts'
            [ring, titulo, Twiss0] = sirius_ts_lattice;
            titulo = regexprep(titulo,'_','-');
            %Calcula parametros de twiss da rede
            twiss = twissline(ring,0.0,Twiss0,1:length(ring)+1,'chrom');
            %Redefine a estrutura de twiss
            tw.pos = cat(1,twiss.SPos);
            beta = cat(1,twiss.beta);
            tw.betax = beta(:,1);
            tw.betay = beta(:,2);
            alpha = cat(1,twiss.alpha);
            tw.alphax = alpha(:,1);
            tw.alphay = alpha(:,2);
            disp = [twiss.Dispersion];
            tw.etax = disp(1,:)';
            tw.etay = disp(3,:)';
        otherwise
            fprintf('Maquina nao reconhecida');
            return;
    end

    fprintf('%4s | %15s | %9s | %8s | %8s | %8s | %8s | %8s | %8s\n', ...
        'idx', 'NAME', 'Pos [m]', 'Betax', 'Alphax', 'Etax', 'Betay', 'Alphay', 'Etay');
    for i=1:length(ring)
        fprintf('%04d | %15s | %9.3f | %8.3f | %8.3f | %8.3f | %8.3f | %8.3f | %8.3f\n', ...
            i, ring{i}.FamName, tw.pos(i), tw.betax(i), tw.alphax(i), tw.etax(i), ...
            tw.betay(i), tw.alphay(i), tw.etay(i))
    end
end