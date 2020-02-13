  PROGRAM
  INCLUDE('jcDebug.inc'),ONCE
  !INCLUDE('jcDML.inc'),ONCE
  INCLUDE('jcField.inc'),ONCE
  INCLUDE('jcWhenTask.inc'),ONCE
  !INCLUDE('jcStack.inc'),ONCE
  !INCLUDE('UltimateDebug.inc'),ONCE
  !INCLUDE('jcBase.inc'),)ONCE
  INCLUDE('jcLogExternal.inc'),ONCE

OMIT('***')
 * Created with Clarion 8.0
 * User: Robert Gaudreau
 * Date: 2012-08-11
 * Time: 4:19 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 ***

JCLIBSRCDDEV_COMMENT_AND_LOGFILENAMEDESCRIPTION   EQUATE('Développement jcWhenTask')

              MAP
           INCLUDE('jcLogMap.inc'),ONCE
UpdateQ         PROCEDURE(BYTE WhenTask,ULONG Set,ULONG Area,BOOL State)
UpdateOnlyQ     PROCEDURE(BYTE WhenTask,ULONG Set,ULONG Area,BOOL State)
              END

WTGroup     GROUP
WhenTask      BYTE
Set           ULONG
Area          ULONG
State         BOOL
            END

WT          QUEUE(WTGroup).

Loc:jcDebugManagerHeaderType BYTE(5)

d               CLASS(jcDebugManager)
ShowValues        PROCEDURE(<*BYTE WhenTask>,<*ULONG Set>,<*ULONG Area>,<*BOOL State>)
GetWhenTask       PROCEDURE(*BYTE WhenTask),ASTRING
                END

ud    UltimateDebug
W     jcWhenTaskClass
Log   jcLogManager
Flm   jcFieldManager

!WT jcBase

  CODE
    DO Init
    D.Programme('jcWhenTaskDev')
      w.Init('w')
      DO Setupsan
      DO GettingCurrentCodeAreaSet
      DO SetCodeAreaSet
      !DO TestCodeAreaSet
      !DO TestCodeAreaSet2
      !DO TestWhosCalling
      !DO TestHasToDO
      !DO TestTriggerOffHasToDO
      DO TestTriggerOffHasDone
      !DO TestHasDone
      !DO TestSetState
      !DO ClearingWhenTaskDefinitions
      !DO DeletingWhenTaskDefinitions
    DO EndProgram

Init  ROUTINE
  d.SetClassName('D')
  ManipulateReadDoc(_Read,InputDocFile)
  ManipulateReadInclude('jcWhenTaskDev.clw',_Beginning)
  Log.SetClassName('d')
  Log.SetApplicationName('jcWhenTaskDev')
  Log.SetDateFormat('@d10-')
  Log.SetTimeFormat('@t4.')
  Log.SetFileName('jcWhenTaskDev')
  Log.SetPath('c:\Dev\Log\jcWhenTask')
  Log.SetExtension('Log')
  Log.Init('jcWhenTaskDev',TRUE,JC_LOG_jcLogManager_SetLogFormat)
  !Start the procedure
  d.SetDebugState(jcWTDebugShow:jcWhenTaskClass)                                      !Make Sure the DebugState is ON
  !d.SetDebugState(TRUE)
  d.Init(Log)
  d.SetDebugState(jcWTDebugShow:jcWhenTaskClass)                                      !Make Sure the DebugState is ON
  D.SetRespectingAreaShow(FALSE)
  DO CommentDetail

Setupsan    ROUTINE
  d.ShowHeader('SetupSan ROUTINE',Loc:jcDebugManagerHeaderType)
  d.Routines('Setupsan')
    !w.Setsan(CAS:jcBase,jcWhenTask::WTDef:InitialArea,'CAS:jcBase')
    d.Embed('w.SetsanSet(CAS:jcWhenTask,''CAS:jcWhenTask'')')
      w.SetsanSet(CAS:jcWhenTask,'CAS:jcWhenTask')
    d.Fin()
    d.Embed('w.SetsanSet(CAS:jcBase,''CAS:jcBase'')')
      w.SetsanSet(CAS:jcBase,'CAS:jcBase')
    d.Fin()
    d.Embed('w.SetsanSet(CAS:jcDebug,''CAS:jcDebug'')')
      w.SetsanSet(CAS:jcDebug,'CAS:jcDebug')
    d.Fin()
    d.Embed('w.SetCurrentCodeAreaSet(CAS:jcWhenTask)')
      w.SetCurrentCodeAreaSet(CAS:jcWhenTask)
    d.Fin()
    d.Embed('w.SetsanArea(WT:GetCodeAreaSet,''WT:GetCodeAreaSet'')')
      w.SetsanArea(WT:GetCodeAreaSet,'WT:GetCodeAreaSet')
    d.Fin()
    d.Embed('')
      w.SetsanArea(WT:ClearWhenTask,'WT:ClearWhenTask')
    d.Fin()
    d.Embed('w.SetCurrentCodeAreaSet(CAS:jcBase)')
      w.SetCurrentCodeAreaSet(CAS:jcBase)
    d.Fin()
    w.SetsanArea(WTBase:Assign,'WTBase:Assign')
    w.SetsanArea(WTBase:ClearFields,'WTBase:ClearFields')
    w.SetsanArea(WTBase:AssignTo,'WTBase:AssignTo')
    w.SetCurrentCodeAreaSet(CAS:jcDebug)
    w.SetsanArea(WTDbg:Init,'WTDbg:Init')
    w.SetsanArea(WTDbg:Assign,'WTDbg:Assign')
    w.SetsanArea(WTDbg:Application,'WTDbg:Application')
    w.SetsanArea(WTDbg:Codes,'WTDbg:Codes')
    w.SetsanArea(WTDbg:Comments,'WTDbg:Comments')
    w.SetsanArea(WTDbg:Beeping,'WTDbg:Beeping')
    w.SetsanArea(WTDbg:Documentation,'WTDbg:Documentation')
    w.SetsanArea(WTDbg:Help,'WTDbg:Help')
    w.SetsanArea(WTDbg:Embed,'WTDbg:Embed')
    w.ShowQsan()
  d.Fin()
  ud.DebugQueue(w.Qsan,'List de SAN')

