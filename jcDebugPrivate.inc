!ABCIncludeFile(Joliciel)
	INCLUDE('jcClassProjectOptions.inc'),ONCE
!
! Joliciel 2012
OMIT('_EndOfInclude_',_jcDebugPrivate_)
_jcDebugPrivate_ EQUATE(1)
  
       INCLUDE('jcBase.inc'),ONCE
       INCLUDE('jcStack.inc'),ONCE
       INCLUDE('jcDebug.equ'),ONCE

jcDebug::jcDebugManagerPrivate          EQUATE('jcDebugManagerPrivate')
       
                
!The Debug Class works in conjonction with DebugView we have a set of  method that will manipulate the diffent sections of a program


jcDebugManagerPrivate CLASS(jcBase),TYPE,Module('jcDebugPrivate.Clw'),LINK('jcDebugPrivate.Clw',_JCLinkMode_),DLL(_JCDllMode_)
! Properties
Stacking               GROUP
SpaceMargin              SHORT
ApplicationName          ASTRING
ProgramName              ASTRING
ProcedureName            ASTRING
ClassName                ASTRING
MethodName               ASTRING
RoutineSection           ASTRING
CodeSection              ASTRING
EmbedSection             ASTRING
Note                     ASTRING
CurrentShow              ASTRING
Mum                      BYTE
AreaCondition            BOOL                   !If the Area has started and is hiden then the following areas are hiden until the Area has reached the End. If the Area has started and is shown then the following areas are shown unless has hide, until the Area has reached the End. It is a recursive condition
                       END

