! Joliciel 2012
      MEMBER
      
	    INCLUDE('jcLog.inc'),ONCE

      Map       
OpenFile    PROCEDURE(*FILE FileName,ASTRING LogFileName)
      End ! map


!----------------------------------------------------------------------------------------------------------------------------------- 
jcLogManager.Construct 						          PROCEDURE              
  CODE
    SELF.Debug &= NEW(jcDebugManagerPrivate)  
    !SELF.Debug &= NEW(jcDebugManager)
!    SELF.ViewerLogErrors &= NEW(ErrorClass)
!    SELF.Viewer &= NEW(AsciiViewerClass)
!    SELF.ViewerLogWindow &= ViewLogWindow
    
    !  SELF.File &= jcLogFile
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.Destruct  						          PROCEDURE              
  CODE
!    DISPOSE(SELF.ViewerLogErrors)
!    DISPOSE(SELF.Viewer)
    DISPOSE(SELF.Debug)

!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.PrepareClassName               PROCEDURE(*jcLogManager jcLogClass,<ASTRING DeclaredClassName>)  
bcn     &jcLogManager
  CODE
? SELF.Debug.MethodStart('PrepareClassName','(jcLogManager jcLogClass,<ASTRING DeclaredClassName>)',jcLogDebugShow:PrepareClassName)
    bcn &= NEW(jcLogClass)
    !STOP('Avant bcn.GetClassName() ' & bcn.GetClassName())
    IF bcn.GetClassName() THEN
       bcn.Debug.SetClassName(bcn.GetClassName())
      bcn.Debug.PrepareClassName(bcn.GetClassName())
      !STOP('bcn.Debug.GetClassName ' & bcn.Debug.GetClassName())
    ELSE
      bcn.Debug.PrepareClassName(bcn.Debug,DeclaredClassName)
!      STOP('bcn.Debug.GetClassName ' & bcn.Debug.GetClassName())
!      STOP('DeclaredClassName ' & DeclaredClassName)
       IF NOT bcn.Debug.GetClassName() THEN
         bcn.Debug.SetClassName(DeclaredClassName)
       END
    END
    !SELF.SetClassName(bcn.GetClassName())
!    STOP('GetClassName ' & SELF.GetClassName())
?   SELF.Debug.SetClassName(bcn.Debug.GetClassNameInstance())
!    STOP('SELF.Debug.GetClassName() ' & SELF.Debug.GetClassName())
    DISPOSE(bcn)
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.Init   PROCEDURE(*FILE File,STRING LogFileName,<BOOL SetLog>,<BYTE LogFormat>)
MethodName            EQUATE('Init')
Prototype             EQUATE('(*FILE File,<STRING LogFileName>,<BOOL SetLog>,<BYTE LogFormat>)')
MethodShow            EQUATE(jcLogDebugShow:Init)
SetFileType           BYTE
InitCall              BYTE

  CODE
    !SELF.PrepareClassName(SELF,jcLog::jcLogManager)
?   SELF.Debug.MethodStart(MethodName,Prototype,MethodShow)
      SELF.SetAssertState(JC_LOG_jcLogManager_SetAssertState)
      SELF.File &= File
      IF NOT OMITTED(4) AND NOT OMITTED(5) THEN InitCall = 1.
      IF NOT OMITTED(4) AND OMITTED(5) THEN InitCall = 2.
      IF OMITTED(4) AND NOT OMITTED(5) THEN InitCall = 3.
      IF OMITTED(4) AND OMITTED(5) THEN InitCall = 4.
      EXECUTE InitCall
        SELF.Init(LogFileName,SetLog,LogFormat)
        SELF.Init(LogFileName,SetLog)
        SELF.Init(LogFileName,,LogFormat)
        SELF.Init(LogFileName)
      END
?   SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.Init   PROCEDURE(<STRING LogFileName>,<BOOL SetLog>,<BYTE LogFormat>)
MethodName            EQUATE('Init')
Prototype             EQUATE('(<STRING LogFileName>,<BOOL SetLog>,<BYTE LogFormat>)')
MethodShow            EQUATE(jcLogDebugShow:Init)
SetFileType           BYTE

  CODE
    !SELF.PrepareClassName(SELF,jcLog::jcLogManager)
    DO Debug1
?   SELF.Debug.MethodStart(MethodName,Prototype,MethodShow)
      SELF.SetAssertState(JC_LOG_jcLogManager_SetAssertState)
      DO Debug2
      DO SetupLog       
?   SELF.Debug.MethodEnd()

Debug1              ROUTINE
?   SELF.Debug.AssignTo(SELF.Debug.ShowingValue,TRUE)
?   IF SELF.GetClassName() THEN
?     SELF.Debug.SetClassName(SELF.GetClassName())
?   ELSE
?     IF NOT SELF.Debug.GetClassName() THEN
?      SELF.Debug.SetClassName(jcLog::jcLogManager)
?     END 
?   END
?  SELF.Debug.Init()
?  SELF.Debug.SetDebugState(JC_LOG_jcLogManager_SetDebugState)

Debug2              ROUTINE
?   SELF.Debug.ShowCurrentMethodValue('DebugState',SELF.Debug.GetBOOL(SELF.Debug.GetDebugState(),_Active))
?   SELF.Debug.ShowValue('LogFileName parameter',LogFileName)
?   SELF.Debug.ShowValue('SetLog parameter',SetLog)
?   SELF.Debug.ShowValue('LogFormat',LogFormat)

SetupLog            ROUTINE
? SELF.Debug.RoutineStart('(jcLogManager.Init)/SetupLog',jcLogDebugShow:Init_SetupLog_Routine)    
    !SELF.Set(JC_LOG_jcLogManager_Set)
    IF NOT OMITTED(3) THEN SELF.Set(SetLog) ELSE SELF.Set(TRUE).
    IF NOT OMITTED(4) THEN 
      SELF.SetLogFormat(LogFormat)
      !STOP('NOT OMITTED(4) THEN SetLogFormat(LogFormat) ' & LogFormat)
    ELSE
      !STOP('OMITTED(4) THEN SetLogFormat(JC_LOG_jcLogManager_SetLogFormat) ' & JC_LOG_jcLogManager_SetLogFormat)
      SELF.SetLogFormat(JC_LOG_jcLogManager_SetLogFormat)
    END
?   SELF.Debug.ShowCurrentMethodValue('GetLogFormat()',SELF.GetLogFormat())
      OMIT('!FIN!')
    IF OMITTED(2) THEN 
      SELF.SetLogFileName(jcLog::DefaultLogFileName)
    ELSE
      !STOP('NOT OMITTED(2) LogFileName ' & LogFileName)
      IF NOT OMITTED(4) THEN
        !STOP('NOT OMITTED(4) LogFormat ' & LogFormat)
        SELF.SetLogFileName(CLIP(LogFileName),LogFormat)
      ELSE
        SELF.SetLogFileName(CLIP(LogFileName))
      END
      SELF.SetExtension(SUB(SELF.LogFileName,INSTRING(jcLog::Dot,SELF.LogFileName,-1,LEN(CLIP(SELF.LogFileName)))+1,LEN(CLIP(SELF.LogFileName))))
      !STOP('GetExtension ' & SELF.GetExtension())
    END
    !FIN!
