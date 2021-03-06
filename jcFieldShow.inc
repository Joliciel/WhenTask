!This list of variables that are used for the status of the DebugManager Show of the procedure for each jcFieldClassmethods that are in jcField.clw
!They are used as a third parameter show for each MethodStart()
! ex. SELF.Debug.MethodStart('Init,,jcDebugShow:jcFieldClass.Init)

         INCLUDE('jcFieldShowOptions.inc'),ONCE
         OMIT('_jcFieldShowVariables_',_SelectjcFieldVariablesShow_)

!jcFieldClass jcDebugShow:jcField
jcDebugShow:jcFieldClass                GROUP,PRE(jcFieldDebugShow)
Construct                                 BOOL !PROCEDURE
Destruct                                  BOOL !PROCEDURE
Init                                      BOOL !PROCEDURE (),VIRTUAL                                        !Init the jcFieldClass class instance
Kill                                      BOOL !PROCEDURE (),VIRTUAL                                        !Kill the jcFieldClass class instance
MethodStart                               BOOL !PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BOOL Show>,<SHORT SpaceMargin>),PRIVATE  !Set Method it check for margin Set the MethodName and MethodStart
MethodEnd                                 BOOL !PROCEDURE () ,PRIVATE                                       !Show to Debug View the end of the Method
PrepareType                               BOOL !PROCEDURE (ASTRING Type),ASTRING,PRIVATE                    !Prepare the Type string evaluation for the next CASE statement
ShowFields                                BOOL !PROCEDURE (),PRIVATE                                        !Debug View Showing fields of from SELF.Q
CreateStructure                           BOOL !PROCEDURE (ASTRING StructureName),VIRTUAL                   !Create a field structure
SetStructure                              BOOL !PROCEDURE (ASTRING StructureName),VIRTUAL                   !Set the field structure name
GetStructure                              BOOL !PROCEDURE (),ASTRING,VIRTUAL                                !Get the field structure name
CreateField                               BOOL !PROCEDURE (ASTRING FieldName,ASTRING Type,? Value,<ASTRING Format>,<USHORT Length>,<USHORT DecimalLength>),BOOL,PROC, VIRTUAL !CreateField is SetField therefore CreateField the property type BYTE, SHORT, STRING etc..., the optional Length is for STRINGs and DECIMALs properties
SetField                                  BOOL !PROCEDURE (ASTRING FieldName,ASTRING Type,? Value,<ASTRING Format>,<USHORT Length>,<USHORT DecimalLength>),BOOL,PROC, PRIVATE !SetField the property type BYTE, SHORT, STRING etc..., the optional Length is for STRINGs and DECIMALs properties
Set                                       BOOL !PROCEDURE (ASTRING FieldName,? Value),VIRTUAL               !Set is the data field assignement. the value is assigned to the FieldName
UpdateDefinition                          BOOL !PROCEDURE (),VIRTUAL                !Replace the current field definition
SetPairQ                                  BOOL !PROCEDURE (*QFields Q,*jcFieldGroupC G)                     !SetPairQ pair fields from a jcFieldGroupC Class to a QFields Queue
SetPairG                                  BOOL !PROCEDURE (*jcFieldGroupC G,*QFields Q)                     !SetPairG pair fields from a QFields Queue fields to a jcFieldGroupC Class
Add                                       BOOL !PROCEDURE (*QFields Q),BYTE ,PROC, VIRTUAL                   !Add a new field with its parameter the FieldName variable type, value, format, formatedvalue and VariableFieldTypeValue
Add2                                      BOOL !PROCEDURE (*QFields Q,*jcFieldGroupC G),BYTE ,PROC, VIRTUAL !Add a new field with its parameter the FieldName variable type, value, format, formatedvalue and VariableFieldTypeValue
Get                                       BOOL !PROCEDURE (ASTRING FieldName),?,PROC, VIRTUAL                !Get the Field value according to its variable type if the Field is a BYTE it will return the BYTE value of the Field
WhatIs                                    BOOL !PROCEDURE (ASTRING FieldName),ASTRING,VIRTUAL                !What is the type of the field name variable type
FieldTypeIs                               BOOL !PROCEDURE (ASTRING Type),ASTRING,VIRTUAL                     !FieldTypeIs returns a string of the variable field type
GetData                                   BOOL !PROCEDURE (),?,VIRTUAL                                       !GetData returns the value of the Field according to its variable type
GetSize                                   BOOL !PROCEDURE (ASTRING FieldName),LONG,VIRTUAL                    !Get the Size of the field
Update                                    BOOL !PROCEDURE (ASTRING FieldName,? ValueReplacement),BOOL,PROC ,VIRTUAL  !Assign a value to the field
Update2                                   BOOL !PROCEDURE (ASTRING ValueReplacement),BOOL,PROC ,VIRTUAL     !Replace the Value of the current Field
Delete                                    BOOL !PROCEDURE (ASTRING FieldName),BOOL,PROC ,VIRTUAL            !Delete the field
GetString                                 BOOL !PROCEDURE (? Field),ASTRING,VIRTUAL                         !GetString Returns a string value of any fields
SetTypeOnly                               BOOL !PROCEDURE(BOOL Type),VIRTUAL                                !IF type is to true then CSTRING, STRING or STRING[] will return only the field type CSTRING STRING<br/>Otherwise CSTRING(Length) STRING(Length) and STRING[Subscript]
GetTypeOnly                               BOOL !PROCEDURE(),BOOL,VIRTUAL                                    !IF type is to true then CSTRING, STRING or STRING[] will return only the field type CSTRING STRING<br/>Otherwise CSTRING(Length) STRING(Length)
Is                                        BOOL !PROCEDURE(*FILE Field),ASTRING,VIRTUAL                      !Confirm if the field type is a FILE or not, if true then return 'FILE'
Is2                                       BOOL !PROCEDURE(*KEY Field),ASTRING,VIRTUAL                       !Confirm if the field type is a KEY or not, if true then return 'KEY'
Is3                                       BOOL !PROCEDURE(*WINDOW Field),ASTRING,VIRTUAL                    !Confirm if the field type is a WINDOW or not, if true then return 'WINDOW'
Is4                                       BOOL !PROCEDURE(*REPORT Field),ASTRING,VIRTUAL                    !Confirm if the field type is a REPORT or not, if true then return 'REPORT'
Is5                                       BOOL !PROCEDURE(*BLOB Field),ASTRING,VIRTUAL                      !Confirm if the field type is a BLOB not, if true then return 'BLOB'
Is6                                       BOOL !PROCEDURE(*VIEW Field),ASTRING,VIRTUAL                      !Confirm if the field type is a VIEW or not, if true then return 'VIEW'
Is7                                       BOOL !PROCEDURE(*ANY Field),ASTRING,VIRTUAL                       !Confirm if the field type is a ANY or not, if true then return 'ANY'
Is8                                       BOOL !PROCEDURE(*ASTRING Field),ASTRING,VIRTUAL                   !Confirm if the field type is a ASTRING or not, if true then return 'ASTRING'
Is9                                       BOOL !PROCEDURE(*BFLOAT4 Field),ASTRING,VIRTUAL                   !Confirm if the field type is a BFLOAT4 or not, if true then return 'BFLOAT4'
Is10                                      BOOL !PROCEDURE(*BFLOAT8 Field),ASTRING,VIRTUAL                   !Confirm if the field type is a BFLOAT8 or not, if true then return 'BFLOAT8'
Is11                                      BOOL !PROCEDURE(*BYTE Field),ASTRING,VIRTUAL                      !Confirm if the field type is a BYTE or not, if true then return 'BYTE'
Is12                                      BOOL !PROCEDURE(*CSTRING Field),ASTRING,VIRTUAL                   !Confirm if the field type is a CSTRING or not, if true then return 'CSTRING'
Is13                                      BOOL !PROCEDURE(*DATE Field),ASTRING,VIRTUAL                      !Confirm if the field type is a DATE or not, if true then return 'DATE'
Is14                                      BOOL !PROCEDURE(*DECIMAL Field),ASTRING,VIRTUAL                   !Confirm if the field type is a DECIMAL or not, if true then return 'DECIMAL'
Is15                                      BOOL !PROCEDURE(*GROUP Field),ASTRING,VIRTUAL                     !Confirm if the field type is a GROUP or not, if true then return 'GROUP'
Is16                                      BOOL !PROCEDURE(*QUEUE Field),ASTRING,VIRTUAL                     !Confirm if the field type is a QUEUE or not, if true then return 'QUEUE'
Is17                                      BOOL !PROCEDURE(*LONG Field),ASTRING,VIRTUAL                      !Confirm if the field type is a LONG or not, if true then return 'LONG'
Is18                                      BOOL !PROCEDURE(*PDECIMAL Field),ASTRING,VIRTUAL                  !Confirm if the field type is a PDECIMAL or not, if true then return 'PDECIMAL'
Is19                                      BOOL !PROCEDURE(*PSTRING Field),ASTRING,VIRTUAL                   !Confirm if the field type is a PSTRING or not, if true then return 'PSTRING'
Is20                                      BOOL !PROCEDURE(*REAL Field),ASTRING,VIRTUAL                      !Confirm if the field type is a REAL or not, if true then return 'REAL'
Is21                                      BOOL !PROCEDURE(*SHORT Field),ASTRING,VIRTUAL                     !Confirm if the field type is a SHORT or not, if true then return 'SHORT'
Is22                                      BOOL !PROCEDURE(*SREAL Field),ASTRING,VIRTUAL                     !Confirm if the field type is a SREAL or not, if true then return 'SREAL'
Is23                                      BOOL !PROCEDURE(*STRING Field),ASTRING,VIRTUAL                    !Confirm if the field type is a STRING or not, if true then return 'STRING'
Is24                                      BOOL !PROCEDURE(*TIME Field),ASTRING,VIRTUAL                      !Confirm if the field type is a TIME or not, if true then return 'ASTRING'
Is25                                      BOOL !PROCEDURE(*ULONG Field),ASTRING,VIRTUAL                     !Confirm if the field type is a ULONG or not, if true then return 'ULONG'
Is26                                      BOOL !PROCEDURE(*USHORT Field),ASTRING,VIRTUAL                    !Confirm if the field type is a USHORT or not, if true then return 'USHORT'
                                        END

