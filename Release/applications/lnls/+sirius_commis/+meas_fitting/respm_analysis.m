function respm_analysis(respm_medida, rbpm, rcorr, offset, plane, bpm_select, sym)

flag_x = false;
flag_y = false;
n_ch = (size(respm_medida, 2) - 1)/2;
n_cv = size(respm_medida, 2) - n_ch - 1;
n_bpm = size(respm_medida, 1)/2;

if strcmp(plane, 'x')
    flag_x = true;
elseif strcmp(plane, 'y')
    flag_y = true;
end

if flag_y
   rcorr = n_ch + rcorr;
end

figure; 
axes(); 
hold('on'); 
grid('on');
% s_idx = find(rbpm == bpm_select);
% vc = zeros(n_bpm, 1);

% for i=rbpm
%     for j=rcorr
%         vc(find(j==rcorr)) = respm_medida(n_bpm + rbpm(2 + 2 * (j-rcorr(1)):end), j);
%     end
%     vb(i) = rms(vc);
% end

for i=rcorr
    if flag_x
       if sym
          % r_select = bpm_select-(2 + 2 * (i-rcorr(1))); 
          plot(respm_medida(rbpm((1 + 2 * (i-rcorr(1))):end), i), '-o', 'color', [(rcorr(end)-i)/rcorr(end), 0, i/rcorr(end)], 'LineWidth', 1);
          % if rbpm(end) > bpm_select
          %    rbpm = rbpm(rbpm(1):bpm_select);
          % end
          idx = find(rbpm(1 + 2 * (i-rcorr(1)):end) == bpm_select);
          if isempty(idx)
              return
          end
          hold('on')
          grid('on')
          plot(idx, respm_medida(bpm_select, i), '-o', 'color', 'black', 'LineWidth', 5);
          clf('reset');
       else
          plot(rbpm, respm_medida(rbpm, i)+offset*(i - rcorr(1)), '-o', 'color', [(rcorr(end)-i)/rcorr(end), 0, i/rcorr(end)], 'LineWidth', 3); 
          ymax = get(gca, 'ylim');
          plot([bpm_select bpm_select], ymax, 'black', 'LineWidth', 2);
          plot(rbpm, rbpm*0 + offset*(i-rcorr(1)), 'color', [(rcorr(end)-i)/rcorr(end), 0, i/rcorr(end)]);
       end
       
    elseif flag_y
       if sym
          plot(respm_medida(n_bpm + rbpm(2 + 2 * (i-rcorr(1)):end), i) + offset*(i - rcorr(1)), '-o', 'color', [(rcorr(end)-i)/rcorr(end), 0, i/rcorr(end)], 'LineWidth', 1);
          % plot(rbpm, rbpm*0 + offset*(i-rcorr(1)), 'color', [(rcorr(end)-i)/rcorr(end), 0, i/rcorr(end)], 'LineWidth', 1);
          % if rbpm(end) > bpm_select
          %    rbpm = rbpm(rbpm(1):bpm_select);
          % end
          idx = find(rbpm(2 + 2 * (i-rcorr(1)):end) == bpm_select);
          if isempty(idx)
              return
          end
          hold('on')
          grid('on')
          plot(idx, a/b * respm_medida(n_bpm + bpm_select, i) + 0*offset*(i - rcorr(1)), '-o', 'color', 'black', 'LineWidth', 5);
          % title('Response Matrix Column')
          % xlabel('# BPM');
          clf('reset');
       else
          plot(rbpm, respm_medida(n_bpm + rbpm, i)+offset*(i-rcorr(1)), '-o', 'color', [(rcorr(end)-i)/rcorr(end), 0, i/rcorr(end)], 'LineWidth', 3); 
          ymax = get(gca, 'ylim');
          plot([bpm_select bpm_select], ymax, 'black', 'LineWidth', 2);
          plot(rbpm, rbpm*0 + offset*(i-rcorr(1)), 'color', [(rcorr(end)-i)/rcorr(end), 0, i/rcorr(end)], 'LineWidth', 1);
       end
    end
end