?   SELF.Debug.ShowValue('LogFile extension is',SUB(LogFileName,INSTRING(jcLog::Dot,LogFileName,-1,LEN(CLIP(LogFileName)))+1,LEN(CLIP(LogFileName))))
    IF NOT OMITTED(2) THEN
      !IF NOT SELF.GetExtension() THEN
        IF INSTRING(jcLog::Dot,LogFileName,-1,LEN(CLIP(LogFileName))) THEN
?         SELF.Debug.ShowValue('LogFileName',LogFileName)
          !SELF.SetExtension(SUB(LogFileName,INSTRING(jcLog::Dot,LogFileName,-1,LEN(CLIP(LogFileName)))+1,LEN(CLIP(LogFileName))))
          SELF.SetExtension(LogFileName)
          LogFileName = SUB(LogFileName,1,INSTRING(jcLog::Dot,LogFileName,-1,LEN(CLIP(LogFileName)))-1)
?         SELF.Debug.ShowValue('LogFileName',LogFileName)
        ELSIF NOT SELF.GetExtension() THEN
          SELF.SetExtension(JC_LOG_jcLogManager_SetExtension)
        END
      !END
    END
?   SELF.Debug.ShowCurrentMethodValue('GetExtension()',SELF.GetExtension())
    !IF NOT LEN(SELF.GetPath()) THEN SELF.SetPath(JC_LOG_jcLogManager_SetPath).
    IF NOT SELF.GetLogFormatLimit() THEN SELF.SetLogFormatLimit(JC_LOG_jcLogManager_SetLogFormatLimit).
    IF NOT SELF.GetLineFormatLimit() THEN SELF.SetLineFormatLimit(JC_LOG_jcLogManager_SetLineFormatLimit).
    IF NOT SELF.GetLineFormat() THEN SELF.SetLineFormat(JC_LOG_jcLogManager_SetLineFormat).
    IF NOT LEN(SELF.GetDateFormat()) THEN SELF.SetDateFormat(JC_LOG_jcLogManager_SetDateFormat).
    IF NOT LEN(SELF.GetDate()) THEN SELF.SetDate().
    IF NOT LEN(SELF.GetTimeFormat()) THEN SELF.SetTimeFormat(JC_LOG_jcLogManager_SetTimeFormat).
    IF NOT LEN(SELF.GetTime()) THEN SELF.SetTime().
    IF NOT LEN(SELF.GetLineNoFormat()) THEN SELF.SetLineNoFormat(JC_LOG_jcLogManager_SetLineNoFormat).
    DO SetFileSetup
? SELF.Debug.RoutineEnd()     

SetFileSetup        ROUTINE    
? SELF.Debug.RoutineStart('SetFileSetup',jcLogDebugShow:Init_SetFileSetup_Routine)
    IF NOT OMITTED(2) THEN
      SetFileType = 2
      IF NOT OMITTED(4) THEN
        SetFileType = 3
      END
    ELSE
      IF LEN(SELF.GetLogFileName()) > 0 THEN
        SetFileType = 4
      ELSIF LEN(SELF.GetLogFileName()) > 0 AND SELF.GetLogFormat() > 0 THEN
        SetFileType = 5
      ELSE
        SetFileType = 1
      END
    END
?   SELF.Debug.ShowValue('SetFileType',SetFileType)
    EXECUTE SetFileType
      SELF.SetFile()
      SELF.SetFile(LogFileName)
      SELF.SetFile(LogFileName,LogFormat)
      SELF.SetFile(SELF.GetLogFileName())
      SELF.SetFile(SELF.GetLogFileName(),SELF.GetLogFormat())
    END
? SELF.Debug.RoutineEnd()

!------------------------------------------------------------------------------------------------------------------------------------
jcLogManager.Kill 							            PROCEDURE
  CODE  
    SELF.CloseFile(jcLogFile)
!-----------------------------------------------------------------------------------------------------------------------------------  
jcLogManager.Set                   		      PROCEDURE(BOOL Log)
  CODE  
? SELF.Debug.MethodStart('Set','(BOOL Log)',jcLogDebugShow:Set)
    SELF.Logued= Log
?   SELF.Debug.ShowCurrentMethodValue('Log',SELF.Debug.GetBOOL(SELF.Logued,_Active))
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.Get                     		    PROCEDURE()
  CODE  
? SELF.Debug.MethodStart('GetLog',,jcLogDebugShow:Get)
?   SELF.Debug.ShowCurrentMethodValue('Log',SELF.Debug.GetBOOL(SELF.Logued,_Active))
? SELF.Debug.MethodEnd()
  RETURN SELF.Logued
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetPath               		      PROCEDURE(ASTRING Path)
  CODE  
? SELF.Debug.MethodStart('SetPath','(ASTRING Path)',jcLogDebugShow:SetPath) 
    SELF.Path = Path
?   SELF.Debug.ShowCurrentMethodValue('LogPath',SELF.GetPath())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetPath    PROCEDURE()
Path  LIKE(jcLogManager.Path)
  CODE  
?   SELF.Debug.MethodStart('GetPath',,jcLogDebugShow:GetPath)
    Path = SELF.Path
?   SELF.Debug.ShowCurrentMethodValue('LogPath',Path)
? SELF.Debug.MethodEnd()
  RETURN SELF.Path
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetFile               		      PROCEDURE(<ASTRING LogFileName>,<BYTE LogFormat>)
SetFileNameType   BYTE
  CODE  
? SELF.Debug.MethodStart('SetFile','(ASTRING LogFileName)',jcLogDebugShow:SetFile)
?   SELF.Debug.ShowValue('LogFileName paramter',LogFileName)
    DO Init:Procedure
    DO CheckLogFileName
    !DO OpenFile
    SELF.OpenFile(SELF.File)
    !START(OpenFile(SELF.File,SELF.GetLogFileName()))
    !STOP('jcLogManager.SetFile LogFileName = ' & LogFileName)
    !STOP('GetLogFileName ' & SELF.GetLogFileName())
  DO Quit    
Init:Procedure                  ROUTINE
? SELF.Debug.RoutineStart('Init:Procedure')
?   SELF.Debug.SeeVariables()
?   SELF.Debug.ShowCurrentMethodValue('Get()',SELF.Debug.GetBOOL(SELF.Get(),_Active))
    IF SELF.Get() = FALSE THEN DO Quit.
    SELF.SetFileServer(1)
? SELF.Debug.RoutineEnd()
CheckLogFileName                ROUTINE    
? SELF.Debug.RoutineStart('CheckLogFileName')
    IF NOT LEN(SELF.GetLogFileName()) THEN    SetFileNameType = 1.
    IF SELF.GetLogFileName() <> LogFileName THEN SetFileNameType = 2.
    IF OMITTED(2) AND OMITTED(3) THEN         SetFileNameType = 1.
    IF NOT OMITTED(2) AND OMITTED(3) THEN     SetFileNameType = 2.
    IF NOT OMITTED(2) AND NOT OMITTED(3) THEN SetFileNameType = 3.
    IF OMITTED(2) AND NOT OMITTED(3) THEN     SetFileNameType = 4.
     OMIT('!FIN!')
    IF NOT LEN(SELF.GetLogFileName()) 
      SELF.SetLogFileName(jcLog::DefaultLogFileName)
    ELSIF SELF.GetLogFileName() <> LogFileName THEN
      SELF.SetLogFileName(LogFileName)
    END
