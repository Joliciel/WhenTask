!_SelectingjcWhenTaskjcDebugShow_ EQUATE(0) !If 0 then _SelectjcWhenTaskEquatesShow_ is used if 1 then _SelectjcWhenTaskVariablesShow_ is used
!_SelectingjcWhenTaskjcDebugShow is set in the project options under compiler symbols
!_SelectingjcWhenTaskjcDebugShow_=>0
         OMIT('***',_SelectingjcWhenTaskjcDebugShow_)
_SelectjcWhenTaskEquatesShow_		EQUATE(0)
_SelectjcWhenTaskVariablesShow_	EQUATE(1)
         ***
         COMPILE('***',_SelectingjcWhenTaskjcDebugShow_)
_SelectjcWhenTaskEquatesShow_		EQUATE(1)
_SelectjcWhenTaskVariablesShow_	EQUATE(0)
         ***
