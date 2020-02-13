! Joliciel 2012
            MEMBER()    


OMIT('***')
 * Created with Clarion 8.0
 * User: Robert Gaudreau
 * Date: 2012-08-11
 * Time: 12:24 PM
 * 
 * 
 ***
  INCLUDE('jcWhenTask.inc'),ONCE
  INCLUDE('jcDebug.inc'),ONCE
  INCLUDE('jcField.inc'),ONCE

WhnTsk                  CLASS
wt                        &jcWhenTaskClass
CurrentWhenTaskDefinition BYTE,PRIVATE !CurrentWhenTaskDefinition is holding the current identifier value important to know throughout the WhenTask time.
Init                      PROCEDURE()
Showsan                   PROCEDURE(<ULONG Set>,<ULONG Area>,<ASTRING Name>)
Setsan                    PROCEDURE(ULONG pSetID,ULONG pAreaID,ASTRING pName)
Getsan                    PROCEDURE(ULONG pSetID,<ULONG pAreaID>),ASTRING
Kill                      PROCEDURE()
                        END

Dbg:AssertState           BOOL

Loc:GetsanHasToDoState    BOOL(FALSE)

FldMgr          CLASS(jcFieldManager)
wt                &jcWhenTaskClass
Init              PROCEDURE(),VIRTUAL
ShowQueue         PROCEDURE(*QUEUE Q,*GROUP G,ASTRING ClassName)
Kill              PROCEDURE,VIRTUAL
                END


Dbg             CLASS(jcDebugManager)
Margin            SHORT(6)
Method            PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BYTE Show>,<SHORT SpaceMargin>),VIRTUAL   !Set Method it check for margin Set the MethodName and MethodStart
                END

Dbgsan            CLASS(Dbg).

                MAP
                END
  

!----------------------------------------------------------------------------------------------------------------------
!Joliciel WhenTask Class 
!----------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.Construct                            PROCEDURE                           !Construct the beginning of the jcWhenTask class instance
  CODE  
    SELF.Qsan &= NEW QSetAndAreaName
?   ASSERT(~SELF.Qsan &= NULL,'SELF.Qsan not initialized properly to the queue QSetAndAreaName')   
    SELF.Qwt &= NEW QWhenTask
?   ASSERT(~SELF.Qwt &= NULL,'SELF.Qwt not initialized properly to the queue QWhenTask')   
    FREE(SELF.Qsan)
    SORT(SELF.Qsan,SELF.Qsan.SetID,SELF.Qsan.AreaID)
    FREE(SELF.Qwt)   
    SORT(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area)   

!----------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.Destruct                             PROCEDURE                           !Destroy the end of the jcWhenTask class instance
  CODE
    CLEAR(SELF)
    FREE(SELF.Qwt)
    DISPOSE(SELF.Qwt)
    FREE(SELF.Qsan)
    DISPOSE(SELF.Qsan)
    WhnTsk.Kill()
  	FldMgr.Kill()
    Dbg.Kill()
    Dbgsan.Kill()

!----------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.Init  PROCEDURE(<ASTRING VirtualClassName>)

  CODE
    SELF.SetMessageTrigger(jcWhenTask::MessageTrigger) !Meaning when the MESSAGE statement is called it will be validated if it shows up or not.    
    WhnTsk.Init()
    FldMgr.Init()
    DO InitDbg
?   Dbg:AssertState = FALSE
    DO InitCurrentSetArea
?   Dbg:AssertState = FALSE


  
InitDbg   ROUTINE
    IF OMITTED(2) THEN
?     Dbg.SetClassName('jcWhenTaskClass')
    ELSE
?     Dbg.SetClassName(VirtualClassName)
    END
?   Dbgsan.SetClassName(Dbg.GetClassName())      
?   Dbg.Init()
?   Dbgsan.Init()
?   Dbg.SetDebugState(jcWTDebugShow:jcWhenTaskClass)
?   Dbgsan.SetDebugState(Dbg.GetDebugState())
?   Dbg.Embed('ClassName assign to Dbg jcDebugManager instance in jcWhenTaskClass.Init')    
?     Dbg.ShowValue('Class Name',Dbg.GetClassName())
?   Dbg.Fin()  
?   Dbg.SetRespectingAreaShow(jcWhenTask::jcDebugManager:RespectingAreaShow)
?   Dbgsan.Embed('ClassName assign to Dbgsan jcDebugManager instance in jcWhenTaskClass.Init')    
?     Dbg.ShowValue('Class Name',Dbgsan.GetClassName())
?   Dbgsan.Fin()  
?   Dbgsan.SetRespectingAreaShow(jcWhenTask::jcDebugManager:RespectingAreaShow)

InitCurrentSetArea  ROUTINE
? Dbg.Routines('InitCurrentSetArea in jcWhenTaskClass.Init')  
    SELF.Setsan(CAS:jcWhenTask,jcWhenTask::WTDef:InitialArea,'CAS:jcWhenTask')
    SELF.Setsan(CAS:CurrentCodeAreaSet,jcWhenTask::WTDef:InitialArea,'CAS:CurrentCodeAreaSet')
    SELF.Setsan(CAS:CurrentCodeArea,jcWhenTask::WTDef:InitialArea,'CAS:CurrentCodeArea')
    SELF.Setsan(CAS:jcWhenTask,WT:SetCurrentCodeAreaSet,'WT:SetCurrentCodeAreaSet')
    SELF.Setsan(CAS:jcWhenTask,WT:SetCurrentCodeArea,'WT:SetCurrentCodeArea')
    SELF.Setsan(CAS:jcWhenTask,WT:SetWhenTask,'WT:SetWhenTask')
    SELF.Setsan(CAS:jcWhenTask,WT:GetWhenTask,'WT:GetWhenTask')
    SELF.SetState(TRUE,WTDef:CurrentSetArea,CAS:CurrentCodeAreaSet,jcWhenTask::WTDef:InitialArea)
    SELF.SetState(TRUE,WTDef:CurrentSetArea,CAS:CurrentCodeArea,jcWhenTask::WTDef:InitialArea)
    SELF.SetState(TRUE,WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:SetWhenTask)
    SELF.SetState(TRUE,WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:GetWhenTask)
    SELF.SetState(TRUE,WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:SetCurrentCodeAreaSet)
    SELF.SetState(TRUE,WTDef:CodeAreaSetDefinition,CAS:jcWhenTask,WT:SetCurrentCodeArea)
? Dbg.Fin()  
    
!--------------------------------------------------------------------------------------------------------------------_
jcWhenTaskClass.Kill  PROCEDURE()

  CODE
    WhnTsk.Kill()
    FldMgr.Kill()
    Dbg.Kill()
    Dbgsan.Kill()
  
!--------------------------------------------------------------------------------------------------------------------_
jcWhenTaskClass.SetWhenTask       PROCEDURE(BYTE pWhenTask,ULONG pCodeAreaSet,ULONG pCodeArea,BOOL pCodeAreaState)
MethodName                          EQUATE('SetWhenTask')
MethodPrototype                     EQUATE('(BYTE pWhenTask,ULONG pCodeAreaSet,ULONG pCodeArea,BOOL pCodeAreaState),PRIVATE')
WhenTask                            BYTE
Set                                 ULONG
Area                                ULONG
State                               BOOL

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:SetWhenTask)
      WhenTask = pWhenTask
      SELF.SetCurrentWhenTaskDefinition(WhenTask)
      Set = pCodeAreaSet
      Area = pCodeArea
      State = pCodeAreaState
?     SELF.ShowValues(Whentask,Set,Area,State)
      SELF.ValidateSet(WhenTask,Set)
      SELF.ValidateArea(WhenTask,Set,Area)
      SELF.FetchWhenTaskNature(WT:SetWhenTask,WhenTask,Set,Area,State)
?   Dbg.Fin()

!--------------------------------------------------------------------------------------------------------------------_
jcWhenTaskClass.GetWhenTask   PROCEDURE(BYTE pWhenTask,ULONG pCodeAreaSet,<ULONG pCodeArea>)
MethodName                      EQUATE('GetWhenTask')
MethodPrototype                 EQUATE('(BYTE pWhenTask,ULONG pCodeAreaSet,ULONG pCodeArea),ULONG,PRIVATE')
WhenTask                        BYTE
Response                        BOOL

  CODE
!?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask,Dbg.GetNumberSpaceMargin()-2)
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask)
      WhenTask = pWhenTask
      SELF.SetCurrentWhenTaskDefinition(WhenTask)
      IF OMITTED(4) THEN 
        Response = SELF.FetchWhenTaskNature(WT:GetWhenTask,pWhenTask,pCodeAreaSet) 
      ELSE 
        Response = SELF.FetchWhenTaskNature(WT:GetWhenTask,pWhenTask,pCodeAreaSet,pCodeArea)
      END
?     Dbg.ShowValue('Return response value',Response)    
?   Dbg.Fin()
    RETURN Response

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.FetchWhenTaskNature   PROCEDURE(ULONG pWhosCalling,BYTE pWhenTask,ULONG pCodeAreaSet,<ULONG pCodeArea>,<BOOL pState>)!,ULONG,PROC,VIRTUAL  !Fetch for the Nature of WhenTask if its a Set or an Area Nature that we are looking for.<br/>pWhosCalling must be one of the WhenTask procedure equate found in jcWhenTaskWhenTask.equ source file.<br/>Presently it uses WT:SetWhenTask or WT:GetWhenTask as a parameter.<br/>Meaning it will perform a task demand according on the whos calling parameter.
MethodName                              EQUATE('FetchWhenTaskNature')
MethodPrototype                         EQUATE('(ULONG pWhosCalling,BYTE pWhenTask,ULONG pCodeAreaSet,<ULONG pCodeArea>,<BOOL pState>),ULONG,PROC,VIRTUAL')
WhenTaskNature                          BYTE !1 = WhenTask Set, 2 = WhenTask Set Area, 3 = WhenTask Set Area State (Presently WhenTaskNature 3 not used but ready
WhenTaskNature::WhenTaskSet             EQUATE('WhenTask Set')
WhenTaskNature::WhenTaskSetArea         EQUATE('WhenTask Set Area')
WhenTaskNature::WhenTaskSetAreaState    EQUATE('WhenTask Set Area State')
WhosCalling                             ULONG
WhenTask                                BYTE
Set                                     ULONG
Area                                    ULONG
State                                   BOOL
ErrorState                              BOOL
Response                                BOOL

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask)
      DO InitWhenTaskNature
      DO GetWhenTaskNature
      DO SetWhenTaskNature
      DO FetchWhenTaskNature
      DO EndWhenTaskNature
