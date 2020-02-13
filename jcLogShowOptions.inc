!_SelectingjcLogjcDebugShow_ EQUATE(0) !If 0 then _SelectjcLogEquatesShow_ is used if 1 then _SelectjcLogVariablesShow_ is used
!_SelectingjcLogjcDebugShow is set in the project options under compiler symbols
!_SelectingjcLogjcDebugShow_=>0
         OMIT('***',_SelectingjcLogjcDebugShow_)
_SelectjcLogEquatesShow_		EQUATE(0)
_SelectjcLogVariablesShow_	EQUATE(1)
         ***
         COMPILE('***',_SelectingjcLogjcDebugShow_)
_SelectjcLogEquatesShow_		EQUATE(1)
_SelectjcLogVariablesShow_	EQUATE(0)
         ***