!    STOP(SELF.GetClassName() & jcLog::Dot & 'LogFileName = ' & LogFileName)
    IF NOT OMITTED(2) AND NOT OMITTED(3) THEN 
      SELF.SetLogFileName(LogFileName,LogFormat)
    ELSIF NOT OMITTED(2) AND OMITTED(3) THEN
      SELF.SetLogFileName(LogFileName)
    END
    !FIN!
?   SELF.Debug.ShowValue('SetFileNameType',SetFileNameType)
    EXECUTE SetFileNameType
      SELF.SetLogFileName(jcLog::DefaultLogFileName)
      SELF.SetLogFileName(LogFileName)
      SELF.SetLogFileName(LogFileName,LogFormat)
      SELF.SetLogFileName(jcLog::DefaultLogFileName,LogFormat)
    END  
? SELF.Debug.RoutineEnd()
Quit                            ROUTINE
?   SELF.Debug.See('QUIT')
? SELF.Debug.MethodEnd()  
  RETURN
!-----------------------------------------------------------------------------------------------------------------------------------
!  OMIT('!FIN!')
jcLogManager.SetFileServer                  PROCEDURE(BYTE Server)
  CODE
? SELF.Debug.MethodStart('SetFileServer','(BYTE Server)',jcLogDebugShow:SetFileServer)
?   SELF.Debug.ShowValue('Server',Server)
    EXECUTE Server
      DO LogFileNumberUsedService
      DO LogFileReferenceService
      DO LogFileExternalService
    END
? SELF.Debug.MethodEnd()
LogFileNumberUsedService        ROUTINE
? SELF.Debug.RoutineStart('LogFileNumberUsedService')
!      STOP('IF SELF.LogFileName &= NULL THEN ')
      SELF.File &= jcLogFile
      SELF.LogFileName &= jcLogFileName
? SELF.Debug.RoutineEnd()
LogFileReferenceService         ROUTINE
? SELF.Debug.RoutineStart('LogFileReferenceService')
    IF SELF.LogFileName &= NULL THEN 
!      STOP('IF SELF.LogFileName &= NULL THEN ')
      SELF.LogFileName &= jcLogFileName
    END
    IF SELF.File &= NULL THEN 
      SELF.File &= jcLogFile
    END
? SELF.Debug.RoutineEnd()
LogFileExternalService          ROUTINE
? SELF.Debug.RoutineStart('LogFileExternalService')   
!      STOP('IF SELF.LogFileName &= NULL THEN ')
  ! Nothing to Do
!      SELF.File &= jcLogFile
!      SELF.LogFileName &= jcLogFileName
? SELF.Debug.RoutineEnd()
 !FIN!
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.OpenFile                       PROCEDURE(*FILE File)
  CODE
? SELF.Debug.MethodStart('OpenFile','(*FILE File)',jcLogDebugShow:OpenFile)
?   SELF.Debug.ShowCurrentMethodValue('GetFileLabel()',SELF.GetFileLabel())
?   SELF.Debug.ShowCurrentMethodValue('GetLogFileName()',SELF.GetLogFileName())
    CLOSE(File)
    !OPEN(File)
    SHARE(File,ReadWrite+DenyNone)
    IF ERRORCODE() = 2 THEN
      CLOSE(File)
      CREATE(File)
      SHARE(File,ReadWrite+DenyNone)
    END  
    CLOSE(File) 
    SHARE(File,ReadWrite+DenyNone)
    IF ERROR() THEN
      MESSAGE('ERRORCODE : ' & ERRORCODE() & |
             '|ERROR : ' & ERROR() & |
             '|NOTE : ' & 'A file name may not contain one of these characters'  & '": < > * ? " / \ and a stand up straight line"' & |
             '|FILE : ' & SELF.GetLogFileName(),'jcLogManager Error',ICON:Hand)
      RETURN
    END
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.CloseFile                       PROCEDURE(*FILE File)
  CODE
? SELF.Debug.MethodStart('CloseFile','(*FILE File)',jcLogDebugShow:CloseFile)
?   SELF.Debug.ShowCurrentMethodValue('GetFileLabel()',SELF.GetFileLabel())
?   SELF.Debug.ShowCurrentMethodValue('GetLogFileName()',SELF.GetLogFileName())
    CLOSE(File)
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.Fetch                          PROCEDURE()                   !Fetch the current LogFileNumberUsed
  CODE
? SELF.Debug.MethodStart('Fetch','()',jcLogDebugShow:Fetch)
    SET(SELF.File)
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.Next                           PROCEDURE()                   !Read the current LogFileNumberUsed
  CODE
? SELF.Debug.MethodStart('Next','()',jcLogDebugShow:Next)
    NEXT(SELF.File)
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetRecord                      PROCEDURE()                            !Get the current record line of the current logFileNumberUsed
  CODE
? SELF.Debug.MethodStart('GetRecord','()',jcLogDebugShow:GetRecord)
? SELF.Debug.MethodEnd()
    RETURN jcLogFile.Line
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.EoF                    PROCEDURE()                            !Verify the EOF the current logFileNumberUsed
  CODE
? SELF.Debug.MethodStart('EoF','()',jcLogDebugShow:EoF)
? SELF.Debug.MethodEnd()
    IF EOF(SELF.File) THEN RETURN TRUE ELSE RETURN FALSE.

!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetFileLabel                   PROCEDURE()
Response    ASTRING
  CODE  
? SELF.Debug.MethodStart('GetFile',,jcLogDebugShow:GetFileLabel)
    Response = jcLog::jcLogFile
? SELF.Debug.MethodEnd()
  RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetExtension                   PROCEDURE(<ASTRING LogFileName>)
Extension   LIKE(jcLogManager.Extension)
  CODE  
? SELF.Debug.MethodStart('SetExtension','(<STRING LogFileName>)',jcLogDebugShow:SetExtension)
    IF OMITTED(2) THEN
      SELF.Extension = jcLog::Dot & JC_LOG_jcLogManager_SetExtension
    ELSE
      Extension = SUB(LogFileName,INSTRING(jcLog::Dot,LogFileName,-1,LEN(CLIP(LogFileName)))+1,LEN(CLIP(LogFileName)))
      IF INSTRING(jcLog::Dot,Extension,1,1) THEN
        SELF.Extension = Extension
      ELSE
        SELF.Extension = jcLog::Dot & Extension
      END
    END
?   SELF.Debug.ShowCurrentMethodValue('Extension',SELF.GetExtension())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetExtension   PROCEDURE()
Extension                     LIKE(jcLogManager.Extension)
  CODE  
?   SELF.Debug.MethodStart('GetExtension',,jcLogDebugShow:GetExtension)
      Extension = SELF.Extension
?   SELF.Debug.ShowCurrentMethodValue('Extension',Extension)
? SELF.Debug.MethodEnd()
  RETURN SELF.Extension
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetLogFormatLimit  PROCEDURE(BYTE LogFormatLimit)
  CODE  
? SELF.Debug.MethodStart('SetLogFormatLimit','(BYTE LogFormatLimit)',jcLogDebugShow:SetLogFormatLimit)
    SELF.LogFormatLimit = LogFormatLimit
?   SELF.Debug.ShowCurrentMethodValue('LogFormatLimit',SELF.GetLogFormatLimit())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetLogFormatLimit  PROCEDURE()
LogFormatLimit                    LIKE(jcLogManager.LogFormatLimit)
  CODE  
