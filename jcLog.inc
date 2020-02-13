!ABCIncludeFile(Joliciel)
!
! Joliciel 2012

jcLogFileName       STRING(255)

!jc Log file
	OMIT('***',_Export_Joliciel_Classes_)
jcLogFile           FILE,DRIVER('ASCII'),NAME(jcLogFileName),CREATE,EXTERNAL(''),DLL(Dll_mode)
  ***
	COMPILE('***',_Export_Joliciel_Classes_)
jcLogFile           FILE,DRIVER('ASCII'),NAME(jcLogFileName),CREATE !,THREAD
  ***
Record                RECORD
Line                    STRING(2000)
                      END
                    END
  OMIT('_EndOfInclude_',_jcLog_)
_jcLog_ EQUATE(1)
  
                      INCLUDE('ABAscii.inc'),ONCE
                      INCLUDE('jcBase.inc'),ONCE
                      INCLUDE('jcField.inc'),ONCE
             !        INCLUDE('jcDebug.inc'),ONCE
                      INCLUDE('jcDebugPrivate.inc'),ONCE
                      INCLUDE('jcDebug.equ'),ONCE
                      INCLUDE('jcLog.equ'),ONCE
                      INCLUDE('jcLogshow.equ'),ONCE 
                      INCLUDE('jcLogShow.inc'),ONCE
                      INCLUDE('jcLogWhenTask.equ'),ONCE




!Window to view the log file
!ViewLogWindow       WINDOW('View the log file'),AT(3,7,507,286),GRAY,SYSTEM,FONT(,,, |
!                      FONT:regular,CHARSET:DEFAULT)
!                      LIST,AT(5,5,494,262),USE(?LogBox),IMM
!                      BUTTON('&Print'),AT(4,270),USE(?Print)
!                      BUTTON('&Search'),AT(46,270),USE(?Search)
!                      BUTTON('&Close'),AT(467,270),USE(?Close)
!                    END
ViewerLogErrors         ErrorClass                                                 !Viewer Error 

!The jcLogManager Class manage the manipulation of jcLogFIle

