!_SelectingjcDebugjcDebugShow_ EQUATE(0) !If 0 then _SelectjcDebugEquatesShow_ is used if 1 then _SelectjcDebugVariablesShow_ is used
!_SelectingjcDebugjcDebugShow is set in the project options under compiler symbols
!_SelectingjcDebugjcDebugShow_=>0
         OMIT('***',_SelectingjcDebugjcDebugShow_)
_SelectjcDebugEquatesShow_		EQUATE(0)
_SelectjcDebugVariablesShow_	EQUATE(1)
         ***
         COMPILE('***',_SelectingjcDebugjcDebugShow_)
_SelectjcDebugEquatesShow_		EQUATE(1)
_SelectjcDebugVariablesShow_	EQUATE(0)
         ***
