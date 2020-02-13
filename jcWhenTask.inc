!ABCIncludeFile(Joliciel)
   INCLUDE('jcClassProjectOptions.inc'),ONCE
!
! Joliciel 2012
   OMIT('_EndOfInclude_',_jcWhenTask_)
_jcWhenTask_      EQUATE(1)
  INCLUDE('jcDebug.inc'),ONCE
  INCLUDE('UltimateDebug.inc'),ONCE
  INCLUDE('jcWhenTask.equ'),ONCE
  INCLUDE('jcWhenTaskWhenTask.equ'),ONCE
  INCLUDE('jcWhenTaskSet.equ'),ONCE
  INCLUDE('jcWhenTaskShow.equ'),ONCE


SetAndAreaNameGroup       GROUP       !This will hold the name of the Sets and Areas used.
SetID                       ULONG     !ID coming from one of the EQUATE defined in jcWhenTaskSet.equ
AreaID                      ULONG     !ID coming from one of the EQUATE defined in xWhenTask.equ where "x" is the Set source
Name                        ASTRING   !String Name of the SetID or AreaID, When the AreaID is equal to 0 then the Name is the Set Name
                          END

QSetAndAreaName            QUEUE(SetAndAreaNameGroup),TYPE. !Queue Holder list of Set and with their Areas with their corresponding sets

WhenTaskGroup GROUP         !WhenTask Group structure 
WhenTask        BYTE        !Value from WhenTaskDefinition ITEMIZE EQUATEs
Set             ULONG       !Code Area Set (May be an Application, a Program, a Class as well as its instances or Data Multi Link Set)
Area            ULONG       !Code Area (procedure or entity of a Code Area Set)
State           BOOL        !Code Area State (State of the procedure or entity) holding a TRUE or FALSE value or ON and OFF or ENGAGE or NOT ENGAGE or ACTIVE or INACTIVE
              END

QWhenTask QUEUE(WhenTaskGroup),TYPE. !Queue Holder list of WhenTask
      
  MAP
  END