!jcFieldArray jcDebugShow:jcFieldArray
jcDebugShow:jcFieldArray                GROUP,PRE(jcFieldADebugShow)
Is27                                      BOOL !PROCEDURE(ANY[] Field),ASTRING,VIRTUAL                      !Confirm if the field type is a ANY or not, if true then return 'ANY'
Is28                                      BOOL !PROCEDURE(*ASTRING[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a ASTRING or not, if true then return 'ASTRING'
Is29                                      BOOL !PROCEDURE(*BFLOAT4[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a BFLOAT4 or not, if true then return 'BFLOAT4'
Is30                                      BOOL !PROCEDURE(*BFLOAT8[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a BFLOAT8 or not, if true then return 'BFLOAT8'
Is31                                      BOOL !PROCEDURE(*BYTE[] Field),ASTRING,VIRTUAL                    !Confirm if the field type is a BYTE or not, if true then return 'BYTE'
Is32                                      BOOL !PROCEDURE(*CSTRING[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a CSTRING or not, if true then return 'CSTRING'
Is33                                      BOOL !PROCEDURE(*DATE[] Field),ASTRING,VIRTUAL                    !Confirm if the field type is a DATE or not, if true then return 'DATE'
Is34                                      BOOL !PROCEDURE(*DECIMAL[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a DECIMAL or not, if true then return 'DECIMAL'
Is35                                      BOOL !PROCEDURE(*GROUP[] Field),ASTRING,VIRTUAL                   !Confirm if the field type is a GROUP or not, if true then return 'GROUP'
Is36                                      BOOL !PROCEDURE(*LONG[] Field),ASTRING,VIRTUAL                    !Confirm if the field type is a LONG or not, if true then return 'LONG'
Is37                                      BOOL !PROCEDURE(*PDECIMAL[] Field),ASTRING,VIRTUAL                !Confirm if the field type is a PDECIMAL or not, if true then return 'PDECIMAL'
Is38                                      BOOL !PROCEDURE(*PSTRING[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a PSTRING or not, if true then return 'PSTRING'
Is39                                      BOOL !PROCEDURE(*REAL[] Field),ASTRING,VIRTUAL                    !Confirm if the field type is a REAL or not, if true then return 'REAL'
Is40                                      BOOL !PROCEDURE(*SHORT[] Field),ASTRING,VIRTUAL                   !Confirm if the field type is a SHORT or not, if true then return 'SHORT'
Is41                                      BOOL !PROCEDURE(*SREAL[] Field),ASTRING,VIRTUAL                   !Confirm if the field type is a SREAL or not, if true then return 'SREAL'
Is42                                      BOOL !PROCEDURE(*STRING[] Field),ASTRING,VIRTUAL                  !Confirm if the field type is a STRING or not, if true then return 'STRING'
Is43                                      BOOL !PROCEDURE(*TIME[] Field),ASTRING,VIRTUAL                    !Confirm if the field type is a TIME or not, if true then return 'ASTRING'
Is44                                      BOOL !PROCEDURE(*ULONG[] Field),ASTRING,VIRTUAL                   !Confirm if the field type is a ULONG or not, if true then return 'ULONG'
Is45                                      BOOL !PROCEDURE(*USHORT[] Field),ASTRING,VIRTUAL                  !Confirm if the field type is a USHORT or not, if true then return 'USHORT'
                                        END

!jcFieldDataManager jcDebugShow:jcFieldDataManager
jcDebugShow:jcFieldDataManager          GROUP,PRE(jcFieldDDebugShow)
Construct                                 BOOL !PROCEDURE
Destruct                                  BOOL !PROCEDURE
AddData                                   BOOL !PROCEDURE(QFields Q),VIRTUAL                               !Add data to Queue
Get                                       BOOL !PROCEDURE (ASTRING FieldName,USHORT FieldID),?,PROC, VIRTUAL    !Get the Field value according to its variable type if the Field is a BYTE it will return the BYTE value of the Field. <br/> The first parameter is the field name of the data structure <br/> The Second parameter the field id within the Data structure assigned to jcFieldGroup
SetCurrentFieldID                         BOOL !PROCEDURE(USHORT FieldsID),VIRTUAL                         !Set the current field ID
GetCurrentFieldID                         BOOL !PROCEDURE(),USHORT,VIRTUAL                                 !Get the current field ID
DeleteData                                BOOL !PROCEDURE(QFields Q),VIRTUAL                               !Delete data to Queue
UpdateData                                BOOL !PROCEDURE(QFields Q),VIRTUAL                               !Update data to Queue
GetHeaderColumns                          BOOL !PROCEDURE(),ASTRING,VIRTUAL                                !Build the header of the queue
ShowFieldDataQueue                        BOOL !PROCEDURE,VIRTUAL                                          !Show to DebugView the list of data
                                        END

!jcFieldManager jcDebugShow:jcFieldManager
jcDebugShow:jcFieldManager              GROUP,PRE(jcFieldMDebugShow)
Construct                                 BOOL !PROCEDURE (),PROTECTED                                      !Construct the jcFieldmanager class instance
Destruct                                  BOOL !PROCEDURE (),PROTECTED                                      !Destroy the jcFieldmanager class instance
Init                                      BOOL !PROCEDURE (<*GROUP G>,<*QUEUE Q>,<*ANY AnyNodeVal>),VIRTUAL                   !Init the jcFieldmanager class instance
Kill                                      BOOL !PROCEDURE (),VIRTUAL                                        !Kill the jcFieldmanager class instance
MethodStart                               BOOL !PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BOOL Show>,<SHORT SpaceMargin>),PRIVATE  !Set Method it check for margin Set the MethodName and MethodStart
MethodEnd                                 BOOL !PROCEDURE () ,PRIVATE                                       !Show to Debug View the end of the Method
SetIndexField                             BOOL !PROCEDURE (BYTE IndexField),VIRTUAL                         !Set the index ordinal Field,<br/><br/> Default to the equate JC_FIELD_jcFieldManager_SetIndexField = 1, the Ordinal index field start with the first field in the Structure.<br/> the structure may be a QUEUE or GROUP.<br/> If the index field is set to 0 then the name of the GROUP structure is included.<br/> the IndexField is used in GetFields() methods
GetIndexField                             BOOL !PROCEDURE (),BYTE,VIRTUAL                                   !Get the index Field
SetColumnIndex                            BOOL !PROCEDURE (BOOL ColumnIndex),VIRTUAL                        !Do the index field from the StackQueue is shown in the first column or not if TRUE the INDEX Column. <br/> From the stackQueue is shown otherwise FALSE the INDEX Column is not shown we start from the first. <br/> Field of the structure or from the SELF.indexField defined.
GetColumnIndex                            BOOL !PROCEDURE (),BOOL,VIRTUAL                                   !Get the Column Index usage if true there will be an index column
SetColumnIndexLength                      BOOL !PROCEDURE (BYTE ColumnIndexLength),VIRTUAL                  !The length of the Index field column taken from the stackQue that will appear if SELF.ColumnIndex = TRUE
GetColumnIndexLength                      BOOL !PROCEDURE (),BYTE,VIRTUAL                                   !Get the length of the Index field column taken from the stackQue that will appear if SELF.ColumnIndex = TRUE
GetIndex                                  BOOL !PROCEDURE (*QUEUE Q,*? Field),USHORT,VIRTUAL                !Get the field index from a QUEUE , ex. if the Field is the the 3rd field within the QUEUE structure, GetIndex() returns 3
GetIndex2                                 BOOL !PROCEDURE (*GROUP G,*? Field),USHORT,VIRTUAL                 !Get the field index from a GROUP, ex. if the Field is the the 3rd field within the GROUP structure, GetIndex() returns 3
GetName                                   BOOL !PROCEDURE (*QUEUE Q,USHORT indexField),ASTRING,VIRTUAL      !Get the indexField position field name of a QUEUE, ex. if the indexField is 2 then second FieldName in UPPER case is given within the QUEUE structure, GetName() returns 'FIELDNAME' according to the indexField position
GetName2                                  BOOL !PROCEDURE (*GROUP G,USHORT indexField),ASTRING,VIRTUAL      !Get the indexField position field name of a GROUP , ex. if the indexField is 2 then second FieldName in UPPER case is given within the GROUP structure, GetName() returns 'FIELDNAME' according to the indexField position
GetData                                   BOOL !PROCEDURE (*QUEUE Q,USHORT indexField),ASTRING,VIRTUAL      !Get the indexField position field data of a QUEUE , ex. if the indexField is 2 then second FieldData is given from the QUEUE structure, GetData() returns 'FIELDDATA' according to the indexField position
GetData2                                  BOOL !PROCEDURE (*GROUP G,USHORT indexField),ASTRING,VIRTUAL      !Get the indexField position field data of a GROUP , ex. if the indexField is 2 then second FieldData is given from the GROUP structure, GetData() returns 'FIELDDATA' according to the indexField position
GetFields                                 BOOL !PROCEDURE (*GROUP G,<USHORT StartPosition>,<BYTE FieldsFormat>),ASTRING,VIRTUAL   !Get the fields Name of a structure GROUP, GROUP FIELDS, if the StartPosition is assigned then the GetFields will start from the assigned field sequence. <br/>  The FieldsFormat parameter accept a value between 1 and 4.<br/> FieldsFormat 1 = 'FieldName',<br/> FieldsFormat 2 = 'FieldName = FieldData',<br/> FieldsFormat 3 = 'NameOfTheStructure.FieldName = FieldData',<br
GetFields2                                BOOL !PROCEDURE (*QUEUE Q,<USHORT StartPosition>,<BYTE FieldsFormat>),ASTRING,VIRTUAL   !Get the fields Name of a structure QUEUE, RECORD QUEUE FIELDS, if the StartPosition is assigned then the GetFields will start from the assigned field sequence. <br/>  The FieldsFormat parameter accept a value between 1 and 4.<br/> FieldsFormat 1 = 'FieldName',<br/> FieldsFormat 2 = 'FieldName = FieldData',<br/> FieldsFormat 3 = 'NameOfTheStructure.FieldName = FieldDa
SetFieldsFormat                           BOOL !PROCEDURE (<BYTE FieldsFormat>),VIRTUAL                     !Set the fields return format of a structure CLASS, QUEUE or GROUP, <br/>  The FieldsFormat parameter accept a value between 1 and 4.<br/> FieldsFormat 1 = 'FieldName',<br/> FieldsFormat 2 = 'FieldName = FieldData',<br/> FieldsFormat 3 = 'NameOfTheStructure.FieldName = FieldData',<br/> FieldsFormat 4 = 'FieldData'
GetFieldsFormat                           BOOL !PROCEDURE (),BYTE,VIRTUAL                                   !Get the fields format
SetFieldsFormatLimit                      BOOL !PROCEDURE (<BYTE FieldsFormatLimit>),VIRTUAL                !Set the fields FormatLimit presently we have a limit of 4 set with the constant equate JC_FIELD_jcFieldManager_SetFormatFields
GetFieldsFormatLimit                      BOOL !PROCEDURE (),BYTE,VIRTUAL                                   !Get the fields FormatLimit
GetARecordFromQueue                       BOOL !PROCEDURE (LONG indexQPosition,USHORT indexField),ANY       !Get the data from the indexField position of a single record of a queue
CalculateColumnsSet                       BOOL !PROCEDURE (*stackQueue Q,*GROUP TargetGroup,*USHORT[] ColumnsLength)   !CalculateColumnsSet compute the length of each columns according to the data and/or the TargetGroup field length, the largest result is taken
CalculateColumnsSet2                      BOOL !PROCEDURE (*stackQueue Q,*GROUP TargetGroup)                !CalculateColumnsSet compute the length of each columns according to the data and/or the TargetGroup field length, the largest result is taken
CalculateColumnsSet3                      BOOL !PROCEDURE (*QUEUE Q,*GROUP TargetGroup)                !CalculateColumnsSet compute the length of each columns according to the data and/or the TargetGroup field length, the largest result is taken
CalculateColumnsSet4                      BOOL !PROCEDURE (*QUEUE Q,*USHORT[] ColumnsLength)                !Calculate Columns Sets of a define queue
CalculateColumnsSet5                      BOOL !PROCEDURE (*QUEUE Q)                                        !Calculate Columns Sets of a define queue
CalculateColumnsRow                       BOOL !PROCEDURE (*QUEUE Q,*USHORT[] ColumnsLength)                !Calculate for the largest column of a queue, ColumnsLength dimensional array parameter used by address
CalculateColumnsRow2                      BOOL !PROCEDURE (*QUEUE Q)                                        !Calculate for the largest column of a queue, the internal jcFieldManager class ColumnsLength dimensional array property is used
CalculateColumnsRow3                      BOOL !PROCEDURE (*QUEUE Q,*GROUP G,*USHORT[] ColumnsLength)       !Calculate for the largest column of a group, ColumnsLength dimensional array parameter used by address
CalculateColumnsRow4                      BOOL !PROCEDURE (*QUEUE Q,*GROUP G)                                               !Calculate for the largest column of a queue, the internal jcFieldManager class ColumnsLength dimensional array property is used
SetColumnsSize                            BOOL !PROCEDURE (? Columns),VIRTUAL                               !Set the largest length for all columns
GetColumnsSize                            BOOL !PROCEDURE (),USHORT,VIRTUAL                                 !Get the largest length for all columns
GetNumberOfColumns                        BOOL !PROCEDURE (*USHORT[] Columns),ULONG                         !Get the number columns used
GetNumberOfColumns2                       BOOL !PROCEDURE (),ULONG                         !Get the number columns used
GetHeaderColumns                          BOOL !PROCEDURE (*QUEUE Q,*USHORT[] ColumnsLength),ASTRING,VIRTUAL !Get Header columns from a QUEUE structure According to the size of the data in the queue
GetHeaderColumns2                         BOOL !PROCEDURE (*QUEUE Q),ASTRING,VIRTUAL                        !Get Header columns from a QUEUE structure According to the calculated columns set of the data in the queue
GetHeaderColumns3                         BOOL !PROCEDURE (*GROUP G,*USHORT[] ColumnsLength),ASTRING,VIRTUAL !Get Header columns from a GROUP structure According to the calculcate columns set  of the data in the group
GetHeaderColumns4                         BOOL !PROCEDURE (*GROUP G),ASTRING,VIRTUAL                        !Get Header columns from a GROUP structure According to the calculated columns set of the data in the group
ShowColumns                               BOOL !PROCEDURE (stackQueue Q,<*GROUP G>,*USHORT[] ColumnsLength) !Show the columns of the group from the Saved QUEUE where the group may be referenced in the Init() method or pass as a parameter. If omitted then the refernce Group is used.
ShowColumns2                              BOOL !PROCEDURE (stackQueue Q,<*GROUP G>)                         !Show the columns of the group from the Saved QUEUE where the group may be referenced in the Init() method or pass as a parameter. If omitted then the refernce Group is used.
ShowColumns3                              BOOL !PROCEDURE (*QUEUE Q)                                        !Show the columns of the QUEUE format to fit the entire array of data.
ShowColumns4                              BOOL !PROCEDURE (USHORT indexField,*USHORT[] ColumnsLength)       !Show the columns of the group from the Saved QUEUE where the group is referenced in the Init() method. The external dimensional ColumnsLength dimensional array is used.
ShowColumns5                              BOOL !PROCEDURE (USHORT indexField)                               !Show the columns of the group from the Saved QUEUE where the group is referenced in the Init() method
ShowColumns6                              BOOL !PROCEDURE (*USHORT[] ColumnsLength)                         !Show the columns of a QUEUE referenced in Init() method
ShowColumns7                              BOOL !PROCEDURE ()                                                !Show the columns of a QUEUE referenced in Init() method
GetStringFormatLength                     BOOL !PROCEDURE (USHORT StringLength),ASTRING                     !Get the length of the formatted strings if parameter(6) it returns '@s6'
EmbedShow                                 BOOL !PROCEDURE (ASTRING EmbedShow)                               !Show the EmbedShow
ShowQueue                                 BOOL !PROCEDURE (*QUEUE Q),VIRTUAL                                !Show the contenant of the Queue to the screen
ShowQueue2                                BOOL !PROCEDURE (stackQueue Q,<*GROUP G>),VIRTUAL                 !Show the contenant of the Queue to the screen
ShowQueue3                                BOOL !PROCEDURE (*QUEUE Q,*GROUP G),VIRTUAL                     !Show the contenant of the Queue to the screen
AddDataLog                                BOOL !PROCEDURE (*QUEUE Q),VIRTUAL                                !Add Data from the Queue to the log file
PrintLog                                  BOOL !PROCEDURE (),VIRTUAL                                        !Print the current logFileNumberUsed log file to the printer
PrintQ                                    BOOL !PROCEDURE (*QUEUE Q),VIRTUAL                                !Print the Queue content
                                        END
_jcFieldShowVariables_
