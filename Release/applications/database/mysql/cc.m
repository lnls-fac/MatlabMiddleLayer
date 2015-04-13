%CC - Compile script for the mysql.cpp function
%  Some compile instructions available at
%           http://www.mmf.utoronto.ca/resrchres/mysql/
%
%  Briefly, after configuring with "mex -setup", from Matlab:
%    Windows:  mex -I"C:\mysql\include" -DWIN32 mysql.cpp 
%                               "C:\mysql\lib\opt\libmySQL.lib"
%    Linux:    mex -I/usr/include/mysql -L/usr/lib/mysql
%                              -lmysqlclient mysql.cpp
%    where "C:\mysql", "/usr/lib/mysql", "/usr/include/mysql", etc
%    are where you installed the MySQL client libraries.


if ispc
    mex -I'C:\Program Files\MySQL\MySQL Server 5.0\include' -DWIN32 mysql.cpp 'C:\Program Files\MySQL\MySQL Server 5.0\lib\opt\libmySQL.lib'
elseif strcmp(computer, 'GLNX86')
    mex -I/home/als/alsbase/mysql/mysql-standard-5.0.18-linux-i686/include -L/home/als/alsbase/mysql/mysql-standard-5.0.18-linux-i686/lib -lmysqlclient mysql.cpp
elseif strcmp(computer, 'SOL2')
    %mex -I/home/als/alsbase/mysql/mysql-standard-5.0.18-solaris10-sparc/include -L/home/als/alsbase/mysql/mysql-standard-5.0.18-solaris10-sparc/lib -v -llibmysqlclient mysql.cpp
    %mex -I/home/als/alsbase/mysql/mysql-standard-5.0.18-solaris9-sparc-64bit/include -L/home/als/alsbase/mysql/mysql-standard-5.0.18-solaris9-sparc-64bit/lib -llibmysqlclient mysql.cpp
    mex -I/home/als/alsbase/mysql/mysql-standard-5.0.18-solaris9-sparc/include /home/als/alsbase/mysql/mysql-standard-5.0.18-solaris9-sparc/lib/libmysqlclient.a mysql.cpp
end