jcLogManager         CLASS(jcBase),TYPE,Module('jcLog.Clw'),LINK('jcLog.Clw',_JCLinkMode_),DLL(_JCDllMode_),THREAD
! Properties
Debug                  &jcDebugManagerPrivate                                       !Debugging the current Class
!Debug                 &jcDebugManager                                             !Reference to jcDebugManagerPrivate class    
!Viewer                  &AsciiViewerClass!,THREAD                                   !Viewing the log file 
!ViewerActive            BYTE!,THREAD                                                !Viewer state
!ViewerLogWindow         &WINDOW                                                      !Reference to a window
ViewLogFile            PROCEDURE(),VIRTUAL                                         !View the log file
File                   &FILE,PRIVATE                                                !Log File creation
Logued                 BOOL,PRIVATE                                                 !Are we using jcLogManager if yes TRUE then we log otherwise no FALSE nothing is hapening
Path                   ASTRING,PRIVATE                                              !Set the pathe use the EQUATE
LogFileName            &STRING!,THREAD                                              !The log file name reference, it reference to jcLogFileName STRING declare above. jcLogFileName is used as the parameter of the NAME(jcLogFileName) of the jcLogFile
!LogFileNumberUsed      BYTE,PRIVATE                                                 !LogFile sets the current jcLogFile used when initializing the jcLogManager. We can initialized up to 5 concurrent log file. Each time the log manager is invoked the LogFile is incrementing of 1 up to 5
ExtensionName          STRING(30),PRIVATE                                           !The Extension name of the log file
LineNoFormat           ASTRING,PRIVATE                                              !Set with SetLineNoFormat(), LineNoFormat = JC_LOG_jcLogManager_SetLineNoFormat EQUATE()
DateFormat             ASTRING,PRIVATE                                              !Set with SetDateFormat('@d?') or SetDateFormat(?) where '?' is the picture token format number
TimeFormat             ASTRING,PRIVATE                                              !Set with SetTimeFormat('@T?') or SetTimeFormat(?) where '?' is the picture token format number
LineFormat             BYTE,PRIVATE                                                 !Line format use by SetLine second parameter type,<br/> Format 1 = Line from Debug, <br/> Format 2 = LineNo and Line <br/> Format 3 = LineNo Time and Line
LineFormatLimit        BYTE,PRIVATE                                                 !Line format limit holds the number of line format used
LogFormat              BYTE,PRIVATE                                                 !Log Format use by SetLogFileName second parameter LogFormat,<br/> LogFormat 1 = FileName only <br/> LogFormat 2 = ApplicationName-FileName <br/> LogFormat 3 = ApplicationName-Date-Time-(FileName)
LogFormatLimit         BYTE,PRIVATE                                                 !Log Format limit holds the number of log format used
LineNo                 LONG,PRIVATE                                                 !LineNo defines in SetLine()
Date                   ASTRING,PRIVATE                                              !Formated date
Time                   ASTRING,PRIVATE                                              !Formated time
Extension              ASTRING,PRIVATE                                              !Extension of the log file defines in SetExtension()
Separator              ASTRING,PRIVATE                                              !Date and Time separator
!Methods
!Initialized the class
Construct              PROCEDURE                                                    !Begins the jcDebug scope instance
!Setup of the class elements
Init                   PROCEDURE(<STRING LogFileName>,<BOOL SetLog>,<BYTE LogFormat>), VIRTUAL  !Initialized the jcLogManager to the optional LogFileName parameter and optional SetLog Set(TRUE) log to a file and Set(FALSE) do not log to a file.<br/> The optional Log Format parameter  set the FileName format use by SetLogFileName second parameter LogFormat,<br/> LogFormat 1 = FileName only <br/> LogFormat 2 = ApplicationName-FileName <br/> LogFormat 3 = ApplicationName-Date-Time-(FileName).<br/>If the first parameter is omitted it default to the defined equate jcLog::DefaultLogFileName "Debug.log" found in jcLog.inc file.<br/>If the second parameter is omitted it default to the defined equate JC_LOG_jcLogManager_Set "TRUE" found in jcLog.inc file.<br/>If the third parameter is omitted then the LogFormat is set to the defined equate JC_LOG_jcLogManager_SetLogFormat "3" in jcLog.inc file
Init                   PROCEDURE(*FILE File,STRING LogFileName,<BOOL SetLog>,<BYTE LogFormat>), VIRTUAL  !Initialized the jcLogManager to the optional LogFileName parameter and optional SetLog Set(TRUE) log to a file and Set(FALSE) do not log to a file.<br/> The optional Log Format parameter  set the FileName format use by SetLogFileName second parameter LogFormat,<br/> LogFormat 1 = FileName only <br/> LogFormat 2 = ApplicationName-FileName <br/> LogFormat 3 = ApplicationName-Date-Time-(FileName).<br/>The first parameter may not be omitted is the File structure name.<br/>The second parameter may not omitted omitted is the physical filename.<br/>If the third parameter is omitted it default to the defined equate JC_LOG_jcLogManager_Set "TRUE" found in jcLog.inc file.<br/>If the forth parameter is omitted then the LogFormat is set to the defined equate JC_LOG_jcLogManager_SetLogFormat "3" in jcLog.inc file
PrepareClassName       PROCEDURE(*jcLogManager jcLogClass,<ASTRING DeclaredClassName>),VIRTUAL
Set                    PROCEDURE(BOOL Log), VIRTUAL                                 !Set Log TRUE Log is active FALSE log is inactive
Get                    PROCEDURE(),BOOL,VIRTUAL                                     !Get Log status TRUE Log is active FALSE log is inactive
!Setup of the physical log file name, format and extension
 !GetLogFileNumberUsed   PROCEDURE(),BYTE,VIRTUAL                                     !Get the LogFile. LogFile gets the current jcLogFile used when initializing the jcLogManager. We can initialized up to 5 concurrent log file. Each time the log manager is invoked the LogFile is incrementing of 1 up to 5. 
