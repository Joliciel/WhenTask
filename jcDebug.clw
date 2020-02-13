! Joliciel 2012
      MEMBER
      
  INCLUDE('jcDebug.inc'),ONCE

      Map
       MODULE('ImpShell2')
         SendToDebug(*CSTRING),RAW,PASCAL,NAME('OutputDebugStringA')
         VerQueryValue(Long,Long,Long,Long),Bool,Raw,Pascal,Name('VerQueryValueA')
       END       
      END ! map
Dg jcDebugManager,THREAD
  
!-----------------------------------------------------------------------------------------------------------------------------------
!jcDebugManager setup
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Construct 						  PROCEDURE              
    CODE
!    SELF.critSect &= NewCriticalSection()
      SELF.Stack &= NEW(jcStackManager)
      SELF.UD &= NEW(UltimateDebug)
      SELF.QD &= NEW(QBase)
      SELF.QDR &= NEW(QBase)
    !SELF.F &= NEW(jcFieldManager)
!  SELF.Debug &= NEW(jcDebugManagerPrivate)
!  SELF.Debug &= NEW(jcDebugManager)
  
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Destruct  						  PROCEDURE              
  CODE
    SELF.QD &= NULL
    SELF.QDR &= NULL
    DISPOSE(SELF.Stack)    
    !DISPOSE(SELF.F)
   !DISPOSE(SELF.Debug)
    DISPOSE(SELF.UD)
    !SELF.critSect.Kill()
    IF SELF.LogIsReferenced = TRUE THEN DISPOSE(SELF.Log).
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.PrepareClassName               PROCEDURE(<ASTRING ClassName>)  
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    IF NOT OMITTED(2) THEN
      SELF.SetClassName(ClassName)
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.PrepareClassName               PROCEDURE(*jcDebugManager jcDebugClass,<ASTRING DeclaredClassName>)  
dcn     &jcDebugManager
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    dcn &= NEW(jcDebugClass) 
    IF NOT dcn.GetClassName() THEN
      dcn.SetClassName(DeclaredClassName)
    END
    SELF.SetClassName(dcn.GetClassName())
    DISPOSE(dcn)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Init 							  PROCEDURE(<jcLogManager Log>)
!!critProc  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    SELF.Stack.Init()  
    SELF.DebugPrefix = jcDebug::DebugPrefix
    SELF.DoDebugPrefix = jcDebug::DoDebugPrefix
    IF NOT OMITTED(2) THEN
      SELF.Log &= Log
    ELSE
      SELF.Log &= NEW(jcLogManager)
      SELF.LogIsReferenced = TRUE
    END
    !SELF.Log.SetClassName('jcDebugManager.log')
    !SELF.Log.Init('jcDebug',TRUE,4) !JC_LOG_jcLogManager_SetLogFormatOnClassName)
    !? SELF.Debug.SetClassName('jcDebugManager')
    !? SELF.Debug.PrepareClassName(SELF.Debug,jcDebug::jcDebugManager)
    SELF.SetAssertState(JC_DEBUG_jcDebugManager_SetAssertState)
    SELF.SetDebugState(JC_DEBUG_jcDebugManager_SetDebugState)
   
    DO SetupMethod
    DO SetupShow

SetupMethod         ROUTINE
    SELF.DefaultMargin = JC_DEBUG_jcDebugManager_DefaultMargin
    SELF.DM = JC_DEBUG_jcDebugManager_DefaultMargin     !DefaultMargin short version
    SELF.SetIndentSpaceMargin(JC_DEBUG_jcDebugManager_IndentMargin)
    SELF.SetRepetitionLength()              
    SELF.SetSeeVariablesRepetitionLength()
    SELF.SetShowDebugQueueRepetitionLength()

SetupShow ROUTINE
    !Setup State Valus
    SELF.SetRespectingAreaShow(JC_DEBUG_jcDebugManager_RespectingAreaShow)
    SELF.SetShowingCurrentMethodValue(JC_DEBUG_SHOW_jcDebugManager_ShowingCurrentMethodValue)
    SELF.ShowingValue = JC_DEBUG_SHOW_jcDebugManager_ShowingValue
    SELF.ShowingSpaceMargin = JC_DEBUG_SHOW_jcDebugManager_ShowingSpaceMargin
    SELF.SetShow(jcDebug::Show,JC_DEBUG_SHOW_jcDebugManager_Show)
    !Setup the Show according to the AreaType
    SELF.SetShow(jcDebug::HeaderShow,JC_DEBUG_SHOW_jcDebugManager_HeaderShow)
    SELF.SetShow(jcDebug::DescriptionShow,JC_DEBUG_SHOW_jcDebugManager_DescriptionShow)
    SELF.SetShow(jcDebug::CommentShow,JC_DEBUG_SHOW_jcDebugManager_CommentShow)
    SELF.SetShow(jcDebug::ApplicationShow,JC_DEBUG_SHOW_jcDebugManager_ApplicationShow)
    SELF.SetShow(jcDebug::ProgramShow,JC_DEBUG_SHOW_jcDebugManager_ProgramShow)
    SELF.SetShow(jcDebug::ClassShow,JC_DEBUG_SHOW_jcDebugManager_ClassShow)
    SELF.SetShow(jcDebug::ProcedureShow,JC_DEBUG_SHOW_jcDebugManager_ProcedureShow)
    SELF.SetShow(jcDebug::MethodShow,JC_DEBUG_SHOW_jcDebugManager_MethodShow)
    SELF.SetShow(jcDebug::RoutineShow,JC_DEBUG_SHOW_jcDebugManager_RoutineShow)
    SELF.SetShow(jcDebug::CodeShow,JC_DEBUG_SHOW_jcDebugManager_CodeShow)
    SELF.SetShow(jcDebug::EmbedShow,JC_DEBUG_SHOW_jcDebugManager_EmbedShow)
		SELF.SetShow(jcDebug::EXECUTEShow,JC_DEBUG_SHOW_jcDebugManager_EXECUTEShow)
		SELF.SetShow(jcDebug::BEGINShow,JC_DEBUG_SHOW_jcDebugManager_BEGINShow)
    SELF.SetShow(jcDebug::CASEShow,JC_DEBUG_SHOW_jcDebugManager_CASEShow)
    SELF.SetShow(jcDebug::OFShow,JC_DEBUG_SHOW_jcDebugManager_OFShow)
    SELF.SetShow(jcDebug::LoopShow,JC_DEBUG_SHOW_jcDebugManager_LoopShow)
    SELF.SetShow(jcDebug::IfShow,JC_DEBUG_SHOW_jcDebugManager_IfShow)
    SELF.SetShow(jcDebug::IfOnTrueShow,JC_DEBUG_SHOW_jcDebugManager_IfOnTrueShow)
    SELF.SetShow(jcDebug::IfOnFalseShow,JC_DEBUG_SHOW_jcDebugManager_IfOnFalseShow)
    SELF.SetShow(jcDebug::SIShow,JC_DEBUG_SHOW_jcDebugManager_SIShow)
    SELF.SetShow(jcDebug::SIOnTrueShow,JC_DEBUG_SHOW_jcDebugManager_SIOnTrueShow)
    SELF.SetShow(jcDebug::SIOnFalseShow,JC_DEBUG_SHOW_jcDebugManager_SIOnFalseShow)
    SELF.SetShow(jcDebug::NoteShow,JC_DEBUG_SHOW_jcDebugManager_NoteShow)  
    SELF.SetShow(jcDebug::DocShow,JC_DEBUG_SHOW_jcDebugManager_DocShow)  
    SELF.SetShow(jcDebug::DocumentationShow,JC_DEBUG_SHOW_jcDebugManager_DocumentationShow)  
    SELF.SetShow(jcDebug::HelpShow,JC_DEBUG_SHOW_jcDebugManager_HelpShow)  
    SELF.SetShow(jcDebug::HelperShow,JC_DEBUG_SHOW_jcDebugManager_HelperShow)  
    SELF.SetShow(jcDebug::ErreurShow,JC_DEBUG_SHOW_jcDebugManager_ErreurShow)  
    SELF.SetShow(jcDebug::ASSERTShow,JC_DEBUG_SHOW_jcDebugManager_ASSERTShow)
    SELF.SetShow(jcDebug::WarningShow,JC_DEBUG_SHOW_jcDebugManager_WarningShow)
    SELF.SetShow(jcDebug::NotifyShow,JC_DEBUG_SHOW_jcDebugManager_NotifyShow)
    SELF.SetShow(jcDebug::NotificationShow,JC_DEBUG_SHOW_jcDebugManager_NotificationShow)
        
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Kill 							  PROCEDURE

  CODE
  SELF.Stack.Kill()
!  !SELF.critSect.Kill()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetDebugState    PROCEDURE(<BOOL DebugState>)
!!critProc                          CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    IF OMITTED(2) THEN
      SELF.DebugState = TRUE
    ELSE
      SELF.DebugState = DebugState
    END

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetDebugState    PROCEDURE
!!critProc                          CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN CHOOSE(SELF.DebugState=TRUE,TRUE,FALSE)

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Save                               PROCEDURE()
  CODE
    !SELF.critSect.Wait()
?   IF SELF.GetAssertState(99) THEN
?     ASSERT(~SELF.Stack &= NULL,'The Stack reference to jcStackManager is not properly initialized')  
?   END
    DO SaveShow
    DO SaveSetup
    SELF.Stack.Push(SELF.Stacking)
   !SELF.critSect.Release()

!Save the Setup State Values    
SaveSetup ROUTINE    
  SELF.Stacking.StackCounter += 1
  SELF.Stacking.Thread = SELF.GetThread()
  SELF.Stacking.NumberSpaceMargin = SELF.GetNumberSpaceMargin()
  SELF.Stacking.IndentSpaceMargin = SELF.GetIndentSpaceMargin()
  SELF.Stacking.ShowWhat = SELF.GetShowWhat()
  SELF.Stacking.ShowWhom = SELF.GetShowWhom()
  SELF.Stacking.CurrentShow = SELF.CurrentShow
  SELF.CreateDebugManager(SELF.Stacking.sDebug)
  SELF.Stacking.sDebug &= SELF

