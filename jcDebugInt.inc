iDebugInterface   INTERFACE
Fetching            PROCEDURE	!Fetching is reading the jcDebugShow of the main class ini file
Updating            PROCEDURE	!Updating is writing to the jcDebugShow of the main class ini file
 OMIT('!DÉCLARATION SERA FAITE PLUS TARD!')
!CES PROCÉDURES DANS jcDML seront convertis de jcDataMultiLinkManager.SetDebugInit() à jcDataMultiLinkManager.Debug.SetDebugInit() et ainsi de suite
SetDebugInit                  PROCEDURE (BOOL InitializeDebug),PROTECTED                   ! SetDebugInit a TRUE or FALSE if Set to TRUE then the Debug.Init() method in jcDataMultiLinkManager.Init will be called else FALSE then not.    
GetDebugInit                  PROCEDURE (),BOOL,PROTECTED                                  ! GetDebugInit Return a TRUE or FALSE if DebugInit is Set to TRUE then the Debug.Init() method in jcDataMultiLinkManager.Init will be called else FALSE then not.  
SetDebugMessageType           PROCEDURE(BYTE Type),VIRTUAL  	!Set DebugMessageType used by jcDataMultiLinkManager.DebugMessage<br/>if 1=jcDML::DebugMessageTypeMESSAGE invoke MESSAGE window<br/>if 2=jcDML::DebugMessageTypeDebugView invoke DebugView 
GetDebugMessageType           PROCEDURE(),BYTE,VIRTUAL  		  !Get DebugMessageType used by jcDataMultiLinkManager.DebugMessage<br/>if 1=jcDML::DebugMessageTypeMESSAGE invoke MESSAGE window<br/>if 2=jcDML::DebugMessageTypeDebugView invoke DebugView 
DebugMessage                  PROCEDURE (<ASTRING Message>,<ASTRING From>,<BYTE ExecuteDebug>),PROC ,BYTE,VIRTUAL    !Show Detail message including Error, DataMultiLink Data structure and more within a message window or DebugView.<br/>Prior calling the DebugMessage, DebugMessageType must be set.<br/>SetDebugMessageType(jcDML::DebugMessageTypeMESSAGE) will invoke the window MESSAGE.<br/>SetDebugMessageType(jcDML::DebugMessageTypeDebugView) will invoke DebugView.
SetBypassDebugMessageMethodStartAndEnd PROCEDURE(BOOL ByPassMethodStartEnd),PROTECTED ! Set BypassDebugMessageMethodStartAndEnd if TRUE or FALSE
GetBypassDebugMessageMethodStartAndEnd PROCEDURE(),BOOL,PROTECTED                     ! Get BypassDebugMessageMethodStartAndEnd state
!Utility procedures
SetMethodName                 PROCEDURE (ASTRING MethodName,ASTRING Prototype), VIRTUAL    !Set the private MethodName
MethodStart                   PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BOOL Show>,<SHORT SpaceMargin>)   !Set Method it check for margin Set the MethodName and MethodStart
MethodEnd                     PROCEDURE (<BYTE SkipStacking>) ,VIRTUAL                     !Show to Debug View the end of the Method
MethodShow                    PROCEDURE (ASTRING MethodNamePar,<ASTRING PrototypePar>,BYTE ShowPar,ASTRING PromptPar,ASTRING ValuePar), VIRTUAL !Method Show display a short description of a single property
!DÉCLARATION SERA FAITE PLUS TARD!
                  END
