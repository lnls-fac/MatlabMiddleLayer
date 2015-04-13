% INSTALLATION
% ------------
% -Windows copy mym.mexw32, zlibwapi.dll, and mym.m to a directory under the matlab path.
% 	 note: libmysql.dll need to be accessible by mYm.
% -Matlab  the source can be compiled using the following command (thanks to Jeffrey Elrich)
%          mex -I[mysql_include_dir] -I[zlib_include_dir] -L[mysql_lib_dir] -L[zlib_lib_dir] -lz -lmysqlclient mym.cpp
%          Note: to compile, the zlib library should be installed on the system (including the headers).
%                for more information, cf. http://www.zlib.net/


%mex -I'C:\Program Files\MySQL\MySQL Server 5.0\include' -IC:\applications\zlib\zlib-1.2.3 -L'C:\Program Files\MySQL\MySQL Server 5.0\lib\opt' -LC:\applications\zlib\zlib-1.2.3 -lz -lmysqlclient mym.cpp


if ispc
    
    mex -I'C:\Program Files\MySQL\MySQL Server 5.0\include' -DWIN32 mym.cpp 'C:\Program Files\MySQL\MySQL Server 5.0\lib\opt\libmySQL.lib'

elseif strcmp(computer, 'GLNX86')

    mex -I/home/als/alsbase/mysql/mysql-standard-5.0.18-linux-i686/include -I/home/als/alsbase/zlib/linux-x86 -L/home/als/alsbase/mysql/mysql-standard-5.0.18-linux-i686/lib -L/home/als/alsbase/zlib/linux-x86 -lz -lmysqlclient mym.cpp
    
elseif strcmp(computer, 'GLNXA64')

    disp('May need zlib and mysql for GLNXA64');
    mex -I/home/als/alsbase/mysql/mysql-standard-5.0.18-linux-i686/include -I/home/als/alsbase/zlib/linux-x86 -L/home/als/alsbase/mysql/mysql-standard-5.0.18-linux-i686/lib -L/home/als/alsbase/zlib/linux-x86 -lz -lmysqlclient mym.cpp

elseif strcmp(computer, 'SOL2')

    %mex -I/home/als/alsbase/mysql/mysql-standard-5.0.18-solaris10-sparc/include -L/home/als/alsbase/mysql/mysql-standard-5.0.18-solaris10-sparc/lib -v -llibmysqlclient mym.cpp
    %mex -I/home/als/alsbase/mysql/mysql-standard-5.0.18-solaris9-sparc-64bit/include -L/home/als/alsbase/mysql/mysql-standard-5.0.18-solaris9-sparc-64bit/lib -v -llibmysqlclient mym.cpp
    mex -I/home/als/alsbase/mysql/mysql-standard-5.0.18-solaris9-sparc/include -I/home/als/alsbase/zlib/solaris-sparc /home/als/alsbase/zlib/solaris-sparc/libz.a /home/als/alsbase/mysql/mysql-standard-5.0.18-solaris9-sparc/lib/libmysqlclient.a mym.cpp

elseif strcmp(computer, 'SOL64')

    mex -I/home/als/alsbase/mysql/mysql-5.0.41-solaris9-sparc-64bit/include -I/home/als/alsbase/zlib/solaris-sparc /home/als/alsbase/zlib/solaris-sparc/libz.a /home/als/alsbase/mysql/mysql-5.0.41-solaris9-sparc-64bit/lib/libmysqlclient.a mym.cpp

end