?   Dbg.Fin()

InitWhenTaskNature  ROUTINE
? Dbg.Routines('InitWhenTaskNature')
    WhosCalling = pWhosCalling
    WhenTask = pWhenTask
    Set = pCodeAreaSet
?   Dbg.ShowValue('Whos Calling',WhosCalling)
?   CASE WhosCalling
?     OF WT:SetWhenTask
?       Dbg.ShowValue('WhosCalling','WT:SetWhenTask')
?     OF WT:GetWhenTask
?       Dbg.ShowValue('WhosCalling','WT:GetWhenTask')
?     ELSE
?       Dbg.ShowValue('WhosCalling','NOT FOUND')
?   END
    IF NOT OMITTED(5) THEN Area = pCodeArea.
?   IF NOT OMITTED(5) THEN  
?     SELF.ShowValues(WhenTask,Set,Area)
?   ELSE
?     SELF.ShowValues(WhenTask,Set)
?   END   
    IF NOT OMITTED(6) THEN State = pState.
? Dbg.Fin()
  
GetWhenTaskNature  ROUTINE
? Dbg.Routines('GetWhenTaskNature')
    IF WhenTask = WTDef:CurrentSetArea THEN WhenTaskNature = 1 ELSE WhenTaskNature = 2.
     CASE WhenTask
      OF WTDef:CurrentSetArea
        WhenTaskNature = 1
      ELSE
        WhenTaskNature = 2
    END
   !WhenTaskNature = 3 not used presently      
?   Dbg.ShowValue('WhenTaskNature',WhenTaskNature)  
?   EXECUTE WhenTaskNature
?     Dbg.ShowValue('WhenTaskNature',WhenTaskNature::WhenTaskSet)
?     Dbg.ShowValue('WhenTaskNature',WhenTaskNature::WhenTaskSetArea)
?     Dbg.ShowValue('WhenTaskNature',WhenTaskNature::WhenTaskSetAreaState)   
?   END
? Dbg.Fin()

SetWhenTaskNature  ROUTINE
? Dbg.Routines('SetWhenTaskNature')
    CLEAR(SELF.Qwt)
?   Dbg.Embed('Values at the beginning of SetWhenTaskNature routine after clearing the content of Qwt')
?    Dbg.See('CLEAR(SELF.Qwt) is clearing the value in memory from the queue Qwt')
?   Dbg.Fin()  
    DO PrimeWhenTaskSet
    EXECUTE WhenTaskNature
      BEGIN 
        GET(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set)
        IF ERROR() THEN ErrorState = TRUE ELSE ErrorState = FALSE.
      END
      BEGIN
        SELF.Qwt.Area = Area 
        GET(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area)
        IF ERROR() THEN ErrorState = TRUE ELSE ErrorState = FALSE.
      END
      BEGIN
        SELF.Qwt.Area = Area 
        SELF.Qwt.State = State
        GET(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area,SELF.Qwt.State)
        IF ERROR() THEN ErrorState = TRUE ELSE ErrorState = FALSE.
      END
    END
?   Dbg.Embed('Values at the end of SetWhenTaskNature routine')
      DO ShowValuesWhenTaskNature
?   Dbg.Fin()  
? Dbg.Fin()

PrimeWhenTaskSet ROUTINE
? Dbg.Routines('PrimeWhenTaskSet')  
    SELF.Qwt.WhenTask = WhenTask
    SELF.Qwt.Set = Set
?   SELF.ShowValues(SELF.Qwt.WhenTask,SELF.Qwt.Set)
? Dbg.Fin()
  
FetchWhenTaskNature   ROUTINE
? Dbg.Routines('FetchWhenTaskNature')
?   Dbg.Embed('Values at the beginning of FetchWhenTaskNature routine')
      DO ShowValuesWhenTaskNature
?   Dbg.Fin()  
    CASE WhosCalling
      OF WT:SetWhenTask
        IF ErrorState THEN
          SELF.Qwt.State = State
?         Dbg.See('Adding WhenTask Set Area State')
          EXECUTE WhenTaskNature
            ADD(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set)
            ADD(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area)
            ADD(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area,SELF.Qwt.State)
          END
        ELSE
?         Dbg.See('Updating WhenTask Set Area State')
          SELF.Qwt.State = State
          EXECUTE WhenTaskNature
            BEGIN
              SELF.Qwt.Area =Area
              PUT(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set)
            END
            PUT(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area)
            PUT(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area,SELF.Qwt.State)
          END
        END
      OF WT:GetWhenTask
        IF ErrorState THEN
?         Dbg.See('WhenTask Set Area not defined')
          Response = FALSE
        ELSE
?         Dbg.See('WhenTask Set Area defined')    
          IF WhenTaskNature = 1 THEN
            Response = SELF.Qwt.Area
?           Dbg.ShowValue('Response SELF.Qwt.Area',Response)
          ELSE
            Response = SELF.Qwt.State
?           Dbg.ShowValue('Response SELF.Qwt.State',Response)
          END
        END
    END
?   Dbg.Embed('Values at the end of FetchWhenTaskNature routine')
?       SELF.ShowValues(SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area,SELF.Qwt.State)
?   Dbg.Fin()  
? Dbg.Fin()  

ShowValuesWhenTaskNature  ROUTINE
      EXECUTE WhenTaskNature
?       SELF.ShowValues(SELF.Qwt.WhenTask,SELF.Qwt.Set)
?       SELF.ShowValues(SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area)
?       SELF.ShowValues(SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area,SELF.Qwt.State)
      END
  
EndWhenTaskNature ROUTINE
    CASE WhosCalling
      OF WT:GetWhenTask
?       Dbg.Fin()  
        RETURN Response
    END    
 
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetWhenTaskName   PROCEDURE(*BYTE WhenTask)!,!ASTRING
Response                            ASTRING

  CODE
    EXECUTE WhenTask
      Response = jcWhenTask::Name:CodeAreaSetDefinition
      Response = jcWhenTask::Name:CurrentSetArea
      Response = jcWhenTask::Name:WhosCalling
      Response = jcWhenTask::Name:HasToDO
      Response = jcWhenTask::Name:TriggerOffHasToDO
      Response = jcWhenTask::Name:HasDone
      Response = jcWhenTask::Name:TriggerOffHasDone
    END
    RETURN Response

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.ShowWTD           PROCEDURE()

  CODE
    Dbg.Helper('Show When Task Definition current list')
      Dbg.See('WhenTaskDefinition prefix is "WTDef"')
      Dbg.See('WhenTaskDefinition identifier values are between 1 and 6')
      Dbg.Doc('WhenTaskDefinition list')
        Dbg.ShowValue('1 = WTDef:CodeAreaSetDefinition',jcWhenTask::Name:CodeAreaSetDefinition)
        Dbg.ShowValue('2 = WTDef:CurrentSetArea',jcWhenTask::Name:CurrentSetArea)
        Dbg.ShowValue('3 = WTDef:WhosCalling',jcWhenTask::Name:WhosCalling)
        Dbg.ShowValue('4 = WTDef:HasToDO',jcWhenTask::Name:HasToDO)
        Dbg.ShowValue('5 = WTDef:TriggerOffHasToDO',jcWhenTask::Name:TriggerOffHasToDO)
        Dbg.ShowValue('6 = WTDef:HasDone',jcWhenTask::Name:HasDone)
        Dbg.ShowValue('7 = WTDef:TriggerOffHasDone',jcWhenTask::Name:TriggerOffHasDone)
      Dbg.Fin()
    Dbg.Fin()

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetState         PROCEDURE(BOOL pCodeAreaState,BYTE pWhenTask,<ULONG pCodeAreaSet>,<ULONG pCodeArea>)
MethodName                          EQUATE('SetState')
MethodPrototype                     EQUATE('(BOOL pCodeAreaState,BYTE pWhenTask,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),VIRTUAL')
WhenTask                            BYTE
Set                                 ULONG
Area                                ULONG
State                               BOOL

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:SetState)
      DO InitSetState
      DO CodeAreaState
?   Dbg.Fin()

InitSetState  ROUTINE
? Dbg.Routines('InitSetState')
    WhenTask = pWhenTask
    IF OMITTED(4) THEN 
      Set = SELF.GetCurrentCodeAreaSet() 
      SELF.ValidateSet(WhenTask,Set)
    ELSE 
      Set = pCodeAreaSet
    END
    IF OMITTED(5) THEN 
      Area = SELF.GetCurrentCodeArea() 
      SELF.ValidateArea(WhenTask,Set,Area)
    ELSE 
      Area = pCodeArea
    END
    State = pCodeAreaState
?   SELF.ShowValues(WhenTask,Set,Area,State)
? Dbg.Fin()

