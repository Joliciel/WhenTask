!ABCIncludeFile(Joliciel)
	INCLUDE('jcClassProjectOptions.inc'),ONCE
!
! Joliciel 2012
OMIT('_EndOfInclude_',_jcDebug_)
_jcDebug_ EQUATE(1)
  
  INCLUDE('ABUTIL.INC'),ONCE
  INCLUDE('jcBase.inc'),ONCE
  INCLUDE('jcStack.inc'),ONCE  
  INCLUDE('jcDebug.equ'),ONCE
  INCLUDE('jcDebugShow.equ'),ONCE
  INCLUDE('jcDebugShow.inc'),ONCE
  INCLUDE('jcDebugWhenTask.equ'),ONCE
  INCLUDE('jcLog.inc'),ONCE
  INCLUDE('UltimateDebug.inc'),ONCE
  !INCLUDE('jcDebugPrivate.inc'),ONCE
 ! INCLUDE('jcField.inc'),ONCE
 ! INCLUDE('cwsynchm.inc'),ONCE      
 ! INCLUDE('cwsynchc.inc'),ONCE


!The Debug Class works in conjonction with DebugView we have a set of  method that will manipulate and

jcDebugManager      CLASS(jcBase),TYPE,Module('jcDebug.Clw'),LINK('jcDebug.Clw',_JCLinkMode_),DLL(_JCDllMode_)!,THREAD
!Class References
INIManager            &INIClass                   !Reference to the INIClass
UD                    &UltimateDebug              !Reference to the UltimateDebug
Log                   &jcLogManager               !Reference to the jcLogManager this object is 
QD                    &QBase                      !Debug Queue Base holds all instances of DebugShow and their status.
QDR                   &QBase                      !Debug Queue Base holds all instances of DebugShowValue current value.
LogIsReferenced       BOOL,PROTECTED              !IF Log is Referencing jcLogManager locally to the jcDebugManager class then LogIsReferenced property is set to true
Stack                 &jcStackManager             !Use the stack class for the Margin
!Debug                  &jcDebugManagerPrivate      !Debugging the current Class
!Debug                  &jcDebugManager
! Properties
F                     &jcFieldManager
Stacking              GROUP
StackCounter            LONG
Thread                  LONG
OverrideSpaceMargin     SHORT
NumberSpaceMargin       SHORT
IndentSpaceMargin       SHORT
Header                  ASTRING
Comment                 ASTRING
Description             ASTRING
ApplicationName         ASTRING
ProgramName             ASTRING
ProcedureName           ASTRING
ClassName               ASTRING
MethodName              ASTRING
RoutineSection          ASTRING
CodeSection             ASTRING
EmbedSection            ASTRING
EXECUTESection          ASTRING
BEGINSection            ASTRING
CASESection             ASTRING
OFSection               ASTRING
LoopSection             ASTRING
IFSection               ASTRING
IFOnTrueSection         ASTRING
IFOnFalseSection        ASTRING
SISection               ASTRING
SIOnTrueSection         ASTRING
SIOnFalseSection        ASTRING
DocName                 ASTRING
DocumentationName       ASTRING
HelpName                ASTRING
HelperName              ASTRING
NoteName                ASTRING
ShowWhat                ASTRING
ShowWhom                ASTRING
ErreurName              ASTRING
AssertName              ASTRING
WarningName             ASTRING
NotifyName              ASTRING
NotificationName        ASTRING
CurrentShow             ASTRING
Mum                     BYTE
AreaCondition           BOOL                   !If the Area has started and is hidden then the following areas are hidden until the Area has reached the End. If the Area has started and is shown then the following areas are shown unless has hide, until the Area has reached the End. It is a recursive condition
sDebug                  &jcDebugManager
                      END