SetFile                PROCEDURE(<ASTRING LogFileName>,<BYTE LogFormat>),VIRTUAL    !Set the physical log file. First optional parameter is the name of the log file. <br/> Log Format parameter  set the format of the FileName use by SetLogFileName second parameter LogFormat,<br/> LogFormat 1 = FileName only <br/> LogFormat 2 = ApplicationName-FileName <br/> LogFormat 3 = ApplicationName-Date-Time-(FileName)
SetFileServer          PROCEDURE(BYTE Server),PRIVATE
OpenFile                PROCEDURE(*FILE File),VIRTUAL
CloseFile               PROCEDURE(*FILE File),VIRTUAL
Fetch                  PROCEDURE(),VIRTUAL                    !Fetch the current LogFile
Next                   PROCEDURE(),VIRTUAL                    !Read the current LogFile
GetRecord              PROCEDURE(),STRING,VIRTUAL             !Get the current record line of the current logFile
EoF                    PROCEDURE(),BOOL,VIRTUAL               !Verify the EOF the current logFile
GetFileLabel           PROCEDURE(),ASTRING,VIRTUAL                                  !Get the File Name Label
SetPath                PROCEDURE(ASTRING Path),VIRTUAL                              !Set the log path, if none the default path is the equate JC_LOG_jcLogManager_SetExtension, the parameter of the equate is 'Log'.
GetPath                PROCEDURE(),ASTRING,VIRTUAL                                  !Get the log path used by SetLogFileName. Prior to call GetPath() a call to SetPath(Path) is necessary. Usually in the Init method or before calling SetLogFileName()
SetExtension           PROCEDURE(<ASTRING LogFileName>),VIRTUAL                     !Set the file extension. <br/> if no parameter it default to JC_LOG_jcLogManager_SetExtension EQUATE defines earlier in the jcLog.inc source file, <br/>  the dot behind is used if not passed. Format of SetExtesion(), is <br/> SELF.SetExtension(txt) = .txt, <br/> SELF.SetExtension(.doc) = .doc
GetExtension           PROCEDURE(),ASTRING,VIRTUAL                                  !Get the file extension 
SetLogFormatLimit      PROCEDURE(BYTE LogFormatLimit),VIRTUAL                       !Set log Format limit if 2 then the range is between 1 and 2 otherewise the log format is out of range
GetLogFormatLimit      PROCEDURE(),BYTE,VIRTUAL                                     !Get Log Format Limit
SetLogFormat           PROCEDURE(BYTE LogFormat),VIRTUAL                            !Set log Format use by SetLogFileName second parameter LogFormat,<br/> LogFormat 1 = FileName only <br/> LogFormat 2 = ApplicationName-FileName <br/> LogFormat 3 = ApplicationName-Date-Time-(FileName)
GetLogFormat           PROCEDURE(),BYTE,VIRTUAL                                     !Get Log Format use by SetLogFileName second parameter LogFormat,<br/> LogFormat 1 = FileName only <br/> LogFormat 2 = ApplicationName-FileName <br/> LogFormat 3 = ApplicationName-Date-Time-(FileName)
SetLogFileName         PROCEDURE(<ASTRING LogFileName>,<BYTE LogFormat>),VIRTUAL    !Set the LogFileName format
GetLogFileName          PROCEDURE (),ASTRING,VIRTUAL                                 !Get the LogFilename 
ReadToQueue             PROCEDURE(*QUEUE Q,*? RecordRow,<ASTRING Filter>),VIRTUAL !Sending the log file to a Queue
ReadQueueToLogFile      PROCEDURE(*QUEUE Q,*? RecordRow),VIRTUAL !Sending The Queue to Log file