CodeAreaState ROUTINE
? Dbg.Routines('CodeAreaState')
?   Dbg.See('Prime the SELF.Qwt')
    CLEAR(SELF.Qwt)
    SELF.Qwt.WhenTask = WhenTask
    SELF.Qwt.Set = Set
    SELF.Qwt.Area = Area 
    GET(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area)
    IF ERROR() THEN TrapError# = TRUE ELSE TrapError# = FALSE.
?   Dbg.See('GET(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area)')
?   Dbg.IFs('ERROR() THEN')
    IF TrapError#
?     Dbg.IFOnFalse()
?       Dbg.See('On ERROR() Adding WhenTask Set Area State')
        SELF.Qwt.State = State
        ADD(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area)
?       Dbg.ShowValue('SELF.Qwt.State',SELF.Qwt.State)
?     Dbg.Fin()
    ELSE
?     Dbg.IFOnTrue()
        SELF.Qwt.State = State
        PUT(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area)
?       Dbg.See('Record is found the value is updating WhenTask Set Area State')
?       Dbg.ShowValue('SELF.Qwt.State',SELF.Qwt.State)
?     Dbg.Fin()
    END
?   Dbg.Fin()
? Dbg.Fin()

  
!--------------------------------------------------------------------------------------------------------------------_
jcWhenTaskClass.GetState         PROCEDURE(BYTE pWhenTask,<ULONG pCodeAreaSet>,<ULONG pCodeArea>)
MethodName                          EQUATE('GetState')
MethodPrototype                     EQUATE('(BYTE pWhenTask,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),BYTE,VIRTUAL')
WhenTask                            BYTE
WhenTaskName                        ASTRING
Set                                 ULONG
SetName                             ASTRING
Area                                ULONG
AreaName                            ASTRING
Response                            BYTE

  CODE
!?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask,Dbg.GetNumberSpaceMargin()-2)
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask)
      DO InitGetState
      DO GetCodeAreaState
?   Dbg.Fin()
      RETURN Response
    
InitGetState ROUTINE
? Dbg.Routines('InitGetState')
    WhenTask = pWhenTask
?   Dbg.IFs('OMITTED(3) THEN <ULONG pCodeAreaSet>')
    IF OMITTED(3) THEN 
?     Dbg.IFOnTrue()
        Set = SELF.GetCurrentCodeAreaSet() 
?       SELF.ShowValues(WhenTask,Set)
        SELF.ValidateSet(WhenTask,Set)
?     Dbg.Fin()
    ELSE 
?     Dbg.IFOnFalse()
        Set = pCodeAreaSet
?       SELF.ShowValues(WhenTask,Set)
?     Dbg.Fin()
    END
?   Dbg.Fin()
?   Dbg.IFs('OMITTED(4) THEN (<ULONG pCodeArea>)')
    IF OMITTED(4) THEN 
?     Dbg.IFOnTrue()
        Area = SELF.GetCurrentCodeArea() 
?       SELF.ShowValues(WhenTask,,Area)
        SELF.ValidateArea(WhenTask,Set,Area)
?     Dbg.Fin()
    ELSE 
?     Dbg.IFOnFalse()
        Area = pCodeArea
?       SELF.ShowValues(WhenTask,Set,Area)
?     Dbg.Fin()
    END
?   Dbg.Fin()
?   DbgState# = Dbg.GetDebugState()    
?   Dbg.SetDebugState(FALSE)
    WhenTaskName = SELF.GetWhenTaskName(WhenTask)
    SetName = SELF.Getsan(Set,jcWhenTask::WTDef:InitialArea)
    AreaName = SELF.Getsan(Set,Area)
?   Dbg.SetDebugState(TRUE)
?   Dbg.SetDebugState(DbgState#)
?   SELF.ShowValues(WhenTask,Set,Area)  
? Dbg.Fin()

GetCodeAreaState  ROUTINE
? Dbg.Routines('GetCodeAreaState')
?   Dbg.IFs('SELF.GetWhenTask(WhenTask,Set,Area) THEN')
    IF SELF.GetWhenTask(WhenTask,Set,Area) THEN
?     Dbg.IFOnTrue()
        Response = SELF.Qwt.State
?       Dbg.ShowValue('SELF.Qwt.State',SELF.Qwt.State)
?     Dbg.Fin()
    ELSE
?     Dbg.IFOnFalse()
        CASE WhenTask
          OF WTDef:TriggerOffHasToDO
            SELF.SetTriggerOffHasToDO(FALSE,Set,Area)
            Response = FALSE
          OF WTDef:TriggerOffHasDone
            SELF.SetTriggerOffHasDone(FALSE,Set,Area)
            Response = FALSE
          ELSE
?           Dbg.Warning(jcWhenTask::Error:WhenTaskSetAreaNotFound)
?             Dbg.See(jcWhenTask::Error:WhenTaskSetAreaNotFound)
?             Dbg.ShowValue('WhenTask ' & WhenTask,WhenTaskName)    
?             Dbg.ShowValue('Set ' & Set,SetName)    
?             Dbg.ShowValue('Area ' & Area,AreaName)    
?           Dbg.Fin()          
            IF SELF.GetMessageTrigger() THEN
              MESSAGE(jcWhenTask::Error:WhenTaskSetAreaNotFound & '|WhenTask ' & WhenTask & ' name is ' & WhenTaskName & | 
                '|Set ' & Set & ' name is ' & SetName & '|Area ' & Area & ' name is ' & AreaName,jcWhenTask::Error:MessageTitle,ICON:Exclamation)
            END
        END
?     Dbg.Fin()
    END
?   Dbg.Fin()
? Dbg.Fin()

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.DeleteWhenTask    PROCEDURE(BYTE pWhenTask)
MethodName                          EQUATE('DeleteWhenTask')
MethodPrototype                     EQUATE('(BYTE pWhenTask),VIRTUAL')
WhenTask                            BYTE

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:DeleteWhenTask)   
      WhenTask = pWhenTask
      CLEAR(SELF.Qwt)
      SORT(SELF.Qwt,SELF.Qwt.WhenTask)
      SELF.Qwt.WhenTask = pWhenTask
      GET(SELF.Qwt,SELF.Qwt.WhenTask)
      IF NOT ERROR()
        i# = POINTER(SELF.Qwt)
        LOOP i# = POINTER(SELF.Qwt) TO RECORDS(SELF.Qwt)
          SELF.Qwt.WhenTask = WhenTask
          GET(SELF.Qwt,SELF.Qwt.WhenTask)
          IF ERROR() THEN BREAK.
          GET(SELF.Qwt,POINTER(SELF.Qwt))
          IF SELF.Qwt.WhenTask = WhenTask THEN DELETE(SELF.Qwt).
        END
      END
?     Dbg.Help('About DeleteWhenTask')
?       Dbg.See('DeleteWhenTask delete one of the WhenTask definition')
?       Dbg.See('you may choose between')
?       Dbg.See('WTDef:CodeAreaSetDefinition, WTDef:WhosCalling, WTDef:HasToDO, WTDef:TriggerOffHasToDO or WTDef:HasDone')
?     Dbg.Fin()
?   Dbg.Fin()    
    
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.ClearWhenTask    PROCEDURE(BYTE pWhenTask)
MethodName                          EQUATE('ClearWhenTask')
MethodPrototype                     EQUATE('(BYTE pWhenTask),VIRTUAL')
WhenTask                            BYTE
State                               BOOL(FALSE)

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:ClearWhenTask)   
      WhenTask = pWhenTask
      CLEAR(SELF.Qwt)
      SORT(SELF.Qwt,SELF.Qwt.WhenTask)
      SELF.Qwt.WhenTask = pWhenTask
      GET(SELF.Qwt,SELF.Qwt.WhenTask)
      IF NOT ERROR()
        LOOP i# = POINTER(SELF.Qwt) TO RECORDS(SELF.Qwt)
          GET(SELF.Qwt,i#)
          IF SELF.Qwt.WhenTask <> WhenTask THEN 
            BREAK
          ELSIF SELF.Qwt.WhenTask = WhenTask THEN 
            SELF.Qwt.State = State
            PUT(SELF.Qwt) 
          END
        END
      END
?     Dbg.Help('About ClearWhenTask')
?       Dbg.See('ClearWhenTask clear all their State to FALSE')
?       Dbg.See('according to one of the WhenTask definition')
?       Dbg.See('WTDef:CodeAreaSetDefinition, WTDef:WhosCalling, WTDef:HasToDO, WTDef:TriggerOffHasToDO or WTDef:HasDone')
?     Dbg.Fin()
?   Dbg.Fin()    
    
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.Setsan           PROCEDURE(ULONG pSetID,ULONG pAreaID,ASTRING pName)
MethodName                          EQUATE('Setsan')
MethodPrototype                     EQUATE('(ULONG pSetID,ULONG pAreaID,ASTRING pName)')
SetId                               ULONG
AreaID                              ULONG
Name                                ASTRING                   

  CODE
?   Dbgsan.Method(MethodName,MethodPrototype,jcWTDebugShow:Setsan)
      DO InitSetsan
      DO Setsan
      DO SetWhenTask
?   Dbgsan.Fin()

InitSetsan  ROUTINE
? Dbgsan.Routines('InitSetsan')
   SetID = pSetID
   AreaID = pAreaID
   Name = pName
   WhnTsk.Setsan(SetID,AreaID,Name)
   WhnTsk.Showsan(SetID,AreaID,Name)
? Dbgsan.Fin()

Setsan     ROUTINE
? Dbgsan.Routines('Setsan')
    CLEAR(SELF.Qsan)
    SELF.Qsan.SetID = SetID
    SELF.Qsan.AreaID = AreaID 
    GET(SELF.Qsan,SELF.Qsan.SetID,SELF.Qsan.AreaID)
    IF ERROR() THEN
      SELF.Qsan.Name = Name
?     Dbgsan.See('Adding san Set or Area Name')
      ADD(SELF.Qsan,SELF.Qsan.SetID,SELF.Qsan.AreaID)
    ELSE
?     Dbgsan.See('Updating san Set or Area Name')
      SELF.Qsan.Name = Name
      PUT(SELF.Qsan,SELF.Qsan.SetID,SELF.Qsan.AreaID)
    END
    WhnTsk.Showsan(SELF.Qsan.SetID,SELF.Qsan.AreaID,SELF.Qsan.Name)
? Dbgsan.Fin()

SetWhenTask  ROUTINE  
? Dbg.Routines('SetWhenTask')
    SELF.SetWhenTask(WTDef:CodeAreaSetDefinition,SetID,AreaID,TRUE)
? Dbg.Fin()  

!--------------------------------------------------------------------------------------------------------------------_
jcWhenTaskClass.Getsan          PROCEDURE(ULONG pSetID,ULONG pAreaID)
MethodName                        EQUATE('Getsan')
MethodPrototype                   EQUATE('(ULONG pSetID,ULONG pAreaID),ASTRING')
SetID                             ULONG
AreaID                            ULONG
Response                          ASTRING
DbgState                          BOOL(FALSE)

  CODE
!?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask,Dbg.GetNumberSpaceMargin()-2)
?   IF DbgState THEN Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask).
      SetID = pSetID
      AreaID = pAreaID
      CLEAR(SELF.Qsan)
      SELF.Qsan.SetID = SetID
      SELF.Qsan.AreaID = AreaID 
      GET(SELF.Qsan,SELF.Qsan.SetID,SELF.Qsan.AreaID)
      IF ERROR() THEN
        Response = jcWhenTask::Error:NotFound
        IF Loc:GetsanHasToDoState = TRUE THEN