?   SELF.Debug.MethodStart('GetLogFormatLimit',,jcLogDebugShow:GetLogFormatLimit)
      LogFormatLimit = SELF.LogFormatLimit
?   SELF.Debug.ShowCurrentMethodValue('LogFormatLimit',LogFormatLimit)
? SELF.Debug.MethodEnd()
  RETURN SELF.LogFormatLimit
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetLogFormat         		      PROCEDURE(BYTE LogFormat)
  CODE  
! Set log Format use by SetLogFileName second parameter LogFormat
! LogFormat 1 = FileName only 
! LogFormat 2 = ApplicationName-FileName 
! LogFormat 3 = ApplicationName-Date-Time-(FileName)  
! LogFormat 4 = ClassName-Date-Time-(FileName)  
? SELF.Debug.MethodStart('SetLogFormat','(BYTE LogFormat)',jcLogDebugShow:SetLogFormat)
    IF NOT SELF.GetLogFormatLimit() THEN SELF.SetLogFormatLimit(JC_LOG_jcLogManager_SetLineFormatLimit).
    IF NOT INRANGE(LogFormat,1,SELF.GetLogFormatLimit()) THEN
      SELF.LogFormat = JC_LOG_jcLogManager_SetLogFormat
    ELSE      
      SELF.LogFormat = LogFormat
    END
?   SELF.Debug.ShowCurrentMethodValue('LogFormat',SELF.GetLogFormat())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetLogFormat   PROCEDURE()
LogFormat                     LIKE(jcLogManager.LogFormat)
  CODE  
?   SELF.Debug.MethodStart('GetLogFormat',,jcLogDebugShow:GetLogFormat)
      LogFormat = SELF.LogFormat
?   SELF.Debug.ShowCurrentMethodValue('LogFormat',LogFormat)
? SELF.Debug.MethodEnd()
  RETURN SELF.LogFormat
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetLineFormatLimit     		    PROCEDURE(BYTE LineFormatLimit)
  CODE  
? SELF.Debug.MethodStart('SetLineFormatLimit','(BYTE LineFormatLimit)',jcLogDebugShow:SetLineFormatLimit)
    SELF.LineFormatLimit = LineFormatLimit
?   SELF.Debug.ShowCurrentMethodValue('LineFormatLimit',SELF.GetLineFormatLimit())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetLineFormatLimit PROCEDURE()
LineFormatLimit                   LIKE(jcLogManager.LineFormatLimit)
  CODE  
?   SELF.Debug.MethodStart('GetLineFormatLimit',,jcLogDebugShow:GetLineFormatLimit)
      LineFormatLimit = SELF.LineFormatLimit
?     SELF.Debug.ShowCurrentMethodValue('LineFormatLimit',LineFormatLimit)
? SELF.Debug.MethodEnd()
  RETURN SELF.LineFormatLimit
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetLineFormat         		      PROCEDURE(BYTE LineFormat)
  CODE  
? SELF.Debug.MethodStart('SetLineFormat','(BYTE LineFormat)',jcLogDebugShow:SetLineFormat)
    IF NOT INRANGE(LineFormat,1,SELF.GetLineFormatLimit())
      SELF.LineFormat = JC_LOG_jcLogManager_SetLineFormat
    ELSE
      SELF.LineFormat = LineFormat
    END
?   SELF.Debug.ShowCurrentMethodValue('LineFormat',SELF.GetLineFormat())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetLineFormat  PROCEDURE()
LineFormat                    LIKE(jcLogManager.LineFormat)
  CODE  
?   SELF.Debug.MethodStart('GetLineFormat',,jcLogDebugShow:GetLineFormat)
      LineFormat = SELF.LineFormat
?     SELF.Debug.ShowCurrentMethodValue('LineFormat',LineFormat)
? SELF.Debug.MethodEnd()
  RETURN SELF.LineFormat
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetLogFileName           		  PROCEDURE(<ASTRING LogFileName>,<BYTE LogFormat>)
aPath     BOOL
FileName  ASTRING
  CODE  
? SELF.Debug.MethodStart('SetLogFileName','(<ASTRING LogFileName>,<BYTE LogFormat>)',jcLogDebugShow:SetLogFileName)  
    !IF SELF.LogFileName &= NULL THEN SELF.LogFileName &= jcLogFileName.
    !STOP('SetLogFileName LogFileName parameter ' & LogFileName)
    !STOP('SetLogFileName LogFormat parameter ' & LogFormat)
    !STOP('Path ' & SELF.GetPath())
    !STOP('LEN(Path) ' & LEN(SELF.GetPath()))
?   SELF.Debug.ShowValue('LogFileName parameter',LogFileName)
?   SELF.Debug.ShowValue('LogFormat parameter',LogFormat)
?   SELF.Debug.ShowValue('Path',SELF.GetPath())
?   SELF.Debug.ShowValue('LEN(Path)',LEN(SELF.GetPath()))
    !IF LEN(SELF.GetPath()) > 0 THEN aPath = TRUE.
    IF SELF.GetPath() THEN aPath = TRUE ELSE aPath = FALSE.
    IF OMITTED(2) THEN
      LogFormat = 0
    ELSE
      IF OMITTED(3) THEN LogFormat = 1.
    END
   DO FormatFile
?  SELF.Debug.ShowCurrentMethodValue('GetLogFileName() ' & SELF.GetLogFileName())
   !STOP('GetLogFileName() ' & SELF.GetLogFileName())
? SELF.Debug.MethodEnd()  
FormatFile                   ROUTINE
? SELF.Debug.RoutineStart('FormatFile')
?   SELF.Debug.ShowValue('LogFormat',LogFormat)
    IF LogFormat = 0 THEN   ! When there is no LogFormat assigned
?     SELF.Debug.ShowValue('aPath',aPath)
?     SELF.Debug.ShowValue('LEN(SELF.LogFileName)',LEN(SELF.GetLogFileName()))
      IF NOT LEN(SELF.LogFileName) THEN
?       SELF.Debug.See('IF NOT LEN(SELF.LogFileName)')
        IF aPath THEN
?         SELF.Debug.See('IF aPath = TRUE THEN')
          FileName = SELF.GetPath() & jcLog::BackSlash & jcLog::DefaultLogFileName
?         SELF.Debug.ShowCurrentMethodValue('LogFileName',SELF.GetLogFileName())
        ELSE
?         SELF.Debug.See('IF aPath = FALSE THEN')
          FileName = jcLog::DefaultLogFileName       
?         SELF.Debug.ShowCurrentMethodValue('LogFileName',SELF.GetLogFileName())
        END
      END
    ELSE  
?     SELF.Debug.See('IF LogFormat > 0 THEN')
      DO VerifyLogFileNameAssignment