!Setup of the the record
SetDate                PROCEDURE(<LONG DatePar>,<ASTRING DateFormat>),VIRTUAL       !Prepare Date and Format it
GetDate                PROCEDURE(<LONG DatePar>,<ASTRING DateFormat>),ASTRING,VIRTUAL !Get the formated date add the same parameters as SetDate. The reason the function will have the same possibility to format the date 
SetTime                PROCEDURE(<LONG TimePar>,<ASTRING TimeFormat>),VIRTUAL       !Prepare Time and Format it. The first parameter is the time and the second is the format.<br/>Format the Time. Initialized in Init method, used by SetLine(),<br/>default equate is JC_LOG_jcLogManager_SetTimeFormat<br/><br/>Set with SetTimeFormat('@T?') or SetTimeFormat(?) where '?' is the picture token format number,<br/>TimeFormat = JC_LOG_jcLogManager_SetTimeFormat EQUATE().<br/><br/>Picture   Format       Result<br/>@T1       hh:mm        17:30<br/>@T2       hhmm         1730<br/>@T3       hh:mmXM      5:30PM<br/>@T03      hh:mmXM      05:30PM<br/>@T4       hh:mm:ss     17:30:00<br/>@T5       hhmmss       173000<br/>@T6       hh:mm:ssXM   5:30:00PM<br/>@T7                    Windows Control Panel setting for Short Time<br/>@T8                    Windows Control Panel setting for Long Time<br/><br/>Alternate separators<br/>@T1.      hh.mm        Period separator<br/>@T1-      hh-mm        Dash separator<br/>@T3_      hh mmXM      Underscore produces space separator<br/>@T4'      hh,mm,ss     Grave accent produces comma separator
GetTime                PROCEDURE(<LONG TimePar>,<ASTRING TimeFormat>),ASTRING,VIRTUAL !Get the formated Time add the same parameters as SetTime. The reason the function will have the same possibility to format the time 
SetSeparator           PROCEDURE(<ASTRING Separator>),VIRTUAL                       !Set the separator
GetSeparator           PROCEDURE(),ASTRING,VIRTUAL                                  !Get the separator
VerifyDateFormat       PROCEDURE(<ASTRING DateFormat>),BOOL,PRIVATE                 !Verify if the Date Format is OK
PrepareDateFormat      PROCEDURE(),PRIVATE                                          !PrepareDateFormat set the list of valid date picture token format.<br/>SetDateFormat method needs the list to validate the picture format used.<br/> To validate the Date picture token format is as follows.<br/> IF SELF.Get(jcLog::DateFormat,'@D?') where '?' is a valid picture token number between 1 and 18.
SetDateFormat          PROCEDURE(<ASTRING DateFormat>),VIRTUAL                      !Format the Date. Initialized in Init method, used by SetLine(),<br/>default equate is JC_LOG_jcLogManager_SetDateFormat<br/><br/>Set with SetDateFormat('@d?') or SetDateFormat(?) where '?' is the picture token format number,<br/>DateFormat = JC_LOG_jcLogManager_SetDateFormat EQUATE().<br/><br/>Picture Format               Result<br/>@D1      mm/dd/yy             10/31/59<br/>@D1>40   mm/dd/yy             10/31/59<br/>@D01     mm/dd/yy             01/01/95<br/>@D2      mm/dd/yyyy           10/31/1959<br/>@D3      mmm dd,yyyy          OCT 31,1959<br/>@D4      mmmmmmmmm dd, yyyy   October 31, 1959<br/>@D5      dd/mm/yy             31/10/59<br/>@D6      dd/mm/yyyy           31/10/1959<br/>@D7      dd mmm yy            31 OCT 59<br/>@D8      dd mmm yyyy          31 OCT 1959<br/>@D9      yy/mm/dd             59/10/31<br/>@D10     yyyy/mm/dd           1959/10/31<br/>@D11     yymmdd               591031<br/>@D12     yyyymmdd             19591031<br/>@D13     mm/yy                10/59<br/>@D14     mm/yyyy              10/1959<br/>@D15     yy/mm                59/10<br/>@D16     yyyy/mm              1959/10<br/>@D17                          Windows Control Panel setting for Short Date<br/>@D18                          Windows Control Panel setting for Long Date<br/><br/>Alternate separators<br/>@D1.     mm.dd.yy             Period separator<br/>@D2-     mm-dd-yyyy           Dash separator<br/>@D5_     dd mm yy             Underscore produces space separator<br/>@D6`     dd,mm,yyyy           Grave accent produces comma separator<br/>
GetDateFormat          PROCEDURE(),ASTRING,VIRTUAL                                  !Get the date format
VerifyTimeFormat       PROCEDURE(<ASTRING TimeFormat>),BOOL,PRIVATE                 !Verify if the Time Format is OK
PrepareTimeFormat      PROCEDURE(),PRIVATE                                          !PrepareTimeFormat set the list of valid date picture token format.<br/>SetTimeFormat method needs the list to validate the picture format used.<br/> To validate the Date picture token format is as follows.<br/> IF SELF.Get(jcLog::TimeFormat,'@T?') where '?' is a valid picture token number between 1 and 8.
SetTimeFormat          PROCEDURE(<ASTRING TimeFormat>),VIRTUAL                      !Format the Time. Initialized in Init method, used by SetLine(),<br/>default equate is JC_LOG_jcLogManager_SetTimeFormat<br/><br/>Set with SetTimeFormat('@T?') or SetTimeFormat(?) where '?' is the picture token format number,<br/>TimeFormat = JC_LOG_jcLogManager_SetTimeFormat EQUATE().<br/><br/>Picture   Format       Result<br/>@T1       hh:mm        17:30<br/>@T2       hhmm         1730<br/>@T3       hh:mmXM      5:30PM<br/>@T03      hh:mmXM      05:30PM<br/>@T4       hh:mm:ss     17:30:00<br/>@T5       hhmmss       173000<br/>@T6       hh:mm:ssXM   5:30:00PM<br/>@T7                    Windows Control Panel setting for Short Time<br/>@T8                    Windows Control Panel setting for Long Time<br/><br/>Alternate separators<br/>@T1.      hh.mm        Period separator<br/>@T1-      hh-mm        Dash separator<br/>@T3_      hh mmXM      Underscore produces space separator<br/>@T4'      hh,mm,ss     Grave accent produces comma separator
GetTimeFormat          PROCEDURE(),ASTRING,VIRTUAL                                  !Get the time format
SetLineNoFormat        PROCEDURE(<ASTRING LineNoFormat>),VIRTUAL                    !Format the LineNo. Initialized in Init method, used by SetLine(), default equate is JC_LOG_jcLogManager_SetLineNoFormat
GetLineNoFormat        PROCEDURE(),ASTRING,VIRTUAL                                  !Get the LineNo format
SetLineFormatLimit     PROCEDURE(BYTE LineFormatLimit),VIRTUAL                      !Use by SetLine SetLineFormatLimit assign the number of lineFormat if 3 the range limit is between 1 and 3, this will ensure the number of Line format used, it is setup in the Init() method and reassign in the SetLine method
GetLineFormatLimit     PROCEDURE(),BYTE,VIRTUAL                                     !Get Line Format
SetLineFormat          PROCEDURE(BYTE LineFormat),VIRTUAL                           !Use by SetLine SetLineFormat formats the line of the record according to one of the three defines format,<br/> Format 1 = Line from Debug, <br/> Format 2 = LineNo and Line <br/> Format 3 = LineNo Time and Line
GetLineFormat          PROCEDURE(),BYTE,VIRTUAL                                     !Get Line Format
SetLineNo              PROCEDURE(),VIRTUAL                                          !Set Line No it will increment LineNo + 1
GetLineNo              PROCEDURE(),ULONG,VIRTUAL                                    !Get Line No 
SetLine                PROCEDURE(ASTRING Line),ASTRING,VIRTUAL                       !SetLine ,<br/> Format 1 = Line from Debug, <br/> Format 2 = LineNo and Line <br/> Format 3 = LineNo Time and Line
!Adding a record to the log file
AddLine                PROCEDURE(ASTRING Line),VIRTUAL                               !Add line to the log file
!Terminate the class
Destruct               PROCEDURE                                                    !End the jcDebug scope instance
Kill                   PROCEDURE () ,VIRTUAL                                        !Removing the Class scope instance from memory
                    END
!_EndOfInclude_
