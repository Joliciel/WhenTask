!This list of variables that are used for the status of the DebugManager Show of the procedure for each jcLogManagermethods that are in jcLog.clw
!They are used as a third parameter show for each MethodStart()
! ex. SELF.Debug.MethodStart('Init,,jcDebugShow:jcLogManager.Init)

         INCLUDE('jcLogShowOptions.inc'),ONCE
         OMIT('_jcLogShowVariables_',_SelectjcLogVariablesShow_)

!jcLogManager jcDebugShow:jcLogManager
jcDebugShow:jcLogManager                GROUP,PRE(jcLogDebugShow)
ViewLogFile                               BOOL !PROCEDURE(),VIRTUAL                                         !View the log file
Construct                                 BOOL !PROCEDURE                                                    !Begins the jcDebug scope instance
Init                                      BOOL !PROCEDURE(<STRING LogFileName>,<BOOL SetLog>,<BYTE LogFormat>), VIRTUAL  !Initialized the jcLogManager to the optional LogFileName parameter and optional SetLog Set(TRUE) log to a file and Set(FALSE) do not log to a file.<br/> The optional Log Format parameter  set the FileName format use by SetLogFileName second parameter LogFormat,<br/> LogFormat 1 = FileName only <br/> LogFormat 2 = ApplicationName-FileName <br/> LogFormat 3 = ApplicationName-Da
Init2                                     BOOL !PROCEDURE(*FILE File,STRING LogFileName,<BOOL SetLog>,<BYTE LogFormat>), VIRTUAL  !Initialized the jcLogManager to the optional LogFileName parameter and optional SetLog Set(TRUE) log to a file and Set(FALSE) do not log to a file.<br/> The optional Log Format parameter  set the FileName format use by SetLogFileName second parameter LogFormat,<br/> LogFormat 1 = FileName only <br/> LogFormat 2 = ApplicationName-FileName <br/> LogFormat 3 = Applicati
PrepareClassName                          BOOL !PROCEDURE(*jcLogManager jcLogClass,<ASTRING DeclaredClassName>),VIRTUAL
Set                                       BOOL !PROCEDURE(BOOL Log), VIRTUAL                                 !Set Log TRUE Log is active FALSE log is inactive
Get                                       BOOL !PROCEDURE(),BOOL,VIRTUAL                                     !Get Log status TRUE Log is active FALSE log is inactive
SetFile                                   BOOL !PROCEDURE(<ASTRING LogFileName>,<BYTE LogFormat>),VIRTUAL    !Set the physical log file. First optional parameter is the name of the log file. <br/> Log Format parameter  set the format of the FileName use by SetLogFileName second parameter LogFormat,<br/> LogFormat 1 = FileName only <br/> LogFormat 2 = ApplicationName-FileName <br/> LogFormat 3 = ApplicationName-Date-Time-(FileName)
SetFileServer                             BOOL !PROCEDURE(BYTE Server),PRIVATE
OpenFile                                  BOOL !PROCEDURE(*FILE File),VIRTUAL
CloseFile                                 BOOL !PROCEDURE(*FILE File),VIRTUAL
Fetch                                     BOOL !PROCEDURE(),VIRTUAL                    !Fetch the current LogFile
Next                                      BOOL !PROCEDURE(),VIRTUAL                    !Read the current LogFile
GetRecord                                 BOOL !PROCEDURE(),STRING,VIRTUAL             !Get the current record line of the current logFile
EoF                                       BOOL !PROCEDURE(),BOOL,VIRTUAL               !Verify the EOF the current logFile
GetFileLabel                              BOOL !PROCEDURE(),ASTRING,VIRTUAL                                  !Get the File Name Label
SetPath                                   BOOL !PROCEDURE(ASTRING Path),VIRTUAL                              !Set the log path, if none the default path is the equate JC_LOG_jcLogManager_SetExtension, the parameter of the equate is 'Log'.
GetPath                                   BOOL !PROCEDURE(),ASTRING,VIRTUAL                                  !Get the log path used by SetLogFileName. Prior to call GetPath() a call to SetPath(Path) is necessary. Usually in the Init method or before calling SetLogFileName()
SetExtension                              BOOL !PROCEDURE(<ASTRING LogFileName>),VIRTUAL                     !Set the file extension. <br/> if no parameter it default to JC_LOG_jcLogManager_SetExtension EQUATE defines earlier in the jcLog.inc source file, <br/>  the dot behind is used if not passed. Format of SetExtesion(), is <br/> SELF.SetExtension(txt) = .txt, <br/> SELF.SetExtension(.doc) = .doc
GetExtension                              BOOL !PROCEDURE(),ASTRING,VIRTUAL                                  !Get the file extension
SetLogFormatLimit                         BOOL !PROCEDURE(BYTE LogFormatLimit),VIRTUAL                       !Set log Format limit if 2 then the range is between 1 and 2 otherewise the log format is out of range
GetLogFormatLimit                         BOOL !PROCEDURE(),BYTE,VIRTUAL                                     !Get Log Format Limit
SetLogFormat                              BOOL !PROCEDURE(BYTE LogFormat),VIRTUAL                            !Set log Format use by SetLogFileName second parameter LogFormat,<br/> LogFormat 1 = FileName only <br/> LogFormat 2 = ApplicationName-FileName <br/> LogFormat 3 = ApplicationName-Date-Time-(FileName)
GetLogFormat                              BOOL !PROCEDURE(),BYTE,VIRTUAL                                     !Get Log Format use by SetLogFileName second parameter LogFormat,<br/> LogFormat 1 = FileName only <br/> LogFormat 2 = ApplicationName-FileName <br/> LogFormat 3 = ApplicationName-Date-Time-(FileName)
SetLogFileName                            BOOL !PROCEDURE(<ASTRING LogFileName>,<BYTE LogFormat>),VIRTUAL    !Set the LogFileName format
GetLogFileName                            BOOL !PROCEDURE (),ASTRING,VIRTUAL                                 !Get the LogFilename
ReadToQueue                               BOOL !PROCEDURE(*QUEUE Q,*? RecordRow,<ASTRING Filter>),VIRTUAL !Sending the log file to a Queue
ReadQueueToLogFile                        BOOL !PROCEDURE(*QUEUE Q,*? RecordRow),VIRTUAL !Sending The Queue to Log file
SetDate                                   BOOL !PROCEDURE(<LONG DatePar>,<ASTRING DateFormat>),VIRTUAL       !Prepare Date and Format it
GetDate                                   BOOL !PROCEDURE(<LONG DatePar>,<ASTRING DateFormat>),ASTRING,VIRTUAL !Get the formated date add the same parameters as SetDate. The reason the function will have the same possibility to format the date
SetTime                                   BOOL !PROCEDURE(<LONG TimePar>,<ASTRING TimeFormat>),VIRTUAL       !Prepare Time and Format it. The first parameter is the time and the second is the format.<br/>Format the Time. Initialized in Init method, used by SetLine(),<br/>default equate is JC_LOG_jcLogManager_SetTimeFormat<br/><br/>Set with SetTimeFormat('@T?') or SetTimeFormat(?) where '?' is the picture token format number,<br/>TimeFormat = JC_LOG_jcLogManager_SetTimeFormat EQUATE().<br/><br/>P
GetTime                                   BOOL !PROCEDURE(<LONG TimePar>,<ASTRING TimeFormat>),ASTRING,VIRTUAL !Get the formated Time add the same parameters as SetTime. The reason the function will have the same possibility to format the time
SetSeparator                              BOOL !PROCEDURE(<ASTRING Separator>),VIRTUAL                       !Set the separator
GetSeparator                              BOOL !PROCEDURE(),ASTRING,VIRTUAL                                  !Get the separator
VerifyDateFormat                          BOOL !PROCEDURE(<ASTRING DateFormat>),BOOL,PRIVATE                 !Verify if the Date Format is OK
PrepareDateFormat                         BOOL !PROCEDURE(),PRIVATE                                          !PrepareDateFormat set the list of valid date picture token format.<br/>SetDateFormat method needs the list to validate the picture format used.<br/> To validate the Date picture token format is as follows.<br/> IF SELF.Get(jcLog::DateFormat,'@D?') where '?' is a valid picture token number between 1 and 18.
SetDateFormat                             BOOL !PROCEDURE(<ASTRING DateFormat>),VIRTUAL                      !Format the Date. Initialized in Init method, used by SetLine(),<br/>default equate is JC_LOG_jcLogManager_SetDateFormat<br/><br/>Set with SetDateFormat('@d?') or SetDateFormat(?) where '?' is the picture token format number,<br/>DateFormat = JC_LOG_jcLogManager_SetDateFormat EQUATE().<br/><br/>Picture Format               Result<br/>@D1      mm/dd/yy             10/31/59<br/>@D1>40   mm/
GetDateFormat                             BOOL !PROCEDURE(),ASTRING,VIRTUAL                                  !Get the date format
VerifyTimeFormat                          BOOL !PROCEDURE(<ASTRING TimeFormat>),BOOL,PRIVATE                 !Verify if the Time Format is OK
PrepareTimeFormat                         BOOL !PROCEDURE(),PRIVATE                                          !PrepareTimeFormat set the list of valid date picture token format.<br/>SetTimeFormat method needs the list to validate the picture format used.<br/> To validate the Date picture token format is as follows.<br/> IF SELF.Get(jcLog::TimeFormat,'@T?') where '?' is a valid picture token number between 1 and 8.
SetTimeFormat                             BOOL !PROCEDURE(<ASTRING TimeFormat>),VIRTUAL                      !Format the Time. Initialized in Init method, used by SetLine(),<br/>default equate is JC_LOG_jcLogManager_SetTimeFormat<br/><br/>Set with SetTimeFormat('@T?') or SetTimeFormat(?) where '?' is the picture token format number,<br/>TimeFormat = JC_LOG_jcLogManager_SetTimeFormat EQUATE().<br/><br/>Picture   Format       Result<br/>@T1       hh:mm        17:30<br/>@T2       hhmm         1730<
GetTimeFormat                             BOOL !PROCEDURE(),ASTRING,VIRTUAL                                  !Get the time format
SetLineNoFormat                           BOOL !PROCEDURE(<ASTRING LineNoFormat>),VIRTUAL                    !Format the LineNo. Initialized in Init method, used by SetLine(), default equate is JC_LOG_jcLogManager_SetLineNoFormat
GetLineNoFormat                           BOOL !PROCEDURE(),ASTRING,VIRTUAL                                  !Get the LineNo format
SetLineFormatLimit                        BOOL !PROCEDURE(BYTE LineFormatLimit),VIRTUAL                      !Use by SetLine SetLineFormatLimit assign the number of lineFormat if 3 the range limit is between 1 and 3, this will ensure the number of Line format used, it is setup in the Init() method and reassign in the SetLine method
GetLineFormatLimit                        BOOL !PROCEDURE(),BYTE,VIRTUAL                                     !Get Line Format
SetLineFormat                             BOOL !PROCEDURE(BYTE LineFormat),VIRTUAL                           !Use by SetLine SetLineFormat formats the line of the record according to one of the three defines format,<br/> Format 1 = Line from Debug, <br/> Format 2 = LineNo and Line <br/> Format 3 = LineNo Time and Line
GetLineFormat                             BOOL !PROCEDURE(),BYTE,VIRTUAL                                     !Get Line Format
SetLineNo                                 BOOL !PROCEDURE(),VIRTUAL                                          !Set Line No it will increment LineNo + 1
GetLineNo                                 BOOL !PROCEDURE(),ULONG,VIRTUAL                                    !Get Line No
SetLine                                   BOOL !PROCEDURE(ASTRING Line),ASTRING,VIRTUAL                       !SetLine ,<br/> Format 1 = Line from Debug, <br/> Format 2 = LineNo and Line <br/> Format 3 = LineNo Time and Line
AddLine                                   BOOL !PROCEDURE(ASTRING Line),VIRTUAL                               !Add line to the log file
Destruct                                  BOOL !PROCEDURE                                                    !End the jcDebug scope instance
Kill                                      BOOL !PROCEDURE () ,VIRTUAL                                        !Removing the Class scope instance from memory
                                        END
_jcLogShowVariables_