!Save the Show according to the AreaType
SaveShow  ROUTINE  
  SELF.Stacking.Header = SELF.GetHeader()
  SELF.Stacking.Comment = SELF.GetComment()
  SELF.Stacking.Description = SELF.GetDescription()
  SELF.Stacking.ApplicationName = SELF.GetApplicationName()
  SELF.Stacking.ProgramName = SELF.GetProgramName()
  SELF.Stacking.ProcedureName = SELF.GetProcedureName()
  SELF.Stacking.ClassName = SELF.GetClassName()
  SELF.Stacking.MethodName = SELF.GetMethodName()
  SELF.Stacking.RoutineSection = SELF.GetRoutineSection()
  SELF.Stacking.CodeSection = SELF.GetCodeSection()
  SELF.Stacking.EmbedSection = SELF.GetEmbedSection()
  SELF.Stacking.EXECUTESection = SELF.GetEXECUTESection()
	SELF.Stacking.BEGINSection = SELF.GetBEGINSection()
  SELF.Stacking.CASESection = SELF.GetCASESection()
  SELF.Stacking.OFSection = SELF.GetOFSection()
  SELF.Stacking.LOOPSection = SELF.GetLOOPSection()
  SELF.Stacking.IFSection = SELF.GetIFSection()
  SELF.Stacking.IFOnTrueSection = SELF.GetIFOnTrueSection()
  SELF.Stacking.IFOnFalseSection = SELF.GetIFOnFalseSection()
  SELF.Stacking.SISection = SELF.GetSISection()
  SELF.Stacking.SIOnTrueSection = SELF.GetSIOnTrueSection()
  SELF.Stacking.SIOnFalseSection = SELF.GetSIOnFalseSection()
  SELF.Stacking.NoteName = SELF.GetNote()
  SELF.Stacking.DocName = SELF.GetDoc()
  SELF.Stacking.DocumentationName = SELF.GetDocumentation()
  SELF.Stacking.HelpName = SELF.GetHelp()
  SELF.Stacking.HelperName = SELF.GetHelper()
	SELF.Stacking.ErreurName = SELF.GetErreur()
  SELF.Stacking.ASSERTName = SELF.GetASSERT()
  SELF.Stacking.WarningName = SELF.GetWarning()
  SELF.Stacking.NotifyName = SELF.GetNotify()
  SELF.Stacking.NotificationName = SELF.GetNotification()
  
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.CreateDebugManager                 PROCEDURE(jcDebugManager Debug)
  CODE
    Debug &= NEW(jcDebugManager)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Restore                            PROCEDURE
  CODE
    !SELF.critSect.Wait()
?   IF SELF.GetAssertState(99) THEN
?     ASSERT(~SELF.Stack &= NULL,'The Stack reference to jcStackManager is not properly initialized')
?   END
    SELF.Stack.Pop()
    IF NOT SELF.Stack.isEmpty() THEN 
      DO RestoreShow
      DO RestoreSetup
    END  
    !SELF.critSect.Release()

!Restore the Setup State Values    
RestoreSetup ROUTINE
  SELF.Stacking = SELF.Stack.Top()
  SELF.SetThread(SELF.Stacking.Thread)
  SELF.SetNumberSpaceMargin(SELF.Stacking.NumberSpaceMargin)
  SELF.SetIndentSpaceMargin(SELF.Stacking.IndentSpaceMargin)
  SELF.SetShowWhat(SELF.Stacking.ShowWhat)
  SELF.SetShowWhom(SELF.Stacking.ShowWhom)
  SELF.CurrentShow = SELF.Stacking.CurrentShow
  SELF &= SELF.Stacking.sDebug

!Restore the Show according to the AreaType
RestoreShow   ROUTINE 
  SELF.SetHeader(SELF.Stacking.Header)
  SELF.SetComment(SELF.Stacking.Comment)
  SELF.SetDescription(SELF.Stacking.Description)
  SELF.SetApplicationName(SELF.Stacking.ApplicationName)
  SELF.SetProgramName(SELF.Stacking.ProgramName)
  SELF.SetProcedureName(SELF.Stacking.ProcedureName)
  SELF.SetClassName(SELF.Stacking.ClassName)
  SELF.SetMethodName(SELF.Stacking.MethodName)
  SELF.SetRoutineSection(SELF.Stacking.RoutineSection)
  SELF.SetCodeSection(SELF.Stacking.CodeSection)
  SELF.SetEmbedSection(SELF.Stacking.EmbedSection)
  SELF.SetEXECUTESection(SELF.Stacking.EXECUTESection)
	SELF.SetBEGINSection(SELF.Stacking.BEGINSection)
  SELF.SetCASESection(SELF.Stacking.CASESection)
  SELF.SetOFSection(SELF.Stacking.OFSection)
  SELF.SetLoopSection(SELF.Stacking.LoopSection)
  SELF.SetIFSection(SELF.Stacking.IFSection)
  SELF.SetIfOnTrueSection(SELF.Stacking.IfOnTrueSection)
  SELF.SetIfOnFalseSection(SELF.Stacking.IfOnFalseSection)
  SELF.SetSISection(SELF.Stacking.SISection)
  SELF.SetSIOnTrueSection(SELF.Stacking.SIOnTrueSection)
  SELF.SetSIOnFalseSection(SELF.Stacking.SIOnFalseSection)
  SELF.SetNote(SELF.Stacking.NoteName)
  SELF.SetDoc(SELF.Stacking.DocName)
  SELF.SetDocumentation(SELF.Stacking.DocumentationName)
  SELF.SetHelp(SELF.Stacking.HelpName)
  SELF.SetHelper(SELF.Stacking.HelperName)
  SELF.SetErreur(SELF.Stacking.ErreurName)
  SELF.SetAssert(SELF.Stacking.ASSERTName)
  SELF.SetWarning(SELF.Stacking.WarningName)
  SELF.SetNotify(SELF.Stacking.NotifyName)
  SELF.SetNotification(SELF.Stacking.NotificationName)
    
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetRestoreDebugState PROCEDURE (*BOOL DebugState)  !Set Restore DebugState
!!critProc                              CriticalProcedure
  CODE
  !critProc.Init(SELF.critSect)
  !IF SELF.GetDebugState() = FALSE THEN  RETURN.
    DebugState = TRUE
    IF SELF.GetDebugState() = FALSE THEN  
      DebugState = FALSE
      SELF.SetDebugState(TRUE)
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.CheckRestoreDebugState   PROCEDURE (*BOOL DebugState) ! Check the currrent DebugState
!!critProc                                  CriticalProcedureGe
  CODE
    !critProc.Init(SELF.critSect)
    IF DebugState = FALSE THEN SELF.SetDebugState(FALSE).
!-----------------------------------------------------------------------------------------------------------------------------------
!jcDebugManager Section Shows Setter and Getter
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetNote  PROCEDURE(ASTRING NoteName)

  CODE
    !SELF.critSect.Wait()
    SELF.NoteName = NoteName
    SELF.Add(jcDebug::Note,SELF.GetNote())
    !SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetNote  PROCEDURE
!!critProc                  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.NoteName

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetDoc  PROCEDURE(ASTRING DocName)

  CODE
    !SELF.critSect.Wait()
    SELF.DocName = DocName
    SELF.Add(jcDebug::Doc,SELF.GetDoc())
    !SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetDoc  PROCEDURE
!!critProc                  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.DocName

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetDocumentation  PROCEDURE(ASTRING DocumentationName)

  CODE
    !SELF.critSect.Wait()
    SELF.DocumentationName = DocumentationName
    SELF.Add(jcDebug::Documentation,SELF.GetDocumentation())
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetDocumentation  PROCEDURE
!!critProc                  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.DocumentationName
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetHelp  PROCEDURE(ASTRING HelpName)

  CODE
    !SELF.critSect.Wait()
    SELF.HelpName = HelpName
    SELF.Add(jcDebug::Help,SELF.GetHelp())
    !SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetHelp  PROCEDURE
!!critProc                  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.HelpName

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetHelper  PROCEDURE(ASTRING HelperName)

  CODE
    !SELF.critSect.Wait()
    SELF.HelperName = HelperName
    SELF.Add(jcDebug::Helper,SELF.GetHelper())
    !SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetHelper  PROCEDURE
!!critProc                  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.HelperName

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetHeader    PROCEDURE(ASTRING Header)

  CODE
    !SELF.critSect.Wait()
    SELF.Header = Header
    SELF.Add(jcDebug::Header,SELF.GetHeader())
    !SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetHeader    PROCEDURE
!!critProc                      CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.Header

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetComment   PROCEDURE(ASTRING Comment)

  CODE
    !SELF.critSect.Wait()
    SELF.Comment = Comment
    SELF.Add(jcDebug::Comment,SELF.GetComment())
    !SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetComment   PROCEDURE
!!critProc                      CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.Comment

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetDescription                            PROCEDURE(ASTRING Description)
  CODE
    !SELF.critSect.Wait()
    SELF.Description = Description
    SELF.Add(jcDebug::Description,SELF.GetDescription())
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetDescription                            PROCEDURE
!!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.Description
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetErreur  PROCEDURE(ASTRING ErreurName)

  CODE
	!SELF.critSect.Wait()
	SELF.ErreurName = ErreurName
	SELF.Add(jcDebug::Erreur,SELF.GetErreur())
	!SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetErreur  PROCEDURE
!!critProc                  CriticalProcedure

  CODE
	!critProc.Init(SELF.critSect)
	RETURN SELF.ErreurName

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetAssert  PROCEDURE(ASTRING AssertName)

  CODE
	!SELF.critSect.Wait()
	SELF.AssertName = AssertName
	SELF.Add(jcDebug::Assert,SELF.GetAssert())
	!SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetAssert  PROCEDURE
!!critProc                  CriticalProcedure

  CODE
	!critProc.Init(SELF.critSect)
	RETURN SELF.AssertName

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetWarning  PROCEDURE(ASTRING WarningName)

  CODE
	!SELF.critSect.Wait()
	SELF.WarningName = WarningName
	SELF.Add(jcDebug::Warning,SELF.GetWarning())
	!SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetWarning  PROCEDURE
!!critProc                  CriticalProcedure

  CODE
	!critProc.Init(SELF.critSect)
	RETURN SELF.WarningName

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetNotify  PROCEDURE(ASTRING NotifyName)

  CODE
	!SELF.critSect.Wait()
	SELF.NotifyName = NotifyName
	SELF.Add(jcDebug::Notify,SELF.GetNotify())
	!SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetNotify  PROCEDURE
!!critProc                  CriticalProcedure

  CODE
	!critProc.Init(SELF.critSect)
	RETURN SELF.NotifyName

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetNotification  PROCEDURE(ASTRING NotificationName)

  CODE
	!SELF.critSect.Wait()
	SELF.NotificationName = NotificationName
	SELF.Add(jcDebug::Notification,SELF.GetNotification())
	!SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetNotification  PROCEDURE
!!critProc                  CriticalProcedure

  CODE
	!critProc.Init(SELF.critSect)
	RETURN SELF.NotificationName

