!ABCIncludeFile(Joliciel)
  INCLUDE('jcClassProjectOptions.inc'),ONCE
!
! Joliciel 2012
OMIT('_EndOfInclude_',_jcFieldManager_)
_jcFieldManager_ EQUATE(1)

  INCLUDE('jcBase.inc'),ONCE
  INCLUDE('jcDebug.inc'),ONCE
  INCLUDE('jcStack.inc'),ONCE
  INCLUDE('jcLog.inc'),ONCE
  INCLUDE('jcField.equ'),ONCE
  !INCLUDE('jcFieldx.inc'),ONCE
  INCLUDE('ABFile.inc'),ONCE
  INCLUDE('ABError.inc'),ONCE
  INCLUDE('jcFieldShow.equ'),ONCE
  INCLUDE('jcFieldShow.inc'),ONCE
  INCLUDE('jcFieldWhenTask.equ'),ONCE
 
!Fields Structure

jcFieldGroup       GROUP
Structure             ASTRING
FieldName             ASTRING
Type                  ASTRING
Value                 ASTRING
Format                ASTRING
FormatedField         ASTRING
bField                BYTE                    
hField                SHORT
uhField               USHORT
lField                LONG
ulField               ULONG
rField                REAL
srField               SREAL
dtField               DATE
tField                TIME
aField                ANY
bf4Field              BFLOAT4
bf8Field              BFLOAT8
sField                &STRING
csField               &CSTRING
psField               &PSTRING
dField                &DECIMAL
pdField               &PDECIMAL
                    END

jcFieldGroupDim     GROUP,OVER(jcFieldGroup),DIM(100).

jcFieldGroupC CLASS(jcFieldGroup),TYPE.

QFields             QUEUE(jcFieldGroup),TYPE.


QFieldsData         QUEUE(),TYPE
NumberOfFields        LONG
RecordRow             GROUP(jcFieldGroup),DIM(MaximumNumberOfFields). !ça fonctionne je dois utiliser les méthodes de la classe jcFieldClass pour extraire les données selon leur type
                    END

                    MAP
                    END

           


jcFieldClass        CLASS(jcBase),TYPE,MODULE('jcField.clw'),LINK('jcField.clw',_JCLinkMode_),DLL(_JCDllMode_)
F                     &jcFieldClass
G                     &jcFieldGroupC
Q                     &QFields
Debug                 &jcDebugManager                   !The Debug property is a reference the jcDebugManager class    
Structure             ASTRING
bField                &BYTE,PRIVATE                    !A BYTE field property
hField                &SHORT,PRIVATE
uhField               &USHORT,PRIVATE
lField                &LONG,PRIVATE
ulField               &ULONG,PRIVATE
rField                &REAL,PRIVATE
srField               &SREAL,PRIVATE
sField                &STRING,PRIVATE
csField               &CSTRING,PRIVATE
psField               &PSTRING,PRIVATE
dField                &DECIMAL,PRIVATE
pdField               &PDECIMAL,PRIVATE
dtField               &DATE,PRIVATE
tField                &TIME,PRIVATE
aField                ANY,PRIVATE
bf4Field              &BFLOAT4,PRIVATE
bf8Field              &BFLOAT8,PRIVATE
TypeOnly              BOOL,PRIVATE  !IF TypeOnly is to true then CSTRING, STRING or STRING[] will return only the field type CSTRING STRING Otherwise CSTRING(Length) STRING(Length)
!Methods
Construct             PROCEDURE
Destruct              PROCEDURE
Init                  PROCEDURE (),VIRTUAL                                        !Init the jcFieldClass class instance
Kill                  PROCEDURE (),VIRTUAL                                        !Kill the jcFieldClass class instance
MethodStart           PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BOOL Show>,<SHORT SpaceMargin>),PRIVATE  !Set Method it check for margin Set the MethodName and MethodStart
MethodEnd             PROCEDURE () ,PRIVATE                                       !Show to Debug View the end of the Method
PrepareType           PROCEDURE (ASTRING Type),ASTRING,PRIVATE                    !Prepare the Type string evaluation for the next CASE statement
ShowFields            PROCEDURE (),PRIVATE                                        !Debug View Showing fields of from SELF.Q
CreateStructure       PROCEDURE (ASTRING StructureName),VIRTUAL                   !Create a field structure
SetStructure          PROCEDURE (ASTRING StructureName),VIRTUAL                   !Set the field structure name
GetStructure          PROCEDURE (),ASTRING,VIRTUAL                                !Get the field structure name
CreateField           PROCEDURE (ASTRING FieldName,ASTRING Type,? Value,<ASTRING Format>,<USHORT Length>,<USHORT DecimalLength>),BOOL,PROC, VIRTUAL !CreateField is SetField therefore CreateField the property type BYTE, SHORT, STRING etc..., the optional Length is for STRINGs and DECIMALs properties
SetField              PROCEDURE (ASTRING FieldName,ASTRING Type,? Value,<ASTRING Format>,<USHORT Length>,<USHORT DecimalLength>),BOOL,PROC, PRIVATE !SetField the property type BYTE, SHORT, STRING etc..., the optional Length is for STRINGs and DECIMALs properties
Set                   PROCEDURE (ASTRING FieldName,? Value),VIRTUAL               !Set is the data field assignement. the value is assigned to the FieldName
 !UpdateDefinition      PROCEDURE (*QFields FieldDefinition),VIRTUAL                !Replace the current field definition 
