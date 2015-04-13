%XMLDEMO1 Demonstrate how to create an XML tree and save it
%
%   Description
%   This script demonstrates the use of the xmltree class to
%   create an XML tree from scratch and save it in a file.

%   Copyright (C) 2003  Guillaume Flandin

%   Please note that this script is only a demonstration of how
%   to use xmltree, set, add, view and save methods.
%   Indeed in this example, the use of the struct2xml function
%   would have been much more efficient:
%     entry = struct(...); % cf line 51
%     addressBook = struct('entry',entry);
%     tree = struct2xml(addressBook);

Xmon = getx([1 2;2 1; 3 3],'struct');
Ymon = gety([1 2;2 1; 3 3],'struct');
Xact = getsp('HCM', [1 2;2 1;2 2;4 1],'struct');
Yact = getsp('VCM', [1 2;2 1;2 2;4 1],'struct');
S = getbpmresp(Xmon, Ymon, Xact, Yact);

x = struct2xml(S, 'BPM Response Matrix');
view(x)



% tree = xmltree;
% tree = set(tree, root(tree), 'name', 'BPM Response Matrix');
% 
% % Create a new entry
% tree = add(tree, root(tree), 'comment','This is a xmltree demo for Hiroshi');
% [tree, entry_uid] = add(tree, root(tree), 'element','entry');
% tree = attributes(tree,'add',entry_uid,'lastModified',datestr(datenum(S(1,1).Monitor.TimeStamp),'dd-mmm-yyyy'));
% 
% % Create the 'firstName' tag
% [tree, uid] = add(tree, entry_uid, 'element','xx');
% tree = add(tree, uid, 'chardata', S(1,1));
% 
% % Create the 'lastName' tag
% [tree, uid] = add(tree,entry_uid,'element','lastName');
% tree = add(tree,uid,'chardata',entry.lastName);
% 
% % Create the 'address' tag
% [tree, address_uid] = add(tree,entry_uid,'element','address');
% 
% [tree, uid] = add(tree,address_uid,'element','institute');
% tree = add(tree,uid,'chardata',entry.address.institute);
% 
% [tree, uid] = add(tree,address_uid,'element','street');
% tree = add(tree,uid,'chardata',entry.address.street);
% 
% [tree, uid] = add(tree,address_uid,'element','zipCode');
% tree = add(tree,uid,'chardata',entry.address.zipCode);
% 
% [tree, uid] = add(tree,address_uid,'element','city');
% tree = add(tree,uid,'chardata',entry.address.city);
% 
% [tree, uid] = add(tree,address_uid,'element','country');
% tree = add(tree,uid,'chardata',entry.address.country);
% 
% % Create the 'phone' tag
% [tree, uid] = add(tree,entry_uid,'element','phone');
% tree = add(tree,uid,'chardata',entry.phone);
% 
% 
% % Create the 'email' tag
% [tree, uid] = add(tree,entry_uid,'element','email');
% tree = add(tree,uid,'chardata',entry.email);
% 
% 
% % Graphical display and save
% view(tree);
% 
% 
% save(tree,'example.xml');
% disp(['Saved in:' fullfile(pwd,'example.xml')]);
% 