?     SELF.Debug.See('Before calling the conditional aPath')
?     SELF.Debug.ShowValue('aPath',aPath,_Show)
?     SELF.Debug.ShowCurrentMethodValue('GetPath()',SELF.GetPath())
?     SELF.Debug.ShowValue('LogFileName',LogFileName,_Show)
?     SELF.Debug.ShowCurrentMethodValue('GetExtension()',SELF.GetExtension())
?     SELF.Debug.ShowCurrentMethodValue('GetApplicationName()',SELF.GetApplicationName())
?     SELF.Debug.ShowCurrentMethodValue('GetLogFormat()',SELF.GetLogFormat())
?     SELF.Debug.ShowCurrentMethodValue('GetDate()',SELF.GetDate())
?     SELF.Debug.ShowCurrentMethodValue('GetTime()',SELF.GetTime())
      IF aPath THEN
        EXECUTE SELF.GetLogFormat()
          FileName = SELF.GetPath() & jcLog::BackSlash & LogFileName & SELF.GetExtension()
          FileName = SELF.GetPath() & jcLog::BackSlash & SELF.GetApplicationName() & jcLog::Hyphen & LogFileName & SELF.GetExtension()
          FileName = SELF.GetPath() & jcLog::BackSlash & SELF.GetApplicationName() & jcLog::Hyphen & SELF.GetDate() & jcLog::Arobas & SELF.GetTime() & jcLog::OpenParenthesis & LogFileName & jcLog::CloseParenthesis & SELF.GetExtension()
          FileName = SELF.GetPath() & jcLog::BackSlash & SELF.GetClassName()       & jcLog::Hyphen & SELF.GetDate() & jcLog::Arobas & SELF.GetTime() & jcLog::OpenParenthesis & LogFileName & jcLog::CloseParenthesis & SELF.GetExtension()
        END    
      ELSE
        EXECUTE SELF.GetLogFormat()  
          FileName = LogFileName & SELF.GetExtension()
          FileName = SELF.GetApplicationName() & jcLog::Hyphen & LogFileName & SELF.GetExtension()
          FileName = SELF.GetApplicationName() & jcLog::Hyphen & SELF.GetDate() & jcLog::Arobas & SELF.GetTime() & jcLog::OpenParenthesis & LogFileName & jcLog::CloseParenthesis & SELF.GetExtension()
          FileName = SELF.GetClassName()       & jcLog::Hyphen & SELF.GetDate() & jcLog::Arobas & SELF.GetTime() & jcLog::OpenParenthesis & LogFileName & jcLog::CloseParenthesis & SELF.GetExtension()
        END    
      END
    END
    SELF.LogFileName  = FileName
?     SELF.Debug.ShowCurrentMethodValue('LogFileName',SELF.LogFileName)
? SELF.Debug.RoutineEnd()
VerifyLogFileNameAssignment       ROUTINE
? SELF.Debug.RoutineStart('VerifyLogFileNameAssignment')
?   SELF.Debug.ShowCurrentMethodValue('GetLogFormatLimt()',SELF.GetLogFormatLimit())
    IF NOT SELF.GetLogFormatLimit() THEN
      SELF.SetLogFormatLimit(JC_LOG_jcLogManager_SetLogFormatLimit) !If more LogFormat is added then change the equate value to the number of log format within the EXECUTE SELF.GetLogFormat() statement
    END
?   SELF.Debug.ShowCurrentMethodValue('GetLogFormat()',SELF.GetLogFormat())
    IF NOT SELF.GetLogFormat() THEN
      IF NOT OMITTED(3) THEN
        SELF.SetLogFormat(LogFormat)
      END
    END
?   SELF.Debug.ShowCurrentMethodValue('GetExtension()',SELF.GetExtension())
    IF NOT LEN(SELF.GetExtension()) THEN
      SELF.SetExtension(JC_LOG_jcLogManager_SetExtension)
    END
?   SELF.Debug.ShowCurrentMethodValue('GetDate()',SELF.GetDate())
    IF NOT LEN(SELF.GetDate()) THEN
      SELF.SetDate(TODAY(),SELF.GetDateFormat())
    END
    SELF.SetTime(CLOCK(),SELF.GetTimeFormat())
?   SELF.Debug.ShowCurrentMethodValue('GetTime()',SELF.GetTime())
? SELF.Debug.RoutineEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetLogFileName           		  PROCEDURE()!,ASTRING
Response    ASTRING
  CODE  
? SELF.Debug.MethodStart('GetLogFileName',,jcLogDebugShow:GetLogFileName)  
    Response = SELF.LogFileName
?   SELF.Debug.ShowCurrentMethodValue('LogFileName',Response)
? SELF.Debug.MethodEnd()
  RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetDate                        PROCEDURE(<LONG DatePar>,<ASTRING DateFormat>)
  CODE
? SELF.Debug.MethodStart('SetDate',,jcLogDebugShow:SetDate)
    IF OMITTED(2) THEN
      DatePar = TODAY()
    END
    IF OMITTED(3) THEN
      IF NOT LEN(SELF.GetDateFormat()) THEN
        SELF.SetDateFormat()
      END
    ELSE
      SELF.SetDateFormat(DateFormat)
    END
    SELF.Date = FORMAT(DatePar,SELF.GetDateFormat())	  
?   SELF.Debug.ShowCurrentMethodValue('Date',SELF.GetDate())
?   SELF.Debug.ShowCurrentMethodValue('GetDateFormat()',SELF.GetDateFormat())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetDate    PROCEDURE(<LONG DatePar>,<ASTRING DateFormat>)
Date                      LIKE(jcLogManager.Date)
  CODE
? SELF.Debug.MethodStart('GetDate',,jcLogDebugShow:GetDate)
    IF NOT OMITTED(2) AND OMITTED(3) THEN
      IF NOT LEN(SELF.GetDateFormat()) THEN
        SELF.SetDateFormat()
      END
      SELF.Date = FORMAT(DatePar,SELF.GetDateFormat())
    END
    IF NOT OMITTED(2) AND NOT OMITTED(3) THEN
      SELF.SetDateFormat(DateFormat)
      SELF.Date = FORMAT(DatePar,SELF.GetDateFormat())
    END
    Date = SELF.Date
?   SELF.Debug.ShowCurrentMethodValue('Date',Date)
? SELF.Debug.MethodEnd()  
  RETURN SELF.Date
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetTime                        PROCEDURE(<LONG TimePar>,<ASTRING TimeFormat>)
  CODE
? SELF.Debug.MethodStart('SetTime',,jcLogDebugShow:SetTime)
    IF OMITTED(2) THEN
      TimePar = CLOCK()
    END
    IF OMITTED(3) THEN
      IF NOT LEN(SELF.GetTimeFormat()) THEN
        SELF.SetTimeFormat()
      END
    ELSE
      SELF.SetTimeFormat(TimeFormat)
    END
	  SELF.Time = FORMAT(TimePar,SELF.GetTimeFormat())
?   SELF.Debug.ShowCurrentMethodValue('Time',SELF.GetTime())
?   SELF.Debug.ShowCurrentMethodValue('GetTimeFormat()',SELF.GetTimeFormat())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetTime    PROCEDURE(<LONG TimePar>,<ASTRING TimeFormat>)
Time                      LIKE(jcLogManager.Time)
  CODE
? SELF.Debug.MethodStart('GetTime',,jcLogDebugShow:GetTime)
    IF NOT OMITTED(2) AND OMITTED(3) THEN
      IF NOT LEN(SELF.GetTimeFormat()) THEN
        SELF.SetTimeFormat()
      END
      SELF.Time = FORMAT(TimePar,SELF.GetTimeFormat())
    END
    IF NOT OMITTED(2) AND NOT OMITTED(3) THEN
      SELF.SetTimeFormat(TimeFormat)
      SELF.Time = FORMAT(TimePar,SELF.GetTimeFormat())
    END      
    Time = SELF.Time
?   SELF.Debug.ShowCurrentMethodValue('Time',Time)
? SELF.Debug.MethodEnd()
  RETURN SELF.Time
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetLineNo                      PROCEDURE()
  CODE