?         IF DbgState THEN    
?           Dbgsan.Erreur(jcWhenTask::Error:sanSetOrAreaNotFound)
?             Dbgsan.ShowValue(jcWhenTask::Error:sanSetOrAreaNotFound,'',_Show)
?             Dbgsan.ShowValue('Set',SetID)
?             Dbgsan.ShowValue('Area',AreaID)
?           Dbgsan.Fin()
?         END
          IF SELF.GetMessageTrigger() THEN
            MESSAGE(jcWhenTask::Error:sanSetOrAreaNotFound & '|Set ' & SetID & '|Area ' & AreaID,jcWhenTask::Error:MessageTitle,ICON:Exclamation)
          END
        ELSE
?         IF DbgState THEN    
?           Dbgsan.Warning(jcWhenTask::Error:sanSetOrAreaNotFound & ' MESSAGE() skipped when WhnTsk.GetHasToDo(WT:Setsan,CAS:jcWhenTask) is Engage' )
?             Dbgsan.ShowValue(jcWhenTask::Error:sanSetOrAreaNotFound,'',_Show)
?             Dbgsan.ShowValue('Set',SetID)
?             Dbgsan.ShowValue('Area',AreaID)
?           Dbgsan.Fin()
?         END
        END
      ELSE
        Response = SELF.Qsan.Name
?       IF DbgState THEN WhnTsk.Showsan(SELF.Qsan.SetID,SELF.Qsan.AreaID,SELF.Qsan.Name).
      END
?   IF DbgState THEN Dbgsan.Fin().
    RETURN Response
   
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetsanSet        PROCEDURE(ULONG pSetID,ASTRING pName)
MethodName                          EQUATE('SetsanSet')
MethodPrototype                     EQUATE('(ULONG pSetID,ASTRING pName),VIRTUAL')
AreaID                              ULONG(jcWhenTask::WTDef:InitialArea)

  CODE
?   Dbgsan.Method(MethodName,MethodPrototype,jcWTDebugShow:SetsanSet)
      SELF.Setsan(pSetID,AreaID,pName)
?   Dbgsan.Fin()
       
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetsanSet        PROCEDURE(ULONG pSetID)
MethodName                          EQUATE('GetsanSet')
MethodPrototype                     EQUATE('(ULONG pSetID),ASTRING,VIRTUAL')
Response                            ASTRING 

  CODE
?   Dbgsan.Method(MethodName,MethodPrototype,jcWTDebugShow:GetsanSet)
?     Dbgsan.ShowValue('pSetID',pSetID)      
      Response = SELF.Getsan(pSetID,jcWhenTask::WTDef:InitialArea)
?     Dbgsan.ShowValue('Returning SetID response',Response)    
?   Dbgsan.Fin()
    RETURN Response
       
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetsanArea       PROCEDURE(ULONG pAreaID,ASTRING pName)
MethodName                          EQUATE('SetsanArea')
MethodPrototype                     EQUATE('(ULONG pAreaID,ASTRING pName),VIRTUAL')

  CODE
?   Dbgsan.Method(MethodName,MethodPrototype,jcWTDebugShow:SetsanArea)
      IF SELF.GetCurrentCodeAreaSet() THEN
        SELF.Setsan(SELF.CurrentCodeAreaSet,pAreaID,pName)
      ELSE
?       Dbg.Warning('WhenTask Message')
?         Dbg.See(jcWhenTask::Error:CurrentCodeAreaSetUnassigned)
?         Dbg.ShowValue('Area ' & pAreaID,pName)
?       Dbg.Fin()
        IF SELF.GetMessageTrigger() THEN
          MESSAGE(jcWhenTask::Error:CurrentCodeAreaSetUnassigned & '|Area ' & pAreaID & ' named ' & pName,jcWhenTask::Error:MessageTitle,ICON:Exclamation)
        END       
      END
?   Dbgsan.Fin()
       
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetsanArea        PROCEDURE(ULONG pAreaID)
MethodName                          EQUATE('GetsanArea')
MethodPrototype                     EQUATE('(ULONG pAreaID),ASTRING,VIRTUAL')
Response                            ASTRING 

  CODE
?   Dbgsan.Method(MethodName,MethodPrototype,jcWTDebugShow:GetsanArea)
      IF SELF.GetCurrentCodeAreaSet() THEN
        Response = SELF.Getsan(SELF.CurrentCodeAreaSet,pAreaID)
      ELSE
?       Dbg.Warning('WhenTask Message')
?         Dbg.See(jcWhenTask::Error:CurrentCodeAreaSetUnassigned)
?         Dbg.ShowValue('Area',pAreaID)
?       Dbg.Fin()
        IF SELF.GetMessageTrigger() THEN
          MESSAGE(jcWhenTask::Error:CurrentCodeAreaSetUnassigned & '|Area ' & pAreaID,jcWhenTask::Error:MessageTitle,ICON:Exclamation)
        END        
      END
?   Dbgsan.Fin()
    RETURN Response
       
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetCodeAreaSet    PROCEDURE(ULONG pCodeAreaSet,<ULONG pCodeArea>)
MethodName                          EQUATE('SetCodeAreaSet')
MethodPrototype                     EQUATE('(ULONG pCodeAreaSet,<ULONG pCodeArea>),VIRTUAL')
WhenTask                            BYTE(WTDef:CodeAreaSetDefinition)
Set                                 ULONG
Area                                ULONG
State                               BOOL(TRUE)

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:SetCodeAreaSet)
      Set = pCodeAreaSet
      IF OMITTED(3) THEN Area = jcWhenTask::WTDef:InitialArea ELSE Area = pCodeArea.
?     SELF.ShowValues(WhenTask,Set,Area)
      SELF.SetWhenTask(WhenTask,Set,Area,State)
?   Dbg.Fin()
!--------------------------------------------------------------------------------------------------------------------_
jcWhenTaskClass.GetCodeAreaSet   PROCEDURE(ULONG pCodeAreaSet,<ULONG pCodeArea>)!,BOOL
MethodName                          EQUATE('GetCodeAreaSet')
MethodPrototype                     EQUATE('(ULONG pCodeAreaSet,<ULONG pCodeArea>),BOOL,VIRTUAL')
WhenTask                            BYTE(WTDef:CodeAreaSetDefinition)
Set                                 ULONG
Area                                ULONG
State                               BOOL

  CODE
!?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask,Dbg.GetNumberSpaceMargin()-2)
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask)
      Set = pCodeAreaSet
      IF OMITTED(3) THEN Area = jcWhenTask::WTDef:InitialArea ELSE Area = pCodeArea.
?     SELF.ShowValues(WhenTask,Set,Area)
      State = SELF.GetState(WhenTask,Set,Area)
?   Dbg.Fin()
    RETURN State
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetCurrentWhenTaskDefinition  PROCEDURE(BYTE pCurrentWhenTaskDefinition)!,VIRTUAL
MethodName                                      EQUATE('SetCurrentWhenTaskDefinition')
MethodPrototype                                 EQUATE('(BYTE pCurrentWhenTaskDefinition),VIRTUAL')
CurrentWhenTaskDefinition                       BYTE

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:SetCurrentWhenTaskDefinition)    
      CurrentWhenTaskDefinition = pCurrentWhenTaskDefinition
      SELF.CurrentWhenTaskDefinition = CurrentWhenTaskDefinition
      WhnTsk.CurrentWhenTaskDefinition = CurrentWhenTaskDefinition 
?     Dbg.ShowValue('CurrentWhenTaskDefinition code',SELF.CurrentWhenTaskDefinition)    
?     Dbg.ShowValue('CurrentWhenTaskDefinition',SELF.GetWhenTaskName(SELF.CurrentWhenTaskDefinition))    
?   Dbg.Fin()    

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetCurrentWhenTaskDefinition   PROCEDURE()!,BYTE,VIRTUAL
CurrentWhenTaskDefinition                         BYTE

  CODE
    CurrentWhenTaskDefinition = SELF.CurrentWhenTaskDefinition