GettingCurrentCodeAreaSet    ROUTINE
  DATA
Loc:CurrentCodeAreaSet        ULONG
Loc:CurrentCodeAreaSetName    ASTRING
Loc:CurrentCodeArea           ULONG
Loc:CurrentCodeAreaName       ASTRING
  CODE
    d.Routines('GettingCurrentCodeAreaSet')
      w.SetCurrentCodeAreaSet(CAS:jcBase)
      d.Embed('Showing Current Code Area Set')
        Loc:CurrentCodeAreaSet = w.GetCurrentCodeAreaSet()
        Loc:CurrentCodeAreaSetName = w.GetsanSet(Loc:CurrentCodeAreaSet)
        d.ShowValue('GetCurrentCodeAreaSet',Loc:CurrentCodeAreaSet)
        d.ShowValue('CurrentCodeAreaSet',Loc:CurrentCodeAreaSetName)
      d.Fin()
      w.SetCurrentCodeArea(WTBase:AssignTo)
      d.Embed('Showing Current Code Area')
        Loc:CurrentCodeArea = w.GetCurrentCodeArea()
        Loc:CurrentCodeAreaName = w.GetsanArea(Loc:CurrentCodeArea)
        d.ShowValue('GetCurrentCodeArea',Loc:CurrentCodeArea)
        d.ShowValue('CurrentCodeArea',Loc:CurrentCodeAreaName)
      d.Fin()
    d.Fin()
    
EndProgram    ROUTINE
  d.ShowHeader('EndProgram ROUTINE',Loc:jcDebugManagerHeaderType)
    w.ShowQsan()
    w.ShowQwt()
  d.Fin()
  ManipulateReadInclude('jcWhenTaskDev.clw',_End)
  ManipulateReadDoc(_Write,OutputDocFile)  !Quand le premier paramètre de ManipulateReadDoc est à _DoNothing rien est ajouté au OutputDocFile si nous voulons ajouter
  !ManipulateReadDoc(_DoNothing,OutputDocFile)  !Quand le premier paramètre de ManipulateReadDoc est à _DoNothing rien est ajouté au OutputDocFile si nous voulons ajouter
                                            !au OutputDocFile nous devons remplacer le premier paramètre _DoNothing par _Write.
  w.Kill()
  d.Kill()  
  RETURN
  
SetCodeAreaSet    ROUTINE
  d.ShowHeader('SetCodAreaSet ROUTINE',Loc:jcDebugManagerHeaderType)
  D.Routines('SetCodeAreaSet')
    w.SetCodeAreaSet(CAS:jcDebug)
    w.SetCodeAreaSet(CAS:jcBase)
    w.SetCodeAreaSet(CAS:jcWhenTask)
  d.Fin()

TestCodeAreaSet   ROUTINE
  d.ShowHeader('TestCodeAreaSet ROUTINE',Loc:jcDebugManagerHeaderType)
  d.Routines('TestCodeAreaSet')
    d.Codes('w.SetState(FALSE,WTDef:CodeAreaSetDefinition,CAS:jcBase,jcWhenTask::WTDef:InitialArea)')
      w.SetState(FALSE,WTDef:CodeAreaSetDefinition,CAS:jcBase,jcWhenTask::WTDef:InitialArea)
      UpdateQ(WTDef:CodeAreaSetDefinition,CAS:jcBase,WTBase:Add,w.GetCodeAreaSet(CAS:jcBase,jcWhenTask::WTDef:InitialArea))
      ud.DebugQueue(WT,'WhenTask = 1 = WTDef:CodeAreaSetDefinition, Set = CAS:jcBase = 2, Area = WTBase:Add = 62, State = FALSE = 0')
    d.Fin()
    d.Codes('w.SetState(w.GetCodeAreaSet(CAS:jcBase),WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping)')
      w.SetState(w.GetCodeAreaSet(CAS:jcBase),WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping)
      UpdateQ(WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping,w.GetCodeAreaSet(CAS:jcDebug,WTDbg:Beeping))
      ud.DebugQueue(WT,'WhenTask = 1 = WTDef:CodeAreasSetDefinition, Set = CAS:jcDebug = 20, Area = WTDbg:Beeping = 116,State = FALSE = 0')
    d.Fin()
    d.Codes('w.SetState(TRUE,WTDef:CodeAreaSetDefinition,CAS:jcBase,jcWhenTask::WTDef:InitialArea)')
      w.SetState(TRUE,WTDef:CodeAreaSetDefinition,CAS:jcBase,jcWhenTask::WTDef:InitialArea)
      UpdateQ(WTDef:CodeAreaSetDefinition,CAS:jcBase,WTBase:Add,w.GetCodeAreaSet(CAS:jcBase,jcWhenTask::WTDef:InitialArea))
      ud.DebugQueue(WT,'WhenTask = 1 = WTDef:CodeAreaSetDefinition, Set = CAS:jcBase = 2, Area = WTBase:Add = 62, State = TRUE = 1')
    d.Fin()
    d.Codes('w.SetState(w.GetCodeAreaSet(CAS:jcBase),WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping)')
      w.SetState(w.GetCodeAreaSet(CAS:jcBase),WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping)
      UpdateQ(WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping,w.GetCodeAreaSet(CAS:jcDebug,WTDbg:Beeping))
      ud.DebugQueue(WT,'WhenTask = 1 = WTDef:CodeAreasSetDefinition, Set = CAS:jcDebug = 20, Area = WTDbg:Beeping = 116,State = TRUE = 1')
    d.Fin()
  d.Fin()

