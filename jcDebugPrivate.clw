! Joliciel 2012
      MEMBER
      
      INCLUDE('jcBase.inc'),ONCE
      INCLUDE('jcDebug.inc'),ONCE

!JC_DEBUG_SHOW                           EQUATE(_Show)
JC_DEBUG_LOCAL_SHOW                     EQUATE(_Show)
JC_DEBUG_SHOWING_DEBUG_VALUE_ROUTINE    EQUATE(_Hide)   !ShowDebugValue ROUTINE in PrepareShow()

      Map
       MODULE('ImpShell2')
         SendToDebug(*CSTRING),RAW,PASCAL,NAME('OutputDebugStringA')
         VerQueryValue(Long,Long,Long,Long),Bool,Raw,Pascal,Name('VerQueryValueA')
       END
       
      End ! map

    OMIT('!Debug!')
Debug               CLASS(jcDebugManagerPrivate)
Init                   PROCEDURE , VIRTUAL                                          !Initialized the jcDebug scope instances presently DebugState is set to true
See                    PROCEDURE(ASTRING Info)
ShowDebugQueue         PROCEDURE (<BOOL ShowQ>,<SHORT SpaceMargin>) ,VIRTUAL        !Show to Debug View the status of the Q (jcDebugQueue) within the procedure
                    END
	!Debug!  
!----------------------------------------------------------------------------------------------------------------------------------- 
jcDebugManagerPrivate.Construct 						  PROCEDURE              
  CODE
  SELF.Stack &= NEW(jcStackManager)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.Destruct  						  PROCEDURE              
  CODE
  DISPOSE(SELF.Stack)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.PrepareClassName               PROCEDURE(<ASTRING ClassName>)  
  CODE
  IF NOT OMITTED(2) THEN
    SELF.SetClassName(ClassName)
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.PrepareClassName               PROCEDURE(*jcDebugManagerPrivate jcDebugClass,<ASTRING DeclaredClassName>)  
dcn     &jcDebugManagerPrivate
  CODE
  dcn &= NEW(jcDebugClass)
  IF NOT OMITTED(3) THEN
    
    dcn.SetClassName(DeclaredClassName)
    SELF.SetClassName(dcn.GetClassName())
  END
  DISPOSE(dcn)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.Init 							  PROCEDURE
  CODE
  SELF.Stack.Init()  
  !Debug.Init()
  SELF.SetAssertState(99)
  !SELF.PrepareClassName(SELF,jcDebug::jcDebugManagerPrivate)
  IF NOT SELF.GetClassName() THEN
    SELF.SetClassName(jcDebug::jcDebugManagerPrivate)
  END
  SELF.SetDebugState(JC_DEBUG_SHOW)
  SELF.DefaultMargin = 2
  SELF.DM = 2                       !DefaultMargin short version
  SELF.SetNumberSpaceMargin(SELF.DefaultMargin)
  SELF.SetRepetitionLength()              
  SELF.SetSeeVariablesRepetitionLength()
  SELF.SetShowDebugQueueRepetitionLength()
  SELF.ShowingCurrentMethodValue = TRUE
  SELF.ShowingSpaceMargin = FALSE
  DO InitShow

InitShow                                          ROUTINE
  IF SELF.GetDebugState() = FALSE THEN EXIT.
  SELF.SetShow(jcDebug::ApplicationShow,TRUE)
  SELF.SetShow(jcDebug::ProgramShow,TRUE)
  SELF.SetShow(jcDebug::ProcedureShow,TRUE)
  SELF.SetShow(jcDebug::ClassShow,TRUE)
  SELF.SetShow(jcDebug::MethodShow,TRUE)
  SELF.SetShow(jcDebug::ProcedureShow,TRUE)
  SELF.SetShow(jcDebug::RoutineShow,TRUE)
  SELF.SetShow(jcDebug::CodeShow,TRUE)
  SELF.SetShow(jcDebug::EmbedShow,TRUE)
  SELF.SetShow(jcDebug::Show,TRUE)
  SELF.SetShow(jcDebug::NoteShow,TRUE)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.Kill 							  PROCEDURE
  CODE  
  SELF.Stack.Kill()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetDebugState                      PROCEDURE(<BOOL DebugState>)
  CODE
  IF OMITTED(2) THEN
    SELF.DebugState = TRUE
  ELSE
    SELF.DebugState = DebugState
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetDebugState 					  PROCEDURE
  CODE
  IF SELF.DebugState THEN
    RETURN TRUE
  ELSE
    RETURN FALSE 
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetNote                            PROCEDURE(ASTRING Note)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.Note = Note
  SELF.Add(jcDebug::Note,SELF.GetNote())
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetNote                            PROCEDURE
  CODE
  RETURN SELF.Note
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.Save                               PROCEDURE()
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
? ASSERT(~SELF.Stack &= NULL,'The Stack reference to jcStackManager is not properly initialized')  
  SELF.Stacking.SpaceMargin = SELF.GetNumberSpaceMargin()
  SELF.Stacking.ApplicationName = SELF.GetApplicationName()
  SELF.Stacking.ProgramName = SELF.GetProgramName()
  SELF.Stacking.ProcedureName = SELF.GetProcedureName()
  SELF.Stacking.ClassName = SELF.GetClassName()
  SELF.Stacking.MethodName = SELF.GetMethodName()
  SELF.Stacking.RoutineSection = SELF.GetRoutineSection()
  SELF.Stacking.CodeSection = SELF.GetCodeSection()
  SELF.Stacking.EmbedSection = SELF.GetEmbedSection()
  SELF.Stacking.CurrentShow = SELF.CurrentShow
  SELF.Stacking.Note = SELF.GetNote()
  SELF.Stack.Push(SELF.Stacking)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.Restore                            PROCEDURE
  CODE 
  IF SELF.GetDebugState() = FALSE THEN RETURN.