?   Dbg.ShowValue('Current When Task Definition',CurrentWhenTaskDefinition)   
?   Dbg.ShowValue('Current When Task Definition name',SELF.GetWhenTaskName(CurrentWhenTaskDefinition))   
    RETURN CurrentWhenTaskDefinition
    
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetCurrentCodeAreaSet   PROCEDURE(ULONG pCodeAreaSet)
MethodName                                EQUATE('SetCurrentCodeAreaSet')
MethodPrototype                           EQUATE('(ULONG pCodeAreaSet),VIRTUAL')
WhenTask                                  BYTE(WTDef:CurrentSetArea)
CurrentCodeAreaSet                        ULONG
State                                     BOOL(TRUE)

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:SetCurrentCodeAreaSet)
      SELF.WhosCalling = WT:SetCurrentCodeAreaSet
      SELF.CurrentCodeAreaSet = pCodeAreaSet
      CurrentCodeAreaSet = SELF.CurrentCodeAreaSet
?     Dbg.ShowValue('CurrentCodeAreaSet assigned by pCodeAreaSet',CurrentCodeAreaSet)
?     Dbg.ShowValue('CurrentCodeAreaSet Name',SELF.GetsanSet(CurrentCodeAreaSet))   
      SELF.SetWhenTask(WhenTask,CAS:CurrentCodeAreaSet,CurrentCodeAreaSet,State)
?   Dbg.Fin()

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetCurrentCodeAreaSet   PROCEDURE()!,ULONG
MethodName                                EQUATE('GetCurrentCodeAreaSet')
MethodPrototype                           EQUATE('(),ULONG,VIRTUAL')
WhenTask                                  BYTE(WTDef:CurrentSetArea)
CurrentCodeAreaSet                        ULONG

  CODE
    CurrentCodeAreaSet = SELF.GetWhenTask(WhenTask,CAS:CurrentCodeAreaSet)
?   Dbg.ShowValue('Current Code Area Set',CurrentCodeAreaSet)   
?   Dbg.ShowValue('Current Code Area Set name',SELF.GetsanSet(CurrentCodeAreaSet))   
    RETURN CurrentCodeAreaSet
    
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetCurrentCodeArea      PROCEDURE(ULONG pCodeArea)
MethodName                                EQUATE('SetCurrentCodeArea')
MethodPrototype                           EQUATE('(ULONG pCodeArea),VIRTUAL')
WhenTask                                  BYTE(WTDef:CurrentSetArea)
CurrentCodeArea                           ULONG
State                                     BOOL(TRUE)

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:SetCurrentCodeArea)
      SELF.WhosCalling = WT:SetCurrentCodeArea
      CurrentCodeArea = pCodeArea
      SELF.SetWhenTask(WhenTask,CAS:CurrentCodeArea,CurrentCodeArea,State)
?     Dbg.ShowValue('CurrentCodeArea',CurrentCodeArea)
?     Dbg.ShowValue('CurrentCodeArea Name',SELF.GetsanArea(CurrentCodeArea))
?   Dbg.Fin()
        
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetCurrentCodeArea      PROCEDURE()!,ULONG
MethodName                                EQUATE('GetCurrentCodeArea')
MethodPrototype                           EQUATE('(),ULONG,VIRTUAL')
WhenTask                                  BYTE(WTDef:CurrentSetArea)
CurrentCodeArea                           ULONG

  CODE
!?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask,Dbg.GetNumberSpaceMargin()-2)
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask)
      CurrentCodeArea = SELF.GetWhenTask(WhenTask,CAS:CurrentCodeArea)
?     Dbg.ShowValue('CurrentCodeArea',SELF.GetsanArea(CurrentCodeArea),jcWTDebugShow:GetCurrentCodeArea,Dbg.GetNumberSpaceMargin())
?   Dbg.Fin()    
    RETURN CurrentCodeArea
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetWhosCalling PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL pState>)
MethodName                        EQUATE('SetWhosCalling')
MethodPrototype                   EQUATE('(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL pState>),VIRTUAL')
WhenTask                          BYTE(WTDef:WhosCalling)
Set                               ULONG
Area                              ULONG
State                             BOOL(TRUE)

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:SetWhosCalling)
      Area = pCodeArea
      IF OMITTED(3) THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.
      IF NOT OMITTED(4) THEN State = pState.
?     SELF.ShowValues(WhenTask,Set,Area,State)
      SELF.SetWhenTask(WhenTask,Set,Area,State)
?   Dbg.Fin()
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetWhosCalling PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>)!,BOOL
MethodName                        EQUATE('GetWhosCalling')
MethodPrototype                   EQUATE('(ULONG pCodeArea,<ULONG pCodeAreaSet>),BOOL,VIRTUAL')
WhenTask                          BYTE(WTDef:WhosCalling)
Set                               ULONG
Area                              ULONG
State                             BOOL

  CODE
!?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask,Dbg.GetNumberSpaceMargin()-2)
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask)
      Area = pCodeArea
?     Dbg.Codes('IF OMITTED(3) THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.')
        IF OMITTED(3) THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.
?       SELF.ShowValues(WhenTask,Set)
?     Dbg.Fin()
?     SELF.ShowValues(WhenTask,Set,Area,State)
      State = SELF.GetState(WhenTask,Set,Area)
?   Dbg.Fin()
    RETURN State
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.ClearWhosCalling  PROCEDURE()
MethodName                          EQUATE('ClearWhosCalling')
MethodPrototype                     EQUATE('(),VIRTUAL')
WhenTask                            BYTE(WTDef:WhosCalling)

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:ClearWhosCalling)    
      SELF.ClearWhenTask(WhenTask)
?   Dbg.Fin()    

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetHasToDO    PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL HasToDOState>,<BOOL HasDoneState>)
MethodName                      EQUATE('SetHasToDO')
MethodPrototype                 EQUATE('(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL HasToDOState>,<BOOL HasDoneState>),VIRTUAL')
WhenTask                        BYTE(WTDef:HasToDO)
Set                             ULONG
Area                            ULONG
State                           BOOL

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:SetHasToDO)
      Area = pCodeArea
?     Dbg.Codes('IF OMITTED(3)"<ULONG pCodeAreaSet>" THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.')
        IF OMITTED(3) THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.
?       SELF.ShowValues(WhenTask,Set)
?     Dbg.Fin()
?     Dbg.Codes('IF OMITTED(4) "<BOOL HasToDOState>" THEN State = TRUE ELSE State = HasToDOState.')
        IF OMITTED(4) THEN State = TRUE ELSE State = HasDoneState.
?       SELF.ShowValues(WhenTask,,,State)
?     Dbg.Fin()
      SELF.SetWhenTask(WhenTask,Set,Area,State)
?     Dbg.Codes('IF OMITTED(5) "<BOOL HasDoneState>" THEN')
        IF OMITTED(5) THEN
          IF SELF.GetTriggerOffHasDone(Set,Area) THEN State = FALSE ELSE State = SELF.GetHasDone(Area,Set).
        ELSE
          State = HasDoneState
        END
?       SELF.ShowValues(WhenTask,,,State)
?     Dbg.Fin()
?     SELF.ShowValues(WhenTask,Set,Area,State)
      SELF.SetHasDone(Area,Set,State)
      SELF.SetWhosCalling(Area,Set,State)
?   Dbg.Fin()

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetHasToDo    PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>)!,BOOL
MethodName                      EQUATE('GetHasToDo')
MethodPrototype                 EQUATE('(ULONG pCodeArea,<ULONG pCodeAreaSet>),BOOL,VIRTUAL')
WhenTask                        BYTE(WTDef:HasToDO)
Set                             ULONG
Area                            ULONG
State                           BOOL

  CODE
!?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask,Dbg.GetNumberSpaceMargin()-2)
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask)
      Area = pCodeArea
      IF OMITTED(3) THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.
?     SELF.ShowValues(WhenTask,Set,Area)
?     Dbg.IFs('SELF.GetWhosCalling(Area,Set) THEN')
      IF SELF.GetWhosCalling(Area,Set) THEN
?       Dbg.IFOnTrue()
          State = SELF.GetState(WhenTask,Set,Area)
?         SELF.ShowValues(WhenTask,,,State)
?       Dbg.Fin()
      ELSE
?       Dbg.IFOnFalse()
          State = FALSE
?         SELF.ShowValues(WhenTask,,,State)
?       Dbg.Fin()
      END
?     Dbg.Fin()
?     SELF.ShowValues(WhenTask,Set,Area,State)
?   Dbg.Fin()
    RETURN State

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.ClearHasToDo   PROCEDURE()
MethodName                        EQUATE('ClearHasToDo')
MethodPrototype                   EQUATE('(),VIRTUAL')
WhenTask                          BYTE(WTDef:HasToDO)

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:ClearHasToDo)    
      SELF.ClearWhenTask(WhenTask)
?   Dbg.Fin()    
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetTriggerOffHasToDo PROCEDURE(BOOL pTriggerOffHasToDO,<ULONG pCodeAreaSet>,<ULONG pCodeArea>)
MethodName                              EQUATE('SetTriggerOffHasToDo')
MethodPrototype                         EQUATE('(BOOL pTriggerOffHasToDO,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),VIRTUAL')
WhenTask                                BYTE(WTDef:TriggerOffHasToDO)
Set                                     ULONG
Area                                    ULONG
State                                   BOOL

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:SetTriggerOffHasToDO)
      IF OMITTED(3) THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.
      IF OMITTED(4) THEN Area = SELF.GetCurrentCodeArea() ELSE Area = pCodeArea.
      State = pTriggerOffHasToDO
?     SELF.ShowValues(WhenTask,Set,Area,State)
      SELF.SetWhenTask(WhenTask,Set,Area,State)