!-----------------------------------------------------------------------------------------------------------------------------------
!jcDebugManager Section Shows
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Application  PROCEDURE (ASTRING ApplicationName,<ASTRING Parameter>,<BYTE Show>,<SHORT SpaceMargin>)  !Set Applicationt it check for margin Set the ApplicationName and ApplicationStart
  CODE
    !SELF.critSect.Wait()
   	SELF.SetThread(THREAD())
    SELF.SetApplicationName(ApplicationName,Parameter)
    IF NOT OMITTED(4) THEN
      SELF.PrepareShow(jcDebug::ApplicationShow,SELF.GetApplicationName(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::ApplicationShow,SELF.GetApplicationName())
    END
    SELF.ShowStart(jcDebug::Application,CLIP(SELF.GetApplicationName()) & jcDebug::Space & jcDebug::Thread & jcDebug::Colon & SELF.GetThread(),SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Programme    PROCEDURE (ASTRING ProgramName,<ASTRING Parameter>,<BYTE Show>,<SHORT SpaceMargin>)  !Set Program it check for margin Set the ProgramName and ProgramStart
  CODE
    !SELF.critSect.Wait()
   	SELF.SetThread(THREAD())
    SELF.SetProgramName(ProgramName,Parameter)
    IF NOT OMITTED(4) THEN
      SELF.PrepareShow(jcDebug::ProgramShow,SELF.GetProgramName(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::ProgramShow,SELF.GetProgramName())
    END
    SELF.ShowStart(jcDebug::Program,CLIP(SELF.GetProgramName()) & jcDebug::Space & jcDebug::Thread & jcDebug::Colon & SELF.GetThread(),SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Classe   PROCEDURE(ASTRING ClassName,<BYTE Show>,<SHORT SpaceMargin>)

  CODE
    !SELF.critSect.Wait()
    SELF.SetClassName(ClassName)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::ClassShow,SELF.GetClassName(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::ClassShow,SELF.GetClassName())
    END
    SELF.ShowStart(jcDebug::Class,SELF.GetClassName(),SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.MethodShow   PROCEDURE (ASTRING MethodNamePar,<ASTRING PrototypePar>,BYTE ShowPar,ASTRING PromptPar,ASTRING ValuePar)
!critProc                      CriticalProcedure
MethodName                    EQUATE('MethodShow')
Prototype                     EQUATE('(ASTRING MethodName,<ASTRING Prototype>,BYTE Show,ASTRING Prompt,ASTRING Value)')

  CODE
    !critProc.Init(SELF.critSect)
    SELF.Method(MethodNamePar,PrototypePar,ShowPar)
      SELF.ShowCurrentMethodValue(PromptPar,ValuePar)
    SELF.Fin()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Method   PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BYTE Show>,<SHORT SpaceMargin>)  !Set Method it check for margin Set the MethodName and MethodStart
!critProc                  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
   	SELF.SetThread(THREAD())
    IF OMITTED(3) THEN Prototype = '()'.
    SELF.SetMethodName(MethodName,Prototype,jcBases::ProtoType2)
    IF NOT OMITTED(4) THEN
      SELF.PrepareShow(jcDebug::MethodShow,SELF.GetMethodName(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::MethodShow,SELF.GetMethodName())
    END
    SELF.ShowStart(jcDebug::Method,CLIP(SELF.GetMethodName())& jcDebug::Space & jcDebug::Thread & jcDebug::Colon & SELF.GetThread(),SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Proc PROCEDURE(ASTRING ProcedureName,<ASTRING Prototype>,<BYTE Show>,<SHORT SpaceMargin>)
!critProc              CriticalProcedure
SetProtoType          BYTE

  CODE
    !critProc.Init(SELF.critSect)
   	SELF.SetThread(THREAD())
    !IF LEN(Prototype) = 0 THEN Prototype = '()'.
    IF OMITTED(3) THEN 
      SetProtoType = jcBases::ProtoType3
      !Prototype = '()' 
    ELSE 
      SetProtoType = jcBases::ProtoType2
    END
    SELF.SetProcedureName(ProcedureName,Prototype,SetProtoType)
    IF NOT OMITTED(4) THEN
      SELF.PrepareShow(jcDebug::ProcedureShow,SELF.GetProcedureName(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::ProcedureShow,SELF.GetProcedureName())  
    END
    SELF.ShowStart(jcDebug::Procedure,CLIP(SELF.GetProcedureName()) & jcDebug::Space & jcDebug::Thread & jcDebug::Colon & SELF.GetThread(),SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Doc PROCEDURE(ASTRING DocName,<BYTE Show>,<SHORT SpaceMargin>)

  CODE
    !SELF.critSect.Wait()
    SELF.SetDoc(DocName)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::DocShow,SELF.GetDoc(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::DocShow,SELF.GetDoc())
    END
    SELF.ShowStart(jcDebug::Doc,SELF.GetDoc(),SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Documentation PROCEDURE(ASTRING DocumentationName,<BYTE Show>,<SHORT SpaceMargin>)

  CODE
    !SELF.critSect.Wait()
    SELF.SetDocumentation(DocumentationName)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::DocumentationShow,SELF.GetDocumentation(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::DocumentationShow,SELF.GetDocumentation())
    END
    SELF.ShowStart(jcDebug::Documentation,SELF.GetDocumentation(),SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Help PROCEDURE(ASTRING HelpName,<BYTE Show>,<SHORT SpaceMargin>)

  CODE
    !SELF.critSect.Wait()
    SELF.SetHelp(HelpName)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::HelpShow,SELF.GetHelp(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::HelpShow,SELF.GetHelp())
    END
    SELF.ShowStart(jcDebug::Help,SELF.GetHelp(),SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Helper PROCEDURE(ASTRING HelperName,<BYTE Show>,<SHORT SpaceMargin>)

  CODE
    !SELF.critSect.Wait()
    SELF.SetHelper(HelperName)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::HelperShow,SELF.GetHelper(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::HelperShow,SELF.GetHelper())
    END
    SELF.ShowStart(jcDebug::Helper,SELF.GetHelper(),SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Note   PROCEDURE(ASTRING NoteName,<BYTE Show>,<SHORT SpaceMargin>)

  CODE
    !SELF.critSect.Wait()
    SELF.SetNote(NoteName)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::NoteShow,SELF.GetNote(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::NoteShow,SELF.GetNote())
    END
    SELF.ShowStart(jcDebug::Note,SELF.GetNote(),SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Headers  PROCEDURE (ASTRING Header,<BYTE Show>,<SHORT SpaceMargin>)  !Show to Debug View the beginning of the Header. if used as a function then if the status the HeaderSection is _Show = 1 then HeaderStart() is shown and return TRUE otherwise is not shown and return FALSE

  CODE
    !SELF.critSect.Wait()
    SELF.SetHeader(Header)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::HeaderShow,SELF.GetHeader(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::HeaderShow,SELF.GetHeader())
    END
    SELF.ShowStart(jcDebug::Header,SELF.GetHeader(),SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Comments PROCEDURE (ASTRING Comment,<BYTE Show>,<SHORT SpaceMargin>)  !Show to Debug View the beginning of the Comment. if used as a function then if the status the CommentSection is _Show = 1 then CommentStart() is shown and return TRUE otherwise is not shown and return FALSE
 
  CODE
    !SELF.critSect.Wait()
    SELF.SetComment(Comment)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::CommentShow,SELF.GetComment(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::CommentShow,SELF.GetComment())
    END
    SELF.ShowStart(jcDebug::Comment,SELF.GetComment(),SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Descriptions PROCEDURE (ASTRING Description,<BYTE Show>,<SHORT SpaceMargin>)   !Show to Debug View the beginning of the Description. if used as a function then if the status the DescriptionSection is _Show = 1 then DescriptionStart() is shown and return TRUE otherwise is not shown and return FALSE

  CODE
    !SELF.critSect.Wait()
    SELF.SetDescription(Description)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::DescriptionShow,SELF.GetDescription(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::DescriptionShow,SELF.GetDescription())
    END
    SELF.ShowStart(jcDebug::Description,SELF.GetDescription(),SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Routines PROCEDURE(ASTRING RoutineSection,<BYTE Show>,<SHORT SpaceMargin>)

  CODE
    !SELF.critSect.Wait()
    SELF.SetRoutineSection(RoutineSection)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::RoutineShow,SELF.GetRoutineSection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::RoutineShow,SELF.GetRoutineSection())
    END
    SELF.ShowStart(jcDebug::Routine,SELF.GetRoutineSection(),SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Codes    PROCEDURE(ASTRING CodeSection,<BYTE Show>,<SHORT SpaceMargin>)

  CODE
    !SELF.critSect.Wait()
    SELF.SetCodeSection(CodeSection)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::CodeShow,SELF.GetCodeSection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::CodeShow,SELF.GetCodeSection())
    END
    SELF.ShowStart(jcDebug::Code,SELF.GetCodeSection(),SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Embed    PROCEDURE(ASTRING EmbedSection,<BYTE Show>,<SHORT SpaceMargin>)    !Start of embed section

  CODE
    !SELF.critSect.Wait()
    SELF.SetEmbedSection(EmbedSection)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::EmbedShow,SELF.GetEmbedSection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::EmbedShow,SELF.GetEmbedSection())
    END
    SELF.ShowStart(jcDebug::Embed,EmbedSection,SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.EXECUTEs    PROCEDURE(ASTRING EXECUTESection,<BYTE Show>,<SHORT SpaceMargin>)    !Start of EXECUTE section

  CODE
	!SELF.critSect.Wait()
	SELF.SetEXECUTESection(EXECUTESection)
	IF NOT OMITTED(3) THEN
	  SELF.PrepareShow(jcDebug::EXECUTEShow,SELF.GetEXECUTESection(),Show)
	ELSE
	  SELF.PrepareShow(jcDebug::EXECUTEShow,SELF.GetEXECUTESection())
	END
	SELF.ShowStart(jcDebug::EXECUTE,EXECUTESection,SpaceMargin)
	!SELF.critSect.Release()
	RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.BEGINs    PROCEDURE(ASTRING BEGINSection,<BYTE Show>,<SHORT SpaceMargin>)    !Start of BEGIN section

  CODE
	!SELF.critSect.Wait()
	SELF.SetBEGINSection(BEGINSection)
	IF NOT OMITTED(3) THEN
	  SELF.PrepareShow(jcDebug::BEGINShow,SELF.GetBEGINSection(),Show)
	ELSE
	  SELF.PrepareShow(jcDebug::BEGINShow,SELF.GetBEGINSection())
	END
	SELF.ShowStart(jcDebug::BEGIN,BEGINSection,SpaceMargin)
	!SELF.critSect.Release()
	RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.CASEs    PROCEDURE(ASTRING CASESection,<BYTE Show>,<SHORT SpaceMargin>)    !Start of CASE section

  CODE
    !SELF.critSect.Wait()
    SELF.SetCASESection(CASESection)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::CASEShow,SELF.GetCASESection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::CASEShow,SELF.GetCASESection())
    END
    SELF.ShowStart(jcDebug::CASE,CASESection,SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.OFs    PROCEDURE(ASTRING OFSection,<BYTE Show>,<SHORT SpaceMargin>)    !Start of OF section

  CODE
    !SELF.critSect.Wait()
    SELF.SetOFSection(OFSection)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::OFShow,SELF.GetOFSection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::OFShow,SELF.GetOFSection())
    END
    SELF.ShowStart(jcDebug::OF,OFSection,SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Loops    PROCEDURE(ASTRING LoopSection,<BYTE Show>,<SHORT SpaceMargin>)    !Start of Loop section

  CODE
    !SELF.critSect.Wait()
    IF INSTRING('LOOP',LoopSection,1,1) THEN
      SELF.SetLoopSection(LoopSection)
    ELSE
      SELF.SetLoopSection('LOOP ' & LoopSection)
    END
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::LoopShow,SELF.GetLoopSection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::LoopShow,SELF.GetLoopSection())
    END
    SELF.ShowStart(jcDebug::Loop,SELF.GetLoopSection(),SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.IFs  PROCEDURE(ASTRING IFSection,<BYTE Show>,<SHORT SpaceMargin>,<BOOL IFsState>)    !Start of IF section
ifSectionString       ASTRING

  CODE
    !SELF.critSect.Wait()
    IF INSTRING('IF',IFSection,1,1) THEN
      SELF.SetIFSection(IFSection)
    ELSE
      ifSectionString = 'IF ' & IFSection & ' THEN'
      SELF.SetIFSection(ifSectionString)
    END
    SELF.SetIfOnTrueSection(SELF.GetIFSection())
    SELF.SetIfOnFalseSection(SELF.GetIFSection())
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::IFShow,SELF.GetIFSection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::IFShow,SELF.GetIFSection())
    END
    SELF.ShowStart(jcDebug::IF,SELF.GetIFSection(),SpaceMargin)
    !SELF.critSect.Release()
    RETURN IFsState
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.IFOnTrue PROCEDURE(<BYTE Show>,<SHORT SpaceMargin>)    !Start of IFOnTrue section

  CODE
    !SELF.critSect.Wait()
    SELF.SetIFOnTrueSection(SELF.stacking.IFSection)
    !IFOnTrue SELF.GetDebugState() = FALSE THEN  RETURN FALSE.
    IF NOT OMITTED(2) THEN
      SELF.PrepareShow(jcDebug::IFOnTrueShow,SELF.GetIFOnTrueSection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::IFOnTrueShow,SELF.GetIFOnTrueSection())
    END
    SELF.ShowStart(jcDebug::IFOnTrue,SELF.GetIfOnTrueSection(),SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.IFOnFalse    PROCEDURE(<BYTE Show>,<SHORT SpaceMargin>)    !Start of IFOnFalse section

  CODE
    !SELF.critSect.Wait()
    SELF.SetIfOnFalseSection(SELF.stacking.IFSection)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::IFOnFalseShow,SELF.GetIFOnFalseSection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::IFOnFalseShow,SELF.GetIFOnFalseSection())
    END
    SELF.ShowStart(jcDebug::IFOnFalse,SELF.GetIfOnFalseSection(),SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SI    PROCEDURE(ASTRING SISection,<BYTE Show>,<SHORT SpaceMargin>,<BOOL SiState>)    !Start of embed section

  CODE
    !SELF.critSect.Wait()
    SELF.SetSISection(SISection)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::SIShow,SELF.GetSISection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::SIShow,SELF.GetSISection())
    END
    SELF.ShowStart(jcDebug::SIShow,SISection,SpaceMargin)
    !SELF.critSect.Release()
    RETURN SiState
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SIOnTrue    PROCEDURE(<ASTRING SIOnTrueSection>,<BYTE Show>,<SHORT SpaceMargin>)    !Start of embed section

  CODE
    !SELF.critSect.Wait()
    SELF.SetSIOnTrueSection(SIOnTrueSection)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::SIOnTrueShow,SELF.GetSIOnTrueSection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::SIOnTrueShow,SELF.GetSIOnTrueSection())
    END
    SELF.ShowStart(jcDebug::SIOnTrueShow,SIOnTrueSection,SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SIOnFalse    PROCEDURE(<ASTRING SIOnFalseSection>,<BYTE Show>,<SHORT SpaceMargin>)    !Start of embed section

  CODE
    !SELF.critSect.Wait()
    SELF.SetSIOnFalseSection(SIOnFalseSection)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::SIOnFalseShow,SELF.GetSIOnFalseSection(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::SIOnFalseShow,SELF.GetSIOnFalseSection())
    END
    SELF.ShowStart(jcDebug::SIOnFalseShow,SIOnFalseSection,SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Erreur PROCEDURE(ASTRING ErreurName,<BYTE Show>,<SHORT SpaceMargin>)

  CODE
	!SELF.critSect.Wait()
	SELF.SetErreur(ErreurName)
	IF NOT OMITTED(3) THEN
	  SELF.PrepareShow(jcDebug::ErreurShow,SELF.GetErreur(),Show)
	ELSE
	  SELF.PrepareShow(jcDebug::ErreurShow,SELF.GetErreur())
	END
	SELF.ShowStart(jcDebug::Erreur,SELF.GetErreur(),SpaceMargin)
	!SELF.critSect.Release()
  RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Asserts    PROCEDURE(ASTRING AssertName,<BYTE Show>,<SHORT SpaceMargin>)    !Start Assert Assert section

  CODE
    !SELF.critSect.Wait()
    SELF.SetAssert(AssertName)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::AssertShow,SELF.GetAssert(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::AssertShow,SELF.GetAssert())
    END
    SELF.ShowStart(jcDebug::Assert,AssertName,SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Warning    PROCEDURE(ASTRING WarningName,<BYTE Show>,<SHORT SpaceMargin>)    !Start Warning Warning section

  CODE
    !SELF.critSect.Wait()
    SELF.SetWarning(WarningName)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::WarningShow,SELF.GetWarning(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::WarningShow,SELF.GetWarning())
    END
    SELF.ShowStart(jcDebug::Warning,WarningName,SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Notify    PROCEDURE(ASTRING NotifyName,<BYTE Show>,<SHORT SpaceMargin>)    !Start Notify Notify section

  CODE
    !SELF.critSect.Wait()
    SELF.SetNotify(NotifyName)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::NotifyShow,SELF.GetNotify(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::NotifyShow,SELF.GetNotify())
    END
    SELF.ShowStart(jcDebug::Notify,NotifyName,SpaceMargin)
    !SELF.critSect.Release()
    RETURN SELF.GetCurrentShow()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Notification    PROCEDURE(ASTRING NotificationName,<BYTE Show>,<SHORT SpaceMargin>)    !Start Notification Notification section

  CODE
    !SELF.critSect.Wait()
    SELF.SetNotification(NotificationName)
    IF NOT OMITTED(3) THEN
      SELF.PrepareShow(jcDebug::NotificationShow,SELF.GetNotification(),Show)
    ELSE
      SELF.PrepareShow(jcDebug::NotificationShow,SELF.GetNotification())
    END
    SELF.ShowStart(jcDebug::Notification,NotificationName,SpaceMargin)
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
!jcDebugManager function and procedures utilities    
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.CheckSelectiveShow                 PROCEDURE(ASTRING AreaType,ASTRING Area)
SelectShow  ASTRING
Response    BOOL
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    SelectShow = AreaType & jcDebug::Dot & Area
    IF SELF.GetSelectiveShow() THEN
      IF SelectShow = SELF.SelectShow THEN
        Response = TRUE
      ELSIF SelectShow = AreaType THEN
        Response = TRUE
      ELSIF SelectShow = Area THEN
        Response = TRUE
      ELSE
        Response = FALSE
      END
    ELSE
      Response = TRUE     
    END
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.PrepareShow                        PROCEDURE (ASTRING AreaType,ASTRING Area,<BYTE Show>)
Currently           BOOL
MethodPrepareShow   EQUATE(1)
Info                CSTRING(251)
  CODE
    !SELF.critSect.Wait()
    IF NOT SELF.CheckSelectiveShow(AreaType,Area) THEN RETURN.
    DO Check_CurrentShow   !Be carefull to not put a question mark on column one on this statement. If we are not in debug mode the DebugManager will not work
    !SELF.critSect.Wait()
    SELF.SetCurrentShow(AreaType,Area)
    Area = SELF.CurrentShow
    IF Currently = _Show THEN      
      SELF.SetShow(Area,Currently)
    ELSE
      SELF.SetShow(Area,_Hide)  
    END 
    IF NOT SELF.GetRespectingAreaShow() THEN
      IF NOT OMITTED(4) THEN SELF.SetShow(Area,Show).
    END
    !SELF.critSect.Release()
    
Check_CurrentShow           ROUTINE
  !SELF.critSect.Wait()
  IF SELF.CurrentShow <> '' OR LEN(SELF.CurrentShow) > 0 THEN                 !If there's CurrentShow set Currently to the value from GetCurrentShow
    Currently = SELF.GetCurrentShow()
  ELSE
    SELF.SetCurrentShow(SELF.CurrentShow,_Show)
    Currently = _Show                               !Otherwise make sure currently show
  END  
  !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetShow                            PROCEDURE(ASTRING Area,BOOL Value)
Info        CSTRING(251)
  CODE
    !SELF.critSect.Wait()
    IF LEN(Area) > 0 THEN
      IF SELF.Get(Area) = jcBases::Error THEN
        SELF.Add(Area,Value)
      ELSE
        SELF.Put(Area,Value)
      END
    END
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetShow                            PROCEDURE(ASTRING Area)
Response BOOL
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    Response = SELF.Get(Area)
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetjustStarted                     PROCEDURE(BOOL justStarted)         !Set the private justStarted property
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    SELF.justStarted = justStarted
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetjustStarted                     PROCEDURE()                         !Get the private justStarted property
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.justStarted
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetjustEnded                       PROCEDURE(BOOL justEnded)           !Set the private justEnded property
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    SELF.justEnded = justEnded
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetjustEnded                       PROCEDURE()                         !Get the private justEnded property
!critProc  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.justEnded

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetCurrentAreaType                 PROCEDURE(ASTRING CurrentAreaType)     !Set the private CurrentAreaType property
!critProc  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    SELF.CurrentAreaType = CurrentAreaType
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetCurrentAreaType                 PROCEDURE()                         !Get the private CurrentAreaType property
!critProc  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.CurrentAreaType

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetCurrentShow                     PROCEDURE(ASTRING AreaType,<ASTRING Area>)

  CODE
    !SELF.critSect.Wait()
    DO Check_Show_isCurrentShow
    DO Check_AreaType_ifExist
    !SELF.critSect.Wait()
    SELF.CurrentShow = AreaType & jcDebug::Dot & Area
    IF SELF.Get(AreaType) = FALSE THEN
      SELF.SetShow(SELF.CurrentShow,_Hide)            !The AreaType is inactive the dependant currentShow Area is hiden
    END
    SELF.SetCurrentAreaType(AreaType)
    !SELF.critSect.Release()

Check_AreaType_ifExist  ROUTINE
  !SELF.critSect.Wait()
  IF SELF.Get(AreaType) = jcDebug::Error THEN
?   IF SELF.GetAssertState(0) THEN
?     ASSERT(A#=TRUE,'Area Type not found in the base table')        
?   END
    SELF.SetShow(AreaType,TRUE)
  END
  !SELF.critSect.Release()

Check_Show_isCurrentShow    ROUTINE
  !SELF.critSect.Wait()
  IF SELF.CurrentShow = jcDebug::Show THEN  ! Set by Show() method to keep the current margin
                                            !use by See() and Show() if we Show the CurrentShow 
                                            !if CurrentShow = Show then See() will show the current show
    SELF.Showed = TRUE                      !used by SetNumberSpaceMargin in ShowStart when the CurrentShow = 'Show' 
                                            !Still need some thinking again to solve the spaceMargin when the Current Show 
                                            !do not want to embed an additional or fewer spaceMargin or leave as it is
  END  
  !SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetCurrentShow                     PROCEDURE()
Response  BOOL
Info      CSTRING(251)
!critProc  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    Response = SELF.Get(SELF.CurrentShow)
    RETURN Response

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetSelectiveShow                      PROCEDURE(<ASTRING AreaType>,<ASTRING Area>,<BYTE Type>)

  CODE
    !SELF.critSect.Wait()
    IF NOT OMITTED(4) THEN
      EXECUTE Type
        SELF.SelectShow = AreaType & jcDebug::Dot & Area
        SELF.SelectShow = AreaType
        SELF.SelectShow = Area
      END
    ELSE
      IF OMITTED(2) THEN
        SELF.SelectShow = Area
      END
      IF OMITTED(3) THEN
        SELF.SelectShow = AreaType
      END
      IF NOT OMITTED(2) AND NOT OMITTED(3) THEN  
        SELF.SelectShow = AreaType & jcDebug::Dot & Area  
      END
    END
    !SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetSelectShow                         PROCEDURE(<ASTRING AreaType>,<ASTRING Area>)
!critProc  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    SELF.SelectShow = AreaType & jcDebug::Dot & Area  

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetSelectiveShow                      PROCEDURE(BOOL SelectiveShow)
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    SELF.SelectiveShow = SelectiveShow
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetSelectiveShow                      PROCEDURE()
!critProc                                                CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN CHOOSE(SELF.SelectiveShow = TRUE,TRUE,FALSE)
    
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.See 								  PROCEDURE(<STRING Info>,<SHORT SpaceMargin>)    !See the line of of info to DebugView
DebugAction                           BYTE
DebugInfo                             CSTRING(251)
NumberSpaceMargin                     SHORT
Infos                                 CSTRING(251)
ShowMore                              BOOL
Showing                               BOOL

  CODE    
    !SELF.critSect.Wait()
    DO SetMargin
    DO EvaluateDebugAction
    IF Showing THEN DO SendShow.
    !SELF.critSect.Release()

SetMargin           ROUTINE
  !SELF.critSect.Wait()
  NumberSpaceMargin = SpaceMargin
  IF NumberSpaceMargin <> 0 THEN
    SELF.CheckSpaceMargin(NumberSpaceMargin,SpaceMargin)
  ELSE
    NumberSpaceMargin = SELF.GetNumberSpaceMargin()
  END  
  !SELF.critSect.Release()

EvaluateDebugAction ROUTINE
  !SELF.critSect.Wait()
  ShowMore = TRUE
  DebugAction = SELF.GetDebugState()
  !SELF.critSect.Wait()
  IF SELF.GetSelectiveShow() THEN
    IF SELF.SelectShow = SELF.CurrentShow THEN
      DebugAction = SELF.GetCurrentShow()
      Showing = TRUE
    ELSIF SELF.SelectShow = SELF.CurrentAreaType THEN
      DebugAction = SELF.GetShow(SELF.GetCurrentAreaType())
      Showing = TRUE
    END
    IF INSTRING(jcDebug::HeaderShow,SELF.CurrentShow,1,1)
      DebugAction = SELF.GetCurrentShow()
      Showing = TRUE
    ELSIF INSTRING(jcDebug::CommentShow,SELF.CurrentShow,1,1)
      DebugAction = SELF.GetCurrentShow()
      Showing = TRUE
    END
    ShowMore = FALSE
  END    
  !SELF.critSect.Release()
  IF ShowMore THEN
    IF DebugAction THEN
      DebugAction = SELF.GetCurrentShow()
    END
    IF DebugAction THEN
      DebugAction = SELF.GetShow(SELF.GetCurrentAreaType())
    END
    Showing = TRUE
  END  
  !SELF.critSect.Release()

CheckDebugAction    ROUTINE
    MESSAGE('DebugAction is ' & DebugAction |
            &  '|MethodName ' & SELF.GetMethodName() |
            & '|Prototype ' & SELF.GetParameterString() |
            & '|MethodShow ' & SELF.GetShow(SELF.GetCurrentAreaType())|
            & '|Showing is ' & Showing |
            & '|ShowMore is ' & ShowMore)

SendShow            ROUTINE
  !SELF.critSect.Wait()
  DebugInfo = ALL(' ',NumberSpaceMargin) & Info 
  IF DebugAction THEN      
    IF OMITTED(2) THEN
      DebugInfo = ' '
    END
    IF SELF.Log.Get() THEN
      SELF.Log.AddLine(DebugInfo)
    END
    IF SELF.DoDebugPrefix THEN
      DebugInfo = SELF.DebugPrefix & DebugInfo
    END
    SendToDebug(DebugInfo)    
  END  
  !SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ShowStart    PROCEDURE (ASTRING ShowWhat,ASTRING ShowWhom,SHORT SpaceMargin) !ShowStart of whom
NumberSpaceMargin             SHORT
Info                          CSTRING(251)

  CODE  
    !SELF.critSect.Wait()
    SELF.SetjustStarted(TRUE)
    SELF.AreaCondition = _Started
    SELF.SetMargin(NumberSpaceMargin,SpaceMargin)
    IF SELF.GetOverrideSpaceMargin() <> 0 THEN 
      SELF.SetNumberSpaceMargin(SELF.GetOverrideSpaceMargin())
    ELSE
      SELF.SetNumberSpaceMargin(NumberSpaceMargin)
    END
    !SELF.critSect.Wait()
    IF SELF.GetClassName() = '' AND SELF.GetMethodName() <> '' THEN 
      SELF.SetClassName('UnAssignedClass = Call ''Class.SetClassName(''ClassName'')')
    END  
    SELF.SeeStart(ShowWhat,ShowWhom)
    SELF.SetShowWhat(ShowWhat)
    SELF.SetShowWhom(ShowWhom)
    SELF.Save()
    IF SELF.Showed THEN
      SELF.SetNumberSpaceMargin(NumberSpaceMargin)
      SELF.Showed = FALSE
    ELSE
      SELF.SetNumberSpaceMargin(NumberSpaceMargin+SELF.GetIndentSpaceMargin())
    END
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ShowEnd  PROCEDURE (ASTRING ShowWhat,ASTRING ShowWhom) !Show End of whom
RestoreDebugState         BOOL
s                         CSTRING(251)
!critProc                  CriticalProcedure
isEmpty                   LONG(FALSE)

  CODE
    !critProc.Init(SELF.critSect)
    SELF.SetjustEnded(TRUE) !NOT USED YET WORK IN PROGRESS
   !Les méthodes SetRestoreDebugState(RestoreDebugState) et SELF.CheckRestoreDebugState(RestoreDebugState) sont utilisées seulement
    !dans la méthode ShowEnd() je remarque qu'il est inutile d'utiliser ces méthodes, car lorsque je les utilises 
    !et le DebugState est désactivé nous avons toujours le END des sections qui apparaient dans DebugView. En enlevant ces instructions 
    !le problème est résolu. Je remarque avec tous le développement qui s'est fait ils sont devenus vains de les utilisées. 
    !!SELF.SetRestoreDebugState(RestoreDebugState) Je crois que SetRestoreDebugState est inutile je pense à supprimer cette méthode
    SELF.SetNumberSpaceMargin(SELF.Stacking.NumberSpaceMargin)
?   IF SELF.GetAssertState(1) AND ShowWhom = '' THEN
      isEmpty = TRUE
?     ASSERT(isEmpty=TRUE,'Show Whom parameter is empty')      
?   END    
    IF LEN(ShowWhom) > 0 THEN ! Used as a check for a not Showing the End of a Section used for SetShow(<Section>,FALSE)
      SELF.SeeEnd(ShowWhat,ShowWhom)
    END
    SELF.AreaCondition = _Ended
    SELF.Restore()
    
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetShowWhat  PROCEDURE(ASTRING What)!,PROTECTED                                !SetShowWhat save the current ShowWhat parameter of ShowStart, it will be later used by ShowEnd method this way we can use only and End method for all the areas.
!critProc                      CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    SELF.ShowWhat = What
    
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetShowWhat  PROCEDURE()!,ASTRING,PROTECTED                                    !GetShowWhat return the current ShowWhat
!critProc                      CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.ShowWhat
    
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetShowWhom  PROCEDURE(ASTRING Whom)!,PROTECTED                                !SetShowWhat save the current ShowWhat parameter of ShowStart, it will be later used by ShowEnd method this way we can use only and End method for all the areas.
!critProc                      CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    SELF.ShowWhom = Whom
    
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetShowWhom  PROCEDURE()!,ASTRING,PROTECTED                        !GetShowWhat return the current ShowWhat
!critProc                      CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.ShowWhom
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Halt PROCEDURE()!,VIRTUAL                                              !Ending the current section

  CODE
    SELF.Fin()
    
!-----------------------------------------------------------------------------------------------------------------------------------    
jcDebugManager.Fin  PROCEDURE()!,VIRTUAL                        !Ending the current section

  CODE
    !SELF.critSect.Wait()
    SELF.ShowEnd(SELF.GetShowWhat(),SELF.GetShowWhom())
    !SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------    
jcDebugManager.Fin    PROCEDURE(*BYTE ConditionalEnd)!,VIRTUAL                        !Ending the current section

  CODE
    !SELF.critSect.Wait()
    IF ConditionalEnd=TRUE THEN
      SELF.ShowEnd(SELF.GetShowWhat(),SELF.GetShowWhom())
      ConditionalEnd = FALSE
 	  END
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------    
jcDebugManager.SeeStart PROCEDURE (ASTRING SeeWhat,ASTRING SeeWhom)         !Show the start of whom
!critProc                  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    SELF.See(jcDebug::OpenBracket & jcDebug::Start & jcDebug::Space & SeeWhat & jcDebug::Colon & jcDebug::Space & SeeWhom & jcDebug::CloseBracket)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SeeEnd   PROCEDURE (ASTRING SeeWhat,ASTRING SeeWhom)         !Show the end of whom
!critProc                  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    SELF.See(jcDebug::OpenBracket & jcDebug::End & ALL(jcDebug::Space,3) & SeeWhat & jcDebug::Colon & jcDebug::Space & SeeWhom & jcDebug::CloseBracket)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ShowHeader   PROCEDURE (ASTRING HeaderString,<USHORT Type>,<BYTE Show>)       !Show an header string according to a type format.
SidesChar                     ASTRING
HeaderSize                    ULONG
Repetition                    ULONG
SidesLength                   ULONG
Character                     ASTRING
!critProc                      CriticalProcedure

			OMIT('!ShowHeaderDoc!')
The following possible header returned by the procedure jcDebugManager.ShowHeader			
jcDebugManager.ShowHeader(1)
Type 1
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: SetupSan ROUTINE ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

jcDebugManager.ShowHeader(2)
Type 2 
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: TESTTRIGGEROFFHASTODO ROUTINE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

jcDebugManager.ShowHeader(3)
Type 3
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: ENDPROGRAM ROUTINE

jcDebugManager.ShowHeader(4)
Type 4
SETUPSAN ROUTINE ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

jcDebugManager.ShowHeader(5)
Type 5
------------------------------------------------------------------------------------------------------------------------------------------------------
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: TestWhosCalling ROUTINE ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
------------------------------------------------------------------------------------------------------------------------------------------------------

jcDebugManager.ShowHeader(6)
Type 6
------------------------------------------------------------------------------------------------------------------------------------------------------
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: SETUPSAN ROUTINE ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
------------------------------------------------------------------------------------------------------------------------------------------------------

jcDebugManager.ShowHeader(7)
Type 7
------------------------------------------------------------------------------------------------------------------------------------------------------
TESTHASDONE ROUTINE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
------------------------------------------------------------------------------------------------------------------------------------------------------

jcDebugManager.ShowHeader(8)
Type 8
------------------------------------------------------------------------------------------------------------------------------------------------------
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: SETUPSAN ROUTINE
------------------------------------------------------------------------------------------------------------------------------------------------------

jcDebugManager.ShowHeader(9)
Type 9
======================================================================================================================================================
------------------------------------------------------------------------------------------------------------------------------------------------------
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: EndProgram ROUTINE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
------------------------------------------------------------------------------------------------------------------------------------------------------
======================================================================================================================================================

jcDebugManager.ShowHeader(10)
Type 10
======================================================================================================================================================
------------------------------------------------------------------------------------------------------------------------------------------------------
SETUPSAN ROUTINE ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
------------------------------------------------------------------------------------------------------------------------------------------------------
======================================================================================================================================================

jcDebugManager.ShowHeader(11)
Type 11
======================================================================================================================================================
------------------------------------------------------------------------------------------------------------------------------------------------------
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: ENDPROGRAM ROUTINE
------------------------------------------------------------------------------------------------------------------------------------------------------
======================================================================================================================================================

jcDebugManager.ShowHeader(12)
Type 12
======================================================================================================================================================
------------------------------------------------------------------------------------------------------------------------------------------------------
:::::::::::::::::::::::::::::::::::::::::::::: OUT OF RANGE HEADER TYPE USE ANOTHER VALUE FROM 1 TO 11 ::::::::::::::::::::::::::::::::::::::::::::::
------------------------------------------------------------------------------------------------------------------------------------------------------
======================================================================================================================================================
!ShowHeaderDoc!

  CODE
    !critProc.Init(SELF.critSect)
    HeaderSize = LEN(HeaderString)
    IF OMITTED(3) THEN Type = 1.
    IF NOT OMITTED(4) THEN
      IF Show = FALSE THEN DO Quit.
    END
    !IF SELF.GetRepetitionLength() = 0 THEN SELF.SetRepetitionLength(130).
    SELF.SetRepetitionLength(jcDebug::Default_SetRepetitionLength)
    EXECUTE Type
      BEGIN !1
        Repetition = SELF.GetRepetitionLength()
        SidesLength = (Repetition - HeaderSize - 2)/2
        SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
        SELF.See(SidesChar & ' ' & HeaderString & ' ' & SidesChar)
      END
      BEGIN !2
        Repetition = SELF.GetRepetitionLength()
        SidesLength = (Repetition - HeaderSize - 2)/2
        SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
        SELF.See(SidesChar & ' ' & UPPER(HeaderString) & ' ' & SidesChar)
      END
      BEGIN !3
        Repetition = SELF.GetRepetitionLength()
        SidesLength = (Repetition - HeaderSize - 2)
        SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
        SELF.See(SidesChar & ' ' & UPPER(HeaderString))
      END
      BEGIN !4
        Repetition = SELF.GetRepetitionLength()
        SidesLength = (Repetition - HeaderSize - 2)
        SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
        SELF.See(UPPER(HeaderString) & ' ' & SidesChar)
      END
      BEGIN !5
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
        Repetition = SELF.GetRepetitionLength()
        SidesLength = (Repetition - HeaderSize - 2)/2
        SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
        SELF.See(SidesChar & ' ' & HeaderString & ' ' & SidesChar)
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      END
      BEGIN !6
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
        Repetition = SELF.GetRepetitionLength()
        SidesLength = (Repetition - HeaderSize - 2)/2
        SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
        SELF.See(SidesChar & ' ' & UPPER(HeaderString) & ' ' & SidesChar)
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      END
      BEGIN !7
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
        Repetition = SELF.GetRepetitionLength()
        SidesLength = (Repetition - HeaderSize - 2)
        SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
        SELF.See(UPPER(HeaderString) & ' ' & SidesChar)
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      END
      BEGIN !8
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
        Repetition = SELF.GetRepetitionLength()
        SidesLength = (Repetition - HeaderSize - 2)
        SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
        SELF.See(SidesChar & ' ' & UPPER(HeaderString))
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
      END
      BEGIN !9
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
      BEGIN !10
        SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
        Repetition = SELF.GetRepetitionLength()
        SidesLength = (Repetition - HeaderSize - 2)
        SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
        SELF.See(UPPER(HeaderString) & ' ' & SidesChar)
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
        SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
      END
      BEGIN !11
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
      BEGIN !12
        SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
        Repetition = SELF.GetRepetitionLength()
        HeaderString = 'OUT OF RANGE HEADER TYPE USE ANOTHER VALUE FROM 1 TO 11'
        HeaderSize = LEN(HeaderString)
        SidesLength = (Repetition - HeaderSize - 2)
        SidesLength /= 2
        SELF.SetRepeatCharacterInVariable(SidesLength,jcDebug::Colon,SidesChar)  
        SELF.See(SidesChar & ' ' & UPPER(HeaderString) & ' ' & SidesChar)
        SELF.ShowLine(jcDebug::Hyphen,SELF.GetRepetitionLength())
        SELF.ShowLine(jcDebug::Equal,SELF.GetRepetitionLength())
      END
    END
Quit                ROUTINE
  RETURN
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetThread PROCEDURE (LONG pThread)
!critProc                  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    SELF.Thread = pThread
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetThread PROCEDURE ()!,LONG
!critProc                  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.Thread 
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Show                              PROCEDURE (STRING Info,<SHORT SpaceMargin>)         !Show the end of whom
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    SELF.SetCurrentShow(jcDebug::Show)
    SELF.See(Info,SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetShowingCurrentMethodValue PROCEDURE(BOOL Show)!,VIRTUAL                           !Set ShowingCurrentMethodValue to Show or Hide, the method accepts only a TRUE or FALSE parameter, it will Trigger TRUE or FALSE on show the current value of a variable this add the ClassName behind
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    SELF.ShowingCurrentMethodValue = Show
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetShowingCurrentMethodValue PROCEDURE()!,BOOL,VIRTUAL                               !Get ShowingCurrentMethodValue to Show or Hide, the method returns only a TRUE or FALSE value.
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.ShowingCurrentMethodValue
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetRespectingAreaShow PROCEDURE(BOOL Show)!,VIRTUAL                           !Set RespectingAreaShow to Show or Hide, the method accepts only a TRUE or FALSE parameter, it will Trigger TRUE or FALSE on show the current value of a variable this add the ClassName behind
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    SELF.RespectingAreaShow = Show
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetRespectingAreaShow PROCEDURE()!,BOOL,VIRTUAL                               !Get RespectingAreaShow to Show or Hide, the method returns only a TRUE or FALSE value.
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.RespectingAreaShow
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ShowCurrentMethodValue             PROCEDURE(ASTRING MethodString,<ANY Value>,<SHORT SpaceMargin>)
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    IF SELF.GetShowingCurrentMethodValue() THEN
      IF INSTRING(jcDebug::Equal,MethodString) THEN
        SELF.See(SELF.GetClassName() & jcDebug::Dot & MethodString & ' ' & jcDebug::Colon & ' ' & Value,SpaceMargin)
      ELSE
        SELF.See(SELF.GetClassName() & jcDebug::Dot & MethodString & ' ' & jcDebug::Equal & ' ' & Value,SpaceMargin)
      END
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ShowValue                          PROCEDURE(ASTRING Value,<ANY pData>,<BOOL Show>,<SHORT SpaceMargin>,<ASTRING Symbol>)
!critProc                                            CriticalProcedure
ShowIs                                              BOOL
DataIs                                              ANY
SpaceMarginIs                                       SHORT

  CODE
    !critProc.Init(SELF.critSect)
    IF OMITTED(3) THEN DataIs = jcDebug::NoData ELSE DataIs = pData.
    IF OMITTED(4) THEN ShowIs = TRUE ELSE ShowIs = Show.
    IF OMITTED(5) THEN SpaceMarginIs = SELF.GetNumberSpaceMargin() ELSE SpaceMarginIs = SpaceMargin.
    IF ShowIs THEN 
      IF SELF.ShowingValue = TRUE THEN
        IF NOT OMITTED(6)
          CASE Symbol
            OF jcDebug::Equal;              SELF.See(Value & ' ' & jcDebug::Equal & ' ' & DataIs,SpaceMargin)
            OF jcDebug::Colon;              SELF.See(Value & ' ' & jcDebug::Colon & ' ' & DataIs,SpaceMargin)
            OF jcDebug::OpenBracket;        SELF.See(Value & ' ' & jcDebug::OpenBracket & ' ' & DataIs,SpaceMargin)
            OF jcDebug::CloseBracket;       SELF.See(Value & ' ' & jcDebug::CloseBracket & ' ' & DataIs,SpaceMargin)
            OF jcDebug::OpenCloseBracket;   SELF.See(Value & ' ' & jcDebug::OpenCloseBracket & ' ' & DataIs,SpaceMargin)
            OF jcDebug::Space;              SELF.See(Value & ' ' & jcDebug::Space & ' ' & DataIs,SpaceMargin)
            OF jcDebug::Dot;                SELF.See(Value & ' ' & jcDebug::Dot & ' ' & DataIs,SpaceMargin)
            OF jcDebug::Hyphen;             SELF.See(Value & ' ' & jcDebug::Hyphen & ' ' & DataIs,SpaceMargin)
            OF jcDebug::LessThan;           SELF.See(Value & ' ' & jcDebug::LessThan & ' ' & DataIs,SpaceMargin)
            OF jcDebug::GreaterThan;        SELF.See(Value & ' ' & jcDebug::GreaterThan & ' ' & DataIs,SpaceMargin)
            OF jcDebug::LessThanEqualTo;    SELF.See(Value & ' ' & jcDebug::LessThanEqualTo & ' ' & DataIs,SpaceMargin)
            OF jcDebug::GreaterThanEqualTo; SELF.See(Value & ' ' & jcDebug::GreaterThanEqualTo & ' ' & DataIs,SpaceMargin)
            OF jcDebug::NotEqualTo;         SELF.See(Value & ' ' & jcDebug::NotEqualTo & ' ' & DataIs,SpaceMargin)
            ELSE
              SELF.See(Value & ' ' & jcDebug::Equal & ' ' & DataIs,SpaceMargin)
          END
        ELSE
          SELF.See(Value & ' ' & jcDebug::Equal & ' ' & DataIs,SpaceMargin)
        END  
      END
    END
    IF SELF.GetShowValueToQDR() THEN SELF.Add(Value,DataIs).
      
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ShowValueDetail                    PROCEDURE(ASTRING Value,<ANY pData>,<ASTRING pDescription>,<BYTE Show>,<SHORT SpaceMargin>)
!critProc                                            CriticalProcedure
ShowIs                                              BYTE
DataIs                                              ANY
DescriptionIs                                       ASTRING
SpaceMarginIs                                       SHORT

  CODE
    !critProc.Init(SELF.critSect)
    IF OMITTED(3) THEN DataIs = jcDebug::NoData ELSE DataIs = pData.
    IF OMITTED(4) THEN DescriptionIs = 'No detail' ELSE DescriptionIs = pDescription.
    IF OMITTED(5) THEN ShowIs = TRUE ELSE ShowIs = Show.
    IF OMITTED(6) THEN SpaceMarginIs = SELF.GetNumberSpaceMargin() ELSE SpaceMarginIs = SpaceMargin.
    IF ShowIs THEN
      IF SELF.ShowingValue = TRUE THEN
        IF INSTRING(jcDebug::Equal,Value) THEN
          SELF.See(Value & ' ' & jcDebug::Colon & ' ' & pData & ' (' & DescriptionIs & ')',SpaceMargin)
        ELSE
          SELF.See(Value & ' ' & jcDebug::Equal & ' ' & pData & ' (' & DescriptionIs & ')',SpaceMargin)
        END
      END
    END
    IF SELF.GetShowValueToQDR()
      SELF.Add(Value,DataIs,DescriptionIs)
    END
      
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetLine                            PROCEDURE(<ASTRING LineCharacter>,<USHORT Repetition>)   !Format with a specify character the repetion length of the line to set
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    IF OMITTED(3) THEN 
      IF SELF.GetRepetitionLength() > 0 THEN
        Repetition = SELF.GetRepetitionLength()
      ELSE
        SELF.SetRepetitionLength(jcDebug::Default_SetLine)
      END
    END
    IF OMITTED(2) THEN
      LineCharacter = jcDebug::Hyphen
    END
    SELF.SetRepeatCharacterInVariable(Repetition,LineCharacter,SELF.Line) !This will assign to SELF.Line the LineCharacter according to the repetition
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetLine  PROCEDURE(<ASTRING LineCharacter>,<USHORT Repetition>)   !Get the formatted line
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
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

jcDebugManager.ShowLine PROCEDURE(<ASTRING LineCharacter>,<USHORT LineLength>,<BYTE Type>)
!critProc                  CriticalProcedure
LineCharactering          ASTRING
LineLengthing             USHORT
Typing                    BYTE
  CODE
    !critProc.Init(SELF.critSect)
    IF OMITTED(4) THEN 
      Typing = 1
    ELSE
      Typing = Type
    END
    IF OMITTED(3) THEN 
      IF SELF.GetRepetitionLength() = 0 THEN
        SELF.SetRepetitionLength(jcDebug::Default_SetRepetitionLength)
      END
      LineLengthing = SELF.GetRepetitionLength()
    ELSE
      LineLengthing = LineLength
    END
    SELF.SetRepetitionLength(LineLengthing)
    IF OMITTED(2) THEN 
      LineCharactering = jcDebug::Hyphen
    ELSE
      LineCharactering = LineCharacter
    END
    SELF.SetLine(LineCharactering,LineLengthing)
    IF LEN(SELF.Line) = 0 THEN SELF.SetLine(LineCharactering,LineLengthing).
    EXECUTE Typing
      SELF.See(SELF.Line)
      SELF.Show(SELF.Line)
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SeeVariables PROCEDURE  (<STRING Info>,<SHORT SpaceMargin>,<BYTE Show>)
F                             &jcFieldManager
DebugAction		        BOOL
winAPIhWnd      CSTRING(251)
  CODE
    IF NOT OMITTED(4) THEN 
      IF Show = FALSE THEN RETURN.
    END
    !SELF.critSect.Wait()
?   IF SELF.GetAssertState(0) THEN
?     ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QD))
?   END
  SELF.Method('SeeVariables','(<STRING Info>,<SHORT SpaceMargin>)',jcDebugDebugShow:SeeVariables)
    SELF.Note('Note about SeeVariables method')
      SELF.See('it shows the last value to the object entry')
      SELF.See('There are many Method Show entry in the table')
      SELF.See('it shows the last updated one')
    SELF.Fin()
    !SELF.critSect.Wait()
    SELF.Note('Thread info')
      SELF.ShowValue('THREAD()',THREAD(),_Show)
!      SELF.ShowValue('INSTANCE(SELF.Debug,THREAD())',INSTANCE(SELF.Debug,THREAD()),_Show)
    SELF.Fin()
?   IF SELF.GetAssertState(0) THEN
?      ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QD))
?   END
    !SELF.SetRepeatCharacterInVariable(SELF.GetSeeVariablesRepetitionLength(),jcDebug::Hyphen,SELF.Line)
    DebugAction = SELF.GetDebugState()
    !OMIT('!FIN!')
    SELF.ShowLine()      
    SELF.See('NUMBER OF VARIABLES ENTRIES TO WATCH IS ' & RECORDS(SELF.QD))
    IF NOT OMITTED(2) THEN SELF.See(Info).
    SELF.ShowLine()
    IF DebugAction THEN
      i# = 0
      LOOP i# = 1 TO RECORDS(SELF.QD)
        GET(SELF.QD,i#)
        SELF.See(SELF.QD.Object & ' ' & jcDebug::Equal & ' ' & SELF.GetValueRepresentation(SELF.QD.Object,SELF.QD.Detail))
      END
    END 
    SELF.ShowLine()
    !FIN!
    !SELF.critSect.Release()
  SELF.Fin()
  !SELF.critSect.Release()
  
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ShowLocalDebug                     PROCEDURE(<BOOL ShowQ>,<SHORT SpaceMargin>)
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ShowDebugQueue                     PROCEDURE(<BOOL ShowQ>,<SHORT SpaceMargin>)
DisplayDebugQueue   BOOL
DetailEntete	    CSTRING(251)
ObjectEntete	    CSTRING(251)
  CODE
    !SELF.critSect.Wait()
    IF OMITTED(2) THEN
      DisplayDebugQueue = TRUE
    ELSE
      DisplayDebugQueue = ShowQ
    END
?   IF SELF.GetAssertState(0) THEN
?     ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QBR))
?   END
    SELF.Method('ShowDebugQueue','(<BYTE ShowQ>,<SHORT SpaceMargin>)',jcDebugDebugShow:ShowDebugQueue )
?     IF SELF.GetAssertState(0) THEN
?       ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QBR))
?     END
      !SELF.critSect.Wait()
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
      !SELF.critSect.Release()
      SELF.Fin()
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ShowClassQueue   PROCEDURE(jcBase BaseClass,<BOOL ShowQ>,<SHORT SpaceMargin>)
DisplayDebugQueue                 BOOL
DetailEntete                      CSTRING(251)
ObjectEntete                      CSTRING(251)
base                              &jcBase

  CODE
    !SELF.critSect.Wait()
    base &= NEW(jcBase)
    base &= BaseClass  
    IF OMITTED(3) THEN
      DisplayDebugQueue = TRUE
    ELSE
      DisplayDebugQueue = ShowQ
    END
?   IF SELF.GetAssertState(0) THEN
?     ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QBR))
?   END
    SELF.Method('ShowClassQueue','(<BYTE ShowQ>,<SHORT SpaceMargin>)',jcDebugDebugShow:ShowClassQueue)
?     IF SELF.GetAssertState(0) THEN
?        ASSERT(a#=TRUE, ' in ' & SELF.CurrentShow & ' is ' & SELF.GetBOOL(SELF.GetCurrentShow(),_Showing) & ' THE NUMBER OF RECORDS IS ' & RECORDS(SELF.QBR))
?     END
      !SELF.critSect.Wait()
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
      !SELF.critSect.Release()
    SELF.Fin()
    !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetRepetitionLength                PROCEDURE(<SHORT Repetition>)
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    IF OMITTED(2) THEN
      SELF.RepetitionLength = jcDebug::Default_SetRepetitionLength
    ELSE
      SELF.RepetitionLength = Repetition
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetRepetitionLength                PROCEDURE()
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    IF SELF.RepetitionLength = 0 THEN SELF.SetRepetitionLength().
    RETURN SELF.RepetitionLength
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetRepeatCharacterInVariable       PROCEDURE(USHORT Repetition,STRING Character,*ASTRING Variables)
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    Variables = ALL(Character,Repetition)
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetSeeVariablesRepetitionLength    PROCEDURE(<USHORT Repetition>)
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    IF OMITTED(2) THEN
      SELF.SeeVariablesRepetitionLength = jcDebug::Default_SetSeeVariablesRepetitionLength
    ELSE
      SELF.SeeVariablesRepetitionLength = Repetition
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetSeeVariablesRepetitionLength    PROCEDURE()
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.SeeVariablesRepetitionLength
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetShowDebugQueueRepetitionLength  PROCEDURE()
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.ShowDebugQueueRepetitionLength
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetShowDebugQueueRepetitionLength  PROCEDURE(<USHORT Repetition>)
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    IF OMITTED(2) THEN
      SELF.ShowDebugQueueRepetitionLength = 130
    ELSE
      SELF.ShowDebugQueueRepetitionLength = Repetition
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetShowDebugQueueLine              PROCEDURE()
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.ShowDebugQueueLine
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetOverrideSpaceMargin               PROCEDURE(SHORT SpaceMargin)
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    SELF.OverrideSpaceMargin = SpaceMargin
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetOverrideSpaceMargin               PROCEDURE()
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.OverrideSpaceMargin
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetNumberSpaceMargin               PROCEDURE(<SHORT SpaceMargin>)
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    IF OMITTED(2) THEN
      SELF.NumberSpaceMargin = jcDebug::DefaultSpaceMargin
    ELSE
      SELF.NumberSpaceMargin = SpaceMargin
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetNumberSpaceMargin               PROCEDURE()
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.NumberSpaceMargin
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.CheckSpaceMargin                   PROCEDURE(*SHORT NumberSpaceMargin,<SHORT SpaceMargin>)
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
?   IF SELF.ShowingSpaceMargin THEN
?     SELF.SetNumberSpaceMargin(SELF.GetNumberSpaceMargin()+SELF.GetIndentSpaceMargin())
?     SELF.SeeStart(jcDebug::Method,SELF.GetClassName() & '.CheckSpaceMargin')!SELF.GetMethodName())
?   END
    IF OMITTED(3) THEN
      SELF.Assign(SELF.GetNumberSpaceMargin(),NumberSpaceMargin)
    ELSE
      SELF.Assign(SpaceMargin,NumberSpaceMargin)
    END
?   IF SELF.ShowingSpaceMargin THEN
?     SELF.Show('GetNumberSpaceMargin ' & SELF.GetNumberSpaceMargin())
?     SELF.Show('SpaceMargin ' & SpaceMargin) 
?     SELF.See('NumberSpaceMargin ' & NumberSpaceMargin)
?     SELF.SeeEnd(jcDebug::Method,SELF.GetClassName() & '.CheckSpaceMargin') !SELF.GetMethodName())
?   END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetMargin                         PROCEDURE(*SHORT NumberSpaceMargin,*SHORT SpaceMargin) !Set the Margin
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    IF SpaceMargin <> 0 THEN
      SELF.CheckSpaceMargin(NumberSpaceMargin,SpaceMargin+SELF.GetIndentSpaceMargin())
    ELSE
      SELF.CheckSpaceMargin(NumberSpaceMargin,SELF.GetNumberSpaceMargin()+SELF.GetIndentSpaceMargin())
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetIndentSpaceMargin             PROCEDURE(<SHORT LengthIndentSpaceMargin>) !Set the Length Indent Margin
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    IF OMITTED(2) THEN
      SELF.IndentSpaceMargin = JC_DEBUG_jcDebugManager_IndentMargin
    ELSE
      SELF.IndentSpaceMargin = LengthIndentSpaceMargin
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetIndentSpaceMargin             PROCEDURE() !Set the Margin
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    RETURN SELF.IndentSpaceMargin
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Assign                             PROCEDURE(STRING Value,*? Fld)
!critProc  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    FLD = Value
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.Beeping  PROCEDURE(<ASTRING pMessage>,<UNSIGNED pSound>)
MessageShow               ASTRING
_BEEPString               EQUATE('BEEP:')

  CODE
    IF OMITTED(2) THEN
      BEEP
    ELSE
      IF pSound > 0
        BEEP(pSound)
      END
    END
    MessageShow = _BEEPString
    IF OMITTED(1) THEN
      SELF.See(MessageShow)
    ELSE
      SELF.See(MessageShow & ' ' & pMessage)
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetValueRepresentation             PROCEDURE(ASTRING Object,ASTRING Detail)
Response            ASTRING
ValueRepresentation BOOL
  CODE
    !SELF.critSect.Wait()
    ValueRepresentation = FALSE
    DO ValueRepresentationResponse
    DO DetailRepresentationResponse
    !SELF.critSect.Release()
    RETURN Response
ValueRepresentationResponse                 ROUTINE
  !SELF.critSect.Wait()
  IF INSTRING(jcDebug::Show,Object,1,1) THEN
    Response = SELF.GetBOOL(Detail,_Active)
    ValueRepresentation = TRUE
  END
  IF INSTRING(jcDebug::Show & jcDebug::Dot,Object,1,1) THEN
    Response = SELF.GetBOOL(Detail,_Showing)
    ValueRepresentation = TRUE
  END
  !SELF.critSect.Release()
DetailRepresentationResponse                ROUTINE  
  !SELF.critSect.Wait()
  IF ValueRepresentation = FALSE THEN
    Response = Detail
  END  
  !SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.RetenirEndroit   PROCEDURE(<ASTRING pMessage>,<LONG pWantToBeep>)
              
MessageAssigned                   ASTRING
WantToBeepAssigned                LONG

  CODE
    IF NOT OMITTED(1) THEN MessageAssigned = pMessage ELSE MessageAssigned = 'Retenir l''endroit où nous devons changer le code'.
    IF NOT OMITTED(2) THEN WantToBeepAssigned = pWantToBeep ELSE WantToBeepAssigned = 0.
    SELF.Beeping(MessageAssigned,WantToBeepAssigned)

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.RetainLocation   PROCEDURE(<ASTRING pMessage>,<LONG pWantToBeep>)
             
MessageAssigned                   ASTRING
WantToBeepAssigned                LONG

  CODE
    IF NOT OMITTED(1) THEN MessageAssigned = pMessage ELSE MessageAssigned = 'Retain the location where we need to change the code'.
    IF NOT OMITTED(2) THEN WantToBeepAssigned = pWantToBeep ELSE WantToBeepAssigned = 0.
    SELF.Beeping(MessageAssigned,WantToBeepAssigned)

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetShowValueToQDR    PROCEDURE(BOOL pValueToQDR)
             

  CODE
    SELF.ShowValueToQDR = pValueToQDR
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.GetShowValueToQDR    PROCEDURE()!,BOOL
             

  CODE
    RETURN SELF.ShowValueToQDR 
!-----------------------------------------------------------------------------------------------------------------------------------
     OMIT('!FIN!')
jcDebugManager.Add  PROCEDURE (ASTRING Object,ASTRING Detail)
F                     &jcFieldManager
!critProc              CriticalProcedure
Response              BOOL
Dummy                 ASTRING

  CODE
    !critProc.Init(SELF.critSect)
    Response = SELF.Add(SELF.QD,Object,Detail,Dummy)
    RETURN Response

!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.AddItem  PROCEDURE (*ASTRING Holder,ASTRING Item,ASTRING Object)!,PROC,PRIVATE!The private method Adding optimize two statements into one,<br/>the first statement field assignment and the second one Add to the jcBase Queue Object holder.<br/> It does NOT add if it exist

  CODE
    !!SELF.critSect.Wait()
    Holder = Item
    SELF.AddItem(SELF.QD,Holder,Item,Object)
    !!SELF.critSect.Release()
!FIN!
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ShowQ    PROCEDURE(*QUEUE Q)
F                         &jcFieldManager
!critProc                  CriticalProcedure
  CODE
    !critProc.Init(SELF.critSect)
    F &= NEW(jcFieldManager)
    F.ShowQueue(Q)
    DISPOSE(F)
    
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ShowQRecordRow  PROCEDURE(*QUEUE Q,*? RecordRow)
!critProc                  CriticalProcedure

  CODE
    !critProc.Init(SELF.critSect)
    CLEAR(Q)
    LOOP i# = 1 TO RECORDS(Q)
      GET(Q,i#)
      SELF.See(RecordRow)
    END
!-----------------------------------------------------------------------------------------------------------------------------------
jcDebugManager.ViewQ    PROCEDURE(*QUEUE Q)


Window                     WINDOW('View Log File'),AT(,,862,340),GRAY,IMM,AUTO,SYSTEM,STATUS, |
                                FONT('Microsoft Sans Serif',8,,FONT:regular+FONT:underline),MSG('To Fill t' & |
                                'he list under the Viewer column clic on the list box'),Centered,DOUBLE
                                BUTTON('&Close'),AT(818,316,42,14),USE(?CloseButton),FONT(,,,FONT:bold)
                                SHEET,AT(2,2,858,311),USE(?SHEET1)
                                  TAB('Tab1'),USE(?TAB1)
                                    LIST,AT(3,18,854,292),USE(?List:Q),HSCROLL,FONT(,,,FONT:regular),FROM(Q), |
                                      FORMAT('20L(2)|M~Viewer~')
                                  END
                                END
                              END

  CODE
    OPEN(Window)
    ACCEPT
      CASE SELECTED()
      OF ?List:Q
      END
      CASE Field()
      OF ?CloseButton
        CASE EVENT()
        OF EVENT:Accepted;BREAK.
      END
    END      

!-------------------------------------------------------------------------------------------------------------------
jcDebugManager.SetFetch PROCEDURE(*INIClass pINIMgr,ASTRING pINISection,ASTRING pINIVariableName,ASTRING pINIValue)!,BOOL,PROC
VerifyValue               ASTRING
Response                  BOOL

  CODE
    SELF.INIManager &= NEW INIClass   
    SELF.INIManager &= pINIMgr   
    VerifyValue = SELF.INIManager.TryFetch(pINISection,pINIVariableName)   
    IF (VerifyValue='' AND VerifyValue <> 0) THEN    
      SELF.INIManager.Update(pINISection,pINIVariableName,pINIValue)    
    ELSE    
      Response = TRUE   
    END   
    pINIMgr &= SELF.INIManager   
    RETURN Response
    
!-------------------------------------------------------------------------------------------------------------------
jcDebugManager.Updating PROCEDURE(*INIClass pINIMgr,ASTRING pINISection,ASTRING pINIVariableName,ASTRING pINIValue)

  CODE
    SELF.INIManager &= NEW INIClass
    SELF.INIManager &= pINIMgr
    SELF.INIManager.Update(pINISection,pINIvariableName,pINIValue)
    pINIMgr &= SELF.INIManager

!-------------------------------------------------------------------------------------------------------------------
    
    
!===================================================== End of jcDebugManager =======================================================
    
  !INCLUDE('jcDebugDebug.clw')