TestCodeAreaSet2   ROUTINE
  d.ShowHeader('TestCodeAreaSet2 ROUTINE',Loc:jcDebugManagerHeaderType)
  d.Routines('TestCodeAreaSet2')
    d.Codes('w.SetState(FALSE,WTDef:CodeAreaSetDefinition,CAS:jcBase,jcWhenTask::WTDef:InitialArea)')
    w.SetState(FALSE,WTDef:CodeAreaSetDefinition,CAS:jcBase,jcWhenTask::WTDef:InitialArea)
    UpdateOnlyQ(WTDef:CodeAreaSetDefinition,CAS:jcBase,WTBase:Add,w.GetCodeAreaSet(CAS:jcBase,jcWhenTask::WTDef:InitialArea))
    ud.DebugQueue(WT,'WhenTask = 1 = WTDef:CodeAreaSetDefinition, Set = CAS:jcBase = 2, Area = WTBase:Add = 62, State = FALSE = 0')
    d.Fin()
    d.Codes('w.SetState(w.GetCodeAreaSet(CAS:jcBase),WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping)')
      w.SetState(w.GetCodeAreaSet(CAS:jcBase),WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping)
      UpdateOnlyQ(WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping,w.GetCodeAreaSet(CAS:jcDebug,WTDbg:Beeping))
      ud.DebugQueue(WT,'WhenTask = 1 = WTDef:CodeAreasSetDefinition, Set = CAS:jcDebug = 20, Area = WTDbg:Beeping = 116,State = FALSE = 0')
    d.Fin()
    d.Codes('w.SetState(TRUE,WTDef:CodeAreaSetDefinition,CAS:jcBase,jcWhenTask::WTDef:InitialArea)')
      w.SetState(TRUE,WTDef:CodeAreaSetDefinition,CAS:jcBase,jcWhenTask::WTDef:InitialArea)
      UpdateOnlyQ(WTDef:CodeAreaSetDefinition,CAS:jcBase,WTBase:Add,w.GetCodeAreaSet(CAS:jcBase,jcWhenTask::WTDef:InitialArea))
      ud.DebugQueue(WT,'WhenTask = 1 = WTDef:CodeAreaSetDefinition, Set = CAS:jcBase = 2, Area = WTBase:Add = 62, State = TRUE = 1')
    d.Fin()
    d.Codes('w.SetState(w.GetCodeAreaSet(CAS:jcBase),WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping)')
      w.SetState(w.GetCodeAreaSet(CAS:jcBase),WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping)
      UpdateOnlyQ(WTDef:CodeAreaSetDefinition,CAS:jcDebug,WTDbg:Beeping,w.GetCodeAreaSet(CAS:jcDebug,WTDbg:Beeping))
      ud.DebugQueue(WT,'WhenTask = 1 = WTDef:CodeAreasSetDefinition, Set = CAS:jcDebug = 20, Area = WTDbg:Beeping = 116,State = TRUE = 1')
    d.Fin()
  d.Fin() 