UpdateDefinition      PROCEDURE (),VIRTUAL                !Replace the current field definition 
SetPairQ              PROCEDURE (*QFields Q,*jcFieldGroupC G)                     !SetPairQ pair fields from a jcFieldGroupC Class to a QFields Queue
SetPairG              PROCEDURE (*jcFieldGroupC G,*QFields Q)                     !SetPairG pair fields from a QFields Queue fields to a jcFieldGroupC Class 
Add                   PROCEDURE (*QFields Q),BYTE ,PROC, VIRTUAL                   !Add a new field with its parameter the FieldName variable type, value, format, formatedvalue and VariableFieldTypeValue
Add                   PROCEDURE (*QFields Q,*jcFieldGroupC G),BYTE ,PROC, VIRTUAL !Add a new field with its parameter the FieldName variable type, value, format, formatedvalue and VariableFieldTypeValue
Get                   PROCEDURE (ASTRING FieldName),?,PROC, VIRTUAL                !Get the Field value according to its variable type if the Field is a BYTE it will return the BYTE value of the Field
WhatIs                PROCEDURE (ASTRING FieldName),ASTRING,VIRTUAL                !What is the type of the field name variable type
FieldTypeIs           PROCEDURE (ASTRING Type),ASTRING,VIRTUAL                     !FieldTypeIs returns a string of the variable field type
GetData               PROCEDURE (),?,VIRTUAL                                       !GetData returns the value of the Field according to its variable type
GetSize               PROCEDURE (ASTRING FieldName),LONG,VIRTUAL                    !Get the Size of the field
Update                PROCEDURE (ASTRING FieldName,? ValueReplacement),BOOL,PROC ,VIRTUAL  !Assign a value to the field 
Update                PROCEDURE (ASTRING ValueReplacement),BOOL,PROC ,VIRTUAL     !Replace the Value of the current Field 
Delete                PROCEDURE (ASTRING FieldName),BOOL,PROC ,VIRTUAL            !Delete the field
GetString             PROCEDURE (? Field),ASTRING,VIRTUAL                         !GetString Returns a string value of any fields
SetTypeOnly           PROCEDURE(BOOL Type),VIRTUAL                                !IF type is to true then CSTRING, STRING or STRING[] will return only the field type CSTRING STRING<br/>Otherwise CSTRING(Length) STRING(Length) and STRING[Subscript] 
GetTypeOnly           PROCEDURE(),BOOL,VIRTUAL                                    !IF type is to true then CSTRING, STRING or STRING[] will return only the field type CSTRING STRING<br/>Otherwise CSTRING(Length) STRING(Length)
Is                    PROCEDURE(*FILE Field),ASTRING,VIRTUAL                      !Confirm if the field type is a FILE or not, if true then return 'FILE' 
Is                    PROCEDURE(*KEY Field),ASTRING,VIRTUAL                       !Confirm if the field type is a KEY or not, if true then return 'KEY'
Is                    PROCEDURE(*WINDOW Field),ASTRING,VIRTUAL                    !Confirm if the field type is a WINDOW or not, if true then return 'WINDOW'
Is                    PROCEDURE(*REPORT Field),ASTRING,VIRTUAL                    !Confirm if the field type is a REPORT or not, if true then return 'REPORT'
Is                    PROCEDURE(*BLOB Field),ASTRING,VIRTUAL                      !Confirm if the field type is a BLOB not, if true then return 'BLOB'
Is                    PROCEDURE(*VIEW Field),ASTRING,VIRTUAL                      !Confirm if the field type is a VIEW or not, if true then return 'VIEW'
Is                    PROCEDURE(*ANY Field),ASTRING,VIRTUAL                       !Confirm if the field type is a ANY or not, if true then return 'ANY'
Is                    PROCEDURE(*ASTRING Field),ASTRING,VIRTUAL                   !Confirm if the field type is a ASTRING or not, if true then return 'ASTRING'
Is                    PROCEDURE(*BFLOAT4 Field),ASTRING,VIRTUAL                   !Confirm if the field type is a BFLOAT4 or not, if true then return 'BFLOAT4'
Is                    PROCEDURE(*BFLOAT8 Field),ASTRING,VIRTUAL                   !Confirm if the field type is a BFLOAT8 or not, if true then return 'BFLOAT8'
Is                    PROCEDURE(*BYTE Field),ASTRING,VIRTUAL                      !Confirm if the field type is a BYTE or not, if true then return 'BYTE'
Is                    PROCEDURE(*CSTRING Field),ASTRING,VIRTUAL                   !Confirm if the field type is a CSTRING or not, if true then return 'CSTRING'
Is                    PROCEDURE(*DATE Field),ASTRING,VIRTUAL                      !Confirm if the field type is a DATE or not, if true then return 'DATE'
Is                    PROCEDURE(*DECIMAL Field),ASTRING,VIRTUAL                   !Confirm if the field type is a DECIMAL or not, if true then return 'DECIMAL'
Is                    PROCEDURE(*GROUP Field),ASTRING,VIRTUAL                     !Confirm if the field type is a GROUP or not, if true then return 'GROUP'
Is                    PROCEDURE(*QUEUE Field),ASTRING,VIRTUAL                     !Confirm if the field type is a QUEUE or not, if true then return 'QUEUE'
Is                    PROCEDURE(*LONG Field),ASTRING,VIRTUAL                      !Confirm if the field type is a LONG or not, if true then return 'LONG'
Is                    PROCEDURE(*PDECIMAL Field),ASTRING,VIRTUAL                  !Confirm if the field type is a PDECIMAL or not, if true then return 'PDECIMAL'
Is                    PROCEDURE(*PSTRING Field),ASTRING,VIRTUAL                   !Confirm if the field type is a PSTRING or not, if true then return 'PSTRING'
Is                    PROCEDURE(*REAL Field),ASTRING,VIRTUAL                      !Confirm if the field type is a REAL or not, if true then return 'REAL'
Is                    PROCEDURE(*SHORT Field),ASTRING,VIRTUAL                     !Confirm if the field type is a SHORT or not, if true then return 'SHORT'
Is                    PROCEDURE(*SREAL Field),ASTRING,VIRTUAL                     !Confirm if the field type is a SREAL or not, if true then return 'SREAL'
Is                    PROCEDURE(*STRING Field),ASTRING,VIRTUAL                    !Confirm if the field type is a STRING or not, if true then return 'STRING'
Is                    PROCEDURE(*TIME Field),ASTRING,VIRTUAL                      !Confirm if the field type is a TIME or not, if true then return 'ASTRING'
Is                    PROCEDURE(*ULONG Field),ASTRING,VIRTUAL                     !Confirm if the field type is a ULONG or not, if true then return 'ULONG'
Is                    PROCEDURE(*USHORT Field),ASTRING,VIRTUAL                    !Confirm if the field type is a USHORT or not, if true then return 'USHORT'
!Data 
                    END