DM                     SHORT(2)                 ! DM represent Default Margin default to 2
DefaultMargin          SHORT(2)                 ! Same as a above longuer version for a better clarity when reading the code.
DebugState             BOOL,Private    			! Turning ON or OFF the DebugClass instances
LocalDebugState        BOOL,PRIVATE             ! Turning ON or OFF the local debug of jcDebug 
Position               STRING(700),PRIVATE    	! Position of the record within the file
Pointer                LONG,Private     		! Pointer position of the record within the file
SaveStatus             BYTE,Private     		! SaveStatus is On or Off (do we save and restore the record?)l
Line                   ASTRING,PRIVATE          ! To format the line to display, it holds the line format
ShowQueue              BOOL,PRIVATE             ! use by ShowDebugQueue ShowQueue is TRUE or False if set ShowQ parameter may be omitted
ShowDebugQueueLine     ASTRING,PRIVATE          ! use by ShowDebugQueue to format the delimeter line to of ShowDebugQueue
SeeVariablesRepetitionLength SHORT,PRIVATE      ! use by to set the length of the repeated character to create the line of SeeVariables
ShowDebugQueueRepetitionLength SHORT,PRIVATE    ! use by to set the length of the repeated character to create the line of ShowDebugQueue
NumberSpaceMargin      SHORT,PRIVATE            ! Set the space margin
RepetitionLength       SHORT,PRIVATE            ! Set the Repetition length used to format character repetition (ex. line delimeter)
Note                   ASTRING,PRIVATE          ! Set a Note
Stack                  &jcStackManager          ! Use the stack class for the Margin
AreaCondition          BOOL                     !If the Area has started and is hiden then the following areas are hiden until the Area has reached the End. If the Area has started and is shown then the following areas are shown unless has hide, until the Area has reached the End. It is a recursive condition
CurrentShow            ASTRING                  ! Hold the current area to show
ShowingCurrentMethodValue BOOL                  ! Trigger TRUE or FALSE on show the current value of a variable
ShowingValue           BOOL                     ! Trigger TRUE or FALSE on show the current value of a variable 
ShowingSpaceMargin     BOOL,PRIVATE             ! When Debug mode triger the property to TRUE or FALSE when TRUE DebugView is showing the SpaceMargin
Showed                 BOOL,PRIVATE             ! Showed property accept TRUE or FALSE value meaning Show is the currentShow. The Margin will stay at the same position
! Methods
!Begin and terminate the class instance
Construct              PROCEDURE                                                    !Begins the jcDebug scope instance
Destruct               PROCEDURE                                                    !End the jcDebug scope instance
Init                   PROCEDURE , VIRTUAL                                          !Initialized the jcDebug scope instances presently DebugState is set to true
PrepareClassName       PROCEDURE(*jcDebugManagerPrivate BaseClassName,<ASTRING DeclaredClassName>)  !PrepareClassName set the current jcDebugManager ClassName.<br/> The condition, if the base ClassName is set then the jcDebugManager ClassName is set to the base ClassName <br/> otherwise <br/>  if the jcDebugManager ClassName is not set then use the declared ClassName.<br/> For Exemple if the declared ClassName is jcLogManager then the jcDebugManager ClassName is 'jcLogManager'
PrepareClassName       PROCEDURE(<ASTRING ClassName>)                               !PrepareClassName set the current jcDebugManager ClassName.
Kill                   PROCEDURE () ,VIRTUAL                                        !Removing the Class scope instance from memory
!Settings
Assign                 PROCEDURE (STRING Value,*? Fld) ,VIRTUAL                     !Assign is anotherway of assigning a value to a field Fld=Value
CheckSpaceMargin       PROCEDURE (*SHORT NumberSpaceMargin,<SHORT SpaceMargin>) ,VIRTUAL !Check if SetNumberSpaceMargin is set otherwise if the Parameter SpaceMargin of a procedure is set
GetDebugState          PROCEDURE (),BOOL ,VIRTUAL                                   !Get the Debug State set by SetDebugState, RETURN SELF.DebugState
GetNumberSpaceMargin   PROCEDURE (),SHORT ,VIRTUAL                                  !Get the Number of Space Margin that was set by SetNumberSpaceMargin, RETURN SELF.NumberSpaceMargin
GetRepetitionLength    PROCEDURE (),SHORT,VIRTUAL                                   !Get the number of repetition of a character 
GetShowDebugQueueLine  PROCEDURE () ,ASTRING, VIRTUAL                               !Get the line delimeter of ShowDebugQueue
SetLine                PROCEDURE (<ASTRING LineCharacter>,<USHORT Repition>),VIRTUAL  !Format with a specify character the repetion length of the line to set
GetLine                PROCEDURE (<ASTRING LineCharacter>,<USHORT Repition>),ASTRING, VIRTUAL      !Get the formatted line
ShowLine               PROCEDURE(<ASTRING LineCharacter>,<USHORT Repetition>,<BYTE Type>), VIRTUAL !Show a line Type = 1 is See() is called and Type = 2 is Show() is called, Default to Type 1
GetShowDebugQueueRepetitionLength PROCEDURE (),USHORT, VIRTUAL                       !Get the length of the line delimeter of ShowDebugQueue
GetSeeVariablesRepetitionLength   PROCEDURE (),USHORT, VIRTUAL                       !Get the length of the line delimeter of SeeVariables
SetRepetitionLength    PROCEDURE(<SHORT Repetition>), VIRTUAL                        !Set the repetition length of a character
SetShowDebugQueueRepetitionLength PROCEDURE (<USHORT LineLenght>), VIRTUAL            !Set the length of the line delimeter of ShowDebugQueue
SetSeeVariablesRepetitionLength   PROCEDURE (<USHORT LineLength>), VIRTUAL            !Set the length of the line delimeter of SeeVariables
SetRepeatCharacterInVariable PROCEDURE(USHORT Repetition,STRING Character,*ASTRING Variables), VIRTUAL !Set a repeat character string to a string variable passed by address
SetRestoreDebugState   PROCEDURE (*BOOL DebugState)                                     !Set Restore DebugState
CheckRestoreDebugState PROCEDURE (*BOOL DebugState)                                     !Check the currrent DebugState
SetMargin              PROCEDURE(*SHORT NumberSpaceMargin,*SHORT SpaceMargin)           !Set the Margin
!Setup of sections
SetDebugState          PROCEDURE (<BOOL DebugState>) ,VIRTUAL                        !Set the DebugState, is ON if its TRUE and OFF if its FALSE
SetNumberSpaceMargin   PROCEDURE (<SHORT SpaceMargin>) ,VIRTUAL                      !Set Number of Space Margin scope    
SetNote                PROCEDURE (ASTRING Note) ,VIRTUAL                             !Set a Note 
GetNote                PROCEDURE (),ASTRING ,VIRTUAL                                 !Get a Note 
!Stacking recursively
Save                   PROCEDURE()                                                  !Stack the current values 
Restore                PROCEDURE()
!Start() and End() sections
ApplicationStart       PROCEDURE (ASTRING ApplicationName,<ASTRING Parameter>,<BYTE Show>,<SHORT SpaceMargin>)   !Set Appliction it check for margin Set the ProgramName and ApplicationStart
ApplicationEnd         PROCEDURE () ,VIRTUAL                                         !Show to Debug View the end of the Application
ProgramStart           PROCEDURE (ASTRING ProgramName,<ASTRING Parameter>,<BYTE Show>,<SHORT SpaceMargin>)   !Set Program it check for margin Set the ProgramName and ProgramStart
ProgramEnd             PROCEDURE () ,VIRTUAL                                         !Show to Debug View the end of the Program
ClassStart             PROCEDURE(ASTRING ClassName,<BYTE Show>,<SHORT SpaceMargin>), VIRTUAL    !Start the class instance
ClassEnd               PROCEDURE(), VIRTUAL                                         !End the class instance
MethodStart            PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BYTE Show>,<SHORT SpaceMargin>)   !Set Method it check for margin Set the MethodName and MethodStart
MethodEnd              PROCEDURE () ,VIRTUAL                                         !Show to Debug View the end of the Method
ProcStart              PROCEDURE (ASTRING ProcedureName,<ASTRING Prototype>,<BYTE Show>,<SHORT SpaceMargin>) , VIRTUAL !Show to Debug View the beginning of the Procedure
ProcEnd                PROCEDURE () , VIRTUAL                                        !Show to Debug View the end of the Procedure
NoteStart               PROCEDURE (ASTRING Note,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Show to Debug View the beginning of the Note. if used as a function then if the status the NoteSection is _Show = 1 then NoteStart() is shown and return TRUE otherwise is not shown and return FALSE
NoteEnd                PROCEDURE () ,VIRTUAL                                         !Show to Debug View the end of the Note
RoutineStart           PROCEDURE (ASTRING RoutineSection,<BYTE Show>,<SHORT SpaceMargin>), VIRTUAL  !Start routine 
RoutineEnd             PROCEDURE (), VIRTUAL                                         !End routine
CodeStart              PROCEDURE (ASTRING CodeSection,<BYTE Show>,<SHORT SpaceMargin>), VIRTUAL  !Start Code Section
CodeEnd                PROCEDURE (), VIRTUAL                                         !End Code Section
EmbedStart             PROCEDURE (ASTRING EmbedSection,<BYTE Show>,<SHORT SpaceMargin>),BOOL,PROC,VIRTUAL  !Start Embed Section if used as a function then if the status the EmbedSection is _Show = 1 then EmbedStart() is shown and return TRUE otherwise is not shown and return FALSE
EmbedEnd               PROCEDURE (), VIRTUAL                                         !End Embed Section
!Prepare the show
ShowStart              PROCEDURE (ASTRING ShowWhat,ASTRING ShowWhom,SHORT SpaceMargin)  !ShowStart of whom
ShowEnd                PROCEDURE (ASTRING ShowWhat,ASTRING ShowWhom) 	                !Show End of whom
SeeStart               PROCEDURE (ASTRING SeeWhat,ASTRING SeeWhom)                      !Show the start of whom
SeeEnd                 PROCEDURE (ASTRING SeeWhat,ASTRING SeeWhom)                      !Show the end of whom
See                    PROCEDURE (STRING Info,<SHORT SpaceMargin>) ,VIRTUAL         !Show to Debug View window the string if DebugState must be set to TRUE otherwise nothing is shown
ShowLocalDebug         PROCEDURE (<BOOL ShowQ>,<SHORT SpaceMargin>),VIRTUAL         !Show Local jcDebugManager Debug it will use the ShowDebugQueue on the local Debug inheritance class within jcDebugManager
Show                   PROCEDURE (STRING Info,<SHORT SpaceMargin>) ,VIRTUAL         !Show to Debug View window the string if DebugState must be set to TRUE otherwise nothing is shown
ShowHeader             PROCEDURE (ASTRING HeaderString,<USHORT Type>),VIRTUAL       !Show an header string according to a type format.
ShowCurrentMethodValue PROCEDURE (ASTRING MethodString,<ANY Value>,<SHORT SpaceMargin>), VIRTUAL            !Show current method value parameter
ShowValue              PROCEDURE (ASTRING Value,<ANY Data>,<BYTE Show>,<SHORT SpaceMargin>),VIRTUAL !Show the data of the value parameter
SeeVariables           PROCEDURE (<STRING Info>,<SHORT SpaceMargin>) ,VIRTUAL       !Show the current state of Q (jcDebugQueue) to Debug View window after it FREEs from memory the Q instance
ShowDebugQueue         PROCEDURE (<BOOL ShowQ>,<SHORT SpaceMargin>) ,VIRTUAL        !Show to Debug View the status of the Q (jcDebugQueue) within the procedure
ShowClassQueue         PROCEDURE(jcBase BaseClass,<BOOL ShowQ>,<SHORT SpaceMargin>) !Show to Class View the status of the Q (jcBaseQueue) within the procedure 
PrepareShow            PROCEDURE (ASTRING AreaType,ASTRING Area,<BYTE Show>) ,VIRTUAL     ! The AreaType = Application Show, Program Show, Procedure Show, Class Show, Method Show, Routine Show, Code Show, Embed Show and Note Show. These AreaTypes they all have an EQUATE representation. You will find them in the jcDebug.equ source file, "Application Show" = jcDebug::ApplicationShow, "Note Show" = jcDebug::NoteShow etc..., Area = Name of the area we are on, Show = Accept a value of 1, 0, TRUE or FALSE, _Show or _Hide. Note _Show = TRUE and _Hide = FALSE. Prepare the current area for a show if the show does not exist it is created and set to true, the optional Show overwrites the first parameter with a true or false value
SetShow                PROCEDURE (ASTRING Area,BOOL Value) ,VIRTUAL                 !Set show will display certain area or not, by default in Init() it is set to true
GetShow                PROCEDURE (ASTRING Area),BOOL, VIRTUAL                       !Get the Area value 
SetCurrentShow         PROCEDURE (ASTRING AreaType,<ASTRING Area>) ,VIRTUAL         !Set Current Show AreaType = All Area of the same type; Area = Some Area of the same type. ex. The AreaType is All Method Show is active or inactive and The Area is Some Method Show.MethodName(Prototype) is shown or hyde, format of SetCurrentShow is SELF.SetCurrentShow(jcDebug::ProcShow,GetProcedurName())
GetCurrentShow         PROCEDURE (),BOOL, VIRTUAL                                   !Get the current Area value 
GetBOOL                PROCEDURE(BOOL Value,<BYTE Type>),ASTRING                    !IF Value = 1 then GetBOOL() returns 'TRUE' else 'FALSE',<br/>  If the Type parameter is used it accepts the positive values of the boolean entity, <br/> if FALSE the contrary is returned. <br/> The list of true value equates are <br/> _True,<br/>  _On,<br/>  _Open, <br/> _Start, <br/> _Enable, <br/> _Active, <br/> _Functional, <br/> _Engage, <br/> _Alive, <br/> _Awake, <br/> _Startup, <br/> _Showing and <br/> _Something
GetValueRepresentation PROCEDURE(ASTRING Object,ASTRING Detail),ASTRING                             !IF Object is part of the internal list then GetValueRepresentation() returns the string according to the detail. Presently only one type is used when the value = 0 = HYDE, value = 1 = SHOW and value = 2 = HYDE
                    END
!_EndOfInclude_