TestWhosCalling   ROUTINE
  d.ShowHeader('TestWhosCalling ROUTINE',Loc:jcDebugManagerHeaderType)
  d.Routines('TestWhosCalling')
    !d.Codes('w.SetWhosCalling(WTBase:AssignTo,CAS:jcBase,_:Engage)')
      w.SetWhosCalling(WTBase:AssignTo,CAS:jcBase,_:Engage)
     ! ud.DebugQueue(w.Qwt,'WhenTask = 2 = WTDef:WhosCalling, Set = 2 = CAS:jcBase, Area = 70 = WTBase:AssignTo, State = TRUE = 1')
    !d.Fin()
    !GOTO _EndOfTestWhosCalling
    d.Codes('w.SetState(w.GetWhosCalling(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasToDO,CAS:jcDebug,WTDbg:Documentation)')
      d.See('When w.SetCurrentCodeAreaSet(CAS:jcBase)')
      d.See('When w.SetCurrentCodeArea(WTBase:AssignTo)')
      w.SetCurrentCodeAreaSet(CAS:jcBase)
      w.SetCurrentCodeArea(WTBase:AssignTo)
      w.SetState(w.GetWhosCalling(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasToDO,CAS:jcDebug,WTDbg:Documentation)
      ud.DebugQueue(w.Qwt,'WhenTask = 3 = WTDef:HasToDO, Set = 20 = CAS:jcDebg, Area = 69 = Documentation, State = 1 = TRUE')
    d.Fin()
    d.Codes('w.SetState(FALSE,WTDef:WhosCalling,CAS:jcBase,WTBase:AssignTo)')
      w.SetState(FALSE,WTDef:WhosCalling,CAS:jcBase,WTBase:AssignTo)
      ud.DebugQueue(w.Qwt,'WhenTask = 2 = WTDef:WhosCalling, Set = 2 = CAS:jcBase, Area = 70 = WTBase:AssignTo, State = 0 = FALSE')
    d.Fin()
    d.Codes('w.SetState(w.GetWhosCalling(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasToDO,CAS:jcDebug,WTDbg:Documentation)')
      d.See('When w.SetCurrentCodeAreaSet(CAS:jcBase)')
      d.See('When w.SetCurrentCodeArea(WTBase:AssignTo)')
      w.SetCurrentCodeAreaSet(CAS:jcBase)
      w.SetCurrentCodeArea(WTBase:AssignTo)
      w.SetState(w.GetWhosCalling(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasToDO,CAS:jcDebug,WTDbg:Documentation)
      ud.DebugQueue(w.Qwt,'WhenTask = 3 = WTDef:HasToDO, Set = 20 = CAS:jcDebg, Area = 69 = Documentation, State = 0 = FALSE')
    d.Fin()
_EndOfTestWhosCalling
  d.Fin()  
  
TestHasToDO   ROUTINE
  d.ShowHeader('TestHasToDo ROUTINE',Loc:jcDebugManagerHeaderType)
  d.Routines('TestHasToDO')
    d.Codes('w.SetState(TRUE,WTDef:HasToDO,CAS:jcBase,WTBase:AssignTo)')
      w.SetState(TRUE,WTDef:HasToDO,CAS:jcBase,WTBase:AssignTo)
      ud.DebugQueue(w.Qwt,'WhenTask = 3 = WTDef:HasToDO, Set = 2 = CAS:jcBase, Area = 70 = WTBase:AssignTo, State = TRUE = 1')
    d.Fin()
    d.Codes('w.SetState(w.GetHasToDO(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasToDO,CAS:jcDebug,WTDbg:Documentation)')
      d.See('When w.SetCurrentCodeAreaSet(CAS:jcBase)')
      d.See('When w.SetCurrentCodeArea(WTBase:AssignTo)')
      d.See('When w.SetHasToDo(w.GetCurrentCodeArea())')
      w.SetCurrentCodeAreaSet(CAS:jcBase)
      w.SetCurrentCodeArea(WTBase:AssignTo)
      w.SetHasToDo(w.GetCurrentCodeArea())
      !w.SetWhosCalling(w.GetCurrentCodeArea())
      w.SetState(w.GetHasToDO(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasToDO,CAS:jcDebug,WTDbg:Documentation)
      ud.DebugQueue(w.Qwt,'WhenTask = 3 = WTDef:HasToDO, Set = 20 = CAS:jcDebg, Area = 69 = Documentation, State = 1 = TRUE')
    d.Fin()
    d.Codes('w.SetState(FALSE,WTDef:HasToDO,CAS:jcBase,WTBase:AssignTo)')
      w.SetState(FALSE,WTDef:HasToDO,CAS:jcBase,WTBase:AssignTo)
      ud.DebugQueue(w.Qwt,'WhenTask = 3 = WTDef:HasToDO, Set = 2 = CAS:jcBase, Area = 70 = WTBase:AssignTo, State = 0 = FALSE')
    d.Fin()
    d.Codes('w.SetState(w.GetHasToDO(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasToDO,CAS:jcDebug,WTDbg:Documentation)')
      d.See('When w.SetCurrentCodeAreaSet(CAS:jcBase)')
      d.See('When w.SetCurrentCodeArea(WTBase:AssignTo)')
      w.SetCurrentCodeAreaSet(CAS:jcBase)
      w.SetCurrentCodeArea(WTBase:AssignTo)
      w.SetState(w.GetHasToDO(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasToDO,CAS:jcDebug,WTDbg:Documentation)
      ud.DebugQueue(w.Qwt,'WhenTask = 3 = WTDef:HasToDO, Set = 20 = CAS:jcDebg, Area = 69 = Documentation, State = 0 = FALSE')
    d.Fin()
      w.SetCurrentCodeAreaSet(CAS:jcDebug)
      w.SetCurrentCodeArea(WTDbg:Codes)
      w.SetHasToDo(w.GetCurrentCodeArea())
      w.SetTriggerOffHasToDO(TRUE,w.GetCurrentCodeAreaSet(),WTDbg:CheckSpaceMargin)
      w.SetHasToDO(WTDbg:ShowStart)
      w.SetHasDone(WTDbg:ShowStart)    
      !UpdateQ(WTDef:HasToDO,w.GetCurrentCodeAreaSet(),w.GetCurrentCodeArea(),w.GetHasToDo(w.GetCurrentCodeArea()))
      w.SetHasToDO(WTDbg:CheckRestoreDebugState)
      ud.DebugQueue(w.Qwt,RECORDS(w.Qwt))
  d.Fin()
  EXIT
      !UpdateQ(WTDef:HasToDO,w.GetCurrentCodeAreaSet(),WTDbg:CheckRestoreDebugState,w.GetHasToDo(WTDbg:CheckRestoreDebugState))
      !w.SetHasDone(WTDbg:CheckRestoreDebugState,w.GetCurrentCodeAreaSet(),TRUE)
      !UpdateQ(WTDef:HasToDO,w.GetCurrentCodeAreaSet(),WTDbg:CheckRestoreDebugState,w.GetHasToDo(WTDbg:CheckRestoreDebugState))
      w.SetWhosCalling(w.GetCurrentCodeArea())
      !UpdateQ(WTDef:HasDone,w.GetCurrentCodeAreaSet(),w.GetCurrentCodeArea(),w.GetHasDone(w.GetCurrentCodeArea()))
      !ud.DebugQueue(WT)
      ud.DebugQueue(w.Qwt,RECORDS(w.Qwt))
      !w.SetHasDone(WTDbg:CheckRestoreDebugState,w.GetCurrentCodeAreaSet(),FALSE)
      !w.SetHasDone(WTDbg:CheckRestoreDebugState,w.GetCurrentCodeAreaSet())
      UpdateQ(WTDef:HasToDO,w.GetCurrentCodeAreaSet(),WTDbg:CheckRestoreDebugState,w.GetHasToDo(WTDbg:CheckRestoreDebugState))
      ud.DebugQueue(w.Qwt,RECORDS(w.Qwt))
      ud.DebugQueue(WT,RECORDS(WT))
      w.SetCurrentCodeAreaSet(CAS:jcDML)
      !w.SetCurrentCodeArea(WTDML:AutoInc)
      UpdateQ(WTDef:HasToDO,w.GetCurrentCodeAreaSet(),w.GetCurrentCodeArea(),w.GetHasToDo(w.GetCurrentCodeArea()))
     
      w.SetWhosCalling(w.GetCurrentCodeArea())
   
      w.SetCurrentCodeAreaSet(CAS:jcWhenTask)
      w.SetHasToDo(WT:GetWhosCalling)
      w.SetHasDone(WT:SetHasDone)
      w.SetWhosCalling(w.GetCurrentCodeArea())
      w.SetCurrentCodeArea(WTDbg:Assign)
      ud.DebugQueue(w.Qwt, 'Avant dernier Visuel ' & RECORDS(w.Qwt) )
      w.SetCurrentCodeAreaSet(CAS:jcBase)
      w.SetCurrentCodeArea(WTBase:Assign)
      w.SetHasToDo(w.GetCurrentCodeArea())
      w.SetHasDone(w.GetCurrentCodeArea())
      w.SetWhosCalling(w.GetCurrentCodeArea())
      ud.DebugQueue(w.Qwt)
    d.Fin()
  
TestTriggerOffHasToDO ROUTINE
  d.ShowHeader('TestTriggerOffHasToDo ROUTINE',Loc:jcDebugManagerHeaderType)
  d.Routines('TestCodeAreaSet')
    d.Codes('w.SetState(TRUE,WTDef:HasDone,CAS:jcBase,WTBase:AssignTo)')
      w.SetState(TRUE,WTDef:HasDone,CAS:jcBase,WTBase:AssignTo)
      ud.DebugQueue(w.Qwt,'WhenTask = 5 = WTDef:HasDone, Set = 2 = CAS:jcBase, Area = 70 = WTBase:AssignTo, State = TRUE = 1')
    d.Fin()
    d.Codes('w.SetHasToDo(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet())')
      w.SetCurrentCodeAreaSet(CAS:jcBase)
      w.SetCurrentCodeArea(WTBase:AssignTo)
      w.SetTriggerOffHasToDO(TRUE)
      w.SetHasToDo(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet())
    d.Fin()
    d.Codes('w.SetHasDone(w.GetCurrentCodeArea())')
      w.SetHasDone(w.GetCurrentCodeArea())
    d.Fin()
    !w.SetWhosCalling(w.GetCurrentCodeArea())
    !w.SetCurrentCodeAreaSet(CAS:Debug)
    d.Codes('w.SetHasToDo(WTDbg:Documentation,CAS:jcDebug,TRUE)')
      w.SetHasToDo(WTDbg:Documentation,CAS:jcDebug,TRUE)
      w.ShowValues(w.Qwt.WhenTask,w.Qwt.Set,w.Qwt.Area,w.Qwt.State)
    d.Fin()
    d.Codes('w.SetHasDone(WTDbg:Documentation,CAS:jcDebug)')
      w.SetHasDone(WTDbg:Documentation,CAS:jcDebug)
      w.ShowValues(w.Qwt.WhenTask,w.Qwt.Set,w.Qwt.Area,w.Qwt.State)
    d.Fin()
    d.Codes('w.SetState(w.GetHasDone(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasDone,CAS:jcDebug,WTDbg:Documentation)')
      w.SetState(w.GetHasDone(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasDone,CAS:jcDebug,WTDbg:Documentation)
      w.ShowValues(w.Qwt.WhenTask,w.Qwt.Set,w.Qwt.Area,w.Qwt.State)
      ud.DebugQueue(w.Qwt,'WhenTask = 5 = WTDef:HasDone, Set = 20 = CAS:jcDebug, Area = 69 = Documentation, State = 1 = TRUE')
    d.Fin()
    d.Codes('w.SetState(FALSE,WTDef:HasDone,CAS:jcBase,WTBase:AssignTo)')
      w.SetState(FALSE,WTDef:HasDone,CAS:jcBase,WTBase:AssignTo)
      ud.DebugQueue(w.Qwt,'WhenTask = 5 = WTDef:HasDone, Set = 2 = CAS:jcBase, Area = 70 = WTBase:AssignTo, State = 0 = FALSE')
    d.Fin()
    d.Codes('w.SetState(w.GetHasDone(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasDone,CAS:jcDebug,WTDbg:Documentation)')
      d.See('When w.SetCurrentCodeAreaSet(CAS:jcBase)')
      d.See('When w.SetCurrentCodeArea(WTBase:AssignTo)')
      w.SetCurrentCodeAreaSet(CAS:jcBase)
      w.SetCurrentCodeArea(WTBase:AssignTo)
      w.SetState(w.GetHasDone(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasDone,CAS:jcDebug,WTDbg:Documentation)
      ud.DebugQueue(w.Qwt,'WhenTask = 5 = WTDef:HasDone, Set = 20 = CAS:jcDebug, Area = 69 = Documentation, State = 0 = FALSE')
    d.Fin()
  d.Fin()

TestTriggerOffHasDone ROUTINE
  d.ShowHeader('TestTriggerOffHasDone ROUTINE',Loc:jcDebugManagerHeaderType)
  d.Routines('TestCodeAreaSet')
    d.Codes('w.SetState(TRUE,WTDef:HasDone,CAS:jcBase,WTBase:AssignTo)')
      w.SetState(TRUE,WTDef:HasToDO,CAS:jcBase,WTBase:AssignTo)
      ud.DebugQueue(w.Qwt,'WhenTask = 4 = WTDef:HasToDO, Set = 2 = CAS:jcBase, Area = 70 = WTBase:AssignTo, State = TRUE = 1')
    d.Fin()
    d.Codes('w.SetHasDone(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet())')
      w.SetCurrentCodeAreaSet(CAS:jcBase)
      w.SetCurrentCodeArea(WTBase:AssignTo)
      w.SetTriggerOffHasDone(TRUE)
      w.SetHasToDO(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet())
  d.Fin()
  d.Fin()
  EXIT
    d.Codes('w.SetHasToDO(w.GetCurrentCodeArea())')
      w.SetHasToDO(w.GetCurrentCodeArea())
    d.Fin()
    !w.SetWhosCalling(w.GetCurrentCodeArea())
    !w.SetCurrentCodeAreaSet(CAS:Debug)
    d.Codes('w.SetHasDone(WTDbg:Documentation,CAS:jcDebug,TRUE)')
      w.SetHasDone(WTDbg:Documentation,CAS:jcDebug,TRUE)
      w.ShowValues(w.Qwt.WhenTask,w.Qwt.Set,w.Qwt.Area,w.Qwt.State)
    d.Fin()
    d.Codes('w.SetHasDone(WTDbg:Documentation,CAS:jcDebug)')
      w.SetHasToDO(WTDbg:Documentation,CAS:jcDebug)
      w.ShowValues(w.Qwt.WhenTask,w.Qwt.Set,w.Qwt.Area,w.Qwt.State)
    d.Fin()
    d.Codes('w.SetState(w.GetHasDone(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasDone,CAS:jcDebug,WTDbg:Documentation)')
      w.SetState(w.GetHasToDO(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasToDO,CAS:jcDebug,WTDbg:Documentation)
      w.ShowValues(w.Qwt.WhenTask,w.Qwt.Set,w.Qwt.Area,w.Qwt.State)
      ud.DebugQueue(w.Qwt,'WhenTask = 4 = WTDef:HasToDO, Set = 20 = CAS:jcDebug, Area = 69 = Documentation, State = 1 = TRUE')
    d.Fin()
    d.Codes('w.SetState(FALSE,WTDef:HasDone,CAS:jcBase,WTBase:AssignTo)')
      w.SetState(FALSE,WTDef:HasToDO,CAS:jcBase,WTBase:AssignTo)
      ud.DebugQueue(w.Qwt,'WhenTask = 4 = WTDef:HasToDO, Set = 2 = CAS:jcBase, Area = 70 = WTBase:AssignTo, State = 0 = FALSE')
    d.Fin()
    d.Codes('w.SetState(w.GetHasDone(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasDone,CAS:jcDebug,WTDbg:Documentation)')
      d.See('When w.SetCurrentCodeAreaSet(CAS:jcBase)')
      d.See('When w.SetCurrentCodeArea(WTBase:AssignTo)')
      w.SetCurrentCodeAreaSet(CAS:jcBase)
      w.SetCurrentCodeArea(WTBase:AssignTo)
      w.SetState(w.GetHasToDO(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasToDO,CAS:jcDebug,WTDbg:Documentation)
      ud.DebugQueue(w.Qwt,'WhenTask = 4 = WTDef:HasToDO, Set = 20 = CAS:jcDebug, Area = 69 = Documentation, State = 0 = FALSE')
    d.Fin()
  d.Fin()
  
  
TestHasDone ROUTINE
  d.ShowHeader('TestHasDone ROUTINE',Loc:jcDebugManagerHeaderType)
  d.Routines('TestHasDone')
    w.SetHasToDo(WTBase:AssignTo)
    w.SetHasDone(WTBase:AssignTo)
    w.ShowQsan()
    w.ShowQwt()
  d.Fin()
  EXIT
    d.Codes('w.SetHasDone(WTBase:AssignTo,CAS:jcBase,w.GetHasDone(WTDbg:Embed,CAS:jcDebug),FALSE)')
      !w.SetState(TRUE,WTDef:HasDone,CAS:jcDebug,WTDbg:Embed)
      w.SetHasToDo(WTDbg:Embed,CAS:jcDebug)
      !w.SetHasDone(WTDbg:Embed,CAS:jcDebug)
      w.SetHasToDO(WTBase:AssignTo,CAS:jcBase)
      w.SetHasDone(WTBase:AssignTo,CAS:jcBase,w.GetHasDone(WTDbg:Embed,CAS:jcDebug),TRUE)
      !ud.DebugQueue(w.Qwt,'WhenTask = 5 = WTDef:HasDone, Set = 2 = CAS:jcBase, Area = 70 = WTBase:AssignTo, State = TRUE = 1')
      !ud.DebugQueue(w.Qwt,'WhenTask = 5 = WTDef:HasDone, Set = 2 = CAS:jcBase, Area = 70 = WTBase:AssignTo, State = FALSE =  0')
    d.Fin()
      w.ShowQsan()
      w.ShowQwt()
    d.Codes('w.SetHasToDo(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet())')
      d.See('When w.SetCurrentCodeAreaSet(CAS:jcDebug)')
      d.See('When w.SetCurrentCodeArea(WTDbg:Init)')
      w.SetCurrentCodeAreaSet(CAS:jcDebug)
      w.SetCurrentCodeArea(WTDbg:Init)
      w.SetHasToDo(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet())
      w.SetHasDone(w.GetCurrentCodeArea())
    d.Fin()
    d.Codes('w.SetHasDone(WTDbg:Documentation,CAS:jcDebug,TRUE)')
      !w.SetWhosCalling(w.GetCurrentCodeArea())
      !w.SetState(w.GetHasDone(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasDone,CAS:jcDebug,WTDbg:Documentation)
      w.SetHasDone(WTDbg:Documentation,CAS:jcDebug,FALSE)
      !ud.DebugQueue(w.Qwt,'WhenTask = 5 = WTDef:HasDone, Set = 20 = CAS:jcDebug, Area = 69 = Documentation, State = 1 = TRUE')
    d.Fin()
    !ud.DebugQueue(w.Qwt,'WhenTask = 5 = WTDef:HasDone, Set = 20 = CAS:jcDebug, Area = 69 = Documentation, State = 1 = TRUE')
    !w.SetState(FALSE,WTDef:HasDone,CAS:jcBase,WTBase:AssignTo)
    w.SetHasDone(WTBase:AssignTo,CAS:jcBase,FALSE)
    !ud.DebugQueue(w.Qwt,'WhenTask = 5 = WTDef:HasDone, Set = 2 = CAS:jcBase, Area = 70 = WTBase:AssignTo, State = 0 = FALSE')
    w.SetCurrentCodeAreaSet(CAS:jcBase)
    w.SetCurrentCodeArea(WTBase:AssignTo)
    !w.SetState(w.GetHasDone(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet()),WTDef:HasDone,CAS:jcDebug,WTDbg:Documentation)
    w.SetHasDone(w.GetCurrentCodeArea(),w.GetCurrentCodeAreaSet(),TRUE)
    !ud.DebugQueue(w.Qwt,'WhenTask = 5 = WTDef:HasDone, Set = 20 = CAS:jcDebg, Area = 69 = Documentation, State = 0 = FALSE')
    w.ShowQsan()
    w.ShowQwt()
  d.Fin()
    
TestSetState  ROUTINE
  d.ShowHeader('TestSetState ROUTINE',Loc:jcDebugManagerHeaderType)
  d.Routines('TestSetState')
    !Test SetState
    d.Codes('w.SetState(FALSE,WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:ClearWhenTask)')
      w.SetState(FALSE,WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:ClearWhenTask)
      ud.DebugQueue(w.Qwt,'Number of records are ' & RECORDS(w.Qwt) & '  Verifying WhenTask = 1 = WTDef:CodeAreaSetDefinition , Set = 1 = CAS:jcWhenTask , Area = 7 = WT:ClearWhenTask, State = 0 ')
    d.Fin()
    d.Codes('w.SetState(w.GetState(WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:ClearWhenTask),WTDef:HasToDO,CAS:jcDebug,WTDbg:Assign)')
      w.SetState(w.GetState(WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:ClearWhenTask),WTDef:HasToDO,CAS:jcDebug,WTDbg:Assign)
      ud.DebugQueue(w.Qwt,'Number of records are ' & RECORDS(w.Qwt) & '  Verifying WhenTask = WTDef:HasToDO = 3, Set = CAS:jcDebug = 20, Area = WTDbg:Assign = 16, State = 0 = FALSE')
    d.Fin()
    d.Codes('w.SetState(TRUE,WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:ClearWhenTask)')
      w.SetState(TRUE,WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:ClearWhenTask)
      ud.DebugQueue(w.Qwt,'Number of records are ' & RECORDS(w.Qwt) & '  Verifying WhenTask = 1 = WTDef:CodeAreaSetDefinition , Set = 1 = CAS:jcWhenTask , Area = 7 = WT:ClearWhenTask, State = 1 = TRUE ')
    d.Fin()
    d.Codes('w.SetState(w.GetState(WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:ClearWhenTask),WTDef:HasToDO,CAS:jcDebug,WTDbg:Assign)')
      w.SetState(w.GetState(WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:ClearWhenTask),WTDef:HasToDO,CAS:jcDebug,WTDbg:Assign)
      ud.DebugQueue(w.Qwt,'Number of records are ' & RECORDS(w.Qwt) & '  Verifying WhenTask = WTDef:HasToDO = 3, Set = CAS:jcDebug = 20, Area = WTDbg:Assign = 16, State = 1 = TRUE')
    d.Fin()
  d.Fin()
  
ClearingWhenTaskDefinitions   ROUTINE    
  d.ShowHeader('ClearingWhenTaskDefinitions ROUTINE',Loc:jcDebugManagerHeaderType)
  d.Routines('ClearingWhenTaskDefinitions')
    DO CountNumberOfRecordsCleared
    w.ShowQwt()
    d.ShowValue('Number of records cleared in Qwt before clearing',c#)
    d.ShowValue('Number of records read in Qwt before clearing',i#)
    d.Codes('ud.DebugQueue(w.Qwt,Avant d''effacer HasDone  & RECORDS(w.Qwt) )')
      ud.DebugQueue(w.Qwt,'Avant d''effacer HasDone ' & RECORDS(w.Qwt) )
      w.ClearHasDone()
      ud.DebugQueue(w.Qwt,'HasDone effacé')
    d.Fin()
    d.Codes('ud.DebugQueue(w.Qwt,Avant d''effacer HasToDO  & RECORDS(w.Qwt) )')
      ud.DebugQueue(w.Qwt,'Avant d''effacer HasToDO ' & RECORDS(w.Qwt) )
      w.ClearHasToDo()
      ud.DebugQueue(w.Qwt,'HasToDO effacé ' & RECORDS(w.Qwt) )
    d.Fin()
    d.Codes('w.ClearWhosCalling()')
      w.ClearWhosCalling()
      ud.DebugQueue(w.Qwt,'WhosCalling effacé ' & RECORDS(w.Qwt) )
    d.Fin()
    DO CountNumberOfRecordsCleared
    d.ShowValue('Number of records read in Qwt after clearing',i#)
    d.ShowValue('Number of records cleared in Qwt after clearing',c#)
    !w.ShowQwt()
  d.Fin()

CountNumberOfRecordsCleared   ROUTINE
  c# = 0
  LOOP i#=1 TO RECORDS(w.Qwt)
    GET(w.Qwt,i#)
    IF w.Qwt.State = FALSE THEN c# += 1.
  END    

DeletingWhenTaskDefinitions ROUTINE    
  d.ShowHeader('DeletingWhenTaskDefinitions ROUTINE',Loc:jcDebugManagerHeaderType)
  d.Routines('DeletingWhenTaskDefinitions')
    d.ShowValue('Number of records in Qwt before deleting',RECORDS(w.Qwt))
    !w.ShowQwt()
    d.Codes('w.DeleteWhenTask(WTDef:HasToDO)')
      d.See('Before')
      w.DeleteWhenTask(WTDef:HasToDO)
      ud.DebugQueue(w.Qwt,'HasToDO supprimé ' & RECORDS(w.Qwt) )
      d.See('After')
    d.Fin()
    d.Codes('w.DeleteWhenTask(WTDef:HasDone)')
      d.See('before')
      w.DeleteWhenTask(WTDef:HasDone)
      ud.DebugQueue(w.Qwt,'HasDone supprimé ' & RECORDS(w.Qwt) )
      d.See('after')
    d.Fin()
    d.Codes('w.DeleteWhenTask(WTDef:WhosCalling)')
      d.See('before')
      w.DeleteWhenTask(WTDef:WhosCalling)
      ud.DebugQueue(w.Qwt,'WhosCalling supprimé ' & RECORDS(w.Qwt) )
      d.See('after')
    d.Fin()
    d.Codes('w.DeleteWhenTask(WTDef:CodeAreaSetDefinition)')
      d.See('before')
      w.DeleteWhenTask(WTDef:CodeAreaSetDefinition)
      ud.DebugQueue(w.Qwt,'Code Area Set supprimé' & RECORDS(w.Qwt) )
      d.See('after')
    d.Fin()
    d.Codes('w.DeleteWhenTask(WTDef:TriggerOffHasToDO)')
      d.See('before')
      w.DeleteWhenTask(WTDef:TriggerOffHasToDO)
      ud.DebugQueue(w.Qwt,'Trigger HasToDO supprimé ' & RECORDS(w.Qwt) )
      d.See('after')
    d.Fin()
    !w.ShowQwt()
    d.ShowValue('Number of records in Qwt after deleting',RECORDS(w.Qwt))
  d.Fin()    

ShowCurrentVariables  ROUTINE
  d.ShowValue('WhenTask',w.Qwt.WhenTask)
  d.ShowValue('Set',w.Qwt.Set)
  d.ShowValue('Area',w.Qwt.Area)
  d.ShowValue('State',w.Qwt.State)

CommentDetail               ROUTINE
  d.Comments(JCLIBSRCDDEV_COMMENT_AND_LOGFILENAMEDESCRIPTION,_Show)
    d.See()
    d.See(d.Log.GetDate() & '@' & d.log.GetTime())! FORMAT(TODAY(),@d10))
!    INCLUDE('C:\Dev\DataMultiLinkDev\LibSrc\LibSrcDev\jcLibSrcDev.inc','CommentDetail')
    d.ShowQRecordRow(Q,Q.String)
    d.See()
  !d.CommentEnd()   
  d.Fin()
  
  
!----------------------------------------------------------------------------------------------------------------------------------------------
! PROCEDURES
!----------------------------------------------------------------------------------------------------------------------------------------------
    
UpdateQ  PROCEDURE(BYTE WhenTask,ULONG Set,ULONG Area,BOOL State)

  CODE
    d.Proc('UpdateQ','(BYTE WhenTask,ULONG Set,ULONG Area,BOOL State)')
      d.ShowValues(WhenTask,Set,Area,State)
      CLEAR(WT)
      SORT(WT,WT.WhenTask,WT.Set,WT.Area,WT.State)
      WT.WhenTask = WhenTask
      WT.Set = Set
      WT.Area = Area
      WT.State = State
      GET(WT,WT.WhenTask,WT.Set,WT.Area,WT.State)
      IF ERROR() THEN
        ADD(WT,WT.WhenTask,WT.Set,WT.Area,WT.State)
      ELSE
        PUT(WT,WT.WhenTask,WT.Set,WT.Area,WT.State)
      END
    d.Fin()
!----------------------------------------------------------------------------------------------------------------------------------------------
UpdateOnlyQ  PROCEDURE(BYTE WhenTask,ULONG Set,ULONG Area,BOOL State)

  CODE
    d.Proc('UpdateOnlyQ','(BYTE WhenTask,ULONG Set,ULONG Area,BOOL State)')
      d.ShowValues(WhenTask,Set,Area,State)
      CLEAR(WT)
      SORT(WT,WT.WhenTask,Wt.Set,WT.Area)
      WT.WhenTask = WhenTask
      WT.Set = Set
      WT.Area = Area
      GET(WT,WT.WhenTask,WT.Set,WT.Area)
      IF ERROR() THEN
        WT:State = State
        ADD(WT,WT.WhenTask,WT.Set,WT.Area,WT.State)
      ELSE
        WT:State = State
        PUT(WT,WT.WhenTask,WT.Set,WT.Area,WT.State)
      END
    d.Fin()

!-------------------------------------------------------------------------------------------------------------------
!                                            d jcDebugManager instance PROCEDURES
!-------------------------------------------------------------------------------------------------------------------
d.ShowValues    PROCEDURE(<*BYTE WhenTask>,<*ULONG Set>,<*ULONG Area>,<*BOOL State>)
  CODE
?   IF NOT OMITTED(2) THEN d.ShowValue('WhenTask',d.GetWhenTask(WhenTask)).
?   IF NOT OMITTED(3) THEN d.ShowValue('Set',Set).
?   IF NOT OMITTED(4) THEN d.ShowValue('Area',Area).
?   IF NOT OMITTED(5) THEN d.ShowValue('State',d.GetBOOL(State,_Active)).

!-------------------------------------------------------------------------------------------------------------------
d.GetWhenTask   PROCEDURE(*BYTE WhenTask)!,!ASTRING
Response            ASTRING

  CODE
    EXECUTE WhenTask
      Response = 'Code Area Set Definition'
      Response = 'Current Code Area Set'
      Response = 'Whos Calling'
      Response = 'Has To DO' 
      Response = 'Trigger Off Has To DO'
      Response = 'Has Done'
    END
    RETURN Response  

  INCLUDE('jcLogReadDoc.clw')
    