? SELF.Debug.MethodStart('SetLineNo',,jcLogDebugShow:SetLineNo)
    SELF.LineNo += 1
?   SELF.Debug.ShowCurrentMethodValue('LineNo',SELF.GetLineNo())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetLineNo  PROCEDURE()
LineNo                    LIKE(jcLogManager.LineNo)
  CODE
?   SELF.Debug.MethodStart('GetLineNo',,jcLogDebugShow:GetLineNo)
      LineNo = SELF.LineNo
?     SELF.Debug.ShowCurrentMethodValue('LineNo',LineNo)
? SELF.Debug.MethodEnd()
  RETURN SELF.LineNo
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetSeparator                   PROCEDURE(<ASTRING Separator>)
  CODE
? SELF.Debug.MethodStart('SetSeparator',,jcLogDebugShow:SetSeparator)
    SELF.Separator = Separator
?   SELF.Debug.ShowCurrentMethodValue('Separator',SELF.GetSeparator())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetSeparator   PROCEDURE()
Separator                     LIKE(jcLogManager.Separator)
  CODE
?   SELF.Debug.MethodStart('GetSeparator',,jcLogDebugShow:GetSeparator)
      Separator = SELF.Separator
?     SELF.Debug.ShowCurrentMethodValue('Separator',Separator)
? SELF.Debug.MethodEnd()
  RETURN SELF.Separator 
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.VerifyDateFormat               PROCEDURE(<ASTRING DateFormat>)
aliveSeparator      BOOL
WorkingDateFormat   ASTRING
WorkingSeparator    ASTRING
Response            BOOL
workingDate         ASTRING
!IMPORTANT NOTE ABOUT THE DebugManager. 
!When the DateFormat parameter has an uppercase 'D' picture format The SetDateFormat(), the VerifyDateFormat() 
!are not shown in the DebugManager even if the the Method Show jcLogDebugShow:VerifyDateFormat and _SetDateFormat are set to _Show.')
!Very strange behavior. Also note when the UPPER and LOWER Clarion statements are used on the DateFormat,we have the same behavior. 
!I have changed to lower case 'd' instead of uppercase 'D' of the date picture format. This way the Debug Show is working nicely.
!I can not use the UPPER() and LOWER() statement it means the developper must make sure the input is always in lower case.
  CODE 
? SELF.Debug.MethodStart('VerifyDateFormat','(<ASTRING DateFormat>)',jcLogDebugShow:VerifyDateFormat)
?   SELF.Debug.ShowValue('SELF.Get(jcLog::DateFormat) If a Date format exist ',SELF.Get(jcLog::DateFormat))
	  IF SELF.Get(jcLog::DateFormat) = jcBases::Error THEN SELF.PrepareDateFormat().
	  WorkingSeparator = SUB(DateFormat,-1,1)
?   SELF.Debug.ShowValue('DateFormat',DateFormat)
?   SELF.Debug.ShowValue('WorkingSeparator',WorkingSeparator)
?   SELF.Debug.ShowValue('SELF.Get(jcLog::DateFormat & jcLog::Dot & jcLog::Separator,WorkingSeparator)',SELF.Get(jcLog::DateFormat & jcLog::Dot & jcLog::Separator,WorkingSeparator))
	  aliveSeparator = SELF.Get(jcLog::DateFormat & jcLog::Dot & jcLog::Separator,WorkingSeparator)
	  IF aliveSeparator THEN
	    WorkingDateFormat = SUB(DateFormat,1,LEN(DateFormat)-1)
	  ELSE
	    WorkingDateFormat = DateFormat
	  END
?   SELF.Debug.ShowValue('WorkingDateFormat',WorkingDateFormat)
?	  SELF.Debug.ShowValue('SELF.Get(jcLog::DateFormat,WorkingDateFormat)',SELF.Get(jcLog::DateFormat,WorkingDateFormat))
    Response = SELF.Get(jcLog::DateFormat,WorkingDateFormat)
    IF Response THEN
      workingDate = FORMAT(TODAY(),WorkingDateFormat)
      IF INSTRING(jcLog::Slash,workingDate,1,1) THEN
        IF NOT LEN(SELF.GetSeparator()) AND NOT aliveSeparator THEN
          SELF.SetSeparator(jcLog::Hyphen)
        END
      END
    END
?   SELF.Debug.ShowValue('WorkingSeparator',WorkingSeparator,_Hide)
?   SELF.Debug.ShowValue('aliveSeparator',SELF.Debug.GetBOOL(aliveSeparator),_Hide)
?    IF aliveSeparator THEN
?     SELF.Debug.ShowValue('Separator',WorkingSeparator)
?    END
?   SELF.Debug.ShowValue('WorkingDateFormat',WorkingDateFormat,_Hide)
?   SELF.Debug.ShowValue('VerifyDateFormat() response',SELF.Debug.GetBOOL(Response),_Hide)
? SELF.Debug.MethodEnd()
  RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.PrepareDateFormat              PROCEDURE
Counter                     BYTE
NumberOfDatePictureFormat   EQUATE(18)
  CODE
? SELF.Debug.MethodStart('PrepareDateFormat',jcLogDebugShow:PrepareDateFormat)    
    LOOP Counter = 1 TO NumberOfDatePictureFormat 
      SELF.Add(jcLog::DateFormat,jcLog::DateFormatPrefix & Counter)
    END
    SELF.Add(jcLog::DateFormat & jcLog::Dot & jcLog::Separator,jcLog::Coma)
    SELF.Add(jcLog::DateFormat & jcLog::Dot & jcLog::Separator,jcLog::Dot)
    SELF.Add(jcLog::DateFormat & jcLog::Dot & jcLog::Separator,jcLog::Hyphen)
    SELF.Add(jcLog::DateFormat & jcLog::Dot & jcLog::Separator,jcLog::Underscore)
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetDateFormat                  PROCEDURE(<ASTRING DateFormat>)
GoodDateFormat  BOOL
  CODE
? SELF.Debug.MethodStart('SetDateFormat','(<ASTRING DateFormat>)',jcLogDebugShow:SetDateFormat)
    !DateFormat = UPPER(DateFormat)
	  IF SELF.VerifyDateFormat(DateFormat) THEN 
	    IF LEN(SELF.GetSeparator()) THEN
	      DateFormat = DateFormat & SELF.GetSeparator()
	      SELF.SetSeparator('')
	    END
	    GoodDateFormat = TRUE
	  END
    IF OMITTED(2) THEN
      SELF.DateFormat = JC_LOG_jcLogManager_SetDateFormat
    ELSE        
      IF NUMERIC(DateFormat) THEN
        SELF.DateFormat = jcLog::DateFormatPrefix & DateFormat & jcLog::Hyphen
      ELSE
        IF GoodDateFormat THEN
          SELF.DateFormat = DateFormat
        ELSE
          MESSAGE(DateFormat & ' is a wrong picture token date format' & |
                  '||it must be lowercase ''d'' and ''@d?'' where ''?'' is the picture token number between 1 and 18' & |
                  '||NOTE : ' & 'A date format may not contain one of these characters' & '": < > * ? " / \ and a stand up straight line"' & |
                  '|        All date picture format containing "/" slash separator will be converted to "-" hyphen separator.' & |
                  '||ex. ''@d10-'' date format is yyyy-mm-dd','jcLogManager Error',ICON:Hand)
        END                                                     
      END
    END
