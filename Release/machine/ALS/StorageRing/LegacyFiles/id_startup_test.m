function id_startup_test

IDlist = getlist('ID');
EPUZlist = [4 1;11 1;11 2];

for IDnum = 1:size(IDlist,1)
    try
        if IDlist(IDnum)==6
            setid(IDlist(IDnum,:), 37);
            setid(IDlist(IDnum,:), 38);
            %disp('  Not changing ID6 - it is locked out.');
        elseif IDlist(IDnum)==4 | IDlist(IDnum)==11
            setid(IDlist(IDnum,:), 209);
            setid(IDlist(IDnum,:), 210);
            setepu(IDlist(IDnum,:), 5);
            setepu(IDlist(IDnum,:), -5);
            setepu(IDlist(IDnum,:), 0);
        else
            setid(IDlist(IDnum,:), 209);
            setid(IDlist(IDnum,:), 210);
        end
        fprintf('ID [%s] is working.\n', num2str(IDlist(IDnum,:)));
    catch
        if IDlist(IDnum)==6
            setid(IDlist(IDnum,:), 38);
            disp('  Not changing ID6 - it is locked out.');
        elseif IDlist(IDnum)==4 | IDlist(IDnum)==11
            setid(IDlist(IDnum,:), 210);
            setepu(IDlist(IDnum,:), 0);
        else
            setid(IDlist(IDnum,:), 210);
        end
        fprintf('ID [%s] is not moving!\n', num2str(IDlist(IDnum,:)));
    end
end