Thread                LONG                     ! Thread property
DM                    SHORT(2)                 ! DM represent Default Margin default to 2
DefaultMargin         SHORT(2)                 ! Same as a above longuer version for a better clarity when reading the code.
DebugState            BOOL,PRIVATE        		 ! Turning ON or OFF the DebugClass instances
RespectingAreaShow    BOOL,PRIVATE             ! IF the state of RespectingAreaShow is true then PrepareShow will respect the current MAIN AreaShow.<br/>If CurrentShow area is under a hidden show even if the CurrentShow Area wants to be shown then the CurrentShow is hidden.
DoDebugPrefix         BOOL,PRIVATE              
DebugPrefix           CSTRING(5),PRIVATE          
LocalDebugState       BOOL,PRIVATE             ! Turning ON or OFF the local debug of jcDebug 
Position              STRING(700),PRIVATE    	 ! Position of the record within the file
Pointer               LONG,Private     		     ! Pointer position of the record within the file
SaveStatus            BYTE,Private     		     ! SaveStatus is On or Off (do we save and restore the record?)l
Line                  ASTRING,PRIVATE          ! To format the line to display, it holds the line format
ShowWhat              ASTRING,PRIVATE          ! ShowWhat is saving the current what section show for later use with the End() method
ShowWhom              ASTRING,PRIVATE          ! ShowWhom is saving the current whom section show for later use with the End() method
ShowQueue             BOOL,PRIVATE             ! use by ShowDebugQueue ShowQueue is TRUE or False if set ShowQ parameter may be omitted
ShowDebugQueueLine    ASTRING,PRIVATE          ! use by ShowDebugQueue to format the delimeter line to of ShowDebugQueue
SeeVariablesRepetitionLength  SHORT,PRIVATE      ! use by to set the length of the repeated character to create the line of SeeVariables
ShowDebugQueueRepetitionLength    SHORT,PRIVATE    ! use by to set the length of the repeated character to create the line of ShowDebugQueue
OverrideSpaceMargin   SHORT,PRIVATE            ! Set the override space margin
NumberSpaceMargin     SHORT,PRIVATE            ! Set the number of space margin
IndentSpaceMargin     SHORT,PRIVATE            ! Set the indent space margin. 
RepetitionLength      SHORT,PRIVATE            ! Set the Repetition length used to format character repetition (ex. line delimeter)
NoteName              ASTRING,PRIVATE          ! Set a Note
DocName               ASTRING,PRIVATE          ! Set a Doc Name
DocumentationName     ASTRING,PRIVATE          ! Set a Documentation Name
HelpName              ASTRING,PRIVATE          ! Set a Help Name
HelperName            ASTRING,PRIVATE          ! Set a Helper Name
ErreurName            ASTRING,PRIVATE          ! Set an Error Name
AssertName            ASTRING,PRIVATE          ! Set an Assert Name 
WarningName           ASTRING,PRIVATE          ! Set an Warning Name 
NotifyName            ASTRING,PRIVATE          ! Set an Notify Name 
NotificationName      ASTRING,PRIVATE          ! Set an Notification Name 
Header                ASTRING,PRIVATE          ! Set the Header
Comment               ASTRING,PRIVATE          ! Set the comment
Description           ASTRING,PRIVATE          ! Set the description
AreaCondition         BOOL                     !If the Area has started and is hidden then the following areas are hidden until the Area has reached the End. If the Area has started and is shown then the following areas are shown unless has hide, until the Area has reached the End. It is a recursive condition
CurrentShow           ASTRING                  ! Hold the current area to show
SelectiveShow         BOOL                     ! Set a Selective show on or off
SelectShow            ASTRING                  ! Set a Selective show on an Output to screen session
ShowingCurrentMethodValue BOOL,PRIVATE          ! Trigger TRUE or FALSE on show the current value of a variable this add the ClassName behind
ShowingValue          BOOL                     ! Trigger TRUE or FALSE on show the current value of a variable 
ShowValueToQDR        BOOL,PRIVATE             ! ShowValueToQDBR if set to TRUE then the current method ShowValue will add its value to the QDR queue
ShowingSpaceMargin    BOOL,PRIVATE             ! When Debug mode triger the property to TRUE or FALSE when TRUE DebugView is showing the SpaceMargin
Showed                BOOL,PRIVATE             ! Showed property accept TRUE or FALSE value meaning Show is the currentShow. The Margin will stay at the same position
justStarted           BOOL,PRIVATE             ! It is true when the section show just begins with the START() code instruction
justEnded             BOOL,PRIVATE             ! It is true when the section show just begins with the END() code instruction
CurrentAreaType       ASTRING,PRIVATE          ! the Current Area Type holds the kind of section show we are on it will be used to check if it is ACTIVE or INACTIVE
! Methods
!Begin and terminate the class instance
Construct             PROCEDURE                                                    !Begins the jcDebug scope instance
Destruct              PROCEDURE                                                    !End the jcDebug scope instance
SetFetch              PROCEDURE(*INIClass pINIMgr,ASTRING pINISection,ASTRING pINIVariableName,ASTRING pINIValue),BOOL,PROC ! SetFetch() will read and update the DebugShow INI file
Updating              PROCEDURE(*INIClass pINIMgr,ASTRING pINISection,ASTRING pINIVariableName,ASTRING pINIValue) ! Updating() will update the DebugShow INI file
CreateDebugManager    PROCEDURE(jcDebugManager Debug)                              !Create a new instance of the jcDebugManager class
PrepareClassName      PROCEDURE(*jcDebugManager BaseClassName,<ASTRING DeclaredClassName>)  !PrepareClassName set the current jcDebugManager ClassName.<br/> The condition, if the base ClassName is set then the jcDebugManager ClassName is set to the base ClassName <br/> otherwise <br/>  if the jcDebugManager ClassName is not set then use the declared ClassName.<br/> For Exemple if the declared ClassName is jcLogManager then the jcDebugManager ClassName is 'jcLogManager'
PrepareClassName      PROCEDURE(<ASTRING ClassName>)                               !PrepareClassName set the current jcDebugManager ClassName.
Init                  PROCEDURE(<jcLogManager Log>) , VIRTUAL                      !Initialized the jcDebug scope instances presently DebugState is set to true.<br/> The optional jcLogManager class parameter may be passed, if not passed then omitted the local version is referenced.
Kill                  PROCEDURE () ,VIRTUAL                                        !Removing the Class scope instance from memory
!Properties setup and access
SetjustStarted        PROCEDURE(BOOL justStarted),PRIVATE                          !Set the private justStarted property
GetjustStarted        PROCEDURE(),BOOL,PRIVATE                                     !Get the private justStarted property
SetjustEnded          PROCEDURE(BOOL justEnded),PRIVATE                            !Set the private justEnded property
GetjustEnded          PROCEDURE(),BOOL,PRIVATE                                     !Get the private justEnded property
SetCurrentAreaType    PROCEDURE(ASTRING CurrentAreaType),PRIVATE                      !Set the private CurrentAreaType property
GetCurrentAreaType    PROCEDURE(),ASTRING,PRIVATE                                     !Get the private CurrentAreaType property
!Settings
Assign                PROCEDURE (STRING Value,*? Fld) ,VIRTUAL                     !Assign is anotherway of assigning a value to a field Fld=Value
CheckSpaceMargin      PROCEDURE (*SHORT NumberSpaceMargin,<SHORT SpaceMargin>) ,VIRTUAL !Check if SetNumberSpaceMargin is set otherwise if the Parameter SpaceMargin of a procedure is set
GetDebugState         PROCEDURE (),BOOL ,VIRTUAL                                   !Get the Debug State set by SetDebugState, RETURN SELF.DebugState
GetRepetitionLength   PROCEDURE (),SHORT,VIRTUAL                                   !Get the number of repetition of a character 
GetShowDebugQueueLine PROCEDURE () ,ASTRING, VIRTUAL                               !Get the line delimeter of ShowDebugQueue
SetLine               PROCEDURE (<ASTRING LineCharacter>,<USHORT Repition>),VIRTUAL  !Format with a specify character the repetion length of the line to set
GetLine               PROCEDURE (<ASTRING LineCharacter>,<USHORT Repition>),ASTRING, VIRTUAL      !Get the formatted line
ShowLine              PROCEDURE(<ASTRING LineCharacter>,<USHORT Repetition>,<BYTE Type>), VIRTUAL !Show a line Type = 1 is See() is called and Type = 2 is Show() is called, Default to Type 1
GetShowDebugQueueRepetitionLength PROCEDURE (),USHORT, VIRTUAL                       !Get the length of the line delimeter of ShowDebugQueue
GetSeeVariablesRepetitionLength   PROCEDURE (),USHORT, VIRTUAL                       !Get the length of the line delimeter of SeeVariables
SetRepetitionLength   PROCEDURE(<SHORT Repetition>), VIRTUAL                        !Set the repetition length of a character
SetShowDebugQueueRepetitionLength PROCEDURE (<USHORT LineLenght>), VIRTUAL           !Set the length of the line delimeter of ShowDebugQueue
SetSeeVariablesRepetitionLength   PROCEDURE (<USHORT LineLength>), VIRTUAL           !Set the length of the line delimeter of SeeVariables 
SetRepeatCharacterInVariable  PROCEDURE(USHORT Repetition,STRING Character,*ASTRING Variables), VIRTUAL !Set a repeat character string to a string variable passed by address. 
SetRestoreDebugState  PROCEDURE (*BOOL DebugState)                                  !Set Restore DebugState
CheckRestoreDebugState    PROCEDURE (*BOOL DebugState)                                  !Check the currrent DebugState
SetMargin             PROCEDURE(*SHORT NumberSpaceMargin,*SHORT SpaceMargin)        !Set the Margin
!Setup of sections 
SetDebugState         PROCEDURE (<BOOL DebugState>) ,VIRTUAL                        !Set the DebugState, is active if its TRUE and inactive if its FALSE
SetOverrideSpaceMargin  PROCEDURE (SHORT SpaceMargin) ,VIRTUAL                      !Set Override of Space Margin scope    
GetOverrideSpaceMargin  PROCEDURE (),SHORT ,VIRTUAL                                 !Get the Override of Space Margin that was set by SetOverrideSpaceMargin, RETURN SELF.NumberSpaceMargin
SetNumberSpaceMargin  PROCEDURE (<SHORT SpaceMargin>),VIRTUAL                       !Set Number of Space Margin scope    
GetNumberSpaceMargin  PROCEDURE (),SHORT ,VIRTUAL                                   !Get the Number of Space Margin that was set by SetNumberSpaceMargin, RETURN SELF.NumberSpaceMargin
SetIndentSpaceMargin  PROCEDURE (<SHORT LengthIndentSpaceMargin>) ,VIRTUAL          !Set Indent Space Margin scope
GetIndentSpaceMargin  PROCEDURE (),SHORT ,VIRTUAL                                   !Get the Number of Indent Space Margin that was set by SetIndentSpaceMargin, RETURN SELF.IndentSpaceMargin
SetNote               PROCEDURE (ASTRING Note) ,VIRTUAL                             !Set a Note 
GetNote               PROCEDURE (),ASTRING ,VIRTUAL                                 !Get a Note 
SetHeader             PROCEDURE (ASTRING Header) ,VIRTUAL                           !Set a Header 
GetHeader             PROCEDURE (),ASTRING ,VIRTUAL                                 !Get a Header 
SetComment            PROCEDURE (ASTRING Comment) ,VIRTUAL                          !Set a Comment 
GetComment            PROCEDURE (),ASTRING ,VIRTUAL                                 !Get a Comment 
SetDescription        PROCEDURE (ASTRING Description) ,VIRTUAL                      !Set a Description 
GetDescription        PROCEDURE (),ASTRING ,VIRTUAL                                 !Get a Description 
SetDoc                PROCEDURE (ASTRING DocName) ,VIRTUAL                          !Set a Doc 
GetDoc                PROCEDURE (),ASTRING ,VIRTUAL                                 !Get a Doc 
SetDocumentation      PROCEDURE (ASTRING DocumentationName) ,VIRTUAL                !Set a Documentation 
GetDocumentation      PROCEDURE (),ASTRING ,VIRTUAL                                 !Get a Documentation 
SetHelp               PROCEDURE (ASTRING HelpName) ,VIRTUAL                         !Set a Help 
GetHelp               PROCEDURE (),ASTRING ,VIRTUAL                                 !Get a Help 
SetHelper             PROCEDURE (ASTRING HelperName) ,VIRTUAL                       !Set a Helper 
GetHelper             PROCEDURE (),ASTRING ,VIRTUAL                                 !Get a Helper 
SetErreur             PROCEDURE (ASTRING ErreurName) ,VIRTUAL                       !Set an Erreur
GetErreur             PROCEDURE (),ASTRING ,VIRTUAL                                 !Get an Erreur
SetAssert             PROCEDURE (ASTRING AssertName) ,VIRTUAL                       !Set an Assert
GetAssert             PROCEDURE (),ASTRING ,VIRTUAL                                 !Get an Assert
SetWarning            PROCEDURE (ASTRING WarningName) ,VIRTUAL                      !Set an Warning
GetWarning            PROCEDURE (),ASTRING ,VIRTUAL                                 !Get an Warning
SetNotify             PROCEDURE (ASTRING NotifyName) ,VIRTUAL                       !Set an Notify
GetNotify             PROCEDURE (),ASTRING ,VIRTUAL                                 !Get an Notify
SetNotification       PROCEDURE (ASTRING NotificationName) ,VIRTUAL                 !Set an Notification
GetNotification       PROCEDURE (),ASTRING ,VIRTUAL                                 !Get an Notification
!Thread
SetThread             PROCEDURE(LONG pThread),VIRTUAL                               !Set the current thread
GetThread             PROCEDURE(),LONG,VIRTUAL                                      !Get the current thread
!Stacking recursively
Save                  PROCEDURE()                                                   !Stack the current values 
Restore               PROCEDURE()
!Sections shows
Headers               PROCEDURE (ASTRING Header,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Show to Debug View the beginning of the Header. if used as a function then if the status the HeaderSection is _Show = 1 then HeaderStart() is shown and return TRUE otherwise is not shown and return FALSE
Comments              PROCEDURE (ASTRING Comment,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Show to Debug View the beginning of the Comment. if used as a function then if the status the CommentSection is _Show = 1 then CommentStart() is shown and return TRUE otherwise is not shown and return FALSE
Descriptions          PROCEDURE (ASTRING Description,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Show to Debug View the beginning of the Description. if used as a function then if the status the DescriptionSection is _Show = 1 then DescriptionStart() is shown and return TRUE otherwise is not shown and return FALSE
Application           PROCEDURE (ASTRING ApplicationName,<ASTRING Parameter>,<BYTE Show>,<SHORT SpaceMargin>)   !Set Appliction it check for margin Set the ProgramName and ApplicationStart
Programme             PROCEDURE (ASTRING ProgramName,<ASTRING Parameter>,<BYTE Show>,<SHORT SpaceMargin>)   !Set Program it check for margin Set the ProgramName and ProgramStart
Classe                PROCEDURE(ASTRING ClassName,<BYTE Show>,<SHORT SpaceMargin>), VIRTUAL    !Start the class instance
MethodShow            PROCEDURE(ASTRING MethodNamePar,<ASTRING PrototypePar>,BYTE ShowPar,ASTRING PromptPar,ASTRING ValuePar), VIRTUAL !Method Show display a short description of a single property
Method                PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BYTE Show>,<SHORT SpaceMargin>),VIRTUAL   !Set Method it check for margin Set the MethodName and MethodStart
Proc                  PROCEDURE (ASTRING ProcedureName,<ASTRING Prototype>,<BYTE Show>,<SHORT SpaceMargin>),VIRTUAL !Show to Debug View the beginning of the Procedure
Note                  PROCEDURE (ASTRING NoteName,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Show to Debug View the beginning of the Note. if used as a function then if the status the NoteSection is _Show = 1 then NoteStart() is shown and return TRUE otherwise is not shown and return FALSE.<br/> the NoteStart() method may also be used as a regular statement.
Doc                   PROCEDURE (ASTRING DocName,<BYTE Show>,<SHORT SpaceMargin>),VIRTUAL  !Start doc section show
Documentation         PROCEDURE (ASTRING DocumentationName,<BYTE Show>,<SHORT SpaceMargin>),VIRTUAL  !Start Documentation section show
Help                  PROCEDURE (ASTRING HelpName,<BYTE Show>,<SHORT SpaceMargin>),VIRTUAL  !Start Help section show
Helper                PROCEDURE (ASTRING HelperName,<BYTE Show>,<SHORT SpaceMargin>),VIRTUAL  !Start Helper section show
Routines              PROCEDURE (ASTRING RoutineSection,<BYTE Show>,<SHORT SpaceMargin>),VIRTUAL  !Start routine 
Codes                 PROCEDURE (ASTRING CodeSection,<BYTE Show>,<SHORT SpaceMargin>), VIRTUAL  !Start Code section show
Embed                 PROCEDURE (ASTRING EmbedSection,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start Embed section show if used as a function then if the status the EmbedSection is _Show = 1 then EmbedStart() is shown and return TRUE otherwise EmbedSection is _Hide = 0 is not shown  and return FALSE.<br/> the EmbedStart() method may also be used as a regular statement.
EXECUTEs              PROCEDURE (ASTRING EXECUTESection,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start EXECUTE section show if used as a function then if the status the EXECUTESection is _Show = 1 then EXECUTEStart() is shown and return TRUE otherwise EXECUTESection is _Hide = 0 is not shown  and return FALSE.<br/> the EXECUTEStart() method may also be used as a regular statement.
BEGINs                PROCEDURE (ASTRING BEGINSection,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start BEGIN section show if used as a function then if the status the BEGINSection is _Show = 1 then BEGINStart() is shown and return TRUE otherwise BEGINSection is _Hide = 0 is not shown  and return FALSE.<br/> the BEGINStart() method may also be used as a regular statement.
CASEs                 PROCEDURE (ASTRING CASESection,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start CASE section show if used as a function then if the status the CASESection is _Show = 1 then CASEStart() is shown and return TRUE otherwise CASESection is _Hide = 0 is not shown  and return FALSE.<br/> the CASEStart() method may also be used as a regular statement.
OFs                   PROCEDURE (ASTRING OFSection,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start OF section show if used as a function then if the status the OFSection is _Show = 1 then OFStart() is shown and return TRUE otherwise OFSection is _Hide = 0 is not shown  and return FALSE.<br/> the OFStart() method may also be used as a regular statement.
Loops                 PROCEDURE (ASTRING LoopSection,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start Loop section show if used as a function then if the status the LoopSection is _Show = 1 then LoopStart() is shown and return TRUE otherwise LoopSection is _Hide = 0 is not shown  and return FALSE.<br/> the LoopStart() method may also be used as a regular statement.<br/> Note when use as a function if the LoopSection is set to _Hide then the code within the condition will not execute.
IFs                   PROCEDURE (ASTRING IFSection,<BYTE Show>,<SHORT SpaceMargin>,<BOOL IFsState>),BOOL,PROC,VIRTUAL  !Start IF section show if used as a function then if the status the IFSection is _Show = 1 then IFStart() is shown and return TRUE otherwise IFSection is _Hide = 0 is not shown  and return FALSE.<br/> the IFStart() method may also be used as a regular statement.<br/> Note when use as a function if the IFSection is set to _Hide then the code within the condition will not execute.<br/> the fourth parameter accept a BOOL value or function returning a BOOL value giving the state of IFs method.
IFOnTrue              PROCEDURE (<BYTE Show>,<SHORT SpaceMargin>), VIRTUAL          !Start IFOnTrue section show dependant on IFs method meaning the text shown within the IFs method is automatically shown when IfOnTrue is called
IFOnFalse             PROCEDURE (<BYTE Show>,<SHORT SpaceMargin>), VIRTUAL          !Start IFOnFalse section show dependant on IFs method meaning the text shown within the IFs method is automatically shown when IfOnFalse is called
SI                    PROCEDURE (ASTRING IFSection,<BYTE Show>,<SHORT SpaceMargin>,<BOOL IFsState>),BOOL,PROC,VIRTUAL  !Start IF section show if used as a function then if the status the IFSection is _Show = 1 then IFStart() is shown and return TRUE otherwise IFSection is _Hide = 0 is not shown  and return FALSE.<br/> the IFStart() method may also be used as a regular statement.<br/> Note when use as a function if the IFSection is set to _Hide then the code within the condition will not execute.<br/> the fourth parameter accept a BOOL value or function returning a BOOL value giving the state of IFs method.
SIOnTrue              PROCEDURE (<ASTRING EmbedSection>,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start SiOnTrue section show, this method do not have dependancy methods like IFs where text is shown automatically in their respected condition<br/>if used as a function then if the status the IFSection is _Show = 1 then EmbedStart() is shown and return TRUE otherwise EmbedSection is _Hide = 0 is not shown  and return FALSE.<br/> the EmbedStart() method may also be used as a regular statement.
SIOnFalse             PROCEDURE (<ASTRING EmbedSection>,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start SiOnFalse section show, this method do not have dependancy methods like IFs where text is shown automatically in their respected condition<br/>if used as a function then if the status the IFSection is _Show = 1 then EmbedStart() is shown and return TRUE otherwise EmbedSection is _Hide = 0 is not shown  and return FALSE.<br/> the EmbedStart() method may also be used as a regular statement.
Erreur                PROCEDURE (ASTRING ErreurName,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start Loop section show if used as a function then if the status the ErreurSection is _Show = 1 then ErreurStart() is shown and return TRUE otherwise ErreurSection is _Hide = 0 is not shown  and return FALSE.<br/> the ErreurStart() method may also be used as a regular statement.<br/> Note when use as a function if the ErreurSection is set to _Hide then the code within the condition will not execute.
Asserts               PROCEDURE (ASTRING AssertName,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start Assert section show if used as a function then if the status the AssertName is _Show = 1 then AssertStart() is shown and return TRUE otherwise AssertName is _Hide = 0 is not shown  and return FALSE.<br/> the AssertStart() method may also be used as a regular statement.
Warning               PROCEDURE (ASTRING WarningName,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start Warning section show if used as a function then if the status the WarningName is _Show = 1 then Warningtart() is shown and return TRUE otherwise WarningName is _Hide = 0 is not shown  and return FALSE.<br/> the Warningtart() method may also be used as a regular statement.
Notify                PROCEDURE (ASTRING NotifyName,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start Notify section show if used as a function then if the status the NotifyName is _Show = 1 then Notifytart() is shown and return TRUE otherwise NotifyName is _Hide = 0 is not shown  and return FALSE.<br/> the Notifytart() method may also be used as a regular statement.
Notification          PROCEDURE (ASTRING NotificationName,<BYTE Show>,<SHORT SpaceMargin>),VIRTUAL  !Start Notification section show
!Prepare the show
ShowStart             PROCEDURE (ASTRING ShowWhat,ASTRING ShowWhom,SHORT SpaceMargin)  !ShowStart of whom, usually ShowWhat is the Area type representation <br/> if Method Show then START METHOD, <br/> about the ShowWhom is the Area representation with its definition. <br/> ex. <br/> jcField.CheckGroup() <br/> All together it shows <br/> [ START METHOD: jcField.CheckGroup() ] <br/> if the SpaceMargin is passed then The START METHOD will show at the specified indent margin otherwise it uses the current calculated SpaceMargin
ShowEnd               PROCEDURE (ASTRING ShowWhat,ASTRING ShowWhom) 	                !ShowStart of whom, usually ShowWhat is the Area type representation <br/> if Method Show then END   METHOD, <br/> about the ShowWhom is the Area representation with its definition. <br/> ex. <br/> jcField.CheckGroup() <br/> All together it shows <br/> [ END   METHOD: jcField.CheckGroup() ] <br/> the space margin is always the one used by ShowStart() method of the current Show
SeeStart              PROCEDURE (ASTRING SeeWhat,ASTRING SeeWhom)                  !Show the start of whom
SeeEnd                PROCEDURE (ASTRING SeeWhat,ASTRING SeeWhom)                  !Show the end of whom
See                   PROCEDURE (<STRING Info>,<SHORT SpaceMargin>) ,VIRTUAL       !Show to Debug View window the string if DebugState must be set to TRUE otherwise nothing is shown
ShowLocalDebug        PROCEDURE (<BOOL ShowQ>,<SHORT SpaceMargin>),VIRTUAL         !Show Local jcDebugManager Debug it will use the ShowDebugQueue on the local Debug inheritance class within jcDebugManager
Show                  PROCEDURE (STRING Info,<SHORT SpaceMargin>) ,VIRTUAL         !Show to Debug View window the string if DebugState must be set to TRUE otherwise nothing is shown
ShowHeader            PROCEDURE (ASTRING HeaderString,<USHORT Type>,<BYTE Show>),VIRTUAL       !Show an header string according to a type format.
SetShowingCurrentMethodValue  PROCEDURE(BOOL Show),VIRTUAL                           !Set ShowingCurrentMethodValue to Show or Hide, the method accepts only a TRUE or FALSE parameter, it will Trigger TRUE or FALSE on show the current value of a variable this add the ClassName behind
GetShowingCurrentMethodValue  PROCEDURE(),BOOL,VIRTUAL                               !Get ShowingCurrentMethodValue to Show or Hide, the method returns only a TRUE or FALSE value.
ShowCurrentMethodValue    PROCEDURE (ASTRING MethodString,<ANY Value>,<SHORT SpaceMargin>), VIRTUAL    !Show current method value parameter
SetRespectingAreaShow PROCEDURE(BOOL RespectAreaShow),VIRTUAL                        !Set RespectingAreaShow to a value of TRUE will respect the CurrentShow in PrepareShow procedure<br/>otherwise if a Show parameter is assigned FALSE will not respect the currentShow.
GetRespectingAreaShow PROCEDURE(),BOOL,VIRTUAL                                       !Get RespectingAreaShow to a value of TRUE will respect the CurrentShow in PrepareShow procedure<br/>otherwise if a Show parameter is assigned FALSE will not respect the currentShow.
ShowValue             PROCEDURE (ASTRING Value,<ANY pData>,<BOOL Show>,<SHORT SpaceMargin>,<ASTRING Symbol>), VIRTUAL            !The symbol separator between the prompt and the passed data<br/>jcDebug::OpenBracket        EQUATE('[ ')<br/>jcDebug::CloseBracket       EQUATE(' ]')<br/>jcDebug::Space              EQUATE(' ')<br/>jcDebug::Dot			          EQUATE('.')<br/>jcDebug::Equal              EQUATE('=')<br/>jcDebug::Hyphen             EQUATE('-')<br/>jcDebug::LessThan<br/>jcDebug::GreaterThan<br/>jcDebug::LessThanEqualTo<br/>jcDebug::GreaterThanEqualTo EQUATE('>=')<br/>jcDebug::Colon<br/>jcDebug::NotEqualTo<br/>jcDebug::OpenCloseBracket
ShowValueDetail       PROCEDURE (ASTRING Value,<ANY pData>,<ASTRING pDescription>,<BYTE Show>,<SHORT SpaceMargin>), VIRTUAL  !Show the data of the value parameter with an optional Description
SeeVariables          PROCEDURE (<STRING Info>,<SHORT SpaceMargin>,<BYTE Show>) ,VIRTUAL   !Show the current state of Q (jcDebugQueue) to Debug View window after it FREEs from memory the Q instance. The third parameter accept a value of TRUE or FALSE, if FALSE SeeVariables() is not executed.
ShowDebugQueue        PROCEDURE (<BOOL ShowQ>,<SHORT SpaceMargin>) ,VIRTUAL            !Show to Debug View the status of the Q (jcDebugQueue) within the procedure
ShowClassQueue        PROCEDURE(jcBase BaseClass,<BOOL ShowQ>,<SHORT SpaceMargin>)     !Show to Class View the status of the Q (jcBaseQueue) within the procedure 
PrepareShow           PROCEDURE (ASTRING AreaType,ASTRING Area,<BYTE Show>) ,VIRTUAL   ! The AreaType = Application Show, Program Show, Procedure Show, Class Show, Method Show, Routine Show, Code Show, Embed Show and Note Show.<br/> These AreaTypes they all have an EQUATE representation.<br/>You will find them in the jcDebug.equ source file, "Application Show" = jcDebug::ApplicationShow,<br/>"Note Show" = jcDebug::NoteShow etc...,<br/>Area = Name of the area we are on,<br/>Show = Accept a value of 1, 0, TRUE or FALSE, _Show or _Hide. Note _Show = TRUE and _Hide = FALSE.<br/>Prepare the current area for a show if the show does not exist it is created and set to true,<br/>the optional Show overwrites the first parameter with a true or false value
SetShow               PROCEDURE (ASTRING Area,BOOL Value) ,VIRTUAL                     !Set show will display certain area or not, by default in Init() it is set to TRUE for ACTIVE or SHOWING,<br/>if desire it may be set to FALSE for INACTIVE or HIDING, an Area Type like ApplicationShow is ACTIVE/INACTIVE<br/>and a particular Area like "Procedure Show.NameOfAProcedure" is SHOWING/HIDING.<br/>The differences the first one AreaType is set globally the second one the Area is set locally.<br/>There is a distinction to make between Active Area which is the AreaType and<br/>the Showing Area which the Actual Area we are on, consider to be local.
GetShow               PROCEDURE (ASTRING Area),BOOL, VIRTUAL                           !Get the Area value including AreaType, GetShow() return TRUE or FALSE
SetShowWhat           PROCEDURE(ASTRING What),PROTECTED                                !SetShowWhat save the current ShowWhat parameter of ShowStart, it will be later used by ShowEnd method this way we can use only and End method for all the section show.
GetShowWhat           PROCEDURE(),ASTRING,PROTECTED                                    !GetShowWhat return the current ShowWhat
SetShowWhom           PROCEDURE(ASTRING Whom),PROTECTED                                !SetShowWhat save the current ShowWhat parameter of ShowStart, it will be later used by ShowEnd method this way we can use only and End method for all the section show.
GetShowWhom           PROCEDURE(),ASTRING,PROTECTED                                    !GetShowWhat return the current ShowWhat
Halt                  PROCEDURE(),VIRTUAL                                              !Ending the current section show same as Fin
Fin                   PROCEDURE(),VIRTUAL                                              !Ending the current section show same as Halt
Fin                   PROCEDURE(*BYTE ConditionalEnd),VIRTUAL                           !Ending the current section show same as Halt,<br/>The ConditionalEnd it will check if the variable is true or false<br/> if it is true then the statement to Fin is executed<br/>otherwise not
SetCurrentShow        PROCEDURE (ASTRING AreaType,<ASTRING Area>) ,VIRTUAL             !Set Current Show AreaType = All Area of the same type; Area = Some Area of the same type.<br/><br/>The list of AreaType are<br/>  Application Show, Program Show, Procedure Show, Class Show, Method Show,<br/>  Routine Show, Code Show, Embed Show and Note Show.<br/><br/>ex. The AreaType is All "Method Show" is ACTIVE or INACTIVE and The Area is Some "Method Show.MethodName(Prototype)" is "SHOWING" or "HIDING".<br/> The format statement of SetCurrentShow is<br/>  SELF.SetCurrentShow('Procedure Show','ProcedureName full string') is the same as <br/>  SELF.SetProcedureName('ProcedureName,'Protype')<br/>  SELF.SetCurrentShow(jcDebug::ProcShow,GetProcedurName())<br/>  The List of the equates to represent each AreaType show are found in jcDebug.equ source file.<br/>  jcDebug::ProcShow EQUATES('Procedure Show')
GetCurrentShow        PROCEDURE (),BOOL, VIRTUAL                                       !Get the current Area value. It may be 1 or 0. For AreaType is ACTIVE or INACTIVE for Area is SHOW or HIDE 
SetSelectiveShow      PROCEDURE (<ASTRING AreaType>,<ASTRING Area>,<BYTE Type>) ,VIRTUAL  !Set Current Show AreaType = All Area of the same type; Area = Some Area of the same type.<br/><br/>The list of AreaType are<br/>  Application Show, Program Show, Procedure Show, Class Show, Method Show,<br/>  Routine Show, Code Show, Embed Show, Note Show, Header Show, Description Show and Comment Show.<br/>  their equates representation are : <br/> jcDebug::ApplicationShow, jcDebug::ProgramShow, jcDebug::ClassShow, jcDebug::MethodShow, jcDebug::ProcShow,  jcDebug::CodeShow, jcDebug::EmbedShow, <br/> jcDebug::NoteShow, jcDebug::HeaderShow,  jcDebug::DescriptionShow and jcDebug::CommentShow<br/><br/>ex. The AreaType is All "Method Show" is ACTIVE or INACTIVE and The Area is Some "Method Show.MethodName(Prototype)" is "SHOWING" or "HIDING".<br/> The format statement of SetCurrentShow is<br/>  SELF.SetCurrentShow('Procedure Show','ProcedureName full string') is the same as <br/>  SELF.SetProcedureName('ProcedureName,'Protype')<br/>  SELF.SetCurrentShow(jcDebug::ProcShow,GetProcedurName())<br/>  The List of the equates to represent each AreaType show are found in jcDebug.equ source file.<br/>  jcDebug::ProcShow EQUATES('Procedure Show')
SetSelectiveShow      PROCEDURE (BOOL SelectiveShow),VIRTUAL                           !Set the Selective Show on or off a value of TRUE turn on the SelectiveShow otherwise a value of FALSE  turn off the selective Show
SetSelectShow         PROCEDURE (<ASTRING AreaType>,<ASTRING Area>) ,VIRTUAL           !Same as SetSelectiveShow() Set Current Show AreaType = All Area of the same type; Area = Some Area of the same type.<br/><br/>The list of AreaType are<br/>  Application Show, Program Show, Procedure Show, Class Show, Method Show,<br/>  Routine Show, Code Show, Embed Show and Note Show.<br/><br/>ex. The AreaType is All "Method Show" is ACTIVE or INACTIVE and The Area is Some "Method Show.MethodName(Prototype)" is "SHOWING" or "HIDING".<br/> The format statement of SetCurrentShow is<br/>  SELF.SetCurrentShow('Procedure Show','ProcedureName full string') is the same as <br/>  SELF.SetProcedureName('ProcedureName,'Protype')<br/>  SELF.SetCurrentShow(jcDebug::ProcShow,GetProcedurName())<br/>  The List of the equates to represent each AreaType show are found in jcDebug.equ source file.<br/>  jcDebug::ProcShow EQUATES('Procedure Show')
CheckSelectiveShow    PROCEDURE (ASTRING AreaType,ASTRING Area),BOOL,VIRTUAL           !Check the SelectiveShow and if the current AreaType and/or Area are part of the select show then return true
GetSelectiveShow      PROCEDURE (),BOOL, VIRTUAL                                       !Get the Selective Show if the SelectiveShow exist returns true. This is used in See() method to only show a Selective area when calling the DebugView we do not want to see anything else
GetValueRepresentation    PROCEDURE(ASTRING Object,ASTRING Detail),ASTRING             !If the Object is part of the internal list then GetValueRepresentation() returns the string according to the detail.<br/> Presently a search over the string "Show" is performed on AreaType and Area.<br/>The AreaType search for "Show" string and the Area search for "Show." with the dot character.<br/> The AreaType values are 1 for ACTIVE and 0 for INACTIVE and for Area 1 for SHOWING and 0 for HIDING.<br/>If the String "Show" is found then <br/> the returning string is 'ACTIVE' or 'INACTIVE'.<br/> If the Object conains "Show." with the dot then the returning string is "SHOWING" or "HIDING" string
Beeping               PROCEDURE(<ASTRING pMessage>, <UNSIGNED Sound>)                  ! Accept an optional Message as a first parameter <br/> and an optional Window sound it will show <br/> in DebugView where exactly the BEEP occurs a display line with the message <br/> BEEP statement with the optional message. <br/> <br/> BEEP:SystemDefault <br/> BEEP:SystemHand <br/> BEEP:SystemQuestion <br/> BEEP:SystemExclamation <br/> BEEP:SystemAsterisk <br/> <br/> Exemple: <br/> BEEP(,BEEP:SystemQuestion) <br/> BEEP('from xyz code section show',BEEP:SystemAsterisk)
  !Add                   PROCEDURE (ASTRING Object,ASTRING Detail),BYTE ,PROC, VIRTUAL    !Add the Object with its detail and optionally the Description of the object to the Queue <br/>DO NOT add if it exist
  !AddItem               PROCEDURE (*ASTRING Holder,ASTRING Item,ASTRING Object),PROC      !The private method Adding optimize two statements into one,<br/>the first statement field assignment and the second one Add to the jcBase Queue Object holder.<br/>It does NOT add if it exist
ShowQ                 PROCEDURE(*QUEUE Q)                                               !Show Q to DebugView with Column fields format
ShowQRecordRow        PROCEDURE(*QUEUE Q,*? RecordRow)                                  !Show Q to DebugView with record Row
ViewQ                 PROCEDURE(*QUEUE Q)                                               !View raw Q to Window
RetenirEndroit        PROCEDURE(<ASTRING pMessage>,<LONG pWantToBeep>),VIRTUAL          !RetenirEndroit Method will retain the location with a beep sound and Debug View Message where we need to note, with the following message <br/> Retenir l'endroit où nous devons changer le code
RetainLocation        PROCEDURE(<ASTRING pMessage>,<LONG pWantToBeep>),VIRTUAL          !RetainLocation Method will retain the location with a beep sound and Debug View Message where we need to note, with the following message <br/> Retain location where we need to change the code
SetShowValueToQDR     PROCEDURE (BOOL pValueToQDR),VIRTUAL                              !Set the ShowValueToQDR TRUE or FALSE value on TRUE the value send to ShowValue method will add the value to QDR queue otherwise NONE
GetShowValueToQDR     PROCEDURE (),BOOL, VIRTUAL                                        !Get the ShowValueToQDR it return the state of the ShowValueToQDR property
                    END


!   INCLUDE('jcDebugDebug.inc')

jcDebugManagerC     CLASS(jcDebugManager)
Dbg                   &jcDebugManagerC
                    END
jcDebugManagerQ     QUEUE
thread                LONG
jcDbgMng              &jcDebugManagerC
                    END                    

!_EndOfInclude_