?   Dbg.Fin()

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetTriggerOffHasToDo    PROCEDURE(<ULONG pCodeAreaSet>,<ULONG pCodeArea>)!,BOOL
MethodName                                EQUATE('GetTriggerOffHasToDo')
MethodPrototype                           EQUATE('(<ULONG pCodeAreaSet>,<ULONG pCodeArea>),BOOL,VIRTUAL')
WhenTask                                  BYTE(WTDef:TriggerOffHasToDO)
Set                                       ULONG
Area                                      ULONG
State                                     BOOL

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetTriggerOffHasToDO,Dbg.GetNumberSpaceMargin()-2)
      IF OMITTED(2) THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.
      IF OMITTED(3) THEN Area = SELF.GetCurrentCodeArea() ELSE Area = pCodeArea.
      State = SELF.GetState(WhenTask,Set,Area)
?     SELF.ShowValues(WhenTask,Set,Area,State)
?   Dbg.Fin()
    RETURN State

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetHasDone    PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL HasDoneState>,<BOOL HasToDOState>)
MethodName                      EQUATE('SetHasDone')
MethodPrototype                 EQUATE('(ULONG pCodeArea,<ULONG pCodeAreaSet>,<BOOL HasDoneState>,<BOOL HasToDOState>),VIRTUAL')
WhenTask                        BYTE(WTDef:HasDone)
Set                             ULONG
Area                            ULONG
State                           BOOL

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:SetHasDone)
      Area = pCodeArea
?     Dbg.Codes('IF OMITTED(3)"<ULONG pCodeAreaSet>" THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.')
        IF OMITTED(3) THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.
?       SELF.ShowValues(WhenTask,Set)
?     Dbg.Fin()
?     Dbg.Codes('IF OMITTED(4) "<BOOL HasDoneState>" THEN State = TRUE ELSE State = HasDoneState.')
        IF OMITTED(4) THEN State = TRUE ELSE State = HasDoneState.
?       SELF.ShowValues(WhenTask,,,State)
?     Dbg.Fin()
      SELF.SetWhenTask(WhenTask,Set,Area,State)
?     Dbg.Codes('IF OMITTED(5) "<BOOL HasToDOState>" THEN')
        IF OMITTED(5) THEN
          IF SELF.GetTriggerOffHasToDO(Set,Area) THEN State = FALSE ELSE State = SELF.GetHasToDo(Area,Set).
        ELSE
          State = HasToDOState
        END
?       SELF.ShowValues(WhenTask,,,State)
?     Dbg.Fin()
?     SELF.ShowValues(WhenTask,Set,Area,State)
      SELF.SetHasToDo(Area,Set,State)
      SELF.SetWhosCalling(Area,Set,State)
?   Dbg.Fin()

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetHasDone    PROCEDURE(ULONG pCodeArea,<ULONG pCodeAreaSet>)!,BOOL
MethodName                      EQUATE('GetHasDone')
MethodPrototype                 EQUATE('(ULONG pCodeArea,<ULONG pCodeAreaSet>),BOOL,VIRTUAL')
WhenTask                        BYTE(WTDef:HasDone)
Set                             ULONG
Area                            ULONG
State                           BOOL

  CODE
!?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask,Dbg.GetNumberSpaceMargin()-2)
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetWhenTask)
      Area = pCodeArea
?     Dbg.Codes('IF OMITTED(3) "<ULONG pCodeAreaSet>" THEN which is <ULONG pCodeAreaSet>')
        IF OMITTED(3) THEN 
          Set = SELF.GetCurrentCodeAreaSet() 
        ELSE 
          Set = pCodeAreaSet
        END
?       SELF.ShowValues(WhenTask,Set)
?     Dbg.Fin()
?     Dbg.Codes('IF SELF.GetWhosCalling(Area,Set) THEN')
        IF SELF.GetWhosCalling(Area,Set) THEN
          State = SELF.GetState(WhenTask,Set,Area)
        ELSE
          State = FALSE
        END
?       SELF.ShowValues(WhenTask,,,State)
?     Dbg.Fin()
?     SELF.ShowValues(WhenTask,Set,Area,State)
?   Dbg.Fin()
    RETURN State

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetTriggerOffHasDone PROCEDURE(BOOL pTriggerOffHasDone,<ULONG pCodeAreaSet>,<ULONG pCodeArea>)
MethodName                              EQUATE('SetTriggerOffHasDone')
MethodPrototype                         EQUATE('(BOOL pTriggerOffHasDone,<ULONG pCodeAreaSet>,<ULONG pCodeArea>),VIRTUAL')
WhenTask                                BYTE(WTDef:TriggerOffHasDone)
Set                                     ULONG
Area                                    ULONG
State                                   BOOL

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:SetTriggerOffHasDone)
      IF OMITTED(3) THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.
      IF OMITTED(4) THEN Area = SELF.GetCurrentCodeArea() ELSE Area = pCodeArea.
      State = pTriggerOffHasDone
?     SELF.ShowValues(WhenTask,Set,Area,State)
      SELF.SetWhenTask(WhenTask,Set,Area,State)
?   Dbg.Fin()

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetTriggerOffHasDone    PROCEDURE(<ULONG pCodeAreaSet>,<ULONG pCodeArea>)!,BOOL
MethodName                                EQUATE('GetTriggerOffHasDone')
MethodPrototype                           EQUATE('(<ULONG pCodeAreaSet>,<ULONG pCodeArea>),BOOL,VIRTUAL')
WhenTask                                  BYTE(WTDef:TriggerOffHasDone)
Set                                       ULONG
Area                                      ULONG
State                                     BOOL

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:GetTriggerOffHasDone,Dbg.GetNumberSpaceMargin()-2)
      IF OMITTED(2) THEN Set = SELF.GetCurrentCodeAreaSet() ELSE Set = pCodeAreaSet.
      IF OMITTED(3) THEN Area = SELF.GetCurrentCodeArea() ELSE Area = pCodeArea.
      State = SELF.GetState(WhenTask,Set,Area)
?     SELF.ShowValues(WhenTask,Set,Area,State)
?   Dbg.Fin()
    RETURN State

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.ClearHasDone  PROCEDURE()
MethodName                      EQUATE('ClearHasDone')
MethodPrototype                 EQUATE('(),VIRTUAL')
WhenTask                        BYTE(WTDef:HasDone)

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:ClearHasDone)    
      SELF.ClearWhenTask(WhenTask)
?   Dbg.Fin()
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.ShowValues    PROCEDURE(<BYTE WhenTask>,<ULONG Set>,<ULONG Area>,<BOOL State>)
MethodName                      EQUATE('ShowValues')
MethodPrototype                 EQUATE('(<BYTE WhenTask>,<ULONG Set>,<ULONG Area>,<BOOL State>)')
Margin                          SHORT
WhenTaskID                      BYTE
SetID                           ULONG
AreaID                          ULONG
WhenTaskName                    ASTRING
SetName                         ASTRING
AreaName                        ASTRING
ShowType                        BYTE(2)
AreaDetailWhenIsASet            EQUATE('Area 0 is the Inital Area representing the Set ')
AreaDetailWhenIsCurrentSet      EQUATE(' is the Current Code Area Set from WhenTaskDefinition WTDef:CurrentSetArea and Set CAS:CurrentCodeAreaSet')
AreaDetailWhenIsCurrentArea     EQUATE(' is the Current Code Area from WhenTaskDefition WTDef:CurrentSetArea and Set CAS:CurrentCodeArea of CAS:CurrentCodeAreaSet ')
  
  CODE
    WhenTaskID = WhenTask
    SetID = Set
    AreaID = Area
    WhenTaskName = SELF.GetWhenTaskName(WhenTaskID)
    SetName = WhnTsk.Getsan(SetID,jcWhenTask::WTDef:InitialArea)
    IF AreaID = jcWhenTask::WTDef:InitialArea THEN
      AreaName = AreaDetailWhenIsASet & SELF.Getsan(SetID,Area)
    ELSIF SetID = CAS:CurrentCodeAreaSet
      AreaName = SELF.Getsan(Area,jcWhenTask::WTDef:InitialArea) & AreaDetailWhenIsCurrentSet
    ELSIF SetID = CAS:CurrentCodeArea
      AreaName = SELF.Getsan(SELF.GetCurrentCodeAreaSet(),Area) & AreaDetailWhenIsCurrentArea & SELF.Getsan(SELF.GetCurrentCodeAreaSet(),jcWhenTask::WTDef:InitialArea)
    ELSE
      AreaName = SELF.Getsan(SetID,Area)
    END
    CASE ShowType
      OF 1
?       IF Dbg.GetNumberSpaceMargin() >= 12 THEN
?         Dbg.SetNumberSpaceMargin(8)
?       END
?       Margin = Dbg.GetNumberSpaceMargin()+2
?       IF NOT OMITTED(2) THEN Dbg.ShowValue('WhenTask',WhenTaskName,Margin).
?       IF NOT OMITTED(3) THEN Dbg.ShowValue('Set ' & SetID,SetName,Margin).
?       IF NOT OMITTED(4) THEN Dbg.ShowValue('Area ' & AreaID,AreaName,Margin).
?       IF NOT OMITTED(5) THEN Dbg.ShowValue('State',Dbg.GetBOOL(State,_Active),Margin).
      OF 2
