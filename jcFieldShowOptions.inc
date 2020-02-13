!_SelectingjcFieldjcDebugShow_ EQUATE(0) !If 0 then _SelectjcFieldEquatesShow_ is used if 1 then _SelectjcFieldVariablesShow_ is used
!_SelectingjcFieldjcDebugShow is set in the project options under compiler symbols
!_SelectingjcFieldjcDebugShow_=>0
         OMIT('***',_SelectingjcFieldjcDebugShow_)
_SelectjcFieldEquatesShow_		EQUATE(0)
_SelectjcFieldVariablesShow_	EQUATE(1)
         ***
         COMPILE('***',_SelectingjcFieldjcDebugShow_)
_SelectjcFieldEquatesShow_		EQUATE(1)
_SelectjcFieldVariablesShow_	EQUATE(0)
         ***
