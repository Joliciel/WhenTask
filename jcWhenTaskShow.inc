!This list of variables that are used for the status of the DebugManager Show of the procedure for each jcWhenTaskClassmethods that are in jcWhenTask.clw
!They are used as a third parameter show for each MethodStart()
! ex. SELF.Debug.MethodStart('Init,,jcDebugShow:jcWhenTaskClass.Init)

         INCLUDE('jcWhenTaskShowOptions.inc'),ONCE
         OMIT('_jcWhenTaskShowVariables_',_SelectjcWhenTaskVariablesShow_)

!jcWhenTaskClass jcWTDebugShow:jcWhenTaskClass
jcDebugShow:jcWhenTaskClass             GROUP,PRE(jcWTDebugShow)
Construct                                 BOOL !PROCEDURE
Destruct                                  BOOL !PROCEDURE
Init                                      BOOL !PROCEDURE(<ASTRING VirtualClassName>) !The VirtualClassName used by jcDebugManager instance in jcWhenClass source file
Kill                                      BOOL !PROCEDURE()                           !The jcWhenTaskClass Kill procedure
SetWhenTask                               BOOL !PROCEDURE(BYTE pWhenTask,ULONG pCodeAreaSet,ULONG pCodeArea,BOOL pCodeAreaState),PRIVATE !Set a single WhenTaskDefinition identifier Code Area Set Area state.
GetWhenTask                               BOOL !PROCEDURE(BYTE pWhenTask,ULONG pCodeAreaSet,<ULONG pCodeArea>),ULONG,PRIVATE !Get a single WhenTaskDefinition identifier Code Area Set Area if it exist or not
GetWhenTaskName                           BOOL !PROCEDURE(*BYTE WhenTask),ASTRING                       !Get the name of one the five WhenTask.<br/>WhenTask 1 is Code Area Set definition<br/>WhenTask 2 is Whos Calling<br/>WhenTask 3 is Has To Do<br/>WhenTask 4 is Trigger Off Has To Do<br/>WhenTask 5 is Has Done
FetchWhenTaskNature                       BOOL !PROCEDURE(ULONG pWhosCalling,BYTE pWhenTask,ULONG pCodeAreaSet,<ULONG pCodeArea>,<BOOL pState>),ULONG,PROC,VIRTUAL  !Fetch for the Nature of WhenTask if its a Set or an Area Nature that we are looking for.<br/>pWhosCalling must be one of the WhenTask procedure equate found in jcWhenTaskWhenTask.equ source file.<br/>Presently it uses WT:SetWhenTask or WT:GetWhenTask as a parameter.<br/>Meaning it will perform a task demand according on the whos call
SetState                                  BOOL !PROCEDURE(BOOL pCodeAreaState,BYTE pWhenTask,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),VIRTUAL   !Set a single WhenTaskDefinition identifier Code Area Set Area state.<br/>The third or forth parameters are optionals, if either one are not passed, CurrentCodeAreaSet or CurrentCodeArea or both are used.
GetState                                  BOOL !PROCEDURE(BYTE pWhenTask,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),BYTE,VIRTUAL   !Get a single WhenTaskDefinition identifier Code Area Set Area state.<br/>If the record is not found or not defined the following equate will be returned "WTDef:AreaNotDefined".<br/>The second and third parameters are optionals, if either one are not passed, CurrentCodeAreaSet or CurrentCodeArea or both are used.
DeleteWhenTask                            BOOL !PROCEDURE(BYTE pWhentTask),VIRTUAL !Delete a single WhenTaskDefinition identifier from the QWhenTask queue
ClearWhenTask                             BOOL !PROCEDURE(BYTE pWhentTask),VIRTUAL  !Clear to 0 a single WhenTaskDefinition identifier from the QWhenTask queue
Setsan                                    BOOL !PROCEDURE(ULONG pSetID,ULONG pAreaID,ASTRING pName)     !Set the name of the Set (CodeAreaSet) or the Area (CodeArea).<br/>When the pAreaID is 0 the Name is reserved for the Set (CodeAreaSet)
Getsan                                    BOOL !PROCEDURE(ULONG pSetID,ULONG pAreaID),ASTRING           !Get the name of the Set (CodeAreaSet) or Area (CodeArea)
SetsanSet                                 BOOL !PROCEDURE(ULONG pSetID,ASTRING pName),VIRTUAL           !Set the name of Set
GetsanSet                                 BOOL !PROCEDURE(ULONG pSetId),ASTRING,VIRTUAL                 !Get the name of the Set
SetsanArea                                BOOL !PROCEDURE(ULONG pAreaID,ASTRING pName),VIRTUAL          !Set the name of Area according to the CurrentSet previously assigned with SetsanCurrentSet
GetsanArea                                BOOL !PROCEDURE(ULONG pAreaId),ASTRING,VIRTUAL                !Get the name of the Area according to the CurrentSet previously assigned With SetsanCurrentSet
SetCodeAreaSet                            BOOL !PROCEDURE(ULONG pCodeAreaSet,<ULONG pCodeArea>),VIRTUAL   ! Set  CodeAreaSet to a particular defined within WhenTaskSet as well as WhenTask ITEMIZEs EQUATEs structures <br/> which they are declared within jcWhenTaskSet.equ file and the xWhenTask.equ where “x” defined the sources of the procedures part. <br/> The xWhenTask.equ represents the list of procedures equates of a program, application or classes. <br/> The first parameter must be passed, it
GetCodeAreaSet                            BOOL !PROCEDURE(ULONG pCodeAreaSet,<ULONG pCodeArea>),BOOL,VIRTUAL ! Get CodeAreaSet to a particular defined within WhenTaskSet as well as WhenTask ITEMIZEs EQUATEs structures <br/> which they are declared within jcWhenTaskSet.equ file and the xWhenTask.equ where “x” defined the sources of the procedures part. <br/> The xWhenTask.equ represents the list of procedures equates of a program, application or classes. <br/> The first parameter must be passed,
SetCurrentWhenTaskDefinition              BOOL !PROCEDURE(BYTE pCurrentWhenTaskDefinition),VIRTUAL ! Set CurrentWhenTaskDefinition to the current When Task Definition where defined by one of the constant equate find in jcWhenTask.equ file.
GetCurrentWhenTaskDefinition              BOOL !PROCEDURE(),BYTE,VIRTUAL                           ! Get CurrentWhenTaskDefinition to the current When Task Definition where defined by one of the constant equate find in jcWhenTask.equ file.
SetCurrentCodeAreaSet                     BOOL !PROCEDURE(ULONG pCodeAreaSet),VIRTUAL ! Set CurrentCodeAreaSet to the current code area set where defined by one of the constant equate find in jcWhenTaskset.equ file.
GetCurrentCodeAreaSet                     BOOL !PROCEDURE(),ULONG,VIRTUAL             ! Get CurrentCodeAreaSet to the current code area set where defined by one of the constant equate find in jcWhenTaskset.equ file.
SetCurrentCodeArea                        BOOL !PROCEDURE(ULONG pCodeArea),VIRTUAL        ! Set CurrentCodeArea to the current code area set where defined by one of the constant equate find in xWhenTaskt.equ file where "x" is the name of the class.
GetCurrentCodeArea                        BOOL !PROCEDURE(),ULONG,VIRTUAL                 ! Get CurrentCodeArea to the current code area set where defined by one of the constant equate find in xWhenTaskset.equ file where "x" is the name of the class.
SetWhosCalling                            BOOL !PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL pState>),VIRTUAL  ! Set  WhosCalling
GetWhosCalling                            BOOL !PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>),BOOL,VIRTUAL           ! Get  WhosCalling
ClearWhosCalling                          BOOL !PROCEDURE(),VIRTUAL                                         ! Clear the Entire WhosCalling
SetHasToDo                                BOOL !PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL HasToDOState>,<BOOL HasDoneState>),VIRTUAL    ! Set  HasToDO
GetHasToDo                                BOOL !PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>),BOOL,VIRTUAL           ! Get  HasToDO
ClearHasToDo                              BOOL !PROCEDURE(),VIRTUAL                       ! Clear the Entire HasToDo property array to FALSE
SetTriggerOffHasToDO                      BOOL !PROCEDURE(BOOL pTriggerOffHasToDO,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),VIRTUAL ! Set  TriggerOffHasToDO. If TriggerOffHasToDO is set to true SetHasDone will SetHasToDO to FALSE.
GetTriggerOffHasToDO                      BOOL !PROCEDURE(<ULONG pCodeAreaSet>,<ULONG pCodeArea>),BOOL,VIRTUAL                 ! Get the state of  TriggerOffHasToDO used by SetHasDone.
SetHasDone                                BOOL !PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL HasDoneState>,<BOOL HasToDOState>),VIRTUAL ! Set  HasDone to a particular defined within WhenTask ITEMIZE EQUATE structure declared.<br/>The forth parameter BOOL HasToDO accept a TRUE or FALSE to activate or deactivate the state of HasToDO.
GetHasDone                                BOOL !PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>),BOOL,VIRTUAL                    ! Get  HasDone to a particular defined within WhenTask ITEMIZE EQUATE structure declared. <br/> HasDone ITEMIZE, PRE (WD) <br/> Set  HasDone to a particular defined within WhenTaskSet as well as WhenTask ITEMIZEs EQUATEs structures
SetTriggerOffHasDone                      BOOL !PROCEDURE(BOOL pTriggerOffHasDone,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),VIRTUAL ! Set  TriggerOffHasDone. If TriggerOffHasDone is set to true SetHasDone will SetHasDone to FALSE.
GetTriggerOffHasDone                      BOOL !PROCEDURE(<ULONG pCodeAreaSet>,<ULONG pCodeArea>),BOOL,VIRTUAL                 ! Get the state of  TriggerOffHasDone used by SetHasDone.
ClearHasDone                              BOOL !PROCEDURE(),VIRTUAL                       ! Clear the Entire HasDone property array to FALSE
ShowValues                                BOOL !PROCEDURE(<BYTE WhenTask>,<ULONG Set>,<ULONG Area>,<BOOL State>) !Show Values to DebugView
ValidateArea                              BOOL !PROCEDURE(BYTE pWhenTask,ULONG pSet,ULONG pArea)     !Validate the AreaID
ValidateSet                               BOOL !PROCEDURE(BYTE pWhenTask,ULONG pSet)                 !Validate SetID according to WhenTask, SetID must be defined within CodeAreaSetDefinition
SetMessageTrigger                         BOOL !PROCEDURE(BOOL pMessageTrigger),VIRTUAL              !Set the MessageTrigger to TRUE or FALSE to turn on or off the message window on error statement.
GetMessageTrigger                         BOOL !PROCEDURE(),BOOL,VIRTUAL                             !Get the MessageTrigger to TRUE or FALSE to turn on or off the message window on error statement.
ShowQsan                                  BOOL !PROCEDURE(<BYTE Type>)                               !Show Qsan queue to DebugView two different ways to look at the queue Qsan
ShowQwt                                   BOOL !PROCEDURE(<BYTE Type>)                               !Show Qwt queue to DebugView two different ways to look at the queue Qwt
ShowWTD                                   BOOL !PROCEDURE()                                          !Show WTD is the list of current WhenTaskDefinition within WhenTask
                                        END
_jcWhenTaskShowVariables_