?       Dbg.ShowValue('DebugMargin',Dbg.GetNumberSpaceMargin(),_Hide)    
?       IF NOT OMITTED(2) THEN Dbg.ShowValue('WhenTask',WhenTaskName).
?       IF NOT OMITTED(3) THEN Dbg.ShowValue('Set ' & SetID,SetName).
?       IF NOT OMITTED(4) THEN Dbg.ShowValue('Area ' & AreaID,AreaName).
?       IF NOT OMITTED(5) THEN Dbg.ShowValue('State',Dbg.GetBOOL(State,_Active)).
    END        
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.ValidateSet   PROCEDURE(BYTE pWhenTask,ULONG pSet)
MethodName                      EQUATE('ValidateSet')
MethodPrototype                 EQUATE('(BYTE pWhenTask,ULONG pSet)')
WhosCalling                     ULONG
CurrentSetArea                  ULONG
WhenTask                        BYTE
WhenTaskName                    ASTRING
Set                             ULONG
SetName                         ASTRING

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:ValidateSet)
      WhosCalling = SELF.WhosCalling
      WhenTask = pWhenTask
      WhenTaskName = SELF.GetWhenTaskName(WhenTask)
      IF WhenTask = WTDef:CurrentSetArea THEN
        CASE WhosCalling
          OF WT:SetCurrentCodeAreaSet; CurrentSetArea = CAS:CurrentCodeAreaSet
        END
      END
      Set = pSet
      SetName = WhnTsk.Getsan(Set,jcWhenTask::WTDef:InitialArea)
?     Dbg.Codes('At the beginning of ValidateSet')    
?       Dbg.ShowValue('WhosCalling',SELF.Getsan(CAS:jcWhenTask,WhosCalling))
?       Dbg.ShowValue('WhenTask',WhenTask)
?       IF WhenTask = WTDef:CurrentSetArea THEN Dbg.ShowValue('CurrentSetArea',CurrentSetArea).
?       Dbg.ShowValue('Set ' & Set,SetName) 
?     Dbg.Fin()      
?     Dbg.IFs('Set = 0 THEN')
      IF Set = 0 THEN 
?       Dbg.IFOnTrue()
?         Dbg.Notify(jcWhenTask::Error:CurrentCodeAreaSetUnassigned)
?           Dbg.See('Set may not be equal to 0')
?           Dbg.See('WhenTask ' & WhenTask & ' name is ' & WhenTaskName)
?           Dbg.See('Set ' & Set & ' Name ' & SetName)
?         Dbg.Fin()
          IF SELF.GetMessageTrigger() THEN
            MESSAGE(jcWhenTask::Error:CurrentCodeAreaSetUnassigned & _SPACE & '|WhenTask ' & WhenTask & ' name is ' & WhenTaskName & '|Set ' & Set & ' Name ' & SetName,jcWhenTask::Error:MessageTitle,ICON:Exclamation)
          END
?         IF Dbg:AssertState = TRUE THEN        
?           ASSERT(Set = 0,jcWhenTask::Error:CurrentCodeAreaSetUnassigned & _SPACE & '|WhenTask ' & WhenTask & ' name is ' & WhenTaskName & '|Set ' & Set & ' Name ' & SetName)
?         END
?       Dbg.Fin()
      ELSE
?       Dbg.IFOnFalse()
?         Dbg.SI('(WhenTask = WTDef:CodeAreaSetDefinition AND SELF.GetWhenTask(WTDef:CodeAreaSetDefinition,Set,jcWhenTask::WTDef:InitialArea)) OR (WhenTask = WTDef:CurrentSetArea AND SELF.GetWhenTask(WTDef:CurrentSetArea,CurrentSetArea,Set))')
          IF (WhenTask = WTDef:CodeAreaSetDefinition AND SELF.GetWhenTask(WTDef:CodeAreaSetDefinition,Set,jcWhenTask::WTDef:InitialArea)) OR |
            (WhenTask = WTDef:CurrentSetArea AND SELF.GetWhenTask(WTDef:CurrentSetArea,CurrentSetArea,Set)) THEN
?             Dbg.SIOnTrue('WhenTask condition is true')            
?               Dbg.See('Set is assigning')
?               Dbg.ShowValue('Set ' & Set,SetName) 
?               SELF.ShowValues(WhenTask,Set)
?             Dbg.Fin()
          ELSE
?           Dbg.SIOnFalse('WhenTask condition is false')
?             Dbg.Notify(jcWhenTask::Error:CurrentCodeAreaSetUnassigned)
?               Dbg.See(jcWhenTask::Error:CurrentCodeAreaSetUnassigned & ' to ' & jcWhenTask::Name:CodeAreaSetDefinition)              
?               SELF.ShowValues(WhenTask,Set)           
?               Dbg.See('Set ' & Set & ' named ' & SetName)
?               Dbg.See(jcWhenTask::Error:CurrentCodeAreaSetUnassigned & ' to ' & jcWhenTask::Name:CodeAreaSetDefinition)
?             Dbg.Fin()
              IF SELF.GetMessageTrigger() THEN
                MESSAGE('Set ' & Set & ' named ' & SetName & '|' & jcWhenTask::Error:CurrentCodeAreaSetUnassigned & ' to ' & jcWhenTask::Name:CodeAreaSetDefinition,jcWhenTask::Error:MessageTitle,ICON:Exclamation)
              END
