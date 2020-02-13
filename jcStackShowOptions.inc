!_SelectingjcStackjcDebugShow_ EQUATE(0) !If 0 then _SelectjcStackEquatesShow_ is used if 1 then _SelectjcStackVariablesShow_ is used
!_SelectingjcStackjcDebugShow is set in the project options under compiler symbols
!_SelectingjcStackjcDebugShow_=>0
OMIT('***',_SelectingjcStackjcDebugShow_)
_SelectjcStackEquatesShow_		EQUATE(0)
_SelectjcStackVariablesShow_	EQUATE(1)
***
COMPILE('***',_SelectingjcStackjcDebugShow_)
_SelectjcStackEquatesShow_		EQUATE(1)
_SelectjcStackVariablesShow_	EQUATE(0)
***