!--------------------------------------------------------------------------------
!
!Joliciel When Task Class
!
!--------------------------------------------------------------------------------
jcWhenTaskClass   CLASS(),TYPE,MODULE('jcWhenTask.Clw'),LINK('jcWhenTask.Clw',_JCLinkMode_),DLL(_JCDllMode_)
! Properties
WhosCalling         ULONG,PRIVATE !WhosCalling is used internally to the WhenTask, applying the concept of WhenTask on areas of the class.<br/>The identifier values that are assigned are coming from the WhenTask ITEMIZE EQUATEs list<br/>with the prefix WT. The list is in the source file jcWhenTaskWhenTask.equ.
CurrentWhenTaskDefinition BYTE,PRIVATE !CurrentWhenTaskDefinition is holding the current identifier value important to know throughout the WhenTask time.
CurrentCodeAreaSet  ULONG,PRIVATE !CurrentCodeAreaSet as the name says it establish the current code area set that is used by the WhenTask concept<br/> for WhosCalling, HasToDO and HasDone
CurrentCodeArea     ULONG,PRIVATE !CurrentCodeArea as the name says it establish the current code area that is used by the WhenTask concept<br/> for WhosCalling, HasToDO and HasDone
MessageTrigger      BOOL,PRIVATE !MessageTrigger used to turn ON or OFF the Message Window on error statement.
Qsan                &QSetAndAreaName !Reference to the QSetAndAreaName queue
Qwt                 &QWhenTask    !Reference to the QWhenTask queue
! The definitions
Construct           PROCEDURE
Destruct            PROCEDURE 
Init                PROCEDURE(<ASTRING VirtualClassName>) !The VirtualClassName used by jcDebugManager instance in jcWhenClass source file
Kill                PROCEDURE()                           !The jcWhenTaskClass Kill procedure
SetWhenTask         PROCEDURE(BYTE pWhenTask,ULONG pCodeAreaSet,ULONG pCodeArea,BOOL pCodeAreaState),PRIVATE !Set a single WhenTaskDefinition identifier Code Area Set Area state.
GetWhenTask         PROCEDURE(BYTE pWhenTask,ULONG pCodeAreaSet,<ULONG pCodeArea>),ULONG,PRIVATE !Get a single WhenTaskDefinition identifier Code Area Set Area if it exist or not
GetWhenTaskName     PROCEDURE(*BYTE WhenTask),ASTRING                       !Get the name of one the five WhenTask.<br/>WhenTask 1 is Code Area Set definition<br/>WhenTask 2 is Whos Calling<br/>WhenTask 3 is Has To Do<br/>WhenTask 4 is Trigger Off Has To Do<br/>WhenTask 5 is Has Done
FetchWhenTaskNature PROCEDURE(ULONG pWhosCalling,BYTE pWhenTask,ULONG pCodeAreaSet,<ULONG pCodeArea>,<BOOL pState>),ULONG,PROC,VIRTUAL  !Fetch for the Nature of WhenTask if its a Set or an Area Nature that we are looking for.<br/>pWhosCalling must be one of the WhenTask procedure equate found in jcWhenTaskWhenTask.equ source file.<br/>Presently it uses WT:SetWhenTask or WT:GetWhenTask as a parameter.<br/>Meaning it will perform a task demand according on the whos calling parameter.
SetState            PROCEDURE(BOOL pCodeAreaState,BYTE pWhenTask,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),VIRTUAL   !Set a single WhenTaskDefinition identifier Code Area Set Area state.<br/>The third or forth parameters are optionals, if either one are not passed, CurrentCodeAreaSet or CurrentCodeArea or both are used.					 
GetState            PROCEDURE(BYTE pWhenTask,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),BYTE,VIRTUAL   !Get a single WhenTaskDefinition identifier Code Area Set Area state.<br/>If the record is not found or not defined the following equate will be returned "WTDef:AreaNotDefined".<br/>The second and third parameters are optionals, if either one are not passed, CurrentCodeAreaSet or CurrentCodeArea or both are used.
DeleteWhenTask      PROCEDURE(BYTE pWhentTask),VIRTUAL !Delete a single WhenTaskDefinition identifier from the QWhenTask queue
ClearWhenTask       PROCEDURE(BYTE pWhentTask),VIRTUAL  !Clear to 0 a single WhenTaskDefinition identifier from the QWhenTask queue
Setsan              PROCEDURE(ULONG pSetID,ULONG pAreaID,ASTRING pName)     !Set the name of the Set (CodeAreaSet) or the Area (CodeArea).<br/>When the pAreaID is 0 the Name is reserved for the Set (CodeAreaSet)
Getsan              PROCEDURE(ULONG pSetID,ULONG pAreaID),ASTRING           !Get the name of the Set (CodeAreaSet) or Area (CodeArea)
SetsanSet           PROCEDURE(ULONG pSetID,ASTRING pName),VIRTUAL           !Set the name of Set 
GetsanSet           PROCEDURE(ULONG pSetId),ASTRING,VIRTUAL                 !Get the name of the Set 
SetsanArea          PROCEDURE(ULONG pAreaID,ASTRING pName),VIRTUAL          !Set the name of Area according to the CurrentSet previously assigned with SetsanCurrentSet
GetsanArea          PROCEDURE(ULONG pAreaId),ASTRING,VIRTUAL                !Get the name of the Area according to the CurrentSet previously assigned With SetsanCurrentSet
SetCodeAreaSet      PROCEDURE(ULONG pCodeAreaSet,<ULONG pCodeArea>),VIRTUAL   ! Set  CodeAreaSet to a particular defined within WhenTaskSet as well as WhenTask ITEMIZEs EQUATEs structures <br/> which they are declared within jcWhenTaskSet.equ file and the xWhenTask.equ where “x” defined the sources of the procedures part. <br/> The xWhenTask.equ represents the list of procedures equates of a program, application or classes. <br/> The first parameter must be passed, it must be one of the equates defined in jcWhenTaskSet.equ that represents the CodeAreaSet. <br/> The second parameter, optional, accept an equate find in the xWhenTask.equ file that represents the CodeArea <br/> the procedures of an application, a program or a class or any instances of a class that are defined within the WhenTaskSet ITEMIZE equates in jcWhenTaskSet.equ file.
GetCodeAreaSet      PROCEDURE(ULONG pCodeAreaSet,<ULONG pCodeArea>),BOOL,VIRTUAL ! Get CodeAreaSet to a particular defined within WhenTaskSet as well as WhenTask ITEMIZEs EQUATEs structures <br/> which they are declared within jcWhenTaskSet.equ file and the xWhenTask.equ where “x” defined the sources of the procedures part. <br/> The xWhenTask.equ represents the list of procedures equates of a program, application or classes. <br/> The first parameter must be passed, it must be one of the equates defined in jcWhenTaskSet.equ that represents the CodeAreaSet. <br/> The second parameter, optional, accept an equate find in the xWhenTask.equ file that represents the CodeArea <br/> the procedures of an application, a program or a class or any instances of a class that are defined within the WhenTaskSet ITEMIZE equates in jcWhenTaskSet.equ file.
SetCurrentWhenTaskDefinition   PROCEDURE(BYTE pCurrentWhenTaskDefinition),VIRTUAL ! Set CurrentWhenTaskDefinition to the current When Task Definition where defined by one of the constant equate find in jcWhenTask.equ file.
GetCurrentWhenTaskDefinition   PROCEDURE(),BYTE,VIRTUAL                           ! Get CurrentWhenTaskDefinition to the current When Task Definition where defined by one of the constant equate find in jcWhenTask.equ file.
SetCurrentCodeAreaSet   PROCEDURE(ULONG pCodeAreaSet),VIRTUAL ! Set CurrentCodeAreaSet to the current code area set where defined by one of the constant equate find in jcWhenTaskset.equ file.
GetCurrentCodeAreaSet   PROCEDURE(),ULONG,VIRTUAL             ! Get CurrentCodeAreaSet to the current code area set where defined by one of the constant equate find in jcWhenTaskset.equ file.
SetCurrentCodeArea  PROCEDURE(ULONG pCodeArea),VIRTUAL        ! Set CurrentCodeArea to the current code area set where defined by one of the constant equate find in xWhenTaskt.equ file where "x" is the name of the class.
GetCurrentCodeArea  PROCEDURE(),ULONG,VIRTUAL                 ! Get CurrentCodeArea to the current code area set where defined by one of the constant equate find in xWhenTaskset.equ file where "x" is the name of the class.
SetWhosCalling      PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL pState>),VIRTUAL  ! Set  WhosCalling 
GetWhosCalling      PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>),BOOL,VIRTUAL           ! Get  WhosCalling 
ClearWhosCalling    PROCEDURE(),VIRTUAL                                         ! Clear the Entire WhosCalling 
SetHasToDo          PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL HasToDOState>,<BOOL HasDoneState>),VIRTUAL    ! Set  HasToDO 
GetHasToDo          PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>),BOOL,VIRTUAL           ! Get  HasToDO 
ClearHasToDo        PROCEDURE(),VIRTUAL                       ! Clear the Entire HasToDo property array to FALSE
SetTriggerOffHasToDO  PROCEDURE(BOOL pTriggerOffHasToDO,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),VIRTUAL ! Set  TriggerOffHasToDO. If TriggerOffHasToDO is set to true SetHasDone will SetHasToDO to FALSE.
GetTriggerOffHasToDO  PROCEDURE(<ULONG pCodeAreaSet>,<ULONG pCodeArea>),BOOL,VIRTUAL                 ! Get the state of  TriggerOffHasToDO used by SetHasDone.
SetHasDone          PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL HasDoneState>,<BOOL HasToDOState>),VIRTUAL ! Set  HasDone to a particular defined within WhenTask ITEMIZE EQUATE structure declared.<br/>The forth parameter BOOL HasToDO accept a TRUE or FALSE to activate or deactivate the state of HasToDO.  
GetHasDone          PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>),BOOL,VIRTUAL                    ! Get  HasDone to a particular defined within WhenTask ITEMIZE EQUATE structure declared. <br/> HasDone ITEMIZE, PRE (WD) <br/> Set  HasDone to a particular defined within WhenTaskSet as well as WhenTask ITEMIZEs EQUATEs structures 
SetTriggerOffHasDone  PROCEDURE(BOOL pTriggerOffHasDone,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),VIRTUAL ! Set  TriggerOffHasDone. If TriggerOffHasDone is set to true SetHasDone will SetHasDone to FALSE.
GetTriggerOffHasDone  PROCEDURE(<ULONG pCodeAreaSet>,<ULONG pCodeArea>),BOOL,VIRTUAL                 ! Get the state of  TriggerOffHasDone used by SetHasDone.
ClearHasDone        PROCEDURE(),VIRTUAL                       ! Clear the Entire HasDone property array to FALSE
ShowValues          PROCEDURE(<BYTE WhenTask>,<ULONG Set>,<ULONG Area>,<BOOL State>) !Show Values to DebugView
ValidateArea        PROCEDURE(BYTE pWhenTask,ULONG pSet,ULONG pArea)     !Validate the AreaID
ValidateSet         PROCEDURE(BYTE pWhenTask,ULONG pSet)                 !Validate SetID according to WhenTask, SetID must be defined within CodeAreaSetDefinition
SetMessageTrigger   PROCEDURE(BOOL pMessageTrigger),VIRTUAL              !Set the MessageTrigger to TRUE or FALSE to turn on or off the message window on error statement.
GetMessageTrigger   PROCEDURE(),BOOL,VIRTUAL                             !Get the MessageTrigger to TRUE or FALSE to turn on or off the message window on error statement.
ShowQsan            PROCEDURE(<BYTE Type>)                               !Show Qsan queue to DebugView two different ways to look at the queue Qsan
ShowQwt             PROCEDURE(<BYTE Type>)                               !Show Qwt queue to DebugView two different ways to look at the queue Qwt
ShowWTD             PROCEDURE()                                          !Show WTD is the list of current WhenTaskDefinition within WhenTask

                  END
_EndOfInclude_