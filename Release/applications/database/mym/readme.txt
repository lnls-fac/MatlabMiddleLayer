mYm v1.2 readme.txt
Updated November 22, 2006 by Janus


WHAT IS MYM?
------------
mYm is a Matlab interface to MySQL server. It is based on the original 'MySQL and Matlab' by Robert Almgren and adds the support for Binary Large Object (BLOB). That is, it can insert matlab objects (e.g. array, structure, cell) into BLOB fields, as well retrieve from them. To save space, the matlab objects is first compressed (using zlib) before storing it into a BLOB field. Like Almgren's original, mYm supports multiple connections to MySQL server.

INSTALLATION
------------
-Windows add the path to the files extracted for archive to Matlab path variable. Use "mym" from Matlab.

-Windows[compilation] The source should be compiled with combination of "mex" and microsoft vcc compiler.
	-install visual studio 2003/2005
        -run "mex -setup" from Matlab command line and choose the compiler installed (do not choose LCC).
	-use command
            mex -I[mysql_include_dir] -I[zlib_include_dir] -L[mysql_lib_dir] -L[zlib_lib_dir] -llibmysql -lzlib -lmysqlclient -lzlibwapi mym.cpp 
	to compiler mex-function.
	
-xNix[compilation]  the source can be compiled using the following command (thanks to Jeffrey Elrich)
         mex -I[mysql_include_dir] -I[zlib_include_dir] -L[mysql_lib_dir] -L[zlib_lib_dir] -lz -lmysqlclient mym.cpp
	 (on Mac OS X you might also need the -lSystemStubs switch to avoid namespace clashes)
         Note: to compile, the zlib library should be installed on the system (including the headers).
               for more information, cf. http://www.zlib.net/

HOW TO USE IT
-------------
see mym.m

HISTORY
-------
v1.2    - fixed bug with memory allocation, result now is being returned as a structure 
v1.1    - fixed bug with port number being ignored when specified

v1.0.9	- a space is now used when the variable corresponding to a string placeholder is empty
        - we now use strtod instead of sscanf(s, "%lf")
	- add support for stored procedure
v1.0.8	- corrected a problem occurring with MySQL commands that do not return results
        - the M$ Windows binary now use the correct runtime DLL (MSVC80.DLL insteaLd of MSVC80D.DL)
v1.0.7  - logical values are now correctly considered as numerical value when using placeholder {Si}
        - corrected a bug occuring when closing a connection that was not openned
        - added the possibility to get the next free connection ID when oppening a connection
v1.0.6  - corrected a bug where mym('use', 'a_schema') worked fine while mym(conn, 'use', 'a_schema') did not work
        - corrected a segmentation violation that happened when issuing a MySQL command when not connected
        - corrected the mex command (this file)
        - corrected a bug where it was impossible to open a connection silently
        - use std::max<int>(a, b) instead of max(a, b)
v1.0.5  - added the preamble 'u', permitting to save binary fields without using compression
        - corrected a bug in mym('closeall')
        - corrected various mistakes in the help file (thanks to Jörg Buchholz)
v1.0.4  corrected the behaviour of mYm with time fields, now return a string dump of the field
v1.0.3 	minor corrections
v1.0.2  put mYm under GPL license, official release
v1.0.1  corrected a bug where non-matlab binary objects were not returned
v1.0.0  initial release