?   SELF.Debug.ShowCurrentMethodValue('DateFormat',SELF.GetDateFormat())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetDateFormat  PROCEDURE()
DateFormat                    LIKE(jcLogManager.DateFormat)
  CODE
?   SELF.Debug.MethodStart('GetDateFormat',,jcLogDebugShow:GetDateFormat)
      DateFormat = SELF.DateFormat
?     SELF.Debug.ShowCurrentMethodValue('DateFormat',DateFormat)
? SELF.Debug.MethodEnd()
  RETURN SELF.DateFormat
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.PrepareTimeFormat              PROCEDURE
Counter                   BYTE
NumberOfTimePictureFormat EQUATE(8)
  CODE
? SELF.Debug.MethodStart('PrepareTimeFormat',jcLogDebugShow:PrepareTimeFormat)
    LOOP Counter = 1 TO NumberOfTimePictureFormat
      SELF.Add(jcLog::TimeFormat,jcLog::TimeFormatPrefix & Counter)
    END
    SELF.Add(jcLog::TimeFormat & jcLog::Dot & jcLog::Separator,jcLog::Coma)
    SELF.Add(jcLog::TimeFormat & jcLog::Dot & jcLog::Separator,jcLog::Dot)
    SELF.Add(jcLog::TimeFormat & jcLog::Dot & jcLog::Separator,jcLog::Hyphen)
    SELF.Add(jcLog::TimeFormat & jcLog::Dot & jcLog::Separator,jcLog::Underscore)
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.VerifyTimeFormat               PROCEDURE(<ASTRING TimeFormat>)
aliveSeparator      BOOL
WorkingTimeFormat   ASTRING
WorkingSeparator    ASTRING
Response            BOOL
workingTime         ASTRING
  CODE
? SELF.Debug.MethodStart('VerifyTimeFormat','(<ASTRING TimeFormat>)',jcLogDebugShow:VerifyTimeFormat)
?   SELF.Debug.ShowValue('SELF.Get(jcLog::TimeFormat) If a time format exist ',SELF.Get(jcLog::TimeFormat))
	  IF SELF.Get(jcLog::TimeFormat) = jcBases::Error THEN SELF.PrepareTimeFormat().
	  WorkingSeparator = SUB(TimeFormat,-1,1)
?   SELF.Debug.ShowValue('TimeFormat',TimeFormat)
?	  SELF.Debug.ShowValue('WorkingSeparator',WorkingSeparator)
?   SELF.Debug.ShowValue('SELF.Get(jcLog::TimeFormat & jcLog::Dot & jcLog::Separator,WorkingSeparator)',SELF.Get(jcLog::TimeFormat & jcLog::Dot & jcLog::Separator,WorkingSeparator))
	  aliveSeparator = SELF.Get(jcLog::TimeFormat & jcLog::Dot & jcLog::Separator,WorkingSeparator)
	  IF aliveSeparator THEN
	    WorkingTimeFormat = UPPER(SUB(TimeFormat,1,LEN(TimeFormat)-1))
	  ELSE
	    WorkingTimeFormat = UPPER(TimeFormat)
	  END
?   SELF.Debug.ShowValue('WorkingTimeFormat',WorkingTimeFormat)
?   SELF.Debug.ShowValue('SELF.Get(jcLog::TimeFormat,WorkingTimeFormat)',SELF.Get(jcLog::TimeFormat,WorkingTimeFormat))
    Response = SELF.Get(jcLog::TimeFormat,WorkingTimeFormat)
    IF Response THEN
      workingTime = FORMAT(CLOCK(),WorkingTimeFormat)
?     SELF.Debug.ShowValue('workingTime',workingTime)
      IF INSTRING(jcLog::Colon,workingTime,1,1) THEN
        IF NOT LEN(SELF.GetSeparator()) AND NOT aliveSeparator THEN
          SELF.SetSeparator(jcLog::Dot)
        END
      END
    END
?   SELF.Debug.ShowValue('WorkingSeparator',WorkingSeparator)
?   SELF.Debug.ShowValue('aliveSeparator',SELF.Debug.GetBOOL(aliveSeparator))
?    IF aliveSeparator THEN
?     SELF.Debug.ShowValue('Separator',WorkingSeparator)
?    END
?   SELF.Debug.ShowValue('WorkingTimeFormat',WorkingTimeFormat)
?   SELF.Debug.ShowValue('VerifyTimeFormat() response',SELF.Debug.GetBOOL(Response))          
? SELF.Debug.MethodEnd()
  RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetTimeFormat                  PROCEDURE(<ASTRING TimeFormat>)
GoodTimeFormat    BOOL
  CODE
? SELF.Debug.MethodStart('SetTimeFormat','(<ASTRING TimeFormat>)',jcLogDebugShow:SetTimeFormat)
	  IF SELF.VerifyTimeFormat(TimeFormat) THEN 
	    IF LEN(SELF.GetSeparator()) THEN
?       SELF.Debug.ShowValue('TimeFormat before setting the separator',TimeFormat)
	      TimeFormat = TimeFormat & SELF.GetSeparator()
?       SELF.Debug.ShowCurrentMethodValue('GetSeparator()',SELF.GetSeparator())
?      SELF.Debug.ShowValue('TimeFormat after setting the separator',TimeFormat)
	      SELF.SetSeparator('')
	    END
	    GoodTimeFormat = TRUE
	  END	  
    IF OMITTED(2) THEN
      SELF.TimeFormat = JC_LOG_jcLogManager_SetTimeFormat
    ELSE
      IF NUMERIC(TimeFormat) THEN
        SELF.TimeFormat = jcLog::TimeFormatPrefix & TimeFormat & jcLog::Dot
      ELSE
        IF GoodTimeFormat THEN
          SELF.TimeFormat = TimeFormat
        ELSE
          MESSAGE(TimeFormat & ' is a wrong picture token time format' & |
                '||it must be ''@T?'' where ''?'' is the picture token number between 1 and 8' & |
                '||NOTE : ' & 'A time format may not contain one of these characters' & '": < > * ? " / \ and a stand up straight line"' & |
                '|        All time picture format containing ":" colon separator will be converted to "." dot separator.' & |
                '||ex. ''@T4.'' time format is  hh.mm.ss 17.30.00','jcLogManager Error',ICON:Hand)
        END
      END
    END
?   SELF.Debug.ShowCurrentMethodValue('TimeFormat',SELF.GetTimeFormat())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetTimeFormat  PROCEDURE()
TimeFormat                    LIKE(jcLogManager.TimeFormat)
  CODE
?   SELF.Debug.MethodStart('GetTimeFormat',,jcLogDebugShow:GetTimeFormat)
      TimeFormat = SELF.TimeFormat
?     SELF.Debug.ShowCurrentMethodValue('TimeFormat',TimeFormat)
?   SELF.Debug.MethodEnd()
    RETURN SELF.TimeFormat
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetLineNoFormat                PROCEDURE(<ASTRING LineNoFormat>)
  CODE
? SELF.Debug.MethodStart('SetLineNoFormat','(<ASTRING LineNoFormat>)',jcLogDebugShow:SetLineNoFormat)
    IF OMITTED(2) THEN
      SELF.LineNoFormat = JC_LOG_jcLogManager_SetLineNoFormat
    ELSE
      SELF.LineNoFormat = LineNoFormat
    END