!Array parameters
jcFieldArray        CLASS(jcFieldClass),TYPE,MODULE('jcField.clw'),LINK('jcField.clw',_JCLinkMode_),DLL(_JCDllMode_)
Is                    PROCEDURE(ANY[] Field),ASTRING,VIRTUAL                      !Confirm if the field type is a ANY or not, if true then return 'ANY'
Is                    PROCEDURE(*ASTRING[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a ASTRING or not, if true then return 'ASTRING'
Is                    PROCEDURE(*BFLOAT4[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a BFLOAT4 or not, if true then return 'BFLOAT4'
Is                    PROCEDURE(*BFLOAT8[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a BFLOAT8 or not, if true then return 'BFLOAT8'
Is                    PROCEDURE(*BYTE[] Field),ASTRING,VIRTUAL                    !Confirm if the field type is a BYTE or not, if true then return 'BYTE'
Is                    PROCEDURE(*CSTRING[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a CSTRING or not, if true then return 'CSTRING'
Is                    PROCEDURE(*DATE[] Field),ASTRING,VIRTUAL                    !Confirm if the field type is a DATE or not, if true then return 'DATE'
Is                    PROCEDURE(*DECIMAL[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a DECIMAL or not, if true then return 'DECIMAL'
Is                    PROCEDURE(*GROUP[] Field),ASTRING,VIRTUAL                   !Confirm if the field type is a GROUP or not, if true then return 'GROUP'
Is                    PROCEDURE(*LONG[] Field),ASTRING,VIRTUAL                    !Confirm if the field type is a LONG or not, if true then return 'LONG'
Is                    PROCEDURE(*PDECIMAL[] Field),ASTRING,VIRTUAL                !Confirm if the field type is a PDECIMAL or not, if true then return 'PDECIMAL'
Is                    PROCEDURE(*PSTRING[] Field),ASTRING,VIRTUAL                 !Confirm if the field type is a PSTRING or not, if true then return 'PSTRING'
Is                    PROCEDURE(*REAL[] Field),ASTRING,VIRTUAL                    !Confirm if the field type is a REAL or not, if true then return 'REAL'
Is                    PROCEDURE(*SHORT[] Field),ASTRING,VIRTUAL                   !Confirm if the field type is a SHORT or not, if true then return 'SHORT'
Is                    PROCEDURE(*SREAL[] Field),ASTRING,VIRTUAL                   !Confirm if the field type is a SREAL or not, if true then return 'SREAL'
Is                    PROCEDURE(*STRING[] Field),ASTRING,VIRTUAL                  !Confirm if the field type is a STRING or not, if true then return 'STRING'
Is                    PROCEDURE(*TIME[] Field),ASTRING,VIRTUAL                    !Confirm if the field type is a TIME or not, if true then return 'ASTRING'
Is                    PROCEDURE(*ULONG[] Field),ASTRING,VIRTUAL                   !Confirm if the field type is a ULONG or not, if true then return 'ULONG'
Is                    PROCEDURE(*USHORT[] Field),ASTRING,VIRTUAL                  !Confirm if the field type is a USHORT or not, if true then return 'USHORT'
                    END

jcFieldDataManager  CLASS(jcFieldClass),TYPE,MODULE('jcField.clw'),LINK('jcField.clw',_JCLinkMode_),DLL(_JCDllMode_)
!Properties
QD                    &QFieldsData
CurrentFieldID        USHORT,PRIVATE
!Methods
Construct             PROCEDURE
Destruct              PROCEDURE
AddData               PROCEDURE(QFields Q),VIRTUAL                               !Add data to Queue
Get                   PROCEDURE (ASTRING FieldName,USHORT FieldID),?,PROC, VIRTUAL    !Get the Field value according to its variable type if the Field is a BYTE it will return the BYTE value of the Field. <br/> The first parameter is the field name of the data structure <br/> The Second parameter the field id within the Data structure assigned to jcFieldGroup 
SetCurrentFieldID     PROCEDURE(USHORT FieldsID),VIRTUAL                         !Set the current field ID
GetCurrentFieldID     PROCEDURE(),USHORT,VIRTUAL                                 !Get the current field ID
DeleteData            PROCEDURE(QFields Q),VIRTUAL                               !Delete data to Queue  
UpdateData            PROCEDURE(QFields Q),VIRTUAL                               !Update data to Queue
GetHeaderColumns      PROCEDURE(),ASTRING,VIRTUAL                                !Build the header of the queue
ShowFieldDataQueue    PROCEDURE,VIRTUAL                                          !Show to DebugView the list of data
                    END 


jcFieldManager      CLASS(jcBase),TYPE,MODULE('jcField.clw'),LINK('jcField.clw',_JCLinkMode_),DLL(_JCDllMode_)
!Properties and references
Debug                 &jcDebugManager                                             !The Debug property is a reference the jcDebugManager class    
Fields                &jcFieldClass                                               !The Fields property is a reference the jcFieldClass class  
FieldsArray           &jcFieldArray                                               !The FieldsArray property is a reference the jcFieldArray class  
Stack                 &jcStackManager                                             !The Stack property is a reference to the jcStackManager class
DataLog               &jcLogManager                                               !The DataLog property is a reference to the jcLogManager class
QFldMgr               &QUEUE                                                      !The Q is reference property to the QUEUE used in the jcFieldManager   
GFldMgr               &GROUP                                                      !The G is reference property to the GROUP used in the jcFieldManager Class
index                 &LONG                                                       !The index is a property reference to a LONG found in the stackQueue of the jcStackManager classe.  
nodeVal               ANY                                                         !The nodeVal is an ANY property found in the stackQueue of the jcStackManager classe.
prevNode              &stackNode                                                  !The prevNode is a property reference to the &stackNode found in the stackQueue of the jcStackManager classe.
indexField            USHORT                                                      !The indexField holds the ordinal number of a field within a queue or group structure. <br/>Ex.<br/> If Name is the second field of a group structure  the indexField holds the value of 2.<br/> The IndexField is used as a working property within the jcFieldManager methods.    
ColumnsLength         USHORT,Dim(300)                                             !The ColumnsLength dimensional property holds the longest calculated columns set length.<br/> Ex.<br/> If a Queue structure of 4 fields, each record, holds data to a certain length,<br/> if the data never reach the size of the field then we can use this space for other columns. <br/> The methods that are responsible for this particular task are the "CalculatedColumnsSet()" and the "CalculatedColumnsRow()" methods.<br/> These will compute the largest possible size columns may have.<br/> If the header column is larger than the data length, the columns will display according to the size of the header.
ColumnsSize           USHORT                                                      !The longuest record size
ColumnIndex           BOOL,PRIVATE                                                !ColumnsIndex if set to TRUE, an extra field, used as a pointer, is added to the GROUP or QUEUE structure.
ColumnIndexLength     USHORT,PRIVATE                                              !ColumnsIndexLength establishes the length of the extra ColumnsIndex field added to the GROUP or QUEUE structure.
FieldsFormat          BYTE,PRIVATE                                                !The SetFieldsFormat equate accept a value between 1 and 4.<br/> FieldsFormat 1 = 'FieldName',<br/> FieldsFormat 2 = 'FieldName = FieldData',<br/> FieldsFormat 3 = 'NameOfTheStructure.FieldName = FieldData',<br/> FieldsFormat 4 = 'FieldData'. See equate JC_FIELD_jcFieldManager_SetFieldsFormat
FieldsFormatLimit     BYTE,PRIVATE                                                !The Number of possible Fields Format. See equate JC_FIELD_jcFieldManager_SetFieldsFormatLimit
!Protected
Construct             PROCEDURE (),PROTECTED                                      !Construct the jcFieldmanager class instance
Destruct              PROCEDURE (),PROTECTED                                      !Destroy the jcFieldmanager class instance
Init                  PROCEDURE (<*GROUP G>,<*QUEUE Q>,<*ANY AnyNodeVal>,<BOOL RespectAreaShow>),VIRTUAL                   !Init the jcFieldmanager class instance
Kill                  PROCEDURE (),VIRTUAL                                        !Kill the jcFieldmanager class instance
MethodStart           PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BOOL Show>,<SHORT SpaceMargin>),PRIVATE  !Set Method it check for margin Set the MethodName and MethodStart
MethodEnd             PROCEDURE () ,PRIVATE                                       !Show to Debug View the end of the Method
SetIndexField         PROCEDURE (BYTE IndexField),VIRTUAL                         !Set the index ordinal Field,<br/><br/> Default to the equate JC_FIELD_jcFieldManager_SetIndexField = 1, the Ordinal index field start with the first field in the Structure.<br/> the structure may be a QUEUE or GROUP.<br/> If the index field is set to 0 then the name of the GROUP structure is included.<br/> the IndexField is used in GetFields() methods
GetIndexField         PROCEDURE (),BYTE,VIRTUAL                                   !Get the index Field
SetColumnIndex        PROCEDURE (BOOL ColumnIndex),VIRTUAL                        !Do the index field from the StackQueue is shown in the first column or not if TRUE the INDEX Column. <br/> From the stackQueue is shown otherwise FALSE the INDEX Column is not shown we start from the first. <br/> Field of the structure or from the SELF.indexField defined.
GetColumnIndex        PROCEDURE (),BOOL,VIRTUAL                                   !Get the Column Index usage if true there will be an index column
SetColumnIndexLength  PROCEDURE (BYTE ColumnIndexLength),VIRTUAL                  !The length of the Index field column taken from the stackQue that will appear if SELF.ColumnIndex = TRUE                            
GetColumnIndexLength  PROCEDURE (),BYTE,VIRTUAL                                   !Get the length of the Index field column taken from the stackQue that will appear if SELF.ColumnIndex = TRUE                            
GetIndex              PROCEDURE (*QUEUE Q,*? Field),USHORT,VIRTUAL                !Get the field index from a QUEUE , ex. if the Field is the the 3rd field within the QUEUE structure, GetIndex() returns 3
GetIndex              PROCEDURE (*GROUP G,*? Field),USHORT,VIRTUAL                 !Get the field index from a GROUP, ex. if the Field is the the 3rd field within the GROUP structure, GetIndex() returns 3
GetName               PROCEDURE (*QUEUE Q,USHORT indexField),ASTRING,VIRTUAL      !Get the indexField position field name of a QUEUE, ex. if the indexField is 2 then second FieldName in UPPER case is given within the QUEUE structure, GetName() returns 'FIELDNAME' according to the indexField position
GetName               PROCEDURE (*GROUP G,USHORT indexField),ASTRING,VIRTUAL      !Get the indexField position field name of a GROUP , ex. if the indexField is 2 then second FieldName in UPPER case is given within the GROUP structure, GetName() returns 'FIELDNAME' according to the indexField position
GetData               PROCEDURE (*QUEUE Q,USHORT indexField),ASTRING,VIRTUAL      !Get the indexField position field data of a QUEUE , ex. if the indexField is 2 then second FieldData is given from the QUEUE structure, GetData() returns 'FIELDDATA' according to the indexField position
GetData               PROCEDURE (*GROUP G,USHORT indexField),ASTRING,VIRTUAL      !Get the indexField position field data of a GROUP , ex. if the indexField is 2 then second FieldData is given from the GROUP structure, GetData() returns 'FIELDDATA' according to the indexField position
GetFields             PROCEDURE (*GROUP G,<USHORT StartPosition>,<BYTE FieldsFormat>),ASTRING,VIRTUAL   !Get the fields Name of a structure GROUP, GROUP FIELDS, if the StartPosition is assigned then the GetFields will start from the assigned field sequence. <br/>  The FieldsFormat parameter accept a value between 1 and 4.<br/> FieldsFormat 1 = 'FieldName',<br/> FieldsFormat 2 = 'FieldName = FieldData',<br/> FieldsFormat 3 = 'NameOfTheStructure.FieldName = FieldData',<br/> FieldsFormat 4 = 'FieldData'
GetFields             PROCEDURE (*QUEUE Q,<USHORT StartPosition>,<BYTE FieldsFormat>),ASTRING,VIRTUAL	!Get the fields Name of a structure QUEUE, RECORD QUEUE FIELDS, if the StartPosition is assigned then the GetFields will start from the assigned field sequence. <br/>  The FieldsFormat parameter accept a value between 1 and 4.<br/> FieldsFormat 1 = 'FieldName',<br/> FieldsFormat 2 = 'FieldName = FieldData',<br/> FieldsFormat 3 = 'NameOfTheStructure.FieldName = FieldData',<br/> FieldsFormat 4 = 'FieldData'
SetFieldsFormat       PROCEDURE (<BYTE FieldsFormat>),VIRTUAL                     !Set the fields return format of a structure CLASS, QUEUE or GROUP, <br/>  The FieldsFormat parameter accept a value between 1 and 4.<br/> FieldsFormat 1 = 'FieldName',<br/> FieldsFormat 2 = 'FieldName = FieldData',<br/> FieldsFormat 3 = 'NameOfTheStructure.FieldName = FieldData',<br/> FieldsFormat 4 = 'FieldData'
GetFieldsFormat       PROCEDURE (),BYTE,VIRTUAL                                   !Get the fields format 
SetFieldsFormatLimit  PROCEDURE (<BYTE FieldsFormatLimit>),VIRTUAL                !Set the fields FormatLimit presently we have a limit of 4 set with the constant equate JC_FIELD_jcFieldManager_SetFormatFields
GetFieldsFormatLimit  PROCEDURE (),BYTE,VIRTUAL                                   !Get the fields FormatLimit
GetARecordFromQueue   PROCEDURE (LONG indexQPosition,USHORT indexField),ANY       !Get the data from the indexField position of a single record of a queue
CalculateColumnsSet   PROCEDURE (*stackQueue Q,*GROUP TargetGroup,*USHORT[] ColumnsLength)   !CalculateColumnsSet compute the length of each columns according to the data and/or the TargetGroup field length, the largest result is taken 
CalculateColumnsSet   PROCEDURE (*stackQueue Q,*GROUP TargetGroup)                !CalculateColumnsSet compute the length of each columns according to the data and/or the TargetGroup field length, the largest result is taken 
CalculateColumnsSet   PROCEDURE (*QUEUE Q,*GROUP TargetGroup)                !CalculateColumnsSet compute the length of each columns according to the data and/or the TargetGroup field length, the largest result is taken 
CalculateColumnsSet   PROCEDURE (*QUEUE Q,*USHORT[] ColumnsLength)                !Calculate Columns Sets of a define queue
CalculateColumnsSet   PROCEDURE (*QUEUE Q)                                        !Calculate Columns Sets of a define queue
CalculateColumnsRow   PROCEDURE (*QUEUE Q,*USHORT[] ColumnsLength)                !Calculate for the largest column of a queue, ColumnsLength dimensional array parameter used by address
CalculateColumnsRow   PROCEDURE (*QUEUE Q)                                        !Calculate for the largest column of a queue, the internal jcFieldManager class ColumnsLength dimensional array property is used
CalculateColumnsRow   PROCEDURE (*QUEUE Q,*GROUP G,*USHORT[] ColumnsLength)       !Calculate for the largest column of a group, ColumnsLength dimensional array parameter used by address   			
CalculateColumnsRow   PROCEDURE (*QUEUE Q,*GROUP G)        			                  !Calculate for the largest column of a queue, the internal jcFieldManager class ColumnsLength dimensional array property is used
SetColumnsSize        PROCEDURE (? Columns),VIRTUAL                               !Set the largest length for all columns
GetColumnsSize        PROCEDURE (),USHORT,VIRTUAL                                 !Get the largest length for all columns 
GetNumberOfColumns    PROCEDURE (*USHORT[] Columns),ULONG                         !Get the number columns used  
GetNumberOfColumns    PROCEDURE (),ULONG                         !Get the number columns used  
GetHeaderColumns      PROCEDURE (*QUEUE Q,*USHORT[] ColumnsLength),ASTRING,VIRTUAL !Get Header columns from a QUEUE structure According to the size of the data in the queue
GetHeaderColumns      PROCEDURE (*QUEUE Q),ASTRING,VIRTUAL                        !Get Header columns from a QUEUE structure According to the calculated columns set of the data in the queue
GetHeaderColumns      PROCEDURE (*GROUP G,*USHORT[] ColumnsLength),ASTRING,VIRTUAL !Get Header columns from a GROUP structure According to the calculcate columns set  of the data in the group
GetHeaderColumns      PROCEDURE (*GROUP G),ASTRING,VIRTUAL                        !Get Header columns from a GROUP structure According to the calculated columns set of the data in the group
ShowColumns           PROCEDURE (stackQueue Q,<*GROUP G>,*USHORT[] ColumnsLength) !Show the columns of the group from the Saved QUEUE where the group may be referenced in the Init() method or pass as a parameter. If omitted then the refernce Group is used.
ShowColumns           PROCEDURE (stackQueue Q,<*GROUP G>)                         !Show the columns of the group from the Saved QUEUE where the group may be referenced in the Init() method or pass as a parameter. If omitted then the refernce Group is used.
ShowColumns           PROCEDURE (*QUEUE Q)                                        !Show the columns of the QUEUE format to fit the entire array of data.
ShowColumns           PROCEDURE (USHORT indexField,*USHORT[] ColumnsLength)       !Show the columns of the group from the Saved QUEUE where the group is referenced in the Init() method. The external dimensional ColumnsLength dimensional array is used.
ShowColumns           PROCEDURE (USHORT indexField)                               !Show the columns of the group from the Saved QUEUE where the group is referenced in the Init() method 
ShowColumns           PROCEDURE (*USHORT[] ColumnsLength)                         !Show the columns of a QUEUE referenced in Init() method
ShowColumns           PROCEDURE ()                                                !Show the columns of a QUEUE referenced in Init() method
GetStringFormatLength PROCEDURE (USHORT StringLength),ASTRING                     !Get the length of the formatted strings if parameter(6) it returns '@s6'
EmbedShow             PROCEDURE (ASTRING EmbedShow)                               !Show the EmbedShow
ShowQueue             PROCEDURE (*QUEUE Q),VIRTUAL                                !Show the contenant of the Queue to the screen
ShowQueue             PROCEDURE (stackQueue Q,<*GROUP G>),VIRTUAL                 !Show the contenant of the Queue to the screen
ShowQueue             PROCEDURE (*QUEUE Q,*GROUP G),VIRTUAL                     !Show the contenant of the Queue to the screen
AddDataLog            PROCEDURE (*QUEUE Q),VIRTUAL                                !Add Data from the Queue to the log file
PrintLog              PROCEDURE (),VIRTUAL                                        !Print the current logFileNumberUsed log file to the printer
PrintQ                PROCEDURE (*QUEUE Q),VIRTUAL                                !Print the Queue content
                    END 

!_EndOfInclude_