? ASSERT(~SELF.Stack &= NULL,'The Stack reference to jcStackManager is not properly initialized')  
  SELF.Stack.Pop()
  IF NOT SELF.Stack.isEmpty() THEN 
    SELF.Stacking = SELF.Stack.Top()
    SELF.SetApplicationName(SELF.Stacking.ApplicationName)
    SELF.SetProgramName(SELF.Stacking.ProgramName)
    SELF.SetProcedureName(SELF.Stacking.ProcedureName)
    SELF.SetClassName(SELF.Stacking.ClassName)
    SELF.SetMethodName(SELF.Stacking.MethodName)
    SELF.SetRoutineSection(SELF.Stacking.RoutineSection)
    SELF.SetCodeSection(SELF.Stacking.CodeSection)
    SELF.SetEmbedSection(SELF.Stacking.EmbedSection)
    SELF.SetNumberSpaceMargin(SELF.Stacking.SpaceMargin)
    SELF.SetNote(SELF.Stacking.Note)
    SELF.CurrentShow = SELF.Stacking.CurrentShow
  END  
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetRestoreDebugState               PROCEDURE (*BOOL DebugState)  !Set Restore DebugState
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  DebugState = TRUE
  IF SELF.GetDebugState() = FALSE THEN 
    DebugState = FALSE
    SELF.SetDebugState(TRUE)
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.CheckRestoreDebugState             PROCEDURE (*BOOL DebugState) ! Check the currrent DebugState
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  IF DebugState = FALSE THEN SELF.SetDebugState(FALSE).
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ApplicationStart                   PROCEDURE (ASTRING ApplicationName,<ASTRING Parameter>,<BYTE Show>,<SHORT SpaceMargin>)  !Set Applicationt it check for margin Set the ApplicationName and ApplicationStart
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.SetApplicationName(ApplicationName,Parameter)
  IF NOT OMITTED(4) THEN
    SELF.PrepareShow(jcDebug::ApplicationShow,SELF.GetApplicationName(),Show)
  ELSE
    SELF.PrepareShow(jcDebug::ApplicationShow,SELF.GetApplicationName())
  END
  SELF.ShowStart(jcDebug::Application,SELF.GetApplicationName(),SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ApplicationEnd                     PROCEDURE
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.ShowEnd(jcDebug::Application,SELF.GetApplicationName())
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ProgramStart                       PROCEDURE (ASTRING ProgramName,<ASTRING Parameter>,<BYTE Show>,<SHORT SpaceMargin>)  !Set Program it check for margin Set the ProgramName and ProgramStart
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.SetProgramName(ProgramName,Parameter)
  IF NOT OMITTED(4) THEN
    SELF.PrepareShow(jcDebug::ProgramShow,SELF.GetProgramName(),Show)
  ELSE
    SELF.PrepareShow(jcDebug::ProgramShow,SELF.GetProgramName())
  END
  SELF.ShowStart(jcDebug::Program,SELF.GetProgramName(),SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ProgramEnd                         PROCEDURE
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.ShowEnd(jcDebug::Program,SELF.GetProgramName())
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ClassStart					      PROCEDURE(ASTRING ClassName,<BYTE Show>,<SHORT SpaceMargin>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.SetClassName(ClassName)
  IF NOT OMITTED(3) THEN
    SELF.PrepareShow(jcDebug::ClassShow,SELF.GetClassName(),Show)
  ELSE
    SELF.PrepareShow(jcDebug::ClassShow,SELF.GetClassName())
  END
  SELF.ShowStart(jcDebug::Class,SELF.GetClassName(),SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ClassEnd    			              PROCEDURE
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.ShowEnd(jcDebug::Class,SELF.GetClassName())
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.MethodStart                        PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BYTE Show>,<SHORT SpaceMargin>)  !Set Method it check for margin Set the MethodName and MethodStart
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  !!Debug.See('START jcDebugManagerPrivate.MethodStart PROCEDURE()')
!  IF LEN(SELF.CurrentShow) > 0 THEN
!    Debug.See('CurrentShow > 0')
!    Debug.ShowCurrentMethodValue('CurrentShow',SELF.CurrentSHow)
!    Debug.ShowCurrentMethodValue('GetCurrentShow',SELF.GetBOOL(SELF.GetCurrentShow()))
!  END
!  IF INSTRING('GetName',MethodName,1,1) THEN  
!     Debug.ShowCurrentMethodValue('GetCurrentShow()',SELF.GetBOOL(SELF.GetCurrentShow()))
!  END
  !IF LEN(Prototype) = 0 THEN Prototype = '()'.
  IF OMITTED(3) THEN Prototype = '()'.
  !SELF.SetCurrentShow(jcDebug::MethodShow)
  SELF.SetMethodName(MethodName,Prototype,jcBases::ProtoType2)
  IF NOT OMITTED(4) THEN
    SELF.PrepareShow(jcDebug::MethodShow,SELF.GetMethodName(),Show)
  ELSE
    SELF.PrepareShow(jcDebug::MethodShow,SELF.GetMethodName())
  END
  !SELF.PrepareShow(jcDebug::MethodShow & jcDebug::Dot & SELF.GetMethodName(),Show)
  SELF.ShowStart(jcDebug::Method,SELF.GetMethodName(),SpaceMargin)
  !!Debug.See('END jcDebugManagerPrivate.MethodStart PROCEDURE()')
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.MethodEnd                          PROCEDURE
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.ShowEnd(jcDebug::Method,SELF.GetMethodName())
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ProcStart  					      PROCEDURE(ASTRING ProcedureName,<ASTRING Prototype>,<BYTE Show>,<SHORT SpaceMargin>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  IF LEN(Prototype) = 0 THEN Prototype = '()'.
  SELF.SetProcedureName(ProcedureName,Prototype,jcBases::ProtoType3)
  IF NOT OMITTED(4) THEN
    SELF.PrepareShow(jcDebug::ProcedureShow,SELF.GetProcedureName(),Show)  
  ELSE
    SELF.PrepareShow(jcDebug::ProcedureShow,SELF.GetProcedureName())  
  END
  SELF.ShowStart(jcDebug::Procedure,SELF.GetProcedureName(),SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ProcEnd     			              PROCEDURE
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.ShowEnd(jcDebug::Procedure,SELF.GetProcedureName())
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.NoteStart                         PROCEDURE(ASTRING Note,<BYTE Show>,<SHORT SpaceMargin>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN FALSE.
  SELF.SetNote(Note)
  IF NOT OMITTED(3) THEN
    SELF.PrepareShow(jcDebug::NoteShow,SELF.GetNote(),Show)
  ELSE
    SELF.PrepareShow(jcDebug::NoteShow,SELF.GetNote())
  END
  SELF.ShowStart(jcDebug::Note,SELF.GetNote(),SpaceMargin)
  RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.NoteEnd                            PROCEDURE
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.ShowEnd(jcDebug::Note,SELF.GetNote())
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.RoutineStart                      PROCEDURE(ASTRING RoutineSection,<BYTE Show>,<SHORT SpaceMargin>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.SetRoutineSection(RoutineSection)
  IF NOT OMITTED(3) THEN
    SELF.PrepareShow(jcDebug::RoutineShow,SELF.GetRoutineSection(),Show)
  ELSE
    SELF.PrepareShow(jcDebug::RoutineShow,SELF.GetRoutineSection())
  END
  SELF.ShowStart(jcDebug::Routine,SELF.GetRoutineSection(),SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.RoutineEnd                         PROCEDURE
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.ShowEnd(jcDebug::Routine,SELF.GetRoutineSection())
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.CodeStart                         PROCEDURE(ASTRING CodeSection,<BYTE Show>,<SHORT SpaceMargin>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.SetCodeSection(CodeSection)
  IF NOT OMITTED(3) THEN
    SELF.PrepareShow(jcDebug::CodeShow,SELF.GetCodeSection(),Show)
  ELSE
    SELF.PrepareShow(jcDebug::CodeShow,SELF.GetCodeSection())
  END
  SELF.ShowStart(jcDebug::Code,SELF.GetCodeSection(),SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.CodeEnd                           PROCEDURE
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.ShowEnd(jcDebug::Code,SELF.GetCodeSection())
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.EmbedStart                        PROCEDURE(ASTRING EmbedSection,<BYTE Show>,<SHORT SpaceMargin>)    !Start of embed section
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN FALSE.
  SELF.SetEmbedSection(EmbedSection)
  IF NOT OMITTED(3) THEN
    SELF.PrepareShow(jcDebug::EmbedShow,SELF.GetEmbedSection(),Show)
  ELSE
    SELF.PrepareShow(jcDebug::EmbedShow,SELF.GetEmbedSection())
  END
  SELF.ShowStart(jcDebug::Embed,EmbedSection,SpaceMargin)
  RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.EmbedEnd                           PROCEDURE         !End of Embed section
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.ShowEnd(jcDebug::Embed,SELF.GetEmbedSection())
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.PrepareShow                        PROCEDURE (ASTRING AreaType,ASTRING Area,<BYTE Show>)
Currently           BOOL
MethodPrepareShow   EQUATE(1)
Info                CSTRING(251)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  !SELF.SeeStart(jcDebug::Method,'PrepareShow')
  !Debug.See('START PrepareShow()')
  DO Check_CurrentShow
  !Area = AreaType & jcDebug::Dot & Area  !ex. "Method Show.MethodName(Prototype)"
  !Debug.See('  ex. Method Show.MethodName(Prototype)')
  !Debug.See('  Current Show = ' & SELF.CurrentShow)
  !Debug.See('  Currently() = ' & Currently)
  !Debug.See('  Current Area = ' & Area)
  DO ShowDebugValue
  SELF.SetCurrentShow(AreaType,Area)
  Area = SELF.CurrentShow
  IF Currently = _Show THEN      
     IF NOT OMITTED(4) 
       SELF.SetShow(Area,Show)
     ELSE
       SELF.SetShow(Area,Currently)
     END
  ELSE
     SELF.SetShow(Area,_Hide)  
  END 
  !Debug.See('  Before ending the PrepareShow() I want to check the CurrentShow')
  !Debug.See('  CurrentShow = ' & SELF.CurrentShow)
  !Debug.See('  GetCurrentShow() = ' & SELF.GetCurrentShow())
  !Debug.See('END PrepareShow()')
  
  !SELF.SeeEnd(jcDebug::Method,'PrepareShow')
Check_CurrentShow           ROUTINE
  IF LEN(SELF.CurrentShow) > 0 THEN                 !If there's CurrentShow set Currently to the value from GetCurrentShow
    Currently = SELF.GetCurrentShow()
  ELSE
    SELF.SetCurrentShow(SELF.CurrentShow,_Show)
    Currently = _Show                               !Otherwise make sure currently show
  END  
ShowDebugValue                      ROUTINE
  DATA
ShowingDebugValue BOOL
  CODE
  ShowingDebugValue = JC_DEBUG_SHOWING_DEBUG_VALUE_ROUTINE
  !SELF.RoutineStart('ShowDebugValue')
  IF ShowingDebugValue = TRUE THEN    
    SELF.SeeStart(jcDebug::Routine,'jcDebugManagerPrivate.PrepareShow()/ShowDebugValue')
      SELF.SeeStart(jcDebug::Code,'The 3 Parameters in sequence')
        SELF.ShowCurrentMethodValue('Paramater AreaType',AreaType)
        SELF.ShowCurrentMethodValue('Parameter Area',Area)
        IF NOT OMITTED(3) THEN
           SELF.See('IF Show is not omitted then')
           SELF.ShowCurrentMethodValue('Parameter Show',SELF.GetBOOL(Show,_Showing))
        END
      SELF.SeeEnd(jcDebug::Code,'The 3 Parameters in sequence')
      SELF.See('CURRENTLY')
      SELF.ShowCurrentMethodValue('CurrentShow',SELF.CurrentShow)
      SELF.ShowCurrentMethodValue('PrepareShow:CurrentShow with Currently variable',SELF.GetValueRepresentation(SELF.CurrentShow,Currently))
      SELF.ShowCurrentMethodValue('with GetCurrentShow()',SELF.GetValueRepresentation(SELF.CurrentShow,SELF.GetCurrentShow()))
      SELF.See('AREA TYPE STATUS')
      SELF.ShowCurrentMethodValue('AreaType',AreaType)
      SELF.See('Get AreaType status ' & SELF.GetBOOL(SELF.GetShow(AreaType),_Active))
      SELF.See('AREA PARAMETER AND HIS STATUS')
      SELF.ShowCurrentMethodValue('Area',Area)
      SELF.ShowCurrentMethodValue('GetShow(Area)',SELF.GetValueRepresentation(Area,SELF.GetBOOL(SELF.GetShow(Area),_Showing)))
    SELF.SeeEnd(jcDebug::Routine,'jcDebugManagerPrivate.PrepareShow()/ShowDebugValue')
  END
  !SELF.RoutineEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetShow                            PROCEDURE(ASTRING Area,BOOL Value)
Info        CSTRING(251)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  !SELF.MethodStart('SetShow',,_Hide)
  !Debug.See('START SetShow()')
  IF LEN(Area) > 0 THEN
    IF SELF.Get(Area) = jcBases::Error THEN
      !SELF.ShowCurrentMethodValue('Add(' & Area & ',' & Value & ')')
      !Debug.See('  Add')      
      !Debug.See('  Area = ' & Area)      
      SELF.Add(Area,Value)
      !Debug.See('  SetShow status ' & SELF.GetBOOL(Value,_Showing))
    ELSE
      !SELF.ShowCurrentMethodValue('Put(' & Area & ',' & Value & ')')
      !Debug.See('  Put')      
      !Debug.See('  Area = ' & Area)      
      !Debug.See('  SetShow status ' & SELF.GetBOOL(Value,_Showing))      
      SELF.Put(Area,Value)
    END
  END
  DO ShowDebugQueueRtn
  !SELF.ShowCurrentMethodValue('jcDebugManagerPrivate.SetShow of ' & Area & ' = ',SELF.GetBOOL(SELF.GetShow(Area),_On))
  !Debug.See('  jcDebugManagerPrivate.SetShow of "' & Area & '" = ' & SELF.GetBOOL(!Debug.GetShow(Area),_Showing))  
  !Debug.See('END SetShow()')  
  !SELF.MethodEnd()
ShowDebugQueueRtn       ROUTINE
  DATA
DisplayDebugQueue   BOOL
DetailEntete	    CSTRING(251)
ObjectEntete	    CSTRING(251)
  CODE
  !Debug.See('START ShowDebugQueueRtn ROUTINE')
    DisplayDebugQueue = TRUE
    IF DisplayDebugQueue THEN
      !Debug.See(ALL('-',130))
      !Debug.See('NUMBER OF RECORDS : ' & RECORDS(SELF.QB))
      ObjectEntete = jcDebug::Object
      DetailEntete = jcDebug::Detail
      !Debug.See(ALL('-',130))
      !Debug.See(FORMAT(CLIP(ObjectEntete),@s80) & FORMAT(CLIP(DetailEntete),@s150))
      !Debug.See(ALL('-',130))
      i# = 0
      LOOP i# = 1 TO RECORDS(SELF.QB)
        GET(SELF.QB,i#)
        !Debug.See(FORMAT(CLIP(SELF.QB.Object),@s80) & SELF.GetValueRepresentation(SELF.QB.Object,SELF.QB.Detail))
      END
      !Debug.See(ALL('-',130))
    END
  !Debug.See('END ShowDebugQueueRtn ROUTINE')  
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetShow                            PROCEDURE(ASTRING Area)
Response BOOL
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN FALSE.
  Response = SELF.Get(Area)
  RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetCurrentShow                     PROCEDURE(ASTRING AreaType,<ASTRING Area>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  !Debug.See('START SetCurrentShow()')
  DO Check_Show_isCurrentShow
  DO Check_AreaType_isActive
  SELF.CurrentShow = AreaType & jcDebug::Dot & Area
  !Debug.See('  Set CurrentShow to ' & SELF.CurrentShow)      
  IF SELF.Get(AreaType) = TRUE THEN
    !Debug.See('SetCurrent Show is active the SetShow is not set here')
  ELSE
    !Debug.See('Set CurrentShow to Hide ' & AreaType & ' is inactive')
    SELF.SetShow(SELF.CurrentShow,_Hide)            !The AreaType is inactive the dependant currentShow Area is hiden
  END
  !Debug.See('END SetCurrentShow()')
Check_AreaType_isActive             ROUTINE
  IF SELF.Get(AreaType) = jcDebug::Error THEN
?   ASSERT(A#=TRUE,'Area Type not found in the base table')        
    !Debug.See('The Area Type ' & AreaType & ' is not in the base table SetShow() is activating it')
    !Debug.See('SELF.SetShow(' & AreaType & ',' & SELF.GetBOOL(TRUE,_Active) & ')')
    SELF.SetShow(AreaType,TRUE)
  END
Check_Show_isCurrentShow            ROUTINE
  IF SELF.CurrentShow = jcDebug::Show THEN  ! Set by Show() method to keep the current margin
                                            !use by See() and Show() if we Show the CurrentShow 
                                            !if CurrentShow = Show then See() will show the current show
    SELF.Showed = TRUE                      !used by SetNumberSpaceMargin in ShowStart when the CurrentShow = 'Show' 
                                            !Still need some thinking again to solve the spaceMargin when the Current Show 
                                            !do not want to embed an additional or fewer spaceMargin
  END  
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetCurrentShow                     PROCEDURE()
Response  BOOL
Info      CSTRING(251)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN FALSE.
!  IF INSTRING('GetName',SELF.CurrentShow,1,1) THEN
!    STOP(SELF.CurrentShow)
!    STOP(SELF.Get(SELF.CurrentShow))
!  END
!  !Debug.See('START GetCurrentShow()')
!  !Debug.See('  Current Method Call : ' & SELF.GetMethodName())
!  !Debug.See('  Current Show : ' & SELF.CurrentShow)
  Response = SELF.Get(SELF.CurrentShow)
!  !Debug.See('  Current Show status : ' & SELF.GetBOOL(Response))
!  !Debug.See('END GetCurrentShow()')
  RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.See 								  PROCEDURE(STRING Info,<SHORT SpaceMargin>)    !See the line of of info to DebugView
DebugAction		        BYTE
DebugInfo		        CSTRING(251)
NumberSpaceMargin       SHORT
Infos                   CSTRING(251)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  !Debug.See('START See(' & CLIP(Info) & ')')
  NumberSpaceMargin = SpaceMargin
  IF NumberSpaceMargin <> 0 THEN
    SELF.CheckSpaceMargin(NumberSpaceMargin,SpaceMargin)
  ELSE
    NumberSpaceMargin = SELF.GetNumberSpaceMargin()
  END  
  IF INSTRING('GetFields',info,1,1) THEN
     !Debug.See('  START CONDITION Infos Calling INSTRING(GetFields) in See()')     
     !Debug.See('    ' & SELF.CurrentShow)
     !Debug.See('    ' & SELF.GetBOOL(SELF.GetShow(SELF.CurrentShow),_Showing))
     !Debug.See('  END CONDITION Infos Calling INSTRING(GetFields) in See()')
  END
  !Debug.See('  SELF.CurrentShow = ' & SELF.CurrentShow)
  !Debug.See('  SELF.GetCurrentShow = ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing))
  IF INSTRING('jcFieldManager.Init(<*GROUP',Info,1,1) THEN
!    STOP(info)
!      STOP
      a# = SELF.GetCurrentShow()
? ASSERT(a#=TRUE,'SetCurrentShow ' & SELF.CurrentShow & ' CurrentShow de est ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing))
  END
  IF SELF.GetCurrentShow() = _Show THEN
    DebugAction = SELF.GetDebugState()
    DebugInfo = ALL(' ',NumberSpaceMargin) & Info 
    IF DebugAction THEN
      SendToDebug(DebugInfo)
    END
  END
  !Debug.See('START See(' & CLIP(Info) & ')')
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ShowStart                         PROCEDURE (ASTRING ShowWhat,ASTRING ShowWhom,SHORT SpaceMargin) !ShowStart of whom
NumberSpaceMargin   SHORT
Info                CSTRING(251)
  CODE  
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.AreaCondition = _Started
  !Debug.See('START ShowStart()')
  !Debug.See('  1st Parameter should a ShowWhat variable we have = ' & ShowWhat)
  !Debug.See('  2nd Parameter should a ShowWhom variable we have = ' & ShowWhom)
  !Debug.See('  CurrentShow is ' & SELF.CurrentShow)
  !Debug.See('  GetCurrentShow() ' & SELF.GetBOOL(SELF.GetCurrentShow()))
  SELF.SetMargin(NumberSpaceMargin,SpaceMargin)
  SELF.SetNumberSpaceMargin(NumberSpaceMargin)
  IF SELF.GetClassName() = '' AND SELF.GetMethodName() <> '' THEN 
    SELF.SetClassName('UnAssignedClass = Call ''Class.SetClassName(''ClassName'')')
  END  
  SELF.SeeStart(ShowWhat,ShowWhom)
  SELF.Save()
  IF SELF.Showed THEN
    SELF.SetNumberSpaceMargin(NumberSpaceMargin)
    SELF.Showed = FALSE
  ELSE
    SELF.SetNumberSpaceMargin(NumberSpaceMargin+2)
  END
  !Debug.See('END ShowStart()')
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ShowEnd                            PROCEDURE (ASTRING ShowWhat,ASTRING ShowWhom) !Show End of whom
RestoreDebugState       BOOL
s   CSTRING(251)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  !Les méthodes SetRestoreDebugState(RestoreDebugState) et SELF.CheckRestoreDebugState(RestoreDebugState) sont utilisées seulement
  !dans la méthode ShowEnd() je remarque qu'il est inutile d'utiliser ces méthodes, car lorsque je les utilises 
  !et le DebugState est désactivé nous avons toujours le END des sections qui apparaient dans DebugView. En enlevant ces instructions 
  !le problème est résolu. Je remarque avec tous le développement qui s'est fait ils sont devenus inutiles de les utilisées. 
  !!SELF.SetRestoreDebugState(RestoreDebugState) Je crois que SetRestoreDebugState est inutile je pense à supprimer cette méthode
  !SELF.SetRestoreDebugState(
  SELF.SetNumberSpaceMargin(SELF.Stacking.SpaceMargin)
? IF SELF.GetAssertState() = 2 THEN
?   ASSERT(ShowWhom='','Show Whom parameter is empty')  
? END
  IF ShowWhom <> '' ! Used as a check for a not Showing the End of a Section used for SetShow(<Section>,FALSE)
    SELF.SeeEnd(ShowWhat,ShowWhom)
  END
  SELF.AreaCondition = _Ended
  !SELF.CheckRestoreDebugState(RestoreDebugState) je crois que CheckRestoreDebugState aussi doit-être supprimé
  SELF.Restore()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SeeStart                          PROCEDURE (ASTRING SeeWhat,ASTRING SeeWhom)         !Show the start of whom
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.See(jcDebug::OpenBracket & jcDebug::Start & jcDebug::Space & SeeWhat & jcDebug::Colon & jcDebug::Space & SeeWhom & jcDebug::CloseBracket)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SeeEnd                            PROCEDURE (ASTRING SeeWhat,ASTRING SeeWhom)         !Show the end of whom
  CODE  
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.See(jcDebug::OpenBracket & jcDebug::End & ALL(jcDebug::Space,3) & SeeWhat & jcDebug::Colon & jcDebug::Space & SeeWhom & jcDebug::CloseBracket)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ShowHeader                        PROCEDURE (ASTRING HeaderString,<USHORT Type>)       !Show an header string according to a type format.
SidesChar   ASTRING
HeaderSize  ULONG
Repetition  ULONG
SidesLength ULONG
Character   ASTRING
  CODE 
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  HeaderSize = LEN(HeaderString)
  IF OMITTED(3) THEN Type = 1.
  IF SELF.GetRepetitionLength() = 0 THEN SELF.SetRepetitionLength(130).
  EXECUTE Type
    BEGIN 
      Repetition = SELF.GetRepetitionLength()
      SidesLength = (Repetition - HeaderSize - 2)/2
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(SidesChar & ' ' & HeaderString & ' ' & SidesChar)
    END
    BEGIN 
      Repetition = SELF.GetRepetitionLength()
      SidesLength = (Repetition - HeaderSize - 2)/2
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(SidesChar & ' ' & UPPER(HeaderString) & ' ' & SidesChar)
    END
    BEGIN 
      Repetition = SELF.GetRepetitionLength()
      SidesLength = (Repetition - HeaderSize - 2)
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(SidesChar & ' ' & UPPER(HeaderString))
    END
    BEGIN 
      Repetition = SELF.GetRepetitionLength()
      SidesLength = (Repetition - HeaderSize - 2)
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(UPPER(HeaderString) & ' ' & SidesChar)
    END
    BEGIN 
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      Repetition = SELF.GetRepetitionLength()
      SidesLength = (Repetition - HeaderSize - 2)/2
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(SidesChar & ' ' & HeaderString & ' ' & SidesChar)
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
    END
    BEGIN 
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      Repetition = SELF.GetRepetitionLength()
      SidesLength = (Repetition - HeaderSize - 2)/2
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(SidesChar & ' ' & UPPER(HeaderString) & ' ' & SidesChar)
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
    END
    BEGIN 
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      Repetition = SELF.GetRepetitionLength()
      SidesLength = (Repetition - HeaderSize - 2)
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(UPPER(HeaderString) & ' ' & SidesChar)
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
    END
    BEGIN 
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      Repetition = SELF.GetRepetitionLength()
      SidesLength = (Repetition - HeaderSize - 2)
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(SidesChar & ' ' & UPPER(HeaderString))
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
    END
    BEGIN 
      SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      Repetition = SELF.GetRepetitionLength()
      SidesLength = (Repetition - HeaderSize - 2)
      SidesLength /= 2
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(SidesChar & ' ' & HeaderString & ' ' & SidesChar)
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
    END
    BEGIN 
      SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      Repetition = SELF.GetRepetitionLength()
      SidesLength = (Repetition - HeaderSize - 2)
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(UPPER(HeaderString) & ' ' & SidesChar)
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
    END
    BEGIN 
      SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      Repetition = SELF.GetRepetitionLength()
      SidesLength = (Repetition - HeaderSize - 2)
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(SidesChar & ' ' & UPPER(HeaderString))
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
    END
  ELSE
    BEGIN 
      SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      Repetition = SELF.GetRepetitionLength()
      HeaderString = 'OUT OF RANGE HEADER TYPE USE ANOTHER VALUE FROM 1'
      HeaderSize = LEN(HeaderString)
      SidesLength = (Repetition - HeaderSize - 2)
      SidesLength /= 2
      SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
      SELF.See(SidesChar & ' ' & UPPER(HeaderString) & ' ' & SidesChar)
      SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
    END
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.Show                              PROCEDURE (STRING Info,<SHORT SpaceMargin>)         !Show the end of whom
  CODE  
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.SetCurrentShow(jcDebug::Show)
  SELF.See(Info,SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ShowCurrentMethodValue             PROCEDURE(ASTRING MethodString,<ANY Value>,<SHORT SpaceMargin>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  IF SELF.ShowingCurrentMethodValue = TRUE THEN
    IF INSTRING(jcDebug::Equal,MethodString) THEN
      SELF.See(SELF.GetClassName() & jcDebug::Dot & MethodString & ' ' & jcDebug::Colon & ' ' & Value,SpaceMargin)
    ELSE
      SELF.See(SELF.GetClassName() & jcDebug::Dot & MethodString & ' ' & jcDebug::Equal & ' ' & Value,SpaceMargin)
    END
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ShowValue                          PROCEDURE (ASTRING Value,<ANY Data>,<BYTE Show>,<SHORT SpaceMargin>)
  CODE
  IF OMITTED(4) THEN Show = TRUE.
  IF Show THEN
    IF SELF.ShowingValue = TRUE THEN
      IF INSTRING(jcDebug::Equal,Value) THEN
        SELF.See(Value & ' ' & jcDebug::Colon & ' ' & Data,SpaceMargin)
      ELSE
        SELF.See(Value & ' ' & jcDebug::Equal & ' ' & Data,SpaceMargin)
      END
    END
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetLine                            PROCEDURE(<ASTRING LineCharacter>,<USHORT Repetition>)   !Format with a specify character the repetion length of the line to set
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  IF OMITTED(3) THEN 
    IF SELF.GetRepetitionLength() > 0 THEN
      Repetition = SELF.GetRepetitionLength()
    ELSE
      SELF.SetRepetitionLength(130)
    END
  END
  IF OMITTED(2) THEN
    LineCharacter = jcDebug::Hyphen
  END
  SELF.SetRepeatCharacterInVariable(Repetition,LineCharacter,SELF.Line) !This will assign to SELF.Line the LineCharacter according to the repetition
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetLine                            PROCEDURE(<ASTRING LineCharacter>,<USHORT Repetition>)   !Get the formatted line
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN FALSE.
  IF OMITTED(2) THEN
    LineCharacter = jcDebug::Hyphen
  END
  IF OMITTED(3) THEN
    IF SELF.GetRepetitionLength() > 0 THEN
      Repetition = SELF.GetRepetitionLength()
    END
  END
  IF LEN(SELF.Line) = 0 THEN SELF.SetLine(LineCharacter,Repetition).
  RETURN SELF.Line
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ShowLine                           PROCEDURE(<ASTRING LineCharacter>,<USHORT Repetition>,<BYTE Type>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  IF OMITTED(3) THEN 
    IF SELF.GetRepetitionLength() = 0 THEN
      SELF.SetRepetitionLength(150)
    END
    Repetition = SELF.GetRepetitionLength()
  END
  IF OMITTED(2) THEN SELF.SetLine(jcDebug::Hyphen,SELF.GetRepetitionLength()).
  IF OMITTED(4) THEN Type = 1.
  IF LEN(SELF.Line) = 0 THEN SELF.SetLine(LineCharacter,Repetition).
  EXECUTE TYPE
    SELF.See(SELF.Line)
    SELF.Show(SELF.Line)
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SeeVariables 					  PROCEDURE  (<STRING Info>,<SHORT SpaceMargin>)
DebugAction		        BOOL
winAPIhWnd      CSTRING(251)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
!? ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QBR))
  SELF.MethodStart('SeeVariables','(<STRING Info>,<SHORT SpaceMargin>)',_Show)
!? ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QBR))
    !SELF.SetRepeatCharacterInVariable(SELF.GetSeeVariablesRepetitionLength(),jcDebug::Hyphen,SELF.Line)
    DebugAction = SELF.GetDebugState()
    SELF.ShowLine()      
    SELF.See('NUMBER OF VARIABLES TO WATCH IS ' & RECORDS(SELF.QBR))
    IF NOT OMITTED(2) THEN SELF.See(Info).
    SELF.ShowLine()
    IF DebugAction THEN
      i# = 0
      LOOP i# = 1 TO RECORDS(SELF.QBR)
        GET(SELF.QBR,i#)
        SELF.See(SELF.QBR.Object & ' ' & jcDebug::Equal & ' ' & SELF.GetValueRepresentation(SELF.QBR.Object,SELF.QBR.Detail))
      END
    END 
  SELF.ShowLine()
  SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ShowLocalDebug                     PROCEDURE(<BOOL ShowQ>,<SHORT SpaceMargin>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  SELF.MethodStart('ShowLocalDebug')
    !Debug.ShowDebugQueue(ShowQ,SpaceMargin)
  SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ShowDebugQueue                     PROCEDURE(<BOOL ShowQ>,<SHORT SpaceMargin>)
DisplayDebugQueue   BOOL
DetailEntete	    CSTRING(251)
ObjectEntete	    CSTRING(251)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  IF OMITTED(2) THEN
    DisplayDebugQueue = TRUE
  ELSE
    DisplayDebugQueue = ShowQ
  END
!? ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QBR))
  SELF.MethodStart('ShowDebugQueue','(<BYTE ShowQ>,<SHORT SpaceMargin>)',_Show)
!? ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QBR))
    !SELF.SetRepeatCharacterInVariable(SELF.GetShowDebugQueueRepetitionLength(),jcDebug::Hyphen,SELF.ShowDebugQueueLine)
    IF DisplayDebugQueue THEN
      SELF.ShowLine()
      SELF.See('NUMBER OF RECORDS : ' & RECORDS(SELF.QB))
      ObjectEntete = jcDebug::Object
      DetailEntete = jcDebug::Detail
      SELF.ShowLine()
      SELF.See(FORMAT(CLIP(ObjectEntete),@s80) & FORMAT(CLIP(DetailEntete),@s150))
      SELF.ShowLine()
      i# = 0
      LOOP i# = 1 TO RECORDS(SELF.QB)
        GET(SELF.QB,i#)
        SELF.See(FORMAT(CLIP(SELF.QB.Object),@s80) & SELF.GetValueRepresentation(SELF.QB.Object,SELF.QB.Detail))
      END
      SELF.ShowLine()
    END
  SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.ShowClassQueue                     PROCEDURE(jcBase BaseClass,<BOOL ShowQ>,<SHORT SpaceMargin>)
DisplayDebugQueue   BOOL
DetailEntete	    CSTRING(251)
ObjectEntete	    CSTRING(251)
base        &jcBase
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  base &= NEW(jcBase)
  base &= BaseClass  
  IF OMITTED(2) THEN
    DisplayDebugQueue = TRUE
  ELSE
    DisplayDebugQueue = ShowQ
  END
!? ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QBR))
  SELF.MethodStart('ShowClassQueue','(<BYTE ShowQ>,<SHORT SpaceMargin>)',_Show)
!? ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QBR))
    !SELF.SetRepeatCharacterInVariable(SELF.GetShowDebugQueueRepetitionLength(),jcDebug::Hyphen,SELF.ShowDebugQueueLine)
    IF DisplayDebugQueue THEN
      SELF.ShowLine()
      SELF.See('NUMBER OF RECORDS : ' & RECORDS(base.QB))
      ObjectEntete = jcDebug::Object
      DetailEntete = jcDebug::Detail
      SELF.ShowLine()
      SELF.See(FORMAT(CLIP(ObjectEntete),@s80) & FORMAT(CLIP(DetailEntete),@s150))
      SELF.ShowLine()
      i# = 0
      LOOP i# = 1 TO RECORDS(base.QB)
        GET(base.QB,i#)
        SELF.See(FORMAT(CLIP(base.QB.Object),@s80) & SELF.GetValueRepresentation(base.QB.Object,base.QB.Detail))
      END
      SELF.ShowLine()
    END
  SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetRepetitionLength                PROCEDURE(<SHORT Repetition>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  IF OMITTED(2) THEN
    SELF.RepetitionLength = 150
  ELSE
    SELF.RepetitionLength = Repetition
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetRepetitionLength                PROCEDURE()
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN FALSE.
  IF SELF.RepetitionLength = 0 THEN SELF.SetRepetitionLength().
  RETURN SELF.RepetitionLength
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetRepeatCharacterInVariable       PROCEDURE(USHORT Repetition,STRING Character,*ASTRING Variables)
  CODE         
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  Variables = ALL(Character,Repetition)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetSeeVariablesRepetitionLength    PROCEDURE(<USHORT Repetition>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  IF OMITTED(2) THEN
    SELF.SeeVariablesRepetitionLength = 150
  ELSE
    SELF.SeeVariablesRepetitionLength = Repetition
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetSeeVariablesRepetitionLength    PROCEDURE()
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN 0.
  RETURN SELF.SeeVariablesRepetitionLength
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetShowDebugQueueRepetitionLength  PROCEDURE()
  CODE
  RETURN SELF.ShowDebugQueueRepetitionLength
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetShowDebugQueueRepetitionLength  PROCEDURE(<USHORT Repetition>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  IF OMITTED(2) THEN
    SELF.ShowDebugQueueRepetitionLength = 130
  ELSE
    SELF.ShowDebugQueueRepetitionLength = Repetition
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetShowDebugQueueLine              PROCEDURE()
  CODE
  RETURN SELF.ShowDebugQueueLine
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetNumberSpaceMargin               PROCEDURE(<SHORT SpaceMargin>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  IF OMITTED(2) THEN
    SELF.NumberSpaceMargin = jcDebug::DefaultSpaceMargin
  ELSE
    SELF.NumberSpaceMargin = SpaceMargin
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetNumberSpaceMargin               PROCEDURE()
  CODE
  RETURN SELF.NumberSpaceMargin
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.CheckSpaceMargin                   PROCEDURE(*SHORT NumberSpaceMargin,<SHORT SpaceMargin>)
  CODE 
  IF SELF.GetDebugState() = FALSE THEN RETURN.
? IF SELF.ShowingSpaceMargin THEN
?   SELF.SetNumberSpaceMargin(SELF.GetNumberSpaceMargin()+2)
?   SELF.SeeStart(jcDebug::Method,SELF.GetClassName() & '.CheckSpaceMargin')!SELF.GetMethodName())
? END
  IF OMITTED(2) THEN
    SELF.Assign(SELF.GetNumberSpaceMargin(),NumberSpaceMargin)
  ELSE
    SELF.Assign(SpaceMargin,NumberSpaceMargin)
  END
? IF SELF.ShowingSpaceMargin THEN
?   SELF.Show('GetNumberSpaceMargin ' & SELF.GetNumberSpaceMargin())
?   SELF.Show('SpaceMargin ' & SpaceMargin) 
?   SELF.See('NumberSpaceMargin ' & NumberSpaceMargin)
?   SELF.SeeEnd(jcDebug::Method,SELF.GetClassName() & '.CheckSpaceMargin') !SELF.GetMethodName())
? END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.SetMargin                         PROCEDURE(*SHORT NumberSpaceMargin,*SHORT SpaceMargin) !Set the Margin
  CODE  
  IF SELF.GetDebugState() = FALSE THEN RETURN.
  IF SpaceMargin <> 0 THEN
    SELF.CheckSpaceMargin(NumberSpaceMargin,SpaceMargin+2)
  ELSE
    SELF.CheckSpaceMargin(NumberSpaceMargin,SELF.GetNumberSpaceMargin()+2)
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.Assign                             PROCEDURE(STRING Value,*? Fld)
  CODE
  FLD = Value
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetBOOL                            PROCEDURE(BOOL Value,<BYTE Type>)
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN FALSE.
  !SELF.SetNumberSpaceMargin(SELF.GetNumberSpaceMargin())
  !SELF.SaveStatus = !Debug.GetShow(jcDebug::NoteShow)
  !SELF.Put(jcDebug::NoteShow,FALSE)
    OMIT('!GetBOOL!')
  !Debug.MethodStart('GetBool','(BOOL Value,<BYTE Type>)')
    !Debug.NoteStart('Describing GetBOOL')
      !Debug.See('The GetBOOL() method returns a string of one or the opposite')
      !Debug.See('By default if the value is 1 then the string ''TRUE'' is returned otherwise ''FALSE')
      !Debug.See('If the optional parameter Type is assigned it accepts a value of 1 to 10')
      !Debug.See('represented by one of the defined EQUATES in the source file jc!Debug.inc')
      !Debug.See('Here''s the liste of EQUATES and returning value according to the boolean TRUE or FALSE')
      !Debug.See('ON TRUE it is always the first string of CHOOSE that is returned')
      !Debug.See('IF the type is _Enable and it is FALSE then ''DISABLE'' is returned by GetBOOL()')
      !Debug.See('Statement examples')
      !Debug.See('  DisplayFieldValue = !Debug.GetBOOL(!Debug.GetShow(jcDebug::NoteShow),_Enable))')
      !Debug.See('    On TRUE')
      !Debug.See('      DisplayFieldValue = ENABLE')
      !Debug.See('    On FALSE')
      !Debug.See('      DisplayFieldValue = DISABLE')
      !Debug.See('')
      !Debug.See('   EQUATE _True RETURNS ON TRUE ''TRUE'' OR ''FALSE')
      !Debug.See('')
      !Debug.See('1. RETURN CHOOSE(Value = TRUE,''TRUE'',''FALSE'') !Use the assigned TRUE value EQUATE _True or value of 1')
      !Debug.See('2. RETURN CHOOSE(Value = TRUE,''ON'',''OFF'')     !Use the assigned TRUE value EQUATE _On or the value of 2')
      !Debug.See('3. RETURN CHOOSE(Value = TRUE,''OPEN'',''CLOSE'') !Use the assigned TRUE value EQUATE _Open or the value of 3')
      !Debug.See('4. RETURN CHOOSE(Value = TRUE,''START'',''STOP'') !Use the assigned TRUE value EQUATE _Start or the value of 4')
      !Debug.See('5. RETURN CHOOSE(Value = TRUE,''ENABLE'',''DISABLE'')   !Use the assigned TRUE value EQUATE _Enable or the value of 5')
      !Debug.See('6. RETURN CHOOSE(Value = TRUE,''ACTIVE'',''INACTIVE'')  !Use the assigned TRUE value EQUATE _Active or the value of 6')
      !Debug.See('7. RETURN CHOOSE(Value = TRUE,''FUNCTIONAL'',''NOT FUNCTIONAL'')    !Use the assigned TRUE value EQUATE _Functional or the value of 7')
      !Debug.See('8. RETURN CHOOSE(Value = TRUE,''ENGAGE'',''DISENGAGE'')             !Use the assigned TRUE value EQUATE _Engage or the value of 8')
      !Debug.See('9. RETURN CHOOSE(Value = TRUE,''ALIVE'',''DEAD'')                   !Use the assigned TRUE value EQUATE _Alive or the value of 9')
      !Debug.See('10.RETURN CHOOSE(Value = TRUE,''STARTUP'',''FAIL'')                  !Use the assigned TRUE value EQUATE _Awake or the value of 10')
      !Debug.See('11.RETURN CHOOSE(Value = TRUE,''AWAKE'',''SLEAP'')                  !Use the assigned TRUE value EQUATE _Awake or the value of 11')
      !Debug.See('12.RETURN CHOOSE(Value = TRUE,''SHOWING'',''HIDING'')               !Use the assigned TRUE value EQUATE _Awake or the value of 12')
      !Debug.See('13.RETURN CHOOSE(Value = TRUE,''SOMETHING'',''NOTHING'')            !Use the assigned TRUE value EQUATE _Awake or the value of 13')
    !Debug.NoteEnd()        
    SELF.Put(jcDebug::NoteShow,SELF.SaveStatus)
  !Debug.MethodEnd()
  
    !GetBOOL!
  IF OMITTED(3) THEN Type = 1.
  EXECUTE Type
    RETURN CHOOSE(Value = TRUE,'TRUE','FALSE')                     !Use EQUATE _True or value of 1
    RETURN CHOOSE(Value = TRUE,'ON','OFF')                         !Use EQUATE _On or the value of 2
    RETURN CHOOSE(Value = TRUE,'OPEN','CLOSE')                     !Use EQUATE _Open or the value of 3
    RETURN CHOOSE(Value = TRUE,'START','STOP')                     !Use EQUATE _Start or the value of 4
    RETURN CHOOSE(Value = TRUE,'ENABLE','DISABLE')                 !Use EQUATE _Enable or the value of 5
    RETURN CHOOSE(Value = TRUE,'ACTIVE','INACTIVE')                !Use EQUATE _Active or the value of 6
    RETURN CHOOSE(Value = TRUE,'FUNCTIONAL','NOT FUNCTIONAL')      !Use EQUATE _Functional or the value of 7
    RETURN CHOOSE(Value = TRUE,'ENGAGE','DISENGAGE')               !Use EQUATE _Engage or the value of 8
    RETURN CHOOSE(Value = TRUE,'ALIVE','DEAD')                     !Use EQUATE _Alive or the value of 9
    RETURN CHOOSE(Value = TRUE,'AWAKE','SLEAP')                    !Use EQUATE _Awake or the value of 10
    RETURN CHOOSE(Value = TRUE,'STARTUP','FAIL')                   !Use EQUATE _Awake or the value of 11
    RETURN CHOOSE(Value = TRUE,'SHOWING','HIDING')                 !Use EQUATE _Awake or the value of 12
    RETURN CHOOSE(Value = TRUE,'SOMETHING','NOTHING')              !Use EQUATE _Awake or the value of 13
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManagerPrivate.GetValueRepresentation             PROCEDURE(ASTRING Object,ASTRING Detail)
Response            ASTRING
ValueRepresentation BOOL
  CODE
  IF SELF.GetDebugState() = FALSE THEN RETURN FALSE.
  !Debug.SetNumberSpaceMargin(SELF.GetNumberSpaceMargin())
!  SELF.SaveStatus = !Debug.GetShow(jcDebug::NoteShow)
!  SELF.Put(jcDebug::NoteShow,FALSE)
  !!Debug.MethodStart('GetValueRepresentation','(USHORT Value,<BYTE Type>)')
    OMIT('!GetValueRepresentationNote!')
    !Debug.NoteStart('Describing GetValueRepresentation')
      !Debug.See('The GetValueRepresentation() method returns a string representation according to a list')
      !Debug.See('Statement examples')
      !Debug.See('  DisplayFieldValue = !Debug.GetValueRepresentation(SELF.QB.Object,SELF.QB.Detail))')
      !Debug.See('    IF Within SELF.QB.Object there''s a Show then 
      !Debug.See('       the Detail value will display the SHOWING or HIDING String instead of the string')
    !Debug.NoteEnd()        
    !SELF.Put(jcDebug::NoteShow,SELF.SaveStatus)
    !GetValueRepresentationNote!
 ! !Debug.MethodEnd()
  ValueRepresentation = FALSE
  IF INSTRING(jcDebug::Show,Object,1,1) THEN
    Response = SELF.GetBOOL(Detail,_Active)
    ValueRepresentation = TRUE
  END
  IF INSTRING(jcDebug::Show & jcDebug::Dot,Object,1,1) THEN
    Response = SELF.GetBOOL(Detail,_Showing)
    ValueRepresentation = TRUE
  END
  IF ValueRepresentation = FALSE THEN
    Response = Detail
  END
  RETURN Response
!===================================================== End of jcDebugManagerPrivate =======================================================
!
!-----------------------------------------------------------------------------------------------------------------------------------
! Debug CLASS(jcDebugManagerPrivate) This local class base on jcDebugManage is another instance that is debugging the jcDebugManagerPrivate
!-----------------------------------------------------------------------------------------------------------------------------------
   OMIT('!Debug!')
Debug.Init                  PROCEDURE
  CODE
  SELF.SetClassName('jcDebugManagerPrivate')
  SELF.SetDebugState(FALSE)
  SELF.DefaultMargin = 2
  SELF.DM = 2                       !DefaultMargin short version
  SELF.SetRepetitionLength(130)              
  SELF.SetSeeVariablesRepetitionLength(130)
  SELF.SetShowDebugQueueRepetitionLength(130)
  SELF.ShowingCurrentMethodValue = TRUE
  SELF.ShowingSpaceMargin = FALSE
  DO InitShow
InitShow        ROUTINE
  SELF.SetShow(jcDebug::ApplicationShow,TRUE)
  SELF.SetShow(jcDebug::ProgramShow,TRUE)
  SELF.SetShow(jcDebug::ProcedureShow,TRUE)
  SELF.SetShow(jcDebug::ClassShow,TRUE)
  SELF.SetShow(jcDebug::MethodShow,TRUE)
  SELF.SetShow(jcDebug::ProcedureShow,TRUE)
  SELF.SetShow(jcDebug::RoutineShow,TRUE)
  SELF.SetShow(jcDebug::CodeShow,TRUE)
  SELF.SetShow(jcDebug::EmbedShow,TRUE)
  SELF.SetShow(jcDebug::Show,TRUE)
!-----------------------------------------------------------------------------------------------------------------------------------
!Debug.See                		            PROCEDURE(ASTRING Info)    !See the line of of info to DebugView
DebugAction		        BYTE
DebugInfo		        CSTRING(251)
  CODE
  DebugAction = JC_DEBUG_LOCAL_SHOW
  DebugInfo = Info 
  IF Info <> '' THEN

  END
? ASSERT(Info<>'','Info parameter in !Debug.See is empty ' & LEN(Info))
  IF DebugAction THEN
    SendToDebug(DebugInfo)
  END
!-----------------------------------------------------------------------------------------------------------------------------------
!Debug.ShowDebugQueue                     PROCEDURE(<BOOL ShowQ>,<SHORT SpaceMargin>)
DisplayDebugQueue   BOOL
DetailEntete	    CSTRING(251)
ObjectEntete	    CSTRING(251)
  CODE
  IF OMITTED(2) THEN
    DisplayDebugQueue = TRUE
  ELSE
    DisplayDebugQueue = ShowQ
  END
  SELF.MethodStart('ShowDebugQueue','(<BYTE ShowQ>,<SHORT SpaceMargin>)',_Show)
  !SELF.SetRepeatCharacterInVariable(SELF.GetShowDebugQueueRepetitionLength(),jcDebug::Hyphen,SELF.ShowDebugQueueLine)
    IF DisplayDebugQueue THEN
      SELF.ShowLine()
      SELF.See('NUMBER OF RECORDS : ' & RECORDS(SELF.QB))
      ObjectEntete = jcDebug::Object
      DetailEntete = jcDebug::Detail
      SELF.ShowLine()
      SELF.See(FORMAT(CLIP(ObjectEntete),@s80) & FORMAT(CLIP(DetailEntete),@s150))
      SELF.ShowLine()
      i# = 0
      LOOP i# = 1 TO RECORDS(SELF.QB)
        GET(SELF.QB,i#)
        SELF.See(FORMAT(CLIP(SELF.QB.Object),@s80) & SELF.GetValueRepresentation(SELF.QB.Object,SELF.QB.Detail))
      END
      SELF.ShowLine()
    END
  SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------

!Debug!