?   SELF.Debug.ShowCurrentMethodValue('LineNoFormat',SELF.GetLineNoFormat())
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.GetLineNoFormat    PROCEDURE()
LineNoFormat                      LIKE(jcLogManager.LineNoFormat)
  CODE
?   SELF.Debug.MethodStart('GetLineNoFormat',,jcLogDebugShow:GetLineNoFormat)
      LineNoFormat = SELF.LineNoFormat
?     SELF.Debug.ShowCurrentMethodValue('LineNoFormat',LineNoFormat)
? SELF.Debug.MethodEnd()
  RETURN SELF.LineNoFormat
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.SetLine               		      PROCEDURE(ASTRING Line)
Response ASTRING
LineNo   ULONG
  CODE  
? SELF.Debug.MethodStart('SetLine','(STRING Line)',jcLogDebugShow:SetLine)
?   SELF.Debug.ShowValue('GetLineFormat()',SELF.GetLineFormat())
?   SELF.Debug.ShowCurrentMethodValue('LineNo',SELF.GetLineNo())
    IF NOT SELF.LineFormat THEN
      SELF.SetLineFormat(1)
    END
    SELF.SetLineNo()
    LineNo = SELF.GetLineNo()
    IF NOT SELF.GetLineFormat() THEN
      SELF.SetLineFormat(JC_LOG_jcLogManager_SetLineFormatLimit)
    END      
    IF NOT LEN(SELF.GetLineNoFormat()) THEN
      SELF.SetLineNoFormat(JC_LOG_jcLogManager_SetLineNoFormat)
    END
    SELF.SetTimeFormat(JC_LOG_jcLogManager_SetLine_SetTimeFormat)
    EXECUTE SELF.GetLineFormat()
      Response = Line
      Response = LEFT(FORMAT(LineNo,SELF.GetLineNoFormat())) & ' ' & Line
      Response = LEFT(FORMAT(LineNo,SELF.GetLineNoFormat())) & ' ' & FORMAT(CLOCK(),SELF.GetTimeFormat()) & ' ' & Line
    END
?   SELF.Debug.ShowCurrentMethodValue('LogLine',Response)
? SELF.Debug.MethodEnd()
  RETURN Response   
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.AddLine               		      PROCEDURE(ASTRING Line)
  CODE  
? SELF.Debug.MethodStart('AddLine','(ASTRING Line)',jcLogDebugShow:AddLine)
      CLEAR(jcLogFile.Record)
!      IF NOT INSTRING('jcDebug',SELF.GetLogFileName(),1,1) THEN
!        MESSAGE('ON 1 FILE ' & SELF.GetLogFileName() & |
!                '|File Name : ' & jcLogFileName)
!      END
      jcLogFile.Record.Line = SELF.SetLine(Line)
?     SELF.Debug.ShowValue('jcLogFile.Line',jcLogFile.Line)
      ADD(jcLogFile)   
      IF ERROR() THEN
        MESSAGE('ERRORCODE : ' & ERRORCODE() & |
             '|ERROR : ' & ERROR() & |
             '|DOS FILE : ' & ERRORFILE() & |
          '|FILE : ' & SELF.GetLogFileName(),'jcLogManager Error',ICON:Hand)
      END
? SELF.Debug.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
!jcLogManager.ViewLogFile    PROCEDURE
!
!  CODE
!?   SELF.Debug.MethodStart('ViewLogFile','()',jcLogDebugShow:ViewLogFile)
!      SELF.ViewerActive = TRUE
!      ViewerLogErrors.Init
!      OPEN(SELF.ViewerLogWindow)
!      SELF.ViewerActive = SELF.Viewer.Init(SELF.File,jcLogFile.Line,SELF.LogFileName,?LogBox,ViewerLogErrors,EnableSearch+EnablePrint)
!      IF ~SELF.ViewerActive  THEN SELF.Viewer.Kill().
!      ACCEPT
!        IF EVENT() = EVENT:CloseWindow
!          IF SELF.ViewerActive THEN SELF.Viewer.Kill().
!        END
!      END
!?   SELF.Debug.MethodEnd()  

!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.ReadToQueue   PROCEDURE(*QUEUE Q,*? RecordRow,<ASTRING Filter>)
RowString                     ASTRING

  CODE
?   SELF.Debug.MethodStart('ReadToQueue','(*QUEUE Q,*? RecordRow)',jcLogDebugShow:ReadToQueue)    
      SELF.Fetch()
      LOOP 
        SELF.Next()
        IF SELF.EoF() THEN BREAK.
        IF NOT OMITTED(4) THEN
          RowString = SELF.GetRecord()
          IF INSTRING(Filter,RowString,1,1) THEN
            RecordRow = RowString
            ADD(Q)
          END
        ELSE
          RecordRow = SELF.GetRecord()                   
          ADD(Q)
        END
      END
?   SELF.Debug.MethodEnd()    
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.ReadQueueToLogFile   PROCEDURE(*QUEUE Q,*? RecordRow)

  CODE
?   SELF.Debug.MethodStart('ReadQueueToLogFile','(*QUEUE Q,*? RecordRow)',jcLogDebugShow:ReadQueueToLogFile)    
    CLEAR(Q)
    LOOP i# = 1 TO RECORDS(Q)
      GET(Q,i#)
      SELF.AddLine(RecordRow)
    END
?   SELF.Debug.MethodEnd()    
!-----------------------------------------------------------------------------------------------------------------------------------
jcLogManager.ViewLogFile    PROCEDURE()

Q           QUEUE
String        ASTRING
            END


LogWindow                     WINDOW('View Log File'),SYSTEM,AT(,,862,340),CENTER,GRAY,IMM,AUTO,STATUS, |
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

!Window                              WINDOW('Debug Queue'),SYSTEM,AT(,,676,416),CENTER,FONT('Tahoma', 8),GRAY,DOUBLE
!										LIST, AT(4,4,668,356), USE(?DebugList), HVSCROLL
!										LIST, AT(4,364,668,48), USE(?MessageList), VSCROLL, FROM(MsgLineQ)
!									END

  CODE
?   SELF.Debug.MethodStart('ViewLogFile','()',jcLogDebugShow:ViewLogFile)
    FREE(Q)    
    OPEN(LogWindow)
    ACCEPT
      CASE SELECTED()
      OF ?List:Q
        SELF.ReadToQueue(Q,Q.String)
        CYCLE
      END
      CASE Field()
      OF ?CloseButton
        CASE EVENT()
        OF EVENT:Accepted;BREAK.
      END
    END      
    FREE(Q)  
?   SELF.Debug.MethodEnd()                              

!===================================================== End of jcLogManager =======================================================

OpenFile                                    PROCEDURE(*FILE FileName,ASTRING LogFileName)
  CODE
    CLOSE(FileName)
    SHARE(FileName)
    IF ERRORCODE() = 2 THEN
      CLOSE(FileName)
      CREATE(FileName)
      SHARE(FileName)
    END  
    CLOSE(FileName)
    SHARE(FileName)
    IF ERROR() THEN
     MESSAGE('ERRORCODE : ' & ERRORCODE() & |
             '|ERROR : ' & ERROR() & |
             '|NOTE : ' & 'A file name may not contain one of these characters'  & '": < > * ? " / \ and a stand up straight line"' & |
             '|FILE : ' & LogFileName,'jcLogManager Error',ICON:Hand)
       RETURN
    END
