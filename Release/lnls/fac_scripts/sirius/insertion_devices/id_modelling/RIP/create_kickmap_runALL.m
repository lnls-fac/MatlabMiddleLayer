function create_kickmap_runALL

close('all');
fclose('all');

fprintf(['CATERETE  begin(' datestr(now) ')  ']);
try
    create_kickmap_CATERETE;
catch
    fprintf('Error!');
end
close('all');
fprintf(['end(' datestr(now) ')\n']);


fprintf(['INGA  begin(' datestr(now) ')  ']);
try
    create_kickmap_INGA;
catch
    fprintf('Error!');
end
close('all');
fprintf(['end(' datestr(now) ')\n']);



fprintf(['ARAUCARIA1  begin(' datestr(now) ')  ']);
try
    create_kickmap_ARAUCARIA1;
catch
    fprintf('Error!');
end
close('all');
fprintf(['end(' datestr(now) ')\n']);


fprintf(['ARAUCARIA2  begin(' datestr(now) ')  ']);
try
    create_kickmap_ARAUCARIA2;
catch
    fprintf('Error!');
end
close('all');
fprintf(['end(' datestr(now) ')\n']);



fprintf(['SCW3T  begin(' datestr(now) ')  ']);
try
    create_kickmap_SCW3T;
catch
    fprintf('Error!');
end
close('all');
fprintf(['end(' datestr(now) ')\n']);



fprintf(['W2T  begin(' datestr(now) ')  ']);
try
    create_kickmap_W2T;
catch
    fprintf('Error!');
end
close('all');
fprintf(['end(' datestr(now) ')\n']);