?             IF Dbg:AssertState = TRUE THEN
?               ASSERT(i#=TRUE,'Set ' & Set & ' named ' & SetName & '|' & jcWhenTask::Error:CurrentCodeAreaSetUnassigned & ' to ' & jcWhenTask::Name:CodeAreaSetDefinition)
?             END
?           Dbg.Fin()
          END
?         Dbg.Fin()    
?       Dbg.Fin()
      END
?     Dbg.Fin()
?   Dbg.Fin()

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.ValidateArea  PROCEDURE(BYTE pWhenTask,ULONG pSet,ULONG pArea)
MethodName                      EQUATE('ValidateArea')
MethodPrototype                 EQUATE('(BYTE pWhenTask,ULONG pSet,ULONG pArea)')
WhosCalling                     ULONG
WhenTask                        BYTE
Set                             ULONG
SetName                         ASTRING
Area                            ULONG
AreaName                        ASTRING
CurrentCodeArea                 ULONG

  CODE
?   Dbg.Method(MethodName,MethodPrototype,jcWTDebugShow:ValidateArea)
      WhosCalling = SELF.WhosCalling
      WhenTask = pWhenTask
      IF WhenTask = WTDef:CurrentSetArea THEN
        IF WhosCalling = WT:SetCurrentCodeArea THEN CurrentCodeArea = CAS:CurrentCodeArea.
      END
      Set = pSet
      Area = pArea
      SetName = WhnTsk.Getsan(Set,jcWhenTask::WTDef:InitialArea)
      AreaName = WhnTsk.Getsan(Set,Area)
      SELF.ShowValues(WhenTask,Set,Area)
?     Dbg.IFs('WhenTask <> WTDef:CodeAreaSetDefinition AND Area = jcWhenTask::WTDef:InitialArea')
      IF  WhenTask <> WTDef:CodeAreaSetDefinition AND Area = jcWhenTask::WTDef:InitialArea THEN 
?       Dbg.IFOnTrue()
?         Dbg.Notify(jcWhenTask::Error:CurrentCodeAreaUnassigned)
?           Dbg.See('IF WhenTask is not WTDef:CodeAreaSetDefinition the Area must be assigned to a corresponding area from the CodeAreaSet CodeArea')
            SELF.ShowValues(WhenTask,Set,Area)
?         Dbg.Fin()
          IF SELF.GetMessageTrigger() THEN
!           MESSAGE(jcWhenTask::Error:CurrentCodeAreaUnassigned & '| Set is ' & Set & ' name is ' & SetName & '| Area is ' & Area & ' name is ' & AreaName,jcWhenTask::Error:MessageTitle,ICON:Exclamation)
          END
?         IF Dbg:AssertState = TRUE THEN
?           ASSERT(i# = TRUE,jcWhenTask::Error:CurrentCodeAreaUnassigned & '| Set is ' & Set & ' name is ' & SetName & '| Area is ' & Area & ' name is ' & AreaName)
?         END
?       Dbg.Fin()
      ELSE
?       Dbg.IFOnFalse
?         Dbg.SI('IF WhenTask = WTDef:CodeAreaSetDefinition AND SELF.GetWhenTask(WTDef:CodeAreaSetDefinition,Set,Area) OR (WhenTask = WTDef:CurrentSetArea AND SELF.GetWhenTask(WTDef:CurrentSetArea,CAS:CurrentCodeArea))')
          IF (WhenTask = WTDef:CodeAreaSetDefinition AND SELF.GetWhenTask(WTDef:CodeAreaSetDefinition,Set,Area)) OR |
            (WhenTask = WTDef:CurrentSetArea AND SELF.GetWhenTask(WTDef:CurrentSetArea,CAS:CurrentCodeArea)) THEN
?           Dbg.SIOnTrue('WhenTask condition is true')
?              Dbg.Codes('The Area is assigning')
                SELF.ShowValues(WhenTask,Set,Area)
?             Dbg.Fin()
?           Dbg.Fin()
          ELSE
?           Dbg.SIOnFalse('WhenTask Condition is false')
?             Dbg.Notify(jcWhenTask::Error:CurrentCodeAreaSetUnassigned)
                SELF.ShowValues(WhenTask,Set,Area)
?             Dbg.Fin()
              IF SELF.GetMessageTrigger() THEN
!                 MESSAGE('|Set ' & Set & ' named ' & SetName & '|Area ' & Area & ' named ' & AreaName & | 
!                   '|' & jcWhenTask::Error:CurrentCodeAreaSetUnassigned & ' to ' & jcWhenTask::Name:CodeAreaSetDefinition,jcWhenTask::Error:MessageTitle,ICON:Exclamation)
              END            
?             IF Dbg:AssertState = TRUE THEN
?                ASSERT(i# = TRUE,'|Set ' & Set & ' named ' & SetName & '|Area ' & Area & ' named ' & AreaName & | 
?                 '|' & jcWhenTask::Error:CurrentCodeAreaSetUnassigned & ' to ' & jcWhenTask::Name:CodeAreaSetDefinition)
?             END
?           Dbg.Fin()
          END
?         Dbg.Fin()  
?       Dbg.Fin()
      END
?     Dbg.Fin()
?   Dbg.Fin()

!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.SetMessageTrigger PROCEDURE(BOOL pMessageTrigger)!,VIRTUAL
  CODE
    SELF.MessageTrigger = pMessageTrigger
    
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.GetMessageTrigger PROCEDURE()!,BOOL
  CODE
    RETURN SELF.MessageTrigger
    
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.ShowQsan  PROCEDURE(<BYTE pType>)
Type                        BYTE(2)

  CODE
    IF NOT OMITTED(2) THEN Type = pType.
    EXECUTE Type
      DO LoopThroughQsan
      FldMgr.ShowQueue(SELF.Qsan,SetAndAreaNameGroup,Dbg.GetClassName())
    END

LoopThroughQsan   ROUTINE
  CLEAR(SELF.Qsan)
  SORT(SELF.Qsan,SELF.Qsan.SetID,SELF.Qsan.Name)
  Dbg.ShowLine(_EQUAL,125)
  Dbg.See('SetID   AreaID  Name')
  Dbg.ShowLine(_EQUAL,125)
  LOOP i# = 1 TO RECORDS(SELF.Qsan)
    GET(SELF.Qsan,i#)
    Dbg.See(SELF.Qsan.SetID & ALL(_SPACE,1) & SELF.Qsan.AreaID & ALL(_SPACE,6) & SELF.Qsan.Name)
  END
  Dbg.ShowLine(_EQUAL,125)
  Dbg.See()  
!-------------------------------------------------------------------------------------------------------------------
jcWhenTaskClass.ShowQwt   PROCEDURE(<BYTE pType>)
Type                        BYTE(2)

  CODE
    IF NOT OMITTED(2) THEN Type = pType.
    EXECUTE Type
      DO LoopThroughQwt
      FldMgr.ShowQueue(SELF.Qwt,WhenTaskGroup,Dbg.GetClassName())
    END

LoopThroughQwt   ROUTINE
  CLEAR(SELF.Qwt)
  SORT(SELF.Qwt,SELF.Qwt.WhenTask,SELF.Qwt.Set,SELF.Qwt.Area)
  Dbg.ShowLine(_EQUAL,125)
  Dbg.See('WhenTask SetID AreaID  Name Stat')
  Dbg.ShowLine(_EQUAL,125)
  LOOP i# = 1 TO RECORDS(SELF.Qwt)
    GET(SELF.Qwt,i#)
    Dbg.See(SELF.Qwt.WhenTask& ALL(_SPACE,5) & SELF.Qwt.Set & ALL(_SPACE,6) & SELF.Qwt.Area & ALL(_SPACE,6) & SELF.Qwt.State)
  END
  Dbg.ShowLine(_EQUAL,125)
  Dbg.See()  
    
!-------------------------------------------------------------------------------------------------------------------
! END OF WHENTASK CONCEPT 
!-------------------------------------------------------------------------------------------------------------------

!-------------------------------------------------------------------------------------------------------------------
!                                               WHENTASK LOCAL PROCEDURES
!-------------------------------------------------------------------------------------------------------------------

!-------------------------------------------------------------------------------------------------------------------
!                                            Dbg jcDebugManager instance PROCEDURES
!-------------------------------------------------------------------------------------------------------------------
Dbg.Method            PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BYTE Show>,<SHORT SpaceMargin>)   !Set Method it check for margin Set the MethodName and MethodStart                
ValidatedSM             SHORT(10)
SM                      SHORT

  CODE
    IF OMITTED(5) THEN SM = SELF.GetNumberSpaceMargin() ELSE SM = SpaceMargin.
    IF SM >= ValidatedSM THEN 
      SM = ValidatedSM-8
      SELF.SetNumberSpaceMargin(SM)
    END
    SELF.Margin = SM
    CASE Dbg.GetOmittedAction(FALSE,OMITTED(3),OMITTED(4),OMITTED(5))
      OF _OFFFF; PARENT.Method(MethodName,Prototype,Show,SM)
      OF _OFFFT; PARENT.Method(MethodName,Prototype,Show)
      OF _OFFTF; PARENT.Method(MethodName,Prototype,,SM)
      OF _OFTFF; PARENT.Method(MethodName,,Show,SM)
      OF _OFFTT; PARENT.Method(MethodName,Prototype)
      OF _OFTFT; PARENT.Method(MethodName,,Show)
      OF _OFTTF; PARENT.Method(MethodName,,,SM)
      OF _OFTTT; PARENT.Method(MethodName)
    END

!-------------------------------------------------------------------------------------------------------------------
!                                            FldMgr jcFieldManager instance PROCEDURES
!-------------------------------------------------------------------------------------------------------------------
FldMgr.Init PROCEDURE()

  CODE
    SELF.wt &= NEW jcWhenTaskClass
    !SELF.wt = WhenTask
    SELF.Init(,,,jcWhenTask::jcDebugManager:RespectingAreaShow)
   
!-------------------------------------------------------------------------------------------------------------------
FldMgr.Kill       PROCEDURE()

  CODE
    DISPOSE(SELF.wt)

!-------------------------------------------------------------------------------------------------------------------
FldMgr.ShowQueue  PROCEDURE(*QUEUE Q,*GROUP G,ASTRING ClassName)    

  CODE
    CLEAR(Q)
    CLEAR(G)
    PARENT.ShowQueue(Q,G)

!-------------------------------------------------------------------------------------------------------------------
!                                                   WhnTsk PROCEDURES
!-------------------------------------------------------------------------------------------------------------------
WhnTsk.Init PROCEDURE()

  CODE
    SELF.wt &= NEW jcWhenTaskClass
    
!-------------------------------------------------------------------------------------------------------------------    
WhnTsk.Kill PROCEDURE()    

  CODE
    DISPOSE(SELF.wt)
    
!-------------------------------------------------------------------------------------------------------------------    
WhnTsk.Showsan       PROCEDURE(<ULONG Set>,<ULONG Area>,<ASTRING Name>)
Margin                  SHORT(6)
SetName                 ASTRING
SetID                   ULONG
AreaID                  ULONG
AreaName                ASTRING
Showtype                BYTE(2)
AreaDetailWhenIsASet    EQUATE('Area 0 is the Inital Area representing the Set ')
  CODE
    SetID  = Set
    AreaID = Area
    DbgState# = Dbgsan.GetDebugState()
    Dbgsan.SetDebugState(FALSE)
    IF AreaID = jcWhenTask::WTDef:InitialArea THEN
      AreaName = AreaDetailWhenIsASet & SELF.Getsan(SetID,Area)
    ELSE
      AreaName = SELF.Getsan(SetID,Area)
    END
    SetName = SELF.Getsan(SetID)
    Dbgsan.SetDebugState(Dbgsan.GetDebugState())
    CASE ShowType
      OF 1
?   IF NOT OMITTED(2) THEN Dbgsan.ShowValue('Set ' & SetID,SetName,Margin).
?   IF NOT OMITTED(3) THEN Dbgsan.ShowValue('Area ' & AreaID,AreaName,Margin).
?   IF NOT OMITTED(4) THEN Dbgsan.ShowValue('Name',Name,Margin).
      OF 2
?   IF NOT OMITTED(2) THEN Dbgsan.ShowValue('Set ' & SetID,SetName).
?   IF NOT OMITTED(3) THEN Dbgsan.ShowValue('Area ' & AreaID,AreaName).
?   IF NOT OMITTED(4) THEN Dbgsan.ShowValue('Name',Name).
    END        
!-------------------------------------------------------------------------------------------------------------------
WhnTsk.Setsan           PROCEDURE(ULONG pSetID,ULONG pAreaID,ASTRING pName)
SetId                               ULONG
AreaID                              ULONG
Name                                ASTRING                   

  CODE
    DO Init
    DO san

Init  ROUTINE
   SetID = pSetID
   AreaID = pAreaID
   Name = pName

san       ROUTINE
    CLEAR(SELF.wt.Qsan)
    SELF.wt.Qsan.SetID = SetID
    SELF.wt.Qsan.AreaID = AreaID 
    GET(SELF.wt.Qsan,SELF.wt.Qsan.SetID,SELF.wt.Qsan.AreaID)
    IF ERROR() THEN
      SELF.wt.Qsan.Name = Name
      ADD(SELF.wt.Qsan,SELF.wt.Qsan.SetID,SELF.wt.Qsan.AreaID)
    ELSE
      SELF.wt.Qsan.Name = Name
      PUT(SELF.wt.Qsan,SELF.wt.Qsan.SetID,SELF.wt.Qsan.AreaID)
    END

!--------------------------------------------------------------------------------------------------------------------_
WhnTsk.Getsan                   PROCEDURE(ULONG pSetID,<ULONG pAreaID>)
SetID                             ULONG
AreaID                            ULONG
Response                          ASTRING

  CODE
    SetId = pSetId
    IF OMITTED(3) THEN AreaID = jcWhenTask::WTDef:InitialArea ELSE AreaID = pAreaID.
    SORT(SELF.wt.Qsan,SELF.wt.Qsan.SetID,SELF.wt.Qsan.AreaID)
    CLEAR(SELF.wt.Qsan)
    SELF.wt.Qsan.SetID = SetID
    SELF.wt.Qsan.AreaID = AreaID 
    GET(SELF.wt.Qsan,SELF.wt.Qsan.SetID,SELF.wt.Qsan.AreaID)
    IF ERROR() THEN
      Response = jcWhenTask::Error:NotFound
    ELSE
      Response = SELF.wt.Qsan.Name
    END
    RETURN Response

!-------------------------------------------------------------------------------------------------------------------
    