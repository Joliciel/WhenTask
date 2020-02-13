
    MEMBER
    
  INCLUDE('jcStack.inc'),ONCE
  INCLUDE('jcDebug.inc'),ONCE
  INCLUDE('jcField.inc'),ONCE
  INCLUDE('cwsynchm.inc'),ONCE      
  INCLUDE('cwsynchc.inc'),ONCE


  MAP
  END

ShowColumnsQ    QUEUE
index             ULONG
Response          ASTRING
                END

Window WINDOW('Caption'),AT(,,395,224),GRAY,FONT('MS Sans Serif',8)
    BUTTON('&OK'),AT(291,201,41,14),USE(?OkButton),DEFAULT
    BUTTON('&Cancel'),AT(333,201,42,14),USE(?CancelButton)
    LIST,AT(3,2,390,194),USE(?List),FROM(ShowColumnsQ),FORMAT('20L(2)|M~fafafafafa~')
  END  

HeaderString    STRING(500)
DetailString    STRING(1000)
  
    OMIT('!FIN!')  
Report REPORT,AT(1000,1000,6500,9000),THOUS
    HEADER,AT(240,0,8010,375),USE(?HEADER1)
      STRING(@s150),AT(198,31,7625),USE(HeaderString)
      LINE,AT(240,271,7573,10),USE(?LINE1)
    END
detail DETAIL,AT(-760,0,8000,240),USE(?DETAIL1)
      STRING(@s150),AT(219,31,7573,146),USE(DetailString)
    END
  END
 !FIN!
 
Report REPORT,AT(1000,1000,6500,9000),THOUS
detail DETAIL,AT(-760,0,13406,240),USE(?DETAIL1)
      STRING(@s180),AT(219,31,13135,146),USE(DetailString)
    END
  END

  

!-----------------------------------------------------------------------------------------------------------------------------------
! jcFieldManager CLASS
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.Construct                           PROCEDURE()
  CODE
    SELF.critSect &= NewCriticalSection()
    SELF.FieldsArray &= NEW(jcFieldArray)
    SELF.Stack &= NEW(jcStackManager)
    SELF.Debug &= NEW(jcDebugManager)
    SELF.DataLog &= NEW(jcLogManager)
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.Destruct                            PROCEDURE()
  CODE
    DISPOSE(SELF.FieldsArray)
    DISPOSE(SELF.Stack)
    DISPOSE(SELF.Debug)
    DISPOSE(SELF.DataLog)
    FREE(SELF.QFldMgr)
    DISPOSE(SELF.QFldMgr)
    SELF.critSect.Kill()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.Init                                PROCEDURE(<*GROUP G>,<*QUEUE Q>,<*ANY AnyNodeVal>,<BOOL RespectShow>)
  CODE
    SELF.Debug.Init()
    SELF.Debug.SetSelectiveShow(JC_FIELD_jcFieldManager_jcDebugManager_SetSelectiveShow)
    SELF.Debug.SetDebugState(jcFieldDebugShow:jcFieldClass)
    SELF.Debug.SetClassName(SELF.GetClassName())
    SELF.DataLog.SetClassName('DataLog')
    SELF.DataLog.SetApplicationName('jcFieldManager-Data')
    SELF.Debug.ShowCurrentMethodValue('DataLog.Get()',SELF.Debug.GetBOOL(SELF.DataLog.Get(),_Active))
  	IF NOT OMITTED(5) THEN
      SELF.Debug.SetRespectingAreaShow(JC_FIELD_jcFieldManager_jcDebugManager_RespectingAreaShow)
    END
    !SELF.DataLog.Init(jcField::Data,TRUE,JC_LOG_jcLogManager_SetLogFormat)
    !SELF.Debug.Log.SetFile(jcField::Data,JC_LOG_jcLogManager_SetLogFormat)
    !SELF.DataLog.SetFile(jcField::Data,JC_LOG_jcLogManager_SetLogFormat)
  !  SELF.MethodStart('Init','(*GROUP G,<*QUEUE Q>)',jcFieldMDebugShow:Init)
    SELF.SetAssertState(2)
    IF SELF.GetAssertState(0) THEN
?     ASSERT(SELF.Debug.GetCurrentShow()=FALSE,' The Current Show ' & SELF.Debug.CurrentShow & ' is ' & SELF.Debug.GetBOOL(SELF.Debug.GetCurrentShow(),_Showing))
    END
      IF NOT OMITTED(2) THEN 
        SELF.GFldMgr &= G
  !       SELF.Debug.See('G &= G')
      ELSE
  !       SELF.Debug.See('No GROUP is passed')
      END
  !    SELF.Debug.See('SIZE of SELF.GFldMgr is ' & SIZE(SELF.GFldMgr))
      IF (Q &= NULL AND OMITTED(3)) THEN
        SELF.QFldMgr &= SELF.Stack.Q
  !       SELF.Debug.See('SELF.QFldMgr &= SELF.Stack.Q')
      ELSE
        SELF.QFldMgr &= Q
  !       SELF.Debug.See('SELF.QFldMgr &= Q')
      END
  !     SELF.Debug.See('SIZE of SELF.QFldMgr is ' & SIZE(SELF.QFldMgr))
      IF NOT OMITTED(2) THEN
  !        SELF.Debug.See('What is the content of SELF.GFldMgr')
  !        SELF.Debug.ShowCurrentMethodValue('GetFields = ',SELF.GetFields(SELF.GFldMgr,0))
      END
      IF NOT OMITTED(3) THEN
  !       SELF.Debug.See('What is the cosntent of SELF.QFldMgr')
  !       SELF.Debug.ShowCurrentMethodValue('GetFields = ',SELF.GetFields(SELF.QFldMgr,0))
      END
      IF NOT OMITTED(4) THEN
        SELF.nodeVal &= AnyNodeVal
      END
      SELF.ColumnIndex = TRUE     !Do the index field from the StackQueue is shown in the first column or not if TRUE the INDEX Column 
                                  !from the stackQueue is shown otherwise FALSE the INDEX Column is not shown we start from the first
                                  !field of the structure or from the SELF.indexField defined.
      !SELF.ColumnIndexLength = 7  !The length of the Index field column taken from the stackQue that will appear if SELF.ColumnIndex = TRUE                            
      SELF.SetColumnIndexLength(JC_FIELD_jcFieldManager_SetColumnIndexLength)
      
      !SELF.indexField = 1         !Default indexField to the first ordinal field of the structure 
      SELF.SetIndexField(JC_FIELD_jcFieldManager_SetIndexField)
      SELF.SetFieldsFormat(JC_FIELD_jcFieldManager_SetFieldsFormat)
      SELF.SetFieldsFormatLimit(JC_FIELD_jcFieldManager_SetFieldsFormatLimit)
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.Kill                                PROCEDURE()
  CODE
    FREE(SELF.QFldMgr)
    SELF.GFldMgr &= NULL
    DISPOSE(SELF.GFldMgr)
    SELF.QFldMgr &= NULL  
    DISPOSE(SELF.QFldMgr)
    SELF.Debug.Kill()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.MethodStart                         PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BOOL Show>,<SHORT SpaceMargin>)   !Set Method it check for margin Set the MethodName and MethodStart
  CODE
    SELF.SetMethodName(MethodName,Prototype)
    SELF.Debug.Method(MethodName,Prototype,Show,SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.MethodEnd                           PROCEDURE ()                 !Show to Debug View the end of the Method
  CODE
    SELF.Debug.Fin()
    SELF.SetMethodName(SELF.Debug.GetMethodNameOnly(),SELF.Debug.GetParameterString())
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.CalculateColumnsSet  PROCEDURE(*stackQueue Q,*GROUP TargetGroup,*USHORT[] ColumnsLength) 
MethodName                            EQUATE('CalculateColumnsSet')
Prototype                             EQUATE('(*stackQueue Q,*GROUP TargetGroup,*USHORT[] ColumnsLength)')
indexQueue                            LONG  
Response                              ASTRING
  CODE
    SELF.critSect.Wait()
!    SELF.Debug.SetLine(jcDebug::Equal,150)
!    SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:CalculateColumnsSet)
      indexQueue = 0
      Response = ''
      SELF.Debug.SetLine(jcDebug::Hyphen,SELF.GetColumnsSize())
      SELF.Debug.See('Number of records within the Queue = ' & RECORDS(Q))
      LOOP indexQueue = 1 TO RECORDS(Q)
        SELF.Debug.ShowLine(jcField::Hyphen,SELF.GetColumnsSize())
        GET(Q,indexQueue)
        SELF.Debug.See('Q,indexQueue = ' & indexQueue)
        SELF.Debug.Embed('Testing TargetGroup = SourceField')
          TargetGroup = Q.nodeVal
          SELF.Debug.ShowCurrentMethodValue('TargetGroup length =',LEN(TargetGroup))
          SELF.CalculateColumnsRow(Q,TargetGroup,ColumnsLength[])
        SELF.Debug.Fin()
      END  
    SELF.MethodEnd()
    SELF.critSect.Release()
!    SELF.Debug.SetLine(jcDebug::Equal,150)
!    SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.CalculateColumnsSet  PROCEDURE(*stackQueue Q,*GROUP TargetGroup) 
MethodName                            EQUATE('CalculateColumnsSet')
Prototype                             EQUATE('(*stackQueue Q,*GROUP TargetGroup)')
indexQueue                            LONG  
Response                              ASTRING
  CODE
    SELF.critSect.Wait()
!    SELF.Debug.SetLine(jcDebug::Equal,150)
!    SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:CalculateColumnsSet2)
      indexQueue = 0
      Response = ''
      CLEAR(SELF.ColumnsLength)
      SELF.Debug.See('Number of records within the Queue = ' & RECORDS(Q))
      IF SELF.GetColumnsSize() > 0 THEN
        SELF.Debug.SetLine(jcDebug::Hyphen,SELF.GetColumnsSize())
      ELSE
        SELF.Debug.SetLine(jcDebug::Hyphen,150)
      END 
      LOOP indexQueue = 1 TO RECORDS(Q)
        !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
        SELF.Debug.ShowLine()
        GET(Q,indexQueue)
        SELF.Debug.See('Q,indexQueue = ' & indexQueue)
        SELF.Debug.Embed('Testing TargetGroup = SourceField')
          TargetGroup = Q.nodeVal
          SELF.Debug.ShowCurrentMethodValue('TargetGroup length =',LEN(TargetGroup))
          SELF.CalculateColumnsRow(Q,TargetGroup)
        SELF.Debug.Fin()
      END  
    SELF.MethodEnd()
    SELF.critSect.Release()
!    SELF.Debug.SetLine(jcDebug::Equal,150)
!    SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.CalculateColumnsSet  PROCEDURE(*QUEUE Q,*GROUP TargetGroup) 
MethodName                            EQUATE('CalculateColumnsSet')
Prototype                             EQUATE('(*QUEUE Q,*GROUP TargetGroup)')
indexQueue                            LONG  
Response                              ASTRING
  CODE
    SELF.critSect.Wait()
    !SELF.Debug.SetLine(jcDebug::Equal,150)
    !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:CalculateColumnsSet3)
      indexQueue = 0
      Response = ''
      CLEAR(SELF.ColumnsLength)
      SELF.Debug.See('Number of records within the Queue = ' & RECORDS(Q))
      IF SELF.GetColumnsSize() > 0 THEN
        SELF.Debug.SetLine(jcDebug::Hyphen,SELF.GetColumnsSize())
      ELSE
        SELF.Debug.SetLine(jcDebug::Hyphen,150)
      END 
      LOOP indexQueue = 1 TO RECORDS(Q)
        !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
        SELF.Debug.ShowLine()
        GET(Q,indexQueue)
        SELF.Debug.See('Q,indexQueue = ' & indexQueue)
        SELF.Debug.Embed('Testing TargetGroup = SourceField')
          TargetGroup = Q
          SELF.Debug.ShowCurrentMethodValue('TargetGroup length =',LEN(TargetGroup))
          SELF.CalculateColumnsRow(Q,TargetGroup)
        SELF.Debug.Fin()
      END  
    SELF.MethodEnd()
    SELF.critSect.Release()
    !SELF.Debug.SetLine(jcDebug::Equal,150)
    !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.CalculateColumnsSet  PROCEDURE(*QUEUE Q,*USHORT[] ColumnsLength)
MethodName                            EQUATE('CalculateColumnsSet')
Prototype                             EQUATE('(*QUEUE Q,*USHORT[] ColumnsLength)')
ndxQ                                  LONG  
Response                              ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:CalculateColumnsSet4)
      !Calculate the size of each column
      ndxQ = 0
      Response = ''
      SELF.Debug.See('RECORDS(Q) = ' & RECORDS(Q))
      LOOP ndxQ = 1 TO RECORDS(Q)
        GET(Q,ndxQ)
        SELF.Debug.See('Q ndxQ is ' & ndxQ)
        SELF.CalculateColumnsRow(Q,ColumnsLength[])
      END  
    SELF.MethodEnd()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.CalculateColumnsSet  PROCEDURE(*QUEUE Q)
MethodName                            EQUATE('CalculateColumnsSet')
Prototype                             EQUATE('(*QUEUE Q)')
indexQueue                            LONG  
Response                              ASTRING

  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:CalculateColumnsSet5)
      !Calculate the size of each column
      CLEAR(SELF.ColumnsLength)
      indexQueue = 0
      Response = ''
      SELF.Debug.See('RECORDS(Q) = ' & RECORDS(Q))
      LOOP indexQueue = 1 TO RECORDS(Q)
        GET(Q,indexQueue)
        SELF.Debug.ShowValue('Q.indexQueue is',indexQueue)
        SELF.CalculateColumnsRow(Q)
      END  
    SELF.MethodEnd()
    SELF.critSect.Release()

!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.CalculateColumnsRow  PROCEDURE(*QUEUE Q,*USHORT[] ColumnsLength)
MethodName                            EQUATE('CalculateColumnsRow')
Prototype                             EQUATE('(*QUEUE Q,*USHORT[] ColumnsLength)')
indexField                            USHORT
ColumnPosition                        USHORT
ndxCol                                USHORT
WhosName                              ASTRING
WhosWhat                              ASTRING
WhosLength                            USHORT
WhatLength                            USHORT

  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:CalculateColumnsRow)
      SELF.Debug.Embed('Verifying the size of the Queue Q parameter')
         SELF.Debug.See('Size of Queue Q is ' & SIZE(Q))
      SELF.Debug.Fin()
      SELF.Debug.Codes('Verifying if we add the INDEX Column from the stackQueue')
        SELF.Debug.See('Do we add the INDEX field Column from the stackQueue ? ' & SELF.Debug.GetBOOL(SELF.ColumnIndex,_Yes))
        ColumnPosition = 1
        IF SELF.ColumnIndex = TRUE THEN
          ColumnsLength[ColumnPosition] = SELF.ColumnIndexLength
          ColumnPosition += 1
        END
        SELF.Debug.See('Index column length = ' & ColumnsLength[1])
        SELF.Debug.See('Next Index Column is ' & ColumnPosition)
      SELF.Debug.Fin()
      SELF.Debug.Loops('Building the columns Length set, Computes the largest ColumnsLength for each fields')
        indexField = 1
        LOOP WHILE LEN(SELF.GetName(Q,indexField)) > 0
          SELF.Debug.Loops('WHILE LEN(SELF.GetName(Q,indexField)) > 0' & indexField)
            WhosName = SELF.GetName(Q,indexField)
            WhosWhat = SELF.GetData(Q,indexField)
            WhosLength = LEN(WhosName)
            WhatLength = LEN(WhosWhat)
            SELF.Debug.ShowCurrentMethodValue('ColumnsLength[' & ColumnPosition & ']',ColumnsLength[ColumnPosition])
            IF WhosLength >= WhatLength THEN
              IF WhosLength >= ColumnsLength[ColumnPosition] THEN
                SELF.Debug.See('When ColumnsLength[indexField] <= WhosLength')
                ColumnsLength[ColumnPosition] = WhosLength
                SELF.Debug.See('WhosLength >= ColumnsLength[' & ColumnPosition & '] :-: ' & WhosLength & ' >= ' & ColumnsLength[ColumnPosition])
                SELF.Debug.See('Therefore ColumnsLength[' & ColumnPosition & '] = WhosLength = ' & WhosLength)
              END
            ELSE
              IF WhatLength >= ColumnsLength[ColumnPosition] THEN
                SELF.Debug.See('When ColumnsLength[indexField] <= WhatLength')
                ColumnsLength[ColumnPosition] = WhatLength
                SELF.Debug.See('WhatLength >= ColumnsLength[' & ColumnPosition & '] :-: ' & WhatLength & ' >= ' & ColumnsLength[ColumnPosition])
                SELF.Debug.See('ColumnsLength[' & ColumnPosition & '] = WhatLength = ' & WhatLength)
              END
            END
            indexField += 1
            ColumnPosition += 1
          SELF.Debug.Fin()
        END
      SELF.Debug.Fin()
    SELF.MethodEnd()
    SELF.critSect.Release()
    
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.CalculateColumnsRow  PROCEDURE(*QUEUE Q)
MethodName                            EQUATE('CalculateColumnsRow')
Prototype                             EQUATE('(*QUEUE Q)')
indexField                            USHORT
ColumnPosition                        USHORT
ndxCol                                USHORT
WhosName                              ASTRING
WhosWhat                              ASTRING
WhosLength                            USHORT
WhatLength                            USHORT
DebugShowMargin                       BYTE(2)

  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:CalculateColumnsRow2)
      SELF.Debug.Codes('Verifying if we add the Column field INDEX from the stackQueue')
        SELF.Debug.See('Do we add the INDEX field Column from the stackQueue ? ' & SELF.Debug.GetBOOL(SELF.ColumnIndex,_Yes))
        ColumnPosition = 1
        IF SELF.ColumnIndex = TRUE THEN
          SELF.ColumnsLength[ColumnPosition] = SELF.ColumnIndexLength
          ColumnPosition += 1
        END
        SELF.Debug.See('Column Position 1 length is ' & SELF.ColumnsLength[1])
        SELF.Debug.See('Next Column position is ' & ColumnPosition)
      SELF.Debug.Fin()
      indexField = 1
      SELF.Debug.Codes('Verifying the data of each field of the Group')
        SELF.Debug.IFs('IF SELF.GetColumnsSize() > 0 THEN')
          IF SELF.GetColumnsSize() > 0 THEN
            SELF.Debug.SetLine(jcDebug::Hyphen,SELF.GetColumnsSize())
          ELSE
            SELF.Debug.SetLine(jcDebug::Hyphen,150)
          END
        SELF.Debug.Fin()
        SELF.Debug.Loops('LOOP WHILE LEN(SELF.GetName(Q,indexField)) > 0',_Show,DebugShowMargin)
          dg# = 0
          LOOP WHILE LEN(SELF.GetName(Q,indexField)) > 0
            dg# += 1
            SELF.Debug.ShowLine()
            SELF.Debug.Loops('LOOP :' & dg#,_Show,DebugShowMargin+2)
              !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
              WhosName = SELF.GetName(Q,indexField)
              WhosWhat = WHAT(Q,indexField) !SELF.GetData(Q,indexField)
              SELF.Debug.See('indexField is ' & indexField)
              SELF.Debug.Embed('Whos Who What and validate their column')
                SELF.Debug.See('Whos ' & WhosName & ' = ' & WhosWhat)
                WhosLength = LEN(WhosName)
                WhatLength = LEN(WhosWhat)
                SELF.Debug.See('WhosLength is ' & WhosLength)
                SELF.Debug.See('WhatLength is ' & WhatLength)
                SELF.Debug.ShowCurrentMethodValue('SELF.ColumnsLength[' & ColumnPosition & ']',SELF.ColumnsLength[ColumnPosition])
                IF WhosLength >= WhatLength THEN
                  SELF.Debug.Embed('Validate length when WhosLength >= WhatLength')
                    SELF.Debug.IFs('WhosLength >= WhatLength ' & WhosLength & ' >= ' & WhatLength)
                      IF WhosLength >= SELF.ColumnsLength[ColumnPosition] THEN
                        SELF.Debug.IFOnTrue()
                          SELF.Debug.Embed('When WhosLength is larger or equal the Column index')
                            SELF.Debug.See('WhosLength >= SELF.ColumnsLength[' & ColumnPosition & '] :-: ' & WhosLength & ' >= ' & SELF.ColumnsLength[ColumnPosition])
                            SELF.Debug.See('Therefore SELF.ColumnsLength[' & ColumnPosition & '] = WhosLength = ' & WhosLength)
                            SELF.ColumnsLength[ColumnPosition] = WhosLength
                          SELF.Debug.Fin()
                        SELF.Debug.Fin()
                      ELSE
                        SELF.Debug.IFOnFalse()
                          SELF.Debug.Embed('When the Column property dimensional array is larger then WhosLength')
                            SELF.Debug.See('Keep the current SELF.Column[' & ColumnPosition & '] = ' & SELF.ColumnsLength[ColumnPosition])
                          SELF.Debug.Fin()
                        SELF.Debug.Fin()
                      END
                    SELF.Debug.Fin()
                  SELF.Debug.Fin()
                ELSE
                  SELF.Debug.See('Validate length when WhosLength <= WhatLength')
                  SELF.Debug.IFs('WhatLength >= SELF.ColumnsLength[ColumnPosition]THEN')
                    IF WhatLength >= SELF.ColumnsLength[ColumnPosition]THEN
                      SELF.Debug.IFOnTrue()
                        SELF.Debug.Embed('When What Length is larger or equal the column index')
                          SELF.Debug.See('WhatLength >= SELF.ColumnsLength[' & ColumnPosition & '] :-: ' & WhatLength & ' >= ' & SELF.ColumnsLength[ColumnPosition])
                          SELF.Debug.See('Therefore SELF.ColumnsLength[' & ColumnPosition & '] = WhatLength = ' & WhatLength)
                          SELF.ColumnsLength[ColumnPosition] = WhatLength
                        SELF.Debug.Fin()
                      SELF.Debug.Fin()
                    ELSE
                      SELF.Debug.IFOnFalse()
                        SELF.Debug.Embed('When the Column property dimensional array is larger then WhatLength')
                          SELF.Debug.See('Keep the current SELF.ColumnsLength[' & ColumnPosition & '] = ' & SELF.ColumnsLength[ColumnPosition])
                        SELF.Debug.Fin()
                      SELF.Debug.Fin()
                    END
                  SELF.Debug.Fin()
                END
                indexField += 1
                ColumnPosition += 1
              SELF.Debug.Fin()
            SELF.Debug.Fin()
          END
        SELF.Debug.Fin()
      SELF.Debug.Fin()
      !SELF.Debug.SetLine(jcDebug::Hyphen,150)
      !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
    SELF.MethodEnd()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.CalculateColumnsRow  PROCEDURE(*QUEUE Q,*GROUP G,*USHORT[] ColumnsLength)
MethodName                            EQUATE('CalculateColumnsRow')
Prototype                             EQUATE('(*QUEUE Q,*GROUP G,*USHORT[] ColumnsLength)')
indexField                            USHORT
ColumnPosition                        USHORT
ndxCol                                USHORT
WhosName                              ASTRING
WhosWhat                              ASTRING
WhosLength                            USHORT
WhatLength                            USHORT
  CODE
    SELF.critSect.Wait()
    !SELF.Debug.SetLine(jcDebug::Equal,150)
    !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:CalculateColumnsRow3)
      !SELF.CheckColumnPosition(ColumnsLength[],ndxCol)
      SELF.Debug.Embed('Verifying the size of the Group G parameter')
         SELF.Debug.See('Size of Group G is ' & SIZE(G))
      SELF.Debug.Fin()
      SELF.Debug.Codes('Verifying if we add the Column field INDEX from the stackQueue')
        SELF.Debug.See('Do we add the INDEX field Column from the stackQueue ? ' & SELF.Debug.GetBOOL(SELF.ColumnIndex,_Yes))
        ColumnPosition = 1
        IF SELF.ColumnIndex = TRUE THEN
          ColumnsLength[ColumnPosition] = SELF.ColumnIndexLength
          ColumnPosition += 1
        END
        SELF.Debug.See('Column Position 1 length is ' & ColumnsLength[1])
        SELF.Debug.See('Next Column position is ' & ColumnPosition)
      SELF.Debug.Fin()
      IF G = SELF.GetData(Q,2) THEN
        SELF.Debug.See('The Group Data is equal to the Queue data at position 2 = ' & SELF.GetName(Q,2))
      ELSE
        SELF.Debug.See('The Group Data is NOT equal to the Queue data at position 2 = ' & SELF.GetName(Q,2))
      END  
      indexField = 1
      SELF.Debug.Embed('Verifying the data of each field of the Group')
        SELF.Debug.Codes('LOOP LEN(SELF.GetName(G,indexField)) > 0')
          IF SELF.GetColumnsSize() > 0 THEN
            SELF.Debug.SetLine(jcDebug::Hyphen,SELF.GetColumnsSize())
          ELSE
            SELF.Debug.SetLine(jcDebug::Hyphen,150)
          END
          LOOP WHILE LEN(SELF.GetName(G,indexField)) > 0
            !SELF.Debug.ShowLine(jcField::Hyphen,LEN(G))
            SELF.Debug.ShowLine()
            WhosName = SELF.GetName(G,indexField)
            WhosWhat = SELF.GetData(G,indexField)
            SELF.Debug.See('indexField is ' & indexField)
            SELF.Debug.Embed('Whos Who What and validate their column')
              SELF.Debug.See('Whos ' & WhosName & ' = ' & WhosWhat)
              WhosLength = LEN(WhosName)
              WhatLength = LEN(WhosWhat)
              SELF.Debug.See('WhosLength is ' & WhosLength)
              SELF.Debug.See('WhatLength is ' & WhatLength)
              SELF.Debug.ShowCurrentMethodValue('ColumnsLength[' & ColumnPosition & ']',ColumnsLength[ColumnPosition])
              IF WhosLength >= WhatLength THEN
                SELF.Debug.Embed('Validate length when WhosLength >= WhatLength')
                  SELF.Debug.See('WhosLength >= WhatLength ' & WhosLength & ' >= ' & WhatLength)
                  IF WhosLength >= ColumnsLength[ColumnPosition] THEN
                    SELF.Debug.Embed('When WhosLength is larger or equal the Column index')
                      SELF.Debug.See('WhosLength >= ColumnsLength[' & ColumnPosition & '] :-: ' & WhosLength & ' >= ' & ColumnsLength[ColumnPosition])
                      SELF.Debug.See('Therefore ColumnsLength[' & ColumnPosition & '] = WhosLength = ' & WhosLength)
                      ColumnsLength[ColumnPosition] = WhosLength
                    SELF.Debug.Fin()
                  ELSE
                    SELF.Debug.Embed('When the Column property dimensional array is larger then WhosLength')
                      SELF.Debug.See('Keep the current SELF.Column[' & ColumnPosition & '] = ' & ColumnsLength[ColumnPosition])
                    SELF.Debug.Fin()
                  END
                SELF.Debug.Fin()
              ELSE
                SELF.Debug.Embed('Validate length when WhosLength <= WhatLength')
                  IF WhatLength >= ColumnsLength[ColumnPosition]THEN
                    SELF.Debug.Embed('When What Length is larger or equal the column index')
                      SELF.Debug.See('WhatLength >= ColumnsLength[' & ColumnPosition & '] :-: ' & WhatLength & ' >= ' & ColumnsLength[ColumnPosition])
                      SELF.Debug.See('Therefore ColumnsLength[' & ColumnPosition & '] = WhatLength = ' & WhatLength)
                      ColumnsLength[ColumnPosition] = WhatLength
                    SELF.Debug.Fin()
                  ELSE
                    SELF.Debug.Embed('When the Column property dimensional array is larger then WhatLength')
                      SELF.Debug.See('Keep the current ColumnsLength[' & ColumnPosition & '] = ' & ColumnsLength[ColumnPosition])
                    SELF.Debug.Fin()
                  END
                SELF.Debug.Fin()
              END
              indexField += 1
              ColumnPosition += 1
            SELF.Debug.Fin()
          END
        SELF.Debug.Fin()
      SELF.Debug.Fin()
      !SELF.Debug.SetLine(jcDebug::Hyphen,150)
      !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
    SELF.MethodEnd()
    SELF.critSect.Release()
EmbedShowVerifyG                                                        ROUTINE
  SELF.Debug.Embed('Verifying the size of the Group G parameter')
     SELF.Debug.See('Size of Group G is ' & SIZE(G))
  SELF.Debug.Fin()
SeeShowVerifyGAndQ                                                      ROUTINE
  IF G = SELF.GetData(Q,2) THEN
    SELF.Debug.See('The Group Data is equal to the Queue data at position 2 = ' & SELF.GetName(Q,2))
  ELSE
    SELF.Debug.See('The Group Data is NOT equal to the Queue data at position 2 = ' & SELF.GetName(Q,2))
  END  
EmbedShowWhenWhosLengthisLargerOrEqualTheColumnIndex                    ROUTINE
  SELF.Debug.Embed('When WhosLength is larger or equal the Column index')
    SELF.Debug.See('WhosLength >= ColumnsLength[' & ColumnPosition & '] :-: ' & WhosLength & ' >= ' & ColumnsLength[ColumnPosition])
    SELF.Debug.See('Therefore ColumnsLength[' & ColumnPosition & '] = WhosLength = ' & WhosLength)
  SELF.Debug.Fin()
EmbedShowWhenTheColumnPropertyDimensionalArrayIsLargerThenWhosLength    ROUTINE
  SELF.Debug.Embed('When the Column property dimensional array is larger then WhosLength')
    SELF.Debug.See('Keep the current SELF.Column[' & ColumnPosition & '] = ' & ColumnsLength[ColumnPosition])
  SELF.Debug.Fin()
EmbedShowWhenWhatLengthIsLargerOrEqualTheColumnIndex                    ROUTINE                  
  SELF.Debug.Embed('When What Length is larger or equal the column index')
    SELF.Debug.See('WhatLength >= ColumnsLength[' & ColumnPosition & '] :-: ' & WhatLength & ' >= ' & ColumnsLength[ColumnPosition])
    SELF.Debug.See('Therefore ColumnsLength[' & ColumnPosition & '] = WhatLength = ' & WhatLength)
  SELF.Debug.Fin()
EmbedShowWhenTheColumnPropertyDimensionalArrayIsLargerThenWhatLength    ROUTINE  
  SELF.Debug.Embed('When the Column property dimensional array is larger then WhatLength')
    SELF.Debug.See('Keep the current ColumnsLength[' & ColumnPosition & '] = ' & ColumnsLength[ColumnPosition])
  SELF.Debug.Fin()
EmbedShowWhatchWhosWhatAndColumnsLength                                 ROUTINE
  SELF.Debug.See('WhosLength is ' & WhosLength)
  SELF.Debug.See('WhatLength is ' & WhatLength)
  SELF.Debug.ShowCurrentMethodValue('ColumnsLength[' & ColumnPosition & ']',ColumnsLength[ColumnPosition])
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.CalculateColumnsRow  PROCEDURE(*QUEUE Q,*GROUP G)
MethodName                            EQUATE('CalculateColumnsRow')
Prototype                             EQUATE('(*QUEUE Q,*GROUP G)')
indexField                            USHORT
ColumnPosition                        USHORT
ndxCol                                USHORT
WhosName                              ASTRING
WhosWhat                              ASTRING
WhosLength                            USHORT
WhatLength                            USHORT
  CODE
    SELF.critSect.Wait()
    !SELF.Debug.SetLine(jcDebug::Equal,150)
    !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:CalculateColumnsRow4)
      !SELF.CheckColumnPosition(SELF.ColumnsLength[],ndxCol)
      SELF.Debug.Embed('Verifying the size of the Group G parameter')
         SELF.Debug.See('Size of Group G is ' & SIZE(G))
      SELF.Debug.Fin()
      SELF.Debug.Codes('Verifying if we add the Column field INDEX from the stackQueue')
        SELF.Debug.See('Do we add the INDEX field Column from the stackQueue ? ' & SELF.Debug.GetBOOL(SELF.ColumnIndex,_Yes))
        ColumnPosition = 1
        IF SELF.ColumnIndex = TRUE THEN
          SELF.ColumnsLength[ColumnPosition] = SELF.ColumnIndexLength
          ColumnPosition += 1
        END
        SELF.Debug.See('Column Position 1 length is ' & SELF.ColumnsLength[1])
        SELF.Debug.See('Next Column position is ' & ColumnPosition)
      SELF.Debug.Fin()
      IF G = SELF.GetData(Q,2) THEN
        SELF.Debug.See('The Group Data is equal to the Queue data at position 2 = ' & SELF.GetName(Q,2))
      ELSE
        SELF.Debug.See('The Group Data is NOT equal to the Queue data at position 2 = ' & SELF.GetName(Q,2))
      END  
      indexField = 1
      SELF.Debug.Embed('Verifying the data of each field of the Group')
        SELF.Debug.Codes('LOOP LEN(SELF.GetName(G,indexField)) > 0')
          IF SELF.GetColumnsSize() > 0 THEN
            SELF.Debug.SetLine(jcDebug::Hyphen,SELF.GetColumnsSize())
          ELSE
            SELF.Debug.SetLine(jcDebug::Hyphen,150)
          END
          LOOP WHILE LEN(SELF.GetName(G,indexField)) > 0
            !SELF.Debug.ShowLine(jcField::Hyphen,LEN(G))
            SELF.Debug.ShowLine()
            WhosName = SELF.GetName(G,indexField)
            WhosWhat = SELF.GetData(G,indexField)
            SELF.Debug.See('indexField is ' & indexField)
            SELF.Debug.Embed('Whos Who What and validate their column')
              SELF.Debug.See('Whos ' & WhosName & ' = ' & WhosWhat)
              WhosLength = LEN(WhosName)
              WhatLength = LEN(WhosWhat)
              SELF.Debug.See('WhosLength is ' & WhosLength)
              SELF.Debug.See('WhatLength is ' & WhatLength)
              SELF.Debug.ShowCurrentMethodValue('SELF.ColumnsLength[' & ColumnPosition & ']',SELF.ColumnsLength[ColumnPosition])
              IF WhosLength >= WhatLength THEN
                SELF.Debug.Embed('Validate length when WhosLength >= WhatLength')
                  SELF.Debug.See('WhosLength >= WhatLength ' & WhosLength & ' >= ' & WhatLength)
                  IF WhosLength >= SELF.ColumnsLength[ColumnPosition] THEN
                    SELF.Debug.Embed('When WhosLength is larger or equal the Column index')
                      SELF.Debug.See('WhosLength >= SELF.ColumnsLength[' & ColumnPosition & '] :-: ' & WhosLength & ' >= ' & SELF.ColumnsLength[ColumnPosition])
                      SELF.Debug.See('Therefore SELF.ColumnsLength[' & ColumnPosition & '] = WhosLength = ' & WhosLength)
                      SELF.ColumnsLength[ColumnPosition] = WhosLength
                    SELF.Debug.Fin()
                  ELSE
                    SELF.Debug.Embed('When the Column property dimensional array is larger then WhosLength')
                      SELF.Debug.See('Keep the current SELF.Column[' & ColumnPosition & '] = ' & SELF.ColumnsLength[ColumnPosition])
                    SELF.Debug.Fin()
                  END
                SELF.Debug.Fin()
              ELSE
                SELF.Debug.Embed('Validate length when WhosLength <= WhatLength')
                  IF WhatLength >= SELF.ColumnsLength[ColumnPosition]THEN
                    SELF.Debug.Embed('When What Length is larger or equal the column index')
                      SELF.Debug.See('WhatLength >= SELF.ColumnsLength[' & ColumnPosition & '] :-: ' & WhatLength & ' >= ' & SELF.ColumnsLength[ColumnPosition])
                      SELF.Debug.See('Therefore SELF.ColumnsLength[' & ColumnPosition & '] = WhatLength = ' & WhatLength)
                      SELF.ColumnsLength[ColumnPosition] = WhatLength
                    SELF.Debug.Fin()
                  ELSE
                    SELF.Debug.Embed('When the Column property dimensional array is larger then WhatLength')
                      SELF.Debug.See('Keep the current SELF.ColumnsLength[' & ColumnPosition & '] = ' & SELF.ColumnsLength[ColumnPosition])
                    SELF.Debug.Fin()
                  END
                SELF.Debug.Fin()
              END
              indexField += 1
              ColumnPosition += 1
            SELF.Debug.Fin()
          END
        SELF.Debug.Fin()
      SELF.Debug.Fin()
      !SELF.Debug.SetLine(jcDebug::Hyphen,150)
      !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
    SELF.MethodEnd()
    SELF.critSect.Release()
EmbedShowVerifyG                                                        ROUTINE
  SELF.Debug.Embed('Verifying the size of the Group G parameter')
     SELF.Debug.See('Size of Group G is ' & SIZE(G))
  SELF.Debug.Fin()
SeeShowVerifyGAndQ                                                      ROUTINE
  IF G = SELF.GetData(Q,2) THEN
    SELF.Debug.See('The Group Data is equal to the Queue data at position 2 = ' & SELF.GetName(Q,2))
  ELSE
    SELF.Debug.See('The Group Data is NOT equal to the Queue data at position 2 = ' & SELF.GetName(Q,2))
  END  
EmbedShowWhenWhosLengthisLargerOrEqualTheColumnIndex                    ROUTINE
  SELF.Debug.Embed('When WhosLength is larger or equal the Column index')
    SELF.Debug.See('WhosLength >= SELF.ColumnsLength[' & ColumnPosition & '] :-: ' & WhosLength & ' >= ' & SELF.ColumnsLength[ColumnPosition])
    SELF.Debug.See('Therefore SELF.ColumnsLength[' & ColumnPosition & '] = WhosLength = ' & WhosLength)
  SELF.Debug.Fin()
EmbedShowWhenTheColumnPropertyDimensionalArrayIsLargerThenWhosLength    ROUTINE
  SELF.Debug.Embed('When the Column property dimensional array is larger then WhosLength')
    SELF.Debug.See('Keep the current SELF.Column[' & ColumnPosition & '] = ' & SELF.ColumnsLength[ColumnPosition])
  SELF.Debug.Fin()
EmbedShowWhenWhatLengthIsLargerOrEqualTheColumnIndex                    ROUTINE                  
  SELF.Debug.Embed('When What Length is larger or equal the column index')
    SELF.Debug.See('WhatLength >= SELF.ColumnsLength[' & ColumnPosition & '] :-: ' & WhatLength & ' >= ' & SELF.ColumnsLength[ColumnPosition])
    SELF.Debug.See('Therefore SELF.ColumnsLength[' & ColumnPosition & '] = WhatLength = ' & WhatLength)
  SELF.Debug.Fin()
EmbedShowWhenTheColumnPropertyDimensionalArrayIsLargerThenWhatLength    ROUTINE  
  SELF.Debug.Embed('When the Column property dimensional array is larger then WhatLength')
    SELF.Debug.See('Keep the current SELF.ColumnsLength[' & ColumnPosition & '] = ' & SELF.ColumnsLength[ColumnPosition])
  SELF.Debug.Fin()
EmbedShowWhatchWhosWhatAndColumnsLength                                 ROUTINE
  SELF.Debug.See('WhosLength is ' & WhosLength)
  SELF.Debug.See('WhatLength is ' & WhatLength)
  SELF.Debug.ShowCurrentMethodValue('SELF.ColumnsLength[' & ColumnPosition & ']',SELF.ColumnsLength[ColumnPosition])
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetNumberOfColumns   PROCEDURE(*USHORT[] Columns)
MethodName                            EQUATE('GetNumberOfColumns')
Prototype                             EQUATE('(*USHORT[] Columns)')
ColumnPosition                        USHORT
Count                                 ULONG
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetNumberOfColumns)
      SELF.Debug.Codes('Verifying the Column field INDEX from the stackQueue status')
        SELF.Debug.See('Do we add the Column field INDEX from the stackQueue ? ' & SELF.Debug.GetBOOL(SELF.ColumnIndex,_Yes))
        SELF.Debug.See('Length of the Column field INDEX is ' & SELF.ColumnIndexLength)
        ColumnPosition = 1
      SELF.Debug.Fin()
      SELF.Debug.See('The following columns length are')
      Count = 0
      LOOP WHILE Columns[ColumnPosition] <> 0 
        Count += 1
        SELF.Debug.ShowCurrentMethodValue('Column['& ColumnPosition & '] = ', Columns[ColumnPosition] & ' character(s)')
        ColumnPosition += 1
      END 
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Count
!-----------------------------------------------------------------------------------------------------------------------------------  
jcFieldManager.GetNumberOfColumns   PROCEDURE()
MethodName                            EQUATE('GetNumberOfColumns')
Prototype                             EQUATE('()')
ColumnPosition                        USHORT
Count                                 ULONG
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetNumberOfColumns2)
      SELF.Debug.Codes('Verifying the Column field INDEX from the stackQueue status')
        SELF.Debug.See('Do we add the Column field INDEX from the stackQueue ? ' & SELF.Debug.GetBOOL(SELF.ColumnIndex,_Yes))
        SELF.Debug.See('Length of the Column field INDEX is ' & SELF.ColumnIndexLength)
        ColumnPosition = 1
      SELF.Debug.Fin()
      SELF.Debug.See('The following columns length are')
      Count = 0
      LOOP WHILE SELF.ColumnsLength[ColumnPosition] <> 0 
        Count += 1
        SELF.Debug.ShowCurrentMethodValue('Column['& ColumnPosition & '] = ', SELF.ColumnsLength[ColumnPosition] & ' character(s)')
        ColumnPosition += 1
      END 
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Count
!-----------------------------------------------------------------------------------------------------------------------------------  
jcFieldManager.GetIndex PROCEDURE(*QUEUE Q,*? Field)      !Get the field index from a QUEUE , ex. if the Field is the the 3rd field within the QUEU structure, GetIndex() returns 3
MethodName                EQUATE('GetIndex')
Prototype                 EQUATE('(*QUEUE Q,*? Field)')
Response                  USHORT
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetIndex)
      SELF.Debug.Note('GetIndex on QUEUE details')
        SELF.Debug.See('Note the GetIndex() statement on index works only on Queue that has a GROUP structure')
        SELF.Debug.See('If you need to get the index of all fields within the QUEUE you need to make a GROUP structure')
        SELF.Debug.See('under the queue where the fields are within the GROUP itself. Otherwise all fields that are')
        SELF.Debug.See('outside the GROUP will not be recognized, it will return a value of 0. You may have has many groups')
        SELF.Debug.See('as you want. Note that the ANY field type is not also recognized by GetIndex() method.')
        SELF.Debug.See('This is due to the limitation of the WHERE Statement in CLARION.')
      SELF.Debug.Fin()
      Response = WHERE(Q,Field)
      SELF.Debug.ShowCurrentMethodValue('GetIndex(Q,' & Field & ')')
      SELF.Debug.ShowCurrentMethodValue('GetName(Q,' & Response & ') = ',SELF.GetName(Q,Response))
      SELF.Debug.ShowCurrentMethodValue('GetIndex() response is ',Response)
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetIndex PROCEDURE(*GROUP G,*? Field)      !Get the field index from a GROUP , ex. if the Field is the the 3rd field within the GROUP structure, GetIndex() returns 3
MethodName                EQUATE('GetIndex')
Prototype                 EQUATE('(*GROUP G,*? Field)')
Response                  USHORT
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetIndex)
      Response = WHERE(G,Field)
      SELF.Debug.ShowCurrentMethodValue('GetIndex(G,' & Field & ')')
      SELF.Debug.ShowCurrentMethodValue('GetName(G,' & Response & ') = ',SELF.GetName(G,Response))
      SELF.Debug.ShowCurrentMethodValue('GetIndex() response is ',Response)
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetName  PROCEDURE (*QUEUE Q,USHORT indexField)             !Get the indexField position field name of a QUEUE 
MethodName                EQUATE('GetName')
Prototype                 EQUATE('(*QUEUE Q,USHORT indexField)')
Response                  ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetName)
      Response = WHO(Q,indexField)
      SELF.Debug.ShowCurrentMethodValue('GetName(Q,' & indexField & ') = ',Response)
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetName  PROCEDURE(*GROUP G,USHORT indexField)             !Get the indexField position field name of a GROUP 
MethodName                EQUATE('GetName')
Prototype                 EQUATE('(*GROUP G,USHORT indexField)')
Response                  ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetName2)
      Response = WHO(G,indexField)
      SELF.Debug.ShowCurrentMethodValue('GetName(G,' & indexField & ') = ',Response)
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetData  PROCEDURE(*QUEUE Q,USHORT indexField)             !Get the indexField position field data of a GROUP or QUEUE (Type=1 is a group, Type=2 is a queue), ex. if the indexField is 2 then second FieldData is given from the GROUP structure of Type=1, GetData() returns 'FIELDDATA' according to the indexField position
MethodName                EQUATE('GetData')
Prototype                 EQUATE('(*QUEUE Q,USHORT indexField)')
Response                  ANY !ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetData)
      Response &= WHAT(Q,indexField)
      SELF.Debug.ShowCurrentMethodValue('GetData(Q,' & indexField & ') = ',Response)
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response 
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetData  PROCEDURE(*GROUP G,USHORT indexField)             !Get the indexField position field data of a GROUP or QUEUE (Type=1 is a group, Type=2 is a queue), ex. if the indexField is 2 then second FieldData is given from the GROUP structure of Type=1, GetData() returns 'FIELDDATA' according to the indexField position
MethodName                EQUATE('GetData')
Prototype                 EQUATE('(*GROUP G,USHORT indexField)')
Response                  ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetData2)
      Response = WHAT(G,indexField)
      SELF.Debug.ShowCurrentMethodValue('GetData(SELF.GFldMgr,' & indexField & ') = ',Response)
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response 
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.SetColumnsSize   PROCEDURE(? Columns)
MethodName                        EQUATE('SetColumnsSize')
Prototype                         EQUATE('(? Columns)')
ExtraLength                       EQUATE(20)
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:SetColumnsSize)
      IF SELF.GetColumnIndex() THEN
        SELF.ColumnsSize = Columns + SELF.GetColumnIndexLength() + ExtraLength
      ELSE
        SELF.ColumnsSize = Columns + ExtraLength
      END
    SELF.MethodEnd()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetColumnsSize   PROCEDURE()
MethodName                        EQUATE('GetColumnsSize')
Prototype                         EQUATE('()')
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetColumnsSize)
      SELF.Debug.ShowCurrentMethodValue('ColumnsSize',SELF.ColumnsSize)  
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN SELF.ColumnsSize
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetHeaderColumns PROCEDURE(*QUEUE Q,*USHORT[] ColumnsLength)
MethodName                        EQUATE('GetHeaderColumns')
Prototype                         EQUATE('(*QUEUE Q,*USHORT[] ColumnsLength)')
WhosName                          ASTRING
getString                         ANY
assignString                      STRING(500)
indexField                        ULONG
ColumnPosition                    ULONG
Response                          ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetHeaderColumns)
      GET(Q,1)
      SELF.Debug.Codes('Verifying if we add the Column INDEX from the stackQueue')
        SELF.Debug.See('Do we Add the Column field INDEX from the stackQue ?' & SELF.Debug.GetBOOL(SELF.ColumnIndex,_Yes))
        ColumnPosition = 1
        IF SELF.ColumnIndex = TRUE THEN  !IF We want the INDEX Column from the stack queue then we add the first column with a length of SELF.ColumnIndexLength char
          assignString = jcStack::Index
          getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(ColumnsLength[ColumnPosition]+1))
        END
        SELF.Debug.See('Column position length = ' & ColumnsLength[ColumnPosition])
        SELF.Debug.See('Column position = ' & ColumnPosition)
      SELF.Debug.Fin()    
      indexField = 1
      ColumnPosition += 1
      LOOP WHILE LEN(SELF.GetName(Q,indexField)) > 0
        WhosName = SELF.GetName(Q,indexField)
        assignString = WhosName
        SELF.Debug.See('Column ' & indexField & ' = ' & assignString)
        getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(ColumnsLength[ColumnPosition]+1))
        indexField += 1
        ColumnPosition += 1
      END
      Response = getString 
      SELF.Debug.See('Header is [' & Response & ' ]')
    SELF.MethodEnd()
    IF SELF.GetColumnsSize() > 0 THEN
      SELF.Debug.SetLine(jcDebug::Hyphen,SELF.GetColumnsSize())
    ELSE
      SELF.Debug.SetLine(jcDebug::Hyphen,130)
    END
    !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
    SELF.Debug.ShowLine()
    SELF.critSect.Release()
    RETURN Response

!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetHeaderColumns PROCEDURE(*QUEUE Q)
MethodName                        EQUATE('GetHeaderColumns')
Prototype                         EQUATE('(*QUEUE Q)')
WhosName                          ASTRING
getString                         ANY
assignString                      STRING(500)
indexField                        ULONG
ColumnPosition                    ULONG
Response                          ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetHeaderColumns2)
      GET(Q,1)
      SELF.Debug.Codes('Verifying if we add the Column INDEX from the stackQueue')
        SELF.Debug.See('Do we Add the Column field INDEX from the stackQue ?' & SELF.Debug.GetBOOL(SELF.ColumnIndex,_Yes))
        IF SELF.ColumnIndex = TRUE THEN  !IF We want the INDEX Column from the stack queue then we add the first column with a length of SELF.ColumnIndexLength char
          ColumnPosition = 1
          assignString = jcStack::Index
          getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(SELF.ColumnsLength[ColumnPosition]+1))
        ELSE
          ColumnPosition = 0
        END
        SELF.Debug.See('Column position length = ' & SELF.ColumnsLength[ColumnPosition])
        SELF.Debug.See('Column position = ' & ColumnPosition)
      SELF.Debug.Fin()    
      indexField = 1
      ColumnPosition += 1
      LOOP WHILE LEN(SELF.GetName(Q,indexField)) > 0
        WhosName = SELF.GetName(Q,indexField)
        assignString = WhosName
        SELF.Debug.See('Column ' & indexField & ' = ' & assignString)
        getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(SELF.ColumnsLength[ColumnPosition]+1))
        indexField += 1
        ColumnPosition += 1
      END
      Response = getString 
      SELF.Debug.See('Header is [' & Response & ' ]')
      IF SELF.GetColumnsSize() > 0 THEN
        SELF.Debug.SetLine(jcDebug::Hyphen,SELF.GetColumnsSize())
      ELSE
        SELF.Debug.SetLine(jcDebug::Hyphen,130)
      END
      !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
      SELF.Debug.ShowLine()
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
  !-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetHeaderColumns PROCEDURE(*GROUP G,*USHORT[] ColumnsLength)
MethodName                        EQUATE('GetHeaderColumns')
Prototype                         EQUATE('(*GROUP G,*USHORT[] ColumnsLength)')
WhosName                          ASTRING
indexField                        ULONG
ColumnPosition                    ULONG
assignString                      STRING(500)
getString                         ANY
Response                          ASTRING
  CODE
    SELF.Debug.SetSelectiveShow(jcDebug::MethodShow,'jcFieldClass.GetHeaderColumns(*GROUP G,*USHORT[] ColumnsLength)')
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetHeaderColumns3)
      !Show the header SHOW
      SELF.Debug.Codes('Verifying if we add the INDEX Column from the stackQueue')
        SELF.Debug.See('Do we add the field INDEX column from the stackQueue ? ' & SELF.Debug.GetBOOL(SELF.ColumnIndex,_Yes))
        ColumnPosition = 1
        IF SELF.ColumnIndex = TRUE THEN  !IF We want the INDEX Column from the stack queue then we add the first column with a length of SELF.ColumnIndexLength char
          assignString = jcStack::Index
          getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(ColumnsLength[ColumnPosition]+1))
          SELF.Debug.See('Index column length = ' & ColumnsLength[ColumnPosition])
          ColumnPosition += 1
        END
        SELF.Debug.See('Column position length = ' & ColumnsLength[ColumnPosition])
        SELF.Debug.See('Column position = ' & ColumnPosition)
      SELF.Debug.Fin()  
      SELF.Debug.See('Column ' & indexField+1 & ' = ' & assignString)
      !DO FieldSequence          
      indexField = 1
      LOOP WHILE LEN(SELF.GetName(G,indexField)) > 0
        WhosName = SELF.GetName(G,indexField)
        assignString = WhosName
        DO FieldSequence
        getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(ColumnsLength[ColumnPosition]+1))
        IndexField += 1
        ColumnPosition += 1
      END
      Response = getString 
      SELF.Debug.See('Header is [ ' & Response & ' ]')
    SELF.MethodEnd()
    IF SELF.GetColumnsSize() > 0 THEN
      SELF.Debug.SetLine(jcDebug::Hyphen,SELF.GetColumnsSize())
    ELSE
      SELF.Debug.SetLine(jcDebug::Hyphen,130)
    END
    !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
    SELF.Debug.ShowLine()
    RETURN Response
FieldSequence           ROUTINE
  IF SELF.ColumnIndex = TRUE THEN
    SELF.Debug.See('Column ' & indexField+1 & ' = ' & assignString)
  ELSE
    SELF.Debug.See('Column ' & indexField+1 & ' = ' & assignString)
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetHeaderColumns PROCEDURE(*GROUP G)
MethodName                        EQUATE('GetHeaderColumns')
Prototype                         EQUATE('(*GROUP G)')
WhosName                          ASTRING
indexField                        ULONG
ColumnPosition                    ULONG
assignString                      STRING(500)
getString                         ANY
Response                          ASTRING
  CODE
    SELF.Debug.SetSelectiveShow(jcDebug::MethodShow,'jcFieldClass.GetHeaderColumns(*GROUP G)')
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetHeaderColumns4)
      !Show the header SHOW
      SELF.Debug.Codes('Verifying if we add the INDEX Column from the stackQueue')
        SELF.Debug.See('Do we add the field INDEX column from the stackQueue ? ' & SELF.Debug.GetBOOL(SELF.ColumnIndex,_Yes))
        ColumnPosition = 1
        IF SELF.ColumnIndex = TRUE THEN  !IF We want the INDEX Column from the stack queue then we add the first column with a length of SELF.ColumnIndexLength char
          assignString = jcStack::Index
          getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(SELF.ColumnsLength[ColumnPosition]+1))
          SELF.Debug.See('Index column length = ' & SELF.ColumnsLength[ColumnPosition])
          ColumnPosition += 1
        END
        SELF.Debug.See('Column position length = ' & SELF.ColumnsLength[ColumnPosition])
        SELF.Debug.See('Column position = ' & ColumnPosition)
      SELF.Debug.Fin()  
      SELF.Debug.See('Column ' & indexField+1 & ' = ' & assignString)
      !DO FieldSequence          
      indexField = 1
      LOOP WHILE LEN(SELF.GetName(G,indexField)) > 0
        WhosName = SELF.GetName(G,indexField)
        assignString = WhosName
        DO FieldSequence
        getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(SELF.ColumnsLength[ColumnPosition]+1))
        IndexField += 1
        ColumnPosition += 1
      END
      Response = getString 
      SELF.Debug.See('Header is [ ' & Response & ' ]')
    SELF.MethodEnd()
    IF SELF.GetColumnsSize() > 0 THEN
      SELF.Debug.SetLine(jcDebug::Hyphen,SELF.GetColumnsSize())
    ELSE
      SELF.Debug.SetLine(jcDebug::Hyphen,130)
    END
    !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
    SELF.Debug.ShowLine()
    RETURN Response
FieldSequence           ROUTINE
  IF SELF.ColumnIndex = TRUE THEN
    SELF.Debug.See('Column ' & indexField+1 & ' = ' & assignString)
  ELSE
    SELF.Debug.See('Column ' & indexField+1 & ' = ' & assignString)
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetFields    PROCEDURE(*GROUP G,<USHORT StartPosition>,<BYTE FieldsFormat>)
MethodName                    EQUATE('GetFields')
Prototype                     EQUATE('(*GROUP G,<USHORT StartPosition>,<BYTE FieldsFormat>)')
FieldsFormatLimit             BYTE
FieldName                     ASTRING
FieldData                     ASTRING
indexField                    ULONG
FieldLength                   USHORT
assignString                  STRING(500)
getString                     ANY
GetFieldsQ                    QUEUE
FieldName                       ASTRING
FieldData                       ASTRING
                              END                
Response                      ASTRING
  CODE
    SELF.Debug.SetSelectiveShow(jcDebug::MethodShow,'jcFieldClass.GetFields(*GROUP G,<USHORT StartPosition>,<BYTE FieldsFormat>)')
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetFields)
      !Show the header SHOW
  !    IF OMITTED(4) THEN Type = 3.
  !    IF Type > 4 THEN
  !      MESSAGE('Le type de accepté est de 1 à 4')      !Ajouter Message d'erreur ici pour plus tard.
  !    END    
      IF OMITTED(4) THEN 
        SELF.SetFieldsFormat(JC_FIELD_jcFieldManager_SetFieldsFormat)
        FieldsFormat = SELF.GetFieldsFormat()
      END
      !IF Type > 4 THEN
      FieldsFormatLimit = SELF.GetFieldsFormatLimit()
      IF NOT INRANGE(FieldsFormat,1,FieldsFormatLimit)
        MESSAGE('The Type of Fields Format is out of range the type of accepted values are ' & |
                'in the range between 1 and ' & SELF.GetFieldsFormatLimit() ,'jcFieldManager Error',ICON:Hand)   !Ajouter Message d'erreur ici pour plus tard.
      ELSE
        SELF.SetFieldsFormat(FieldsFormat)
      END

      SELF.Debug.ShowCurrentMethodValue('G = ',G)
      IF NOT OMITTED(3) THEN
         indexField = StartPosition
      ELSE
         indexField = SELF.GetIndexField()
      END
      SELF.Debug.See('LEN(SELF.GetName(G,indexField)) = ' & LEN(SELF.GetName(G,indexField)))
      SELF.Debug.See('SIZE of the FieldsStructure = ' & SIZE(G))
      SELF.Debug.See('indexField = 0 the field name is ' & SELF.GetName(G,0))
      LOOP WHILE LEN(SELF.GetName(G,indexField)) > 0
        FieldName = SELF.GetName(G,indexField)
        FieldData = SELF.GetData(G,indexField)
        DO AddsQ
        FieldLength = LEN(FieldName)
        assignString = FieldName
        SELF.Debug.See('Field ' & indexField & ' = ' & assignString)
        getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(FieldLength+1))
        indexField += 1
      END
      Response = getString 
      SELF.Debug.See('List of fields are ' & Response)
      DO ShowGetFieldsQ
    SELF.MethodEnd()
    RETURN Response
AddsQ                  ROUTINE
  GetFieldsQ.FieldName = FieldName
  GetFieldsQ.FieldData = FieldData
  ADD(GetFieldsQ)  
ShowGetFieldsQ              ROUTINE
  LOOP i# = 1 TO RECORDS(GetFieldsQ)
    GET(GetFieldsQ,i#)
    EXECUTE SELF.GetFieldsFormat() !Type 
      SELF.Debug.See(GetFieldsQ.FieldName)
      SELF.Debug.See(GetFieldsQ.FieldName & ' = ' & GetFieldsQ.FieldData)
      SELF.Debug.See(SELF.GetName(G,0) & '.' & GetFieldsQ.FieldName & ' = ' & GetFieldsQ.FieldData)
      SELF.Debug.See(GetFieldsQ.FieldData)
    END
  END
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetFields    PROCEDURE(*QUEUE Q,<USHORT StartPosition>,<BYTE FieldsFormat>)
MethodName                    EQUATE('GetFields')
Prototype                     EQUATE('(*QUEUE Q,<USHORT StartPosition>,<BYTE FieldsFormat>)')
FieldsFormatLimit             BYTE
FieldName                     ASTRING
FieldData                     ASTRING
indexField                    ULONG
FieldLength                   USHORT
assignString                  STRING(500)
getString                     ANY
Response                      ASTRING
GetFieldsQ                    QUEUE
FieldName                       ASTRING
FieldData                       ASTRING
                              END                
  CODE
    DO ShowBeforeMethodStart
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetFields2)
      IF OMITTED(4) THEN 
        SELF.SetFieldsFormat(JC_FIELD_jcFieldManager_SetFieldsFormat)
        FieldsFormat = SELF.GetFieldsFormat()
      END
      !IF Type > 4 THEN
      FieldsFormatLimit = SELF.GetFieldsFormatLimit()
      IF NOT INRANGE(FieldsFormat,1,FieldsFormatLimit)
        MESSAGE('The Type of Fields Format is out of range the type of accepted values are ' & |
                'in the range between 1 and ' & SELF.GetFieldsFormatLimit() ,'jcFieldManager Error',ICON:Hand)   !Ajouter Message d'erreur ici pour plus tard.
      ELSE
        SELF.SetFieldsFormat(FieldsFormat)
      END
      DO ShowAfterMethodStart
      SELF.Debug.ShowCurrentMethodValue('Q = ',Q)
      !Show the header SHOW
      IF NOT OMITTED(3) THEN
        indexField = StartPosition
      ELSE
        indexField = SELF.GetIndexField()
      END
      DO ShowSomeInfoAboutQueue
      SELF.Debug.Loops('Get the Fields Name from the Queue structure',_Hide)
        LOOP WHILE LEN(SELF.GetName(Q,indexField)) > 0
          FieldName = SELF.GetName(Q,indexField)
          FieldData = SELF.GetData(Q,indexField)
          DO AddsQ
          FieldLength = LEN(FieldName)
          assignString = FieldName
          SELF.Debug.See('Field ' & indexField & ' = ' & assignString)
          getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(FieldLength+1))
          indexField += 1
        END
        SELF.Debug.See('getString = ' & getString)
      SELF.Debug.Fin()
      Response = getString 
    SELF.MethodEnd()
    DO ShowGetFieldsQ
    RETURN Response
AddsQ          ROUTINE
  GetFieldsQ.FieldName = FieldName
  GetFieldsQ.FieldData = FieldData
  ADD(GetFieldsQ)  
ShowBeforeMethodStart   ROUTINE
  SELF.Debug.Routines('Before calling MethodStart in GetFields QUEUE version Method',_Hide)
    SELF.Debug.ShowCurrentMethodValue('GetCurrentShow()',SELF.Debug.GetBool(SELF.Debug.GetCurrentShow(),_Showing))
    SELF.Debug.ShowCurrentMethodValue('CurrentShow',SELF.Debug.CurrentShow)
    SELF.Debug.See('Do Method Show TRUE or FALSE = ' & SELF.Debug.GetBOOL(SELF.Debug.GetShow(jcDebug::MethodShow)))
    SELF.Debug.SetMethodName('GetFields','(*QUEUE Q,<USHORT StartPosition>)')
    SELF.Debug.ShowCurrentMethodValue('GetMethodName()',SELF.Debug.GetMethodName())
    SELF.Debug.ShowCurrentMethodValue('GetShow((GetFields,(*QUEUE Q,<USHORT StartPosition>)',SELF.Debug.GetBOOL(SELF.Debug.GetShow(SELF.GetMethodName()),_Showing))
  SELF.Debug.Fin()  
ShowAfterMethodStart    ROUTINE
  SELF.Debug.Routines('After calling MethodStart in GetFields Method',_Hide)
    SELF.Debug.ShowCurrentMethodValue('GetCurrentShow()',SELF.Debug.GetBOOL(SELF.Debug.GetCurrentShow(),_Showing))
    SELF.Debug.ShowCurrentMethodValue('CurrentShow',SELF.Debug.CurrentShow)
    SELF.Debug.See('Do Method Show TRUE or FALSE = ' & SELF.Debug.GetBOOL(SELF.Debug.GetShow(jcDebug::MethodShow)))
    SELF.Debug.ShowCurrentMethodValue('GetShow()',SELF.Debug.GetBOOL(SELF.Debug.GetShow(jcDebug::MethodShow & jcDebug::Dot & SELF.GetMethodName()),_Showing))
  SELF.Debug.Fin()  
ShowSomeInfoAboutQueue  ROUTINE
  SELF.Debug.Routines('Some info about the Queue structure',_Hide)
    SELF.Debug.See('LEN(SELF.GetName(Q,indexField)) = ' & LEN(SELF.GetName(Q,indexField)))
    SELF.Debug.See('SIZE of the FieldsStructure = ' & SIZE(Q))
    SELF.Debug.See('indexField = 0 the field structure is the Queue ' & SELF.GetName(Q,0))
  SELF.Debug.Fin()  
ShowGetFieldsQ      ROUTINE
  SELF.Debug.Routines('ShowGetFieldsQ, get the fields and its data from the Queue',_Hide)
    LOOP i# = 1 TO RECORDS(GetFieldsQ)
      GET(GetFieldsQ,i#)
      EXECUTE SELF.GetFieldsFormat() !Type 
        SELF.Debug.See(GetFieldsQ.FieldName)
        SELF.Debug.See(GetFieldsQ.FieldName & ' = ' & GetFieldsQ.FieldData)
        SELF.Debug.See(SELF.GetName(Q,0) & '.' & GetFieldsQ.FieldName & ' = ' & GetFieldsQ.FieldData)
        SELF.Debug.See(GetFieldsQ.FieldData)
      END
    END
  SELF.Debug.Fin()
 !----------------------------------------------------------------------------------------------------------------
jcFieldManager.SetFieldsFormat  PROCEDURE(<BYTE FieldsFormat>)
MethodName                        EQUATE('SetFieldsFormat')
Prototype                         EQUATE('(<BYTE FieldsFormat>)')
  CODE  
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:SetFieldsFormat)
      IF OMITTED(2) THEN
        SELF.FieldsFormat = JC_FIELD_jcFieldManager_SetFieldsFormat
      ELSE
        IF NOT INRANGE(FieldsFormat,1,SELF.GetFieldsFormatLimit())
          SELF.FieldsFormat = JC_FIELD_jcFieldManager_SetFieldsFormat
        ELSE
          SELF.FieldsFormat = FieldsFormat
        END
      END    
     SELF.Debug.ShowCurrentMethodValue('FieldsFormat',SELF.FieldsFormat)
   SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetFieldsFormat  PROCEDURE()
MethodName                        EQUATE('GetFieldsFormat')
Prototype                         EQUATE('()')
  CODE  
?   SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetFieldsFormat)
?     SELF.Debug.ShowCurrentMethodValue('FieldsFormat',SELF.FieldsFormat)
?   SELF.MethodEnd()
    RETURN SELF.FieldsFormat
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.SetFieldsFormatLimit PROCEDURE(<BYTE FieldsFormatLimit>)
MethodName                            EQUATE('SetFieldsFormatLimit')
Prototype                             EQUATE('(<BYTE FieldsFormatLimit>)')
  CODE  
?   SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:SetFieldsFormatLimit)
      SELF.FieldsFormatLimit = FieldsFormatLimit
?     SELF.Debug.ShowCurrentMethodValue('FieldsFormatLimit',SELF.FieldsFormatLimit)
?   SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetFieldsFormatLimit PROCEDURE()
MethodName                            EQUATE('GetFieldsFormatLimit')
Prototype                             EQUATE('()')
  CODE  
?   SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetFieldsFormatLimit)
?     SELF.Debug.ShowCurrentMethodValue('FieldsFormatLimit',SELF.FieldsFormatLimit)
?   SELF.MethodEnd()
    RETURN SELF.FieldsFormatLimit
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.SetIndexField    PROCEDURE (BYTE IndexField)        
MethodName                        EQUATE('SetIndexField')
Prototype                         EQUATE('(BYTE IndexField)')
  CODE  
?   SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:SetIndexField)
      SELF.IndexField = IndexField
?     SELF.Debug.ShowCurrentMethodValue('IndexField',SELF.IndexField)
?   SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetIndexField    PROCEDURE ()
MethodName                        EQUATE('GetIndexField')
Prototype                         EQUATE('()')
  CODE  
?   SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetIndexField)
?     SELF.Debug.ShowCurrentMethodValue('IndexField',SELF.IndexField)
?   SELF.MethodEnd()
    RETURN SELF.IndexField 
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.SetColumnIndex   PROCEDURE (BOOL ColumnIndex)
MethodName                        EQUATE('SetColumnIndex')
Prototype                         EQUATE('(BOOL ColumnIndex)')
  CODE  
?   SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:SetColumnIndex)
      SELF.ColumnIndex = ColumnIndex
?     SELF.Debug.ShowCurrentMethodValue('ColumnIndex',SELF.Debug.GetBOOL(SELF.ColumnIndex,_Showing))
?   SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetColumnIndex   PROCEDURE ()
MethodName                        EQUATE('GetColumnIndex')
Prototype                         EQUATE('()')
  CODE  
?   SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetColumnIndex)
?     SELF.Debug.ShowCurrentMethodValue('ColumnIndex',SELF.ColumnIndex)
?   SELF.MethodEnd()
    RETURN SELF.ColumnIndex
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.SetColumnIndexLength PROCEDURE (BYTE ColumnIndexLength)
MethodName                            EQUATE('SetColumnIndexLength')
Prototype                             EQUATE('(BYTE ColumnIndexLength)')
  CODE  
?   SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:SetColumnIndexLength)
      SELF.ColumnIndexLength = ColumnIndexLength
?     SELF.Debug.ShowCurrentMethodValue('ColumnIndexLength',SELF.ColumnIndexLength)
?   SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetColumnIndexLength PROCEDURE ()
MethodName                            EQUATE('GetColumnIndexLength')
Prototype                             EQUATE('()')
  CODE  
?   SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetColumnIndexLength)
?     SELF.Debug.ShowCurrentMethodValue('ColumnIndexLength',SELF.ColumnIndexLength)
?   SELF.MethodEnd()
    RETURN SELF.ColumnIndexLength
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.ShowColumns  PROCEDURE(stackQueue Q,<*GROUP G>,*USHORT[] ColumnsLength)
MethodName                    EQUATE('ShowColumns')
Prototype                     EQUATE('(stackQueue Q,<*GROUP G>,*USHORT[] ColumnsLength)')
index                         LONG        !The index Queue
indexField                    ULONG       !The field ordinal position
ColumnPosition                ULONG       !The actual physical column
WhosWhat                      ASTRING     !Gets the data
assignString                  ASTRING     !Assign the data
getString                     ANY         !Compute the data according to the calculated columns set length
Response                      ASTRING     !Final response    
Gr                            &GROUP
Qs                            &stackQueue
  CODE
    IF NOT OMITTED(3) THEN
      Gr &= G
    ELSE
      Gr &= SELF.GFldMgr
    END
    Qs &= Q
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:ShowColumns)
      FREE(ShowColumnsQ)
      SELF.Debug.Embed('Get the parameters before looping through the Queue')
        SELF.Debug.See('Records(Q) ' & RECORDS(Q))
        SELF.Debug.See('Records(Qs) ' & RECORDS(Qs))    
        SELF.Debug.See('GetNumberOfColumns() = SELF.GetNumberOfColumns(ColumnsLength[]) statement do not work I have access violation')
        SELF.Debug.See('The ColumnsLength dim reference parameter is not allowed one procedure parameter to another sub procedure')
        SELF.Debug.See('I need to do more investigation on that part to understand the function of the dim referencing')
      SELF.Debug.Fin()
      index = 0
      LOOP index = 1 TO RECORDS(Qs)
        GET(Qs,index)
        Gr = Qs.nodeVal 
        SELF.Debug.Embed('GetFields, Group and indexField position within the Queue')
          SELF.Debug.See('Gr ' & Gr)
          SELF.Debug.See(SELF.GetFields(Gr))
          SELF.Debug.See('indexField position ' & indexField)
          SELF.Debug.ShowCurrentMethodValue('ShowColumns.index = ',index)
        SELF.Debug.Fin()  
        indexField = 1
        ColumnPosition = 1
        getString = ''
        LOOP WHILE LEN(SELF.GetName(Gr,indexField)) > 0
          WhosWhat = SELF.GetData(Gr,indexField) 
          SELF.Debug.Embed('Show Group within the ColumnsLength LOOP',_Hide)
            SELF.Debug.ShowCurrentMethodValue('Group Name',SELF.GetName(SELF.GFldMgr,indexField))
            SELF.Debug.ShowCurrentMethodValue('Group Data',WhosWhat)        
            assignString = WhosWhat
            IF SELF.ColumnIndex = TRUE THEN
              getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(ColumnsLength[ColumnPosition+1]+1))
            ELSE
              getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(ColumnsLength[ColumnPosition]+1))
            END
            indexField += 1
            ColumnPosition += 1
            SELF.Debug.ShowCurrentMethodValue('Record',getString)
            SELF.Debug.ShowCurrentMethodValue('ShowColumns.indexField = ',indexField)         
          SELF.Debug.Fin()
        END
        Response = getString
        ShowColumnsQ.index    = Qs.index
        ShowColumnsQ.Response = Response
        ADD(ShowColumnsQ)
      END 
    SELF.MethodEnd()
    DO ShowColumnsToScreen
		DO EndShowColumns

EndShowColumns    ROUTINE
  CLEAR(Gr)
  CLEAR(Qs)

ShowColumnsToScreen   ROUTINE
!  SELF.Debug.ShowLine(jcField::Hyphen,LEN(Gr)) 
  SELF.Debug.ShowLine(jcField::Hyphen,SELF.GetColumnsSize())
  LOOP i# = 1 TO RECORDS(ShowColumnsQ)
    GET(ShowColumnsQ,i#)
    IF SELF.ColumnIndex = TRUE THEN
      SELF.Debug.See(FORMAT(ShowColumnsQ.index,SELF.GetStringFormatLength(SELF.ColumnIndexLength+1)) & ShowColumnsQ.Response)
    ELSE
      SELF.Debug.See(ShowColumnsQ.Response)
    END
  END
  SELF.Debug.ShowLine(jcField::Hyphen,SELF.GetColumnsSize())
  !SELF.Debug.ShowLine(jcField::Hyphen,LEN(Gr))
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.ShowColumns  PROCEDURE(stackQueue Q,<*GROUP G>) 
MethodName                    EQUATE('ShowColumns')
Prototype                     EQUATE('(stackQueue Q,<*GROUP G>)')
index                         LONG        !The index Queue
indexField                    ULONG       !The field ordinal position
ColumnPosition                ULONG       !The actual physical column
WhosWhat                      ASTRING     !Gets the data
assignString                  ASTRING     !Assign the data
getString                     ANY         !Compute the data according to the calculated columns set length
Response                      ASTRING     !Final response    
Gr                            &GROUP
Qs                            &stackQueue
!ShowColumnsQ    QUEUE
!index             ULONG
!Response          ASTRING
!                END
  CODE
    FREE(ShowColumnsQ)
    IF NOT OMITTED(3) THEN
      Gr &= G
    ELSE
      Gr &= SELF.GFldMgr
    END
    Qs &= Q
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:ShowColumns2)
      SELF.Debug.Embed('Get the parameters before looping through the Queue')
        SELF.Debug.See('Records(Q) ' & RECORDS(Q))
        SELF.Debug.See('Records(Qs) ' & RECORDS(Qs))    
        SELF.Debug.See('GetNumberOfColumns() = SELF.GetNumberOfColumns() statement do not work I have access violation')
        SELF.Debug.See('The ColumnsLength dim reference parameter is not allowed one procedure parameter to another sub procedure')
        SELF.Debug.See('I need to do more investigation on that part to understand the function of the dim referencing')
      SELF.Debug.Fin()
      index = 0
      LOOP index = 1 TO RECORDS(Qs)
        GET(Qs,index)
        Gr = Qs.nodeVal 
        SELF.Debug.Embed('GetFields, Group and indexField position within the Queue')
          SELF.Debug.See('Gr ' & Gr)
          SELF.Debug.See(SELF.GetFields(Gr))
          SELF.Debug.See('indexField position ' & indexField)
          SELF.Debug.ShowCurrentMethodValue('ShowColumns.index = ',index)
        SELF.Debug.Fin()  
        indexField = 1
        ColumnPosition = 1
        getString = ''
        LOOP WHILE LEN(SELF.GetName(Gr,indexField)) > 0
          WhosWhat = SELF.GetData(Gr,indexField) 
          SELF.Debug.Embed('Show Group within the ColumnsLength LOOP',_Hide)
            SELF.Debug.ShowCurrentMethodValue('Group Name',SELF.GetName(SELF.GFldMgr,indexField))
            SELF.Debug.ShowCurrentMethodValue('Group Data',WhosWhat)        
            assignString = WhosWhat
            IF SELF.ColumnIndex = TRUE THEN
              getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(SELF.ColumnsLength[ColumnPosition+1]+1))
            ELSE
              getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(SELF.ColumnsLength[ColumnPosition]+1))
            END
            indexField += 1
            ColumnPosition += 1
            SELF.Debug.ShowCurrentMethodValue('Record',getString)
            SELF.Debug.ShowCurrentMethodValue('ShowColumns.indexField = ',indexField)         
          SELF.Debug.Fin()
        END
        Response = getString
        ShowColumnsQ.index    = Qs.index
        ShowColumnsQ.Response = Response
        ADD(ShowColumnsQ)
      END 
    SELF.MethodEnd()
    DO ShowColumnsToScreen
		DO EndShowColumns

EndShowColumns    ROUTINE
  CLEAR(Gr)
  CLEAR(Qs)

ShowColumnsToScreen   ROUTINE
!  SELF.Debug.ShowLine(jcField::Hyphen,LEN(Gr)) 
  SELF.Debug.ShowLine(jcField::Hyphen,SELF.GetColumnsSize())
  LOOP i# = 1 TO RECORDS(ShowColumnsQ)
    GET(ShowColumnsQ,i#)
    IF SELF.ColumnIndex = TRUE THEN
      SELF.Debug.See(FORMAT(ShowColumnsQ.index,SELF.GetStringFormatLength(SELF.ColumnIndexLength+1)) & ShowColumnsQ.Response)
    ELSE
      SELF.Debug.See(ShowColumnsQ.Response)
    END 
  END
!  SELF.Debug.ShowLine(jcField::Hyphen,LEN(Gr))
  SELF.Debug.ShowLine(jcField::Hyphen,SELF.GetColumnsSize())
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.ShowColumns  PROCEDURE(*QUEUE Q)
MethodName                    EQUATE('ShowColumns')
Prototype                     EQUATE('(*QUEUE Q)')
indexQ                        LONG        !The index Queue
indexField                    ULONG       !The field ordinal position
ColumnPosition                ULONG       !The actual physical column
WhosWhat                      ASTRING     !Gets the data
assignString                  ASTRING     !Assign the data
getString                     ANY         !Compute the data according to the calculated columns set length
Response                      ASTRING     !Final response    
!ShowColumnsQ    QUEUE
!index             ULONG
!Response          ASTRING
!                END
  CODE
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:ShowColumns3)
      FREE(ShowColumnsQ)
      SELF.Debug.Note('Get the parameters before looping through the Queue',_Hide)
        SELF.Debug.See('Records(Q) ' & RECORDS(Q))
        SELF.Debug.See('GetNumberOfColumns() = SELF.GetNumberOfColumns() statement do not work I have access violation')
        SELF.Debug.See('The ColumnsLength dim reference parameter is not allowed one procedure parameter to another sub procedure')
        SELF.Debug.See('I need to do more investigation on that part to understand the function of the dim referencing')
      SELF.Debug.Fin()
      indexQ = 0
      ShowColumnsQ.index  = 0
      LOOP indexQ = 1 TO RECORDS(Q)
        GET(Q,indexQ)
        SELF.Debug.Embed('indexField position within the Queue',_Hide)
          SELF.Debug.ShowCurrentMethodValue('ShowColumns.index = ',indexQ,_Hide)
        SELF.Debug.Fin()  
        indexField = 1
        ColumnPosition = 1
        getString = ''
        SELF.Debug.Loops('WHILE LEN(SELF.GetName(Q,indexField)) > 0',_Hide)
          LOOP WHILE LEN(SELF.GetName(Q,indexField)) > 0
            WhosWhat = SELF.GetData(Q,indexField) 
            SELF.Debug.Loops('Show Group within the ColumnsLength LOOP ' & indexField,_Hide)
              SELF.Debug.ShowCurrentMethodValue('Group Name',SELF.GetName(Q,indexField),_Hide)
              SELF.Debug.ShowCurrentMethodValue('Group Data',WhosWhat,_Hide)        
              assignString = WhosWhat
              SELF.Debug.IFs('SELF.ColumnIndex = TRUE THEN',_Hide)
                IF SELF.ColumnIndex = TRUE THEN
                  SELF.Debug.IFOnTrue()
                    getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(SELF.ColumnsLength[ColumnPosition+1]+1))
                    SELF.Debug.ShowValue('getString',getString,_Hide)
                  SELF.Debug.Fin()
                ELSE
                  SELF.Debug.IFOnFalse()
                    getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(SELF.ColumnsLength[ColumnPosition]+1))
                    SELF.Debug.ShowValue('getString',getString,_Hide)
                  SELF.Debug.Fin()
                END
              SELF.Debug.Fin()
              indexField += 1
              ColumnPosition += 1
              SELF.Debug.ShowCurrentMethodValue('Record',getString,_Hide)
              SELF.Debug.ShowCurrentMethodValue('ShowColumns.indexField = ',indexField,_Hide)         
            SELF.Debug.Fin()
          END
        SELF.Debug.Fin()
        Response = getString
        ShowColumnsQ.index   += 1
        ShowColumnsQ.Response = Response
        SELF.Debug.ShowValue('ShowColumnsQ.index',ShowColumnsQ.index,_Hide)
        SELF.Debug.ShowValue('ShowColumnsQ.Response',ShowColumnsQ.Response,_Hide)
        ADD(ShowColumnsQ)
      END 
    SELF.MethodEnd()
    DO ShowColumnsToScreen
ShowColumnsToScreen         ROUTINE
!  SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q)) 
  SELF.Debug.ShowLine(jcField::Hyphen,SELF.GetColumnsSize())
  LOOP i# = 1 TO RECORDS(ShowColumnsQ)
    GET(ShowColumnsQ,i#)
    IF SELF.ColumnIndex = TRUE THEN
      SELF.Debug.See(FORMAT(ShowColumnsQ.index,SELF.GetStringFormatLength(SELF.ColumnIndexLength+1)) & ShowColumnsQ.Response)
    ELSE
      SELF.Debug.See(ShowColumnsQ.Response)
    END
  END
!  SELF.Debug.ShowLine(jcField::Hyphen,LEN(Q))
  SELF.Debug.ShowLine(jcField::Hyphen,SELF.GetColumnsSize())
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.ShowColumns  PROCEDURE(USHORT indexField,*USHORT[] ColumnsLength)
MethodName                    EQUATE('ShowColumns')
Prototype                     EQUATE('(USHORT indexField,*USHORT[] ColumnsLength)')
ndx                           LONG
ndxF                          ULONG
getString                     ANY
assignString                  ASTRING
Response                      ASTRING
WhosWhat                      ASTRING
Gr                            &GROUP
  CODE
    Gr &= SELF.GFldMgr
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:ShowColumns4)
      FREE(ShowColumnsQ)
      SELF.Debug.Embed('Get the parameters before looping through the Queue',_Hide)
        SELF.Debug.ShowCurrentMethodValue('indexField',indexField)
        SELF.Debug.ShowCurrentMethodValue('GetNumberOfColumns()',SELF.GetNumberOfColumns(ColumnsLength[]))
        SELF.Debug.See('Records(SELF.QFldMgr) ' & RECORDS(SELF.QFldMgr))
      SELF.Debug.Fin()
      ndx = 0
      ndxF = indexField
      LOOP ndx = 1 TO RECORDS(SELF.QFldMgr)
        GET(SELF.QFldMgr,ndx)
        SELF.GFldMgr = SELF.nodeVal !SELF.Stack.Q.nodeVal
        SELF.Debug.Embed('GetFields, Group and indexField position within the Queue',_Hide)
          SELF.Debug.See(SELF.GetFields(SELF.GFldMgr))
          SELF.Debug.See('indexField position ' & indexField)
          SELF.Debug.See('SELF.GFldMgr ' & SELF.GFldMgr)
          SELF.Debug.ShowCurrentMethodValue('ShowColumns.ndx = ',ndx)
        SELF.Debug.Fin()  
        ndxF = 1
        getString = ''
        LOOP WHILE LEN(SELF.GetName(SELF.GFldMgr,ndxF)) > 0
          WhosWhat = SELF.GetData(SELF.GFldMgr,ndxF) 
          SELF.Debug.Embed('Show Group within the ColumnsLength LOOP',_Hide)
            SELF.Debug.ShowCurrentMethodValue('Group Name',SELF.GetName(SELF.GFldMgr,ndxF))
            SELF.Debug.ShowCurrentMethodValue('Group Data',WhosWhat)        
            assignString = WhosWhat
            getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(ColumnsLength[ndxF]+1))
            ndxF += 1
            SELF.Debug.ShowCurrentMethodValue('Record',getString)
            SELF.Debug.ShowCurrentMethodValue('ShowColumns.ndxF = ',ndxF)
          SELF.Debug.Fin()
        END
        Response = getString
        SELF.Debug.See(Response)
      END 
  		DO EndShowColumns
    SELF.MethodEnd()

EndShowColumns    ROUTINE
  CLEAR(Gr)

!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.ShowColumns  PROCEDURE(USHORT indexField)
MethodName                    EQUATE('ShowColumns')
Prototype                     EQUATE('(USHORT indexField)')
ndx                           LONG
ndxF                          ULONG
getString                     ANY
assignString                  ASTRING
Response                      ASTRING
WhosWhat                      ASTRING
Gr                            &GROUP
  CODE
    Gr &= SELF.GFldMgr
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:ShowColumns5)
      FREE(ShowColumnsQ)
      SELF.Debug.Embed('Get the parameters before looping through the Queue',_Hide)
        SELF.Debug.ShowCurrentMethodValue('indexField',indexField)
        SELF.Debug.ShowCurrentMethodValue('GetNumberOfColumns()',SELF.GetNumberOfColumns(SELF.ColumnsLength))
        SELF.Debug.See('Records(SELF.QFldMgr) ' & RECORDS(SELF.QFldMgr))
      SELF.Debug.Fin()
      ndx = 0
      ndxF = indexField
      LOOP ndx = 1 TO RECORDS(SELF.QFldMgr)
        GET(SELF.QFldMgr,ndx)
        SELF.GFldMgr = SELF.nodeVal !SELF.Stack.Q.nodeVal
        SELF.Debug.Embed('GetFields, Group and indexField position within the Queue',_Hide)
          SELF.Debug.See(SELF.GetFields(SELF.GFldMgr))
          SELF.Debug.See('indexField position ' & indexField)
          SELF.Debug.See('SELF.GFldMgr ' & SELF.GFldMgr)
          SELF.Debug.ShowCurrentMethodValue('ShowColumns.ndx = ',ndx)
        SELF.Debug.Fin()  
        ndxF = 1
        getString = ''
        LOOP WHILE LEN(SELF.GetName(SELF.GFldMgr,ndxF)) > 0
          WhosWhat = SELF.GetData(SELF.GFldMgr,ndxF) 
          SELF.Debug.Embed('Show Group within th SELF.ColumnsLength LOOP',_Hide)
            SELF.Debug.ShowCurrentMethodValue('Group Name',SELF.GetName(SELF.GFldMgr,ndxF))
            SELF.Debug.ShowCurrentMethodValue('Group Data',WhosWhat)        
            assignString = WhosWhat
            getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(SELF.ColumnsLength[ndxF]+1))
            ndxF += 1
            SELF.Debug.ShowCurrentMethodValue('Record',getString)
            SELF.Debug.ShowCurrentMethodValue('ShowColumns.ndxF = ',ndxF)
          SELF.Debug.Fin()
        END
        Response = getString
        SELF.Debug.See(Response)
      END 
    SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.ShowColumns  PROCEDURE(*USHORT[] ColumnsLength)
MethodName                    EQUATE('ShowColumns')
Prototype                     EQUATE('(*USHORT[] ColumnsLength)')
ndx                           ULONG
ndxF                          ULONG
WhosWhat                      ASTRING
getString                     ANY
assignString                  ASTRING
Response                      ASTRING
  CODE
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:ShowColumns6)
      FREE(ShowColumnsQ)
      SELF.Debug.See('ShowColumns')
      ndx = 0
      ndxF = 0
      SELF.Debug.See('Records(Q) ' & RECORDS(SELF.QFldMgr))
      LOOP ndx = 1 TO RECORDS(SELF.QFldMgr)
        GET(SELF.QFldMgr,ndx)
        SELF.Debug.See('Show SELF.QFldMgr ' & SELF.QFldMgr)
        ndxF = 1
        getString = ''
        LOOP WHILE LEN(SELF.GetName(SELF.QFldMgr,ndxF)) > 0
          WhosWhat = SELF.GetData(SELF.QFldMgr,ndxF)
          assignString = WhosWhat
          getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(ColumnsLength[ndxF]+1))
          ndxF += 1
        END
        Response = getString
        SELF.Debug.See(Response)
      END 
    SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.ShowColumns  PROCEDURE()
MethodName                    EQUATE('ShowColumns')
Prototype                     EQUATE('()')
ndx                           ULONG
ndxF                          ULONG
WhosWhat                      ASTRING
getString                     ANY
assignString                  ASTRING
Response                      ASTRING
  CODE
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:ShowColumns7)
      FREE(ShowColumnsQ)
      SELF.Debug.See('ShowColumns')
      ndx = 0
      ndxF = 0
      SELF.Debug.See('Records(Q) ' & RECORDS(SELF.QFldMgr))
      LOOP ndx = 1 TO RECORDS(SELF.QFldMgr)
        GET(SELF.QFldMgr,ndx)
        SELF.Debug.See('Show SELF.QFldMgr ' & SELF.QFldMgr)
        ndxF = 1
        getString = ''
        LOOP WHILE LEN(SELF.GetName(SELF.QFldMgr,ndxF)) > 0
          WhosWhat = SELF.GetData(SELF.QFldMgr,ndxF)
          assignString = WhosWhat
          getString = getString & FORMAT(assignString,SELF.GetStringFormatLength(SELF.ColumnsLength[ndxF]+1))
          ndxF += 1
        END
        Response = getString
        SELF.Debug.See(Response)
      END 
    SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.ShowQueue    PROCEDURE (*QUEUE Q)                                        !Show the contenant of the Queue to the screen
MethodName                    EQUATE('ShowQueue')
Prototype                     EQUATE('(*QUEUE Q)')
LogFileNumberUsed             BYTE
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:ShowQueue)
      SELF.CalculateColumnsSet(Q)
      IF SELF.GetColumnsSize() = 0 THEN SELF.SetColumnsSize(LEN(SELF.GetHeaderColumns(Q))).
      SELF.Debug.ShowValue('NumberOfColumns',SELF.GetNumberOfColumns(),_Show)
      SELF.Debug.ShowLine(jcField::Hyphen,SELF.GetColumnsSize())
      SELF.Debug.See(SELF.GetHeaderColumns(Q))
      SELF.ShowColumns(Q)
    SELF.MethodEnd()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.AddDataLog   PROCEDURE (*QUEUE Q)                                        !Show the contenant of the Queue to the screen
MethodName                    EQUATE('AddDataLog')
Prototype                     EQUATE('(*QUEUE Q)')
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:AddDataLog)
      SELF.ShowQueue(Q)
      DO AddDataLog
    SELF.MethodEnd()
    SELF.critSect.Release()
AddDataLog        ROUTINE
  DATA
DataString  STRING(2000)
indexQueue  ULONG
  CODE
    SELF.critSect.Wait()
    SELF.Debug.SeeVariables(,,_Hide)
    SELF.Debug.ShowValue('Number of records in ShowColumnsQ',RECORDS(ShowColumnsQ))
    SELF.Debug.ShowValue('DataString',DataString)
    SELF.Debug.ShowValue('DataLogFile structure used',SELF.DataLog.GetFileLabel())
    SELF.Debug.ShowCurrentMethodValue('LogFileName',SELF.DataLog.GetLogFileName())
    SELF.Debug.ShowCurrentMethodValue('DataLog.Get()',SELF.Debug.GetBOOL(SELF.DataLog.Get(),_Active))
    CLEAR(ShowColumnsQ)
    SORT(ShowColumnsQ,ShowColumnsQ.index)
    SELF.DataLog.AddLine(SELF.GetHeaderColumns(Q))
    indexQueue = 0
    SELF.Debug.Loops('indexQueue = 1 TO RECORDS(ShowColumnsQ)')
      LOOP indexQueue = 1 TO RECORDS(ShowColumnsQ)
        GET(ShowColumnsQ,indexQueue)
        SELF.Debug.ShowCurrentMethodValue('DataLog.Get()',SELF.DataLog.Get())
        SELF.Debug.IFS('SELF.DataLog.Get()')
          IF SELF.DataLog.Get() THEN
            SELF.Debug.IFOnTrue()
              DataString = FORMAT(ShowColumnsQ.index,SELF.GetStringFormatLength(SELF.ColumnIndexLength+1)) & ShowColumnsQ.Response
              SELF.Debug.ShowValue('DataString',DataString)
              SELF.DataLog.AddLine(DataString)
            SELF.Debug.Fin()
          ELSE
            SELF.Debug.IFOnFalse()
              SELF.Debug.See('Nothing to show')
            SELF.Debug.Fin()            
          END
        SELF.Debug.Fin()
      END
    SELF.Debug.Fin()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.PrintLog PROCEDURE ()                                        !Show the contenant of the Queue to the screen
MethodName                EQUATE('PrintLong')
Prototype                 EQUATE('()')
LogFileNumberUsed         BYTE
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:PrintLog)
      DO PrintLog   
    SELF.MethodEnd()
    SELF.critSect.Release()
PrintLog          ROUTINE
  DATA
FormatString  ASTRING
  CODE
    SELF.critSect.Wait()
    OPEN(Report)
    SETTARGET(Report)
    SELF.DataLog.Fetch()
    LOOP 
      SELF.DataLog.Next()
      DetailString = SELF.DataLog.GetRecord()
      PRINT(Detail)
      IF SELF.DataLog.Eof() THEN BREAK.
    END
    CLOSE(Report)
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.PrintQ   PROCEDURE (*QUEUE Q)                                        !Show the contenant of the Queue to the screen
MethodName                EQUATE('PrintQ')
Prototype                 EQUATE('(*QUEUE Q)')
LogFileNumberUsed         BYTE
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:PrintLog)
      SELF.ShowColumns(Q)
      !SELF.AddDataLog(Q)
      DO PrintLog   
    SELF.MethodEnd()
    SELF.critSect.Release()
PrintLog          ROUTINE
  DATA
FormatString  ASTRING
  CODE
    SELF.critSect.Wait()
    OPEN(Report)
    SETTARGET(Report)
    DetailString = SELF.GetHeaderColumns(Q)
    PRINT(Detail)
    !?HeaderString{PROP:Text} = SELF.GetHeaderColumns(Q)
    !?DetailString{PROP:Format} = ShowColumnsQ.index & ' ' & ShowColumnsQ.Response!?Show{PROP:Format} = '1000L*~Index ~2000L*~' & SELF.GetHeaderColumns(Q) !'2000L*~First Name~2000L*~Last Name~500L*~Intls~1000D(400)*~Wage~|'
    !?Show{PROPLIST:Header,1} = SELF.GetHeaderColumns(Q) !'First Field'     !Change first field's header text 
    !SELF.DataLog.SetLogFileNumberUsed(LogFileNumberUsed)
    LOOP indexQ# = 1 TO RECORDS(ShowColumnsQ)
      GET(ShowColumnsQ,indexQ#)
      DetailString = FORMAT(ShowColumnsQ.index,SELF.GetStringFormatLength(SELF.ColumnIndexLength+1)) & ' ' & ShowColumnsQ.Response
      PRINT(Detail)
    END
    CLOSE(Report)
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.ShowQueue    PROCEDURE (stackQueue Q,<*GROUP G>)                         !Show the contenant of the Queue to the screen
MethodName                    EQUATE('ShowQueue')
Prototype                     EQUATE('(stackQueue Q,<*GROUP G>)')
Response                      ANY
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:ShowQueue2)
      !SELF.CalculateColumnsSet(Q,G,SELF.Column)
      SELF.CalculateColumnsSet(Q,G)
      SELF.Debug.ShowValue('NumberOfColumns',SELF.GetNumberOfColumns(),_Hide)
      !SELF.Debug.See(SELF.GetHeaderColumns(SELF.GFldMgr,SELF.Column))
      SELF.Debug.See(SELF.GetHeaderColumns(G))
      !SELF.ShowColumns(SELF.Stack.q,,SELF.Column)
      SELF.ShowColumns(Q)
    SELF.MethodEnd()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.ShowQueue    PROCEDURE (*QUEUE Q,*GROUP G)                         !Show the contenant of the Queue to the screen
MethodName                    EQUATE('ShowQueue')
Prototype                     EQUATE('(*QUEUE Q,*GROUP G)')
Response                      ANY
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:ShowQueue3)
      !SELF.CalculateColumnsSet(Q,G,SELF.Column)
      SELF.CalculateColumnsSet(Q,G)
      SELF.Debug.ShowValue('NumberOfColumns',SELF.GetNumberOfColumns(),_Hide)
      !SELF.Debug.See(SELF.GetHeaderColumns(SELF.GFldMgr,SELF.Column))
      SELF.Debug.See(SELF.GetHeaderColumns(G))
      !SELF.ShowColumns(SELF.Stack.q,,SELF.Column)
      SELF.ShowColumns(Q)
    SELF.MethodEnd()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.GetARecordFromQueue  PROCEDURE(LONG indexQPosition,USHORT indexField)
MethodName                            EQUATE('GetARecordFromQueue')
Prototype                             EQUATE('(LONG indexQPosition,USHORT indexField)')
Response                              ANY
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetARecordFromQueue)
      SELF.Debug.See('Records(SELF.QFldMgr) ' & RECORDS(SELF.QFldMgr))
      GET(SELF.QFldMgr,indexQPosition)
      Response = SELF.GetData(SELF.QFldMgr,indexField)
      SELF.Debug.See(Response)
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!----------------------------------------------------------------------------------------------------------------
jcFieldManager.GetStringFormatLength    PROCEDURE(USHORT StringLength)
MethodName                                EQUATE('GetStringFormatLength')
Prototype                                 EQUATE('(USHORT StringLength)')
Response                                  ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldMDebugShow:GetStringFormatLength)
      Response = '@s' & StringLength
      SELF.Debug.ShowCurrentMethodValue('GetStringFormatLength() = ',Response)
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldManager.EmbedShow    PROCEDURE(ASTRING EmbedShow)
MethodName                    EQUATE('EmbedShow')
Prototype                     EQUATE('(ASTRING EmbedShow)')
  CODE
    SELF.critSect.Wait()
    SELF.Debug.Embed(EmbedShow,jcFieldMDebugShow:EmbedShow)
      CASE EmbedShow
      OF 'Before calling MethodStart in GetFields QUEUE version Method'
        !Call From jcFieldManager.GetFields() QUEUE
          SELF.Debug.ShowCurrentMethodValue('GetCurrentShow()',SELF.Debug.GetBool(SELF.Debug.GetCurrentShow(),_Showing))
          SELF.Debug.ShowCurrentMethodValue('CurrentShow',SELF.Debug.CurrentShow)
          SELF.Debug.See('Do Method Show TRUE or FALSE = ' & SELF.Debug.GetBOOL(SELF.Debug.GetShow(jcDebug::MethodShow)))
          SELF.Debug.SetMethodName('GetFields','(*QUEUE Q,<USHORT StartPosition>)')
          SELF.Debug.ShowCurrentMethodValue('GetMethodName()',SELF.Debug.GetMethodName())
          SELF.Debug.ShowCurrentMethodValue('GetShow((GetFields,(*QUEUE Q,<USHORT StartPosition>)',SELF.Debug.GetBOOL(SELF.Debug.GetShow(SELF.GetMethodName()),_Showing))
      OF 'After calling MethodStart in GetFields Method'
          SELF.Debug.ShowCurrentMethodValue('GetCurrentShow()',SELF.Debug.GetBOOL(SELF.Debug.GetCurrentShow(),_Showing))
          SELF.Debug.ShowCurrentMethodValue('CurrentShow',SELF.Debug.CurrentShow)
          SELF.Debug.See('Do Method Show TRUE or FALSE = ' & SELF.Debug.GetBOOL(SELF.Debug.GetShow(jcDebug::MethodShow)))
          SELF.Debug.ShowCurrentMethodValue('GetShow()',SELF.Debug.GetBOOL(SELF.Debug.GetShow(jcDebug::MethodShow & jcDebug::Dot & SELF.GetMethodName()),_Showing))
      OF 'Before calling MethodStart in GetFields CLASS version Method'
        !Call From jcFieldManager.GetFields() CLASS
          SELF.Debug.ShowCurrentMethodValue('GetCurrentShow()',SELF.Debug.GetBool(SELF.Debug.GetCurrentShow(),_Showing))
          SELF.Debug.ShowCurrentMethodValue('CurrentShow',SELF.Debug.CurrentShow)
          SELF.Debug.See('Do Method Show TRUE or FALSE = ' & SELF.Debug.GetBOOL(SELF.Debug.GetShow(jcDebug::MethodShow)))
          SELF.Debug.SetMethodName('GetFields','(*CLASS Q,<USHORT StartPosition>)')
          SELF.Debug.ShowCurrentMethodValue('GetMethodName()',SELF.Debug.GetMethodName())
          SELF.Debug.ShowCurrentMethodValue('GetShow((GetFields,(*CLASS Q,<USHORT StartPosition>)',SELF.Debug.GetBOOL(SELF.Debug.GetShow(SELF.GetMethodName()),_Showing))
      OF 'After calling MethodStart in GetFields Method'
          SELF.Debug.ShowCurrentMethodValue('GetCurrentShow()',SELF.Debug.GetBOOL(SELF.Debug.GetCurrentShow(),_Showing))
          SELF.Debug.ShowCurrentMethodValue('CurrentShow',SELF.Debug.CurrentShow)
          SELF.Debug.See('Do Method Show TRUE or FALSE = ' & SELF.Debug.GetBOOL(SELF.Debug.GetShow(jcDebug::MethodShow)))
          SELF.Debug.ShowCurrentMethodValue('GetShow()',SELF.Debug.GetBOOL(SELF.Debug.GetShow(jcDebug::MethodShow & jcDebug::Dot & SELF.GetMethodName()),_Showing))
      END
    SELF.Debug.Fin()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
! jcField CLASS
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Construct  PROCEDURE
  CODE
    SELF.critSect &= NewCriticalSection()
    SELF.Q &= NEW(QFields)
?   ASSERT(~SELF.Q &= NULL,'jcFieldClass.Q not initialized properly to the queue QFields')    
    SORT(SELF.Q,SELF.Q.Structure,SELF.Q.FieldName,SELF.Q.Type,SELF.Q.Format,SELF.Q.Value)   
    SELF.G &= NEW(jcFieldGroupC)
?   ASSERT(~SELF.G &= NULL,'jcFieldClass.G not initialized properly to the group jcFieldGroup')    
    SELF.Debug &= NEW(jcDebugManager)
?   ASSERT(~SELF.Debug &= NULL,'jcFieldClass.Debug not initialized properly to jcDebugManager class')    
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Destruct   PROCEDURE
  CODE
    FREE(SELF.Q)
    DISPOSE(SELF.Q)
    DISPOSE(SELF.G)
    DISPOSE(SELF.Debug)
    SELF.critSect.Kill()
!-----------------------------------------------------------------------------------------------------------------------------------    
jcFieldClass.Init       PROCEDURE
  CODE
    SELF.Debug.Init()
    SELF.Debug.SetSelectiveShow(FALSE)
    SELF.Debug.SetDebugState(jcFieldDebugShow:jcFieldClass)
    SELF.Debug.SetClassName(SELF.GetClassName())
!-----------------------------------------------------------------------------------------------------------------------------------    
jcFieldClass.Kill       PROCEDURE
  CODE
    SELF.Debug.Kill()
!-----------------------------------------------------------------------------------------------------------------------------------    
jcFieldClass.MethodStart    PROCEDURE (ASTRING MethodName,<ASTRING Prototype>,<BOOL Show>,<SHORT SpaceMargin>)   !Set Method it check for margin Set the MethodName and MethodStart
  CODE
    SELF.SetMethodName(MethodName,Prototype)
    SELF.Debug.Method(MethodName,Prototype,Show,SpaceMargin)
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.MethodEnd  PROCEDURE ()                 !Show to Debug View the end of the Method
  CODE
    SELF.Debug.Fin()
    SELF.SetMethodName(SELF.Debug.GetMethodNameOnly(),SELF.Debug.GetParameterString())
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.CreateStructure    PROCEDURE (ASTRING StructureName)
MethodName                EQUATE('CreateStructure')
Prototype                 EQUATE('(ASTRING StructureName)')
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:CreateStructure)
      SELF.SetStructure(StructureName)    
    SELF.MethodEnd()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------    
jcFieldClass.SetStructure    PROCEDURE (ASTRING StructureName)
MethodName                      EQUATE('SetStructure')
Prototype                       EQUATE('(ASTRING StructureName),ASTRING')
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:SetStructure)
      SELF.Structure = StructureName
    SELF.MethodEnd()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------    
jcFieldClass.GetStructure    PROCEDURE ()
MethodName                      EQUATE('GetStructure')
Prototype                       EQUATE('(),ASTRING')
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:GetStructure)
      SELF.Debug.ShowCurrentMethodValue('Structure',SELF.Structure)
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN SELF.Structure
!-----------------------------------------------------------------------------------------------------------------------------------    
jcFieldClass.CreateField    PROCEDURE (ASTRING FieldName,ASTRING Type,? Value,<ASTRING Format>,<USHORT Length>,<USHORT DecimalLength>)
MethodName                EQUATE('CreateField')
Prototype                 EQUATE('(ASTRING FieldName,ASTRING Type,? Value,<ASTRING Format>,<USHORT Length>,<USHORT DecimalLength>)')
PrepareType               ASTRING
Response                  BOOL

  CODE
    SELF.critSect.Wait()
    SELF.Debug.SetOverrideSpaceMargin(4)
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:CreateField,SELF.Debug.GetNumberSpaceMargin())
      IF OMITTED(6) OR Length = 0 THEN Length = 1.
      Response = SELF.SetField(FieldName,Type,Value,Format,Length,DecimalLength)
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------    
jcFieldClass.SetField   PROCEDURE (ASTRING FieldName,ASTRING Type,? Value,<ASTRING Format>,<USHORT Length>,<USHORT DecimalLength>)
MethodName            EQUATE('SetField')
Prototype             EQUATE('(ASTRING FieldName,ASTRING Type,? Value,<ASTRING Format>,<USHORT Length>,<USHORT DecimalLength>)')
PrepareType           ASTRING
Response              BOOL
F                     &jcFieldClass
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:SetField)
      PrepareType = Type
      F &= NEW(jcFieldClass)
      F &= SELF
      Response = TRUE
      CLEAR(SELF.Q)
      SELF.Q.Structure = SELF.GetStructure()
      SELF.Q.Format = Format
      SELF.Q.FieldName = FieldName
      CASE UPPER(Type)
        OF jc:BYTE
          PrepareType = jc:BYTE
          F.bField &= NEW BYTE
          F.bField = Value
          SELF.Q.bField = F.bField
          SELF.Q.FormatedField = FORMAT(SELF.Q.bField,SELF.Q.Format)
          SELF.Debug.ShowValue('F.bField',F.bField)
        OF jc:SHORT
          PrepareType = jc:SHORT
          F.hField &= NEW SHORT
          F.hField = Value
          SELF.Q.Value = F.hField
          SELF.Q.hField = F.hField
          SELF.Q.FormatedField = FORMAT(SELF.Q.hField,SELF.Q.Format)
        OF jc:USHORT
          PrepareType = jc:USHORT
          F.uhField &= NEW USHORT
          F.uhField = Value
          SELF.Q.Value = F.uhField
          SELF.Q.uhField = F.uhField
          SELF.Q.FormatedField = FORMAT(SELF.Q.uhField,SELF.Q.Format)
        OF jc:LONG
          PrepareType = jc:LONG
          F.lField &= NEW LONG
          F.lField = Value
          SELF.Q.Value = F.lField
          SELF.Q.lField = F.lField
          SELF.Q.FormatedField = FORMAT(SELF.Q.lField,SELF.Q.Format)
        OF jc:ULONG
          PrepareType = jc:ULONG
          F.ulField &= NEW ULONG
          F.ulField = Value
          SELF.Q.Value = F.ulField
          SELF.Q.ulField = F.ulField
          SELF.Q.FormatedField = FORMAT(SELF.Q.ulField,SELF.Q.Format)
        OF jc:REAL
          PrepareType = jc:REAL
          F.rField &= NEW REAL
          F.rField = Value
          SELF.Q.Value = F.rField
          SELF.Q.rField = F.rField
          SELF.Q.FormatedField = FORMAT(SELF.Q.rField,SELF.Q.Format)
        OF jc:SREAL
          PrepareType = jc:SREAL
          F.srField &= NEW SREAL
          F.srField = Value
          SELF.Q.Value = F.srField
          SELF.Q.srField = F.srField
          SELF.Q.FormatedField = FORMAT(SELF.Q.srField,SELF.Q.Format)
        OF jc:STRING
          PrepareType = jc:STRING & '(' & Length & ')'
          F.sField &= NEW STRING(Length)
          F.sField = Value
          SELF.Q.Value = F.sField
          SELF.Q.sField &= NEW STRING(Length)
          SELF.Q.sField = F.sField
          SELF.Q.FormatedField = FORMAT(SELF.Q.sField,SELF.Q.Format)
          SELF.Debug.ShowValue('F.sField',F.sField)
        OF jc:CSTRING
          PrepareType = jc:CSTRING & '(' & Length & ')'
          F.csField &= NEW CSTRING(Length)
          F.csField = Value
          SELF.Q.Value = F.csField
          SELF.Q.csField &= NEW CSTRING(Length)
          SELF.Q.csField = F.csField
          SELF.Q.FormatedField = FORMAT(SELF.Q.csField,SELF.Q.Format) 
        OF jc:PSTRING
          PrepareType = jc:PSTRING & '(' & Length & ')'
          F.psField &= NEW PSTRING(Length)
          F.psField = Value
          SELF.Q.Value = F.psField
          SELF.Q.psField &= NEW PSTRING(Length)
          SELF.Q.psField = F.psField
          SELF.Q.FormatedField = FORMAT(SELF.Q.psField,SELF.Q.Format)
        OF jc:DECIMAL
          PrepareType = jc:DECIMAL & '(' & Length & ',' & DecimalLength & ')'
          F.dField &= NEW DECIMAL(Length,DecimalLength)
          F.dField = Value
          SELF.Q.Value = F.dField
          SELF.Q.dField &= NEW DECIMAL(Length,DecimalLength)
          SELF.Q.dField = F.dField
          SELF.Q.FormatedField = FORMAT(SELF.Q.dField,SELF.Q.Format)
          SELF.Debug.ShowValue('F.dField',F.dField)
        OF jc:PDECIMAL
          PrepareType = jc:PDECIMAL & '(' & Length & ',' & DecimalLength & ')'
          F.pdField &= NEW PDECIMAL(Length,DecimalLength)
          F.pdField = Value
          SELF.Q.Value = F.pdField
          SELF.Q.pdField &= NEW PDECIMAL(Length,DecimalLength)
          SELF.Q.pdField = F.pdField
          SELF.Q.FormatedField = FORMAT(SELF.Q.pdField,SELF.Q.Format)
        OF jc:DATE
          PrepareType = jc:DATE 
          F.dtField &= NEW DATE
          F.dtField = Value
          SELF.Q.Value = F.dtField
          SELF.Q.dtField = F.dtField
          SELF.Q.FormatedField = FORMAT(SELF.Q.dtField,SELF.Q.Format)
        OF jc:TIME
          PrepareType = jc:TIME
          F.tField &= NEW TIME
          F.tField = Value
          SELF.Q.Value = F.tField
          SELF.Q.tField = F.tField
          SELF.Q.FormatedField = FORMAT(SELF.Q.tField,SELF.Q.Format)
        OF jc:BFLOAT4
          PrepareType = jc:BFLOAT4
          F.bf4Field &= NEW BFLOAT4
          F.bf4Field = Value
          SELF.Q.Value = F.bf4Field
          SELF.Q.bf4Field = F.bf4Field
          SELF.Q.FormatedField = FORMAT(SELF.Q.bf4Field,SELF.Q.Format)
        OF jc:BFLOAT8
          PrepareType = jc:BFLOAT8
          F.bf8Field &= NEW BFLOAT8
          F.bf8Field = Value
          SELF.Q.Value = F.bf8Field
          SELF.Q.bf8Field = F.bf8Field        
          SELF.Q.FormatedField = FORMAT(SELF.Q.bf8Field,SELF.Q.Format)
        OF jc:Record    
          PrepareType = jc:RECORD
          SELF.Q.Value = jc:RECORD
        ELSE
          MESSAGE(FieldName & ' of type ' & Type & '|' & _WrongFieldType)
          Response = FALSE
      END      
      SELF.Q.Type = PrepareType
      SELF.Add(SELF.Q)
      F &= NULL
      DISPOSE(F)   
      SELF.ShowFields()
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response

!-----------------------------------------------------------------------------------------------------------------------------------
!jcFieldClass.UpdateDefinition    PROCEDURE (*QFields FieldDefinition)
jcFieldClass.UpdateDefinition    PROCEDURE ()
MethodName                    EQUATE('UpdateDefinition')
Prototype                     EQUATE('()')
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:UpdateDefinition)
!      CLEAR(SELF.Q)
!      SELF.Q = FieldDefinition
      PUT(SELF.Q)
    SELF.MethodEnd()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.ShowFields PROCEDURE ()
MethodName            EQUATE('ShowFields')
Prototype             EQUATE('()')
Response              BOOL
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:ShowFields)
      SELF.Debug.ShowCurrentMethodValue('Q.Structure',SELF.Q.Structure)
      SELF.Debug.ShowCurrentMethodValue('Q.FieldName',SELF.Q.FieldName)
      SELF.Debug.ShowCurrentMethodValue('Q.Type',SELF.Q.Type)
      SELF.Debug.ShowCurrentMethodValue('Q.Value',SELF.Q.Value)
      SELF.Debug.ShowCurrentMethodValue('Q.Format',SELF.Q.Format)
      SELF.Debug.ShowCurrentMethodValue('Q.FormatedField',SELF.Q.FormatedField)
      SELF.Debug.ShowCurrentMethodValue('Q.bField',SELF.Q.bField)
      SELF.Debug.ShowCurrentMethodValue('Q.hField',SELF.Q.hField)
      SELF.Debug.ShowCurrentMethodValue('Q.uhField',SELF.Q.uhField)
      SELF.Debug.ShowCurrentMethodValue('Q.lField',SELF.Q.lField)
      SELF.Debug.ShowCurrentMethodValue('Q.ulField',SELF.Q.ulField)
      SELF.Debug.ShowCurrentMethodValue('Q.rField',SELF.Q.rField)
      SELF.Debug.ShowCurrentMethodValue('Q.srField',SELF.Q.srField)
      SELF.Debug.ShowCurrentMethodValue('Q.sField',SELF.Q.sField)
      SELF.Debug.ShowCurrentMethodValue('Q.csField',SELF.Q.csField)
      !SELF.Debug.ShowCurrentMethodValue('Q.psField',SELF.Q.psField)
      SELF.Debug.ShowCurrentMethodValue('Q.dField',SELF.Q.dField)
      !SELF.Debug.ShowCurrentMethodValue('Q.pdField',SELF.Q.pdField)
      SELF.Debug.ShowCurrentMethodValue('Q.dtField',SELF.Q.dtField)
      SELF.Debug.ShowCurrentMethodValue('Q.tField',SELF.Q.tField)
      SELF.Debug.ShowCurrentMethodValue('Q.aField',SELF.Q.aField)
      SELF.Debug.ShowCurrentMethodValue('Q.bf4Field',SELF.Q.bf4Field)
      SELF.Debug.ShowCurrentMethodValue('Q.bf8Field',SELF.Q.bf8Field)
    SELF.MethodEnd()
    SELF.critSect.Wait()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Add   PROCEDURE (*QFields Q)
MethodName            EQUATE('Add')
Prototype             EQUATE('(*QFields Q)')
Response              BOOL
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:Add)
      !SELF.critSect.Wait()
      IF NOT Q &= NULL  THEN
        GET(Q,Q.Structure,Q.FieldName,Q.Type,Q.Format,Q.Value)
        IF ERRORCODE() = 30 THEN 
          ADD(Q)
          SELF.Debug.See('Add Record to Q')
          Response = TRUE
        ELSE
          SELF.Debug.See('No record to Q')
          Response = FALSE
        END
      END
      !SELF.critSect.Release()
      SELF.ShowFields()
    SELF.MethodEnd()
    !SELF.critSect.Release()
    RETURN Response
!----------------------------------------------------------------------------------------------------------------
jcFieldClass.Add   PROCEDURE (*QFields Q,*jcFieldGroupC G)
MethodName            EQUATE('Add')
Prototype             EQUATE('(*QField Q,*jcFieldGroup G)')
Response              BOOL
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:Add2)
      SELF.critSect.Wait()
      CLEAR(Q)
?     ASSERT(~Q &=NULL,'Q not initialized properly to the Queue QFields')  
      IF NOT G &= NULL  THEN
        SELF.SetPairQ(Q,G)
        GET(Q,Q.Structure,Q.FieldName,Q.Type,Q.Format,Q.Value)
        IF ERRORCODE() = 30 THEN 
          ADD(Q,Q.FieldName,Q.Type,Q.Format,Q.Value)
          Response = TRUE
        ELSE
          Response = FALSE
        END
      END
      SELF.critSect.Release()
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!----------------------------------------------------------------------------------------------------------------
jcFieldClass.SetPairQ   PROCEDURE(*QFields Q,*jcFieldGroupC G)
MethodName            EQUATE('SetPair')
Prototype             EQUATE('(*QFields Q,*jcFieldGroupC G)')
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:SetPairQ)
      Q.FieldName = G.FieldName
      Q.Format = G.Format
      Q.FormatedField = G.FormatedField
      Q.Type = G.Type
      Q.Value = G.Value
      Q.bField = G.bField
      Q.aField = G.aField
      Q.bf4Field = G.bf8Field
      Q.csField = G.csField
      Q.dField = G.dField
      Q.dtField = G.dtField
      Q.hField = G.hField
      Q.lField = G.lField
      Q.pdField = G.pdField
      Q.psField = G.psField
      Q.rField = G.rField
      Q.sField = G.sField
      Q.srField = G.srField
      Q.tField = G.tField
      Q.uhField = G.uhField
      Q.ulField = G.ulField
      SELF.ShowFields()
    SELF.MethodEnd()
    SELF.critSect.Release()
!----------------------------------------------------------------------------------------------------------------
jcFieldClass.SetPairG   PROCEDURE(*jcFieldGroupC G,*QFields Q)
MethodName            EQUATE('SetPair')
Prototype             EQUATE('(*jcFieldGroupC G,*QFields Q)')
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:SetPairG)
      G &= NULL
      G &= NEW(jcFieldGroupC)
      G.FieldName = Q.FieldName
      G.Format = Q.Format
      G.FormatedField = Q.FormatedField
      G.Type = Q.Type
      G.Value = Q.Value
      G.bField = Q.bField
      G.aField = Q.aField
      G.bf4Field = Q.bf8Field
      G.csField = Q.csField
      G.dField = Q.dField
      G.dtField = Q.dtField
      G.hField = Q.hField
      G.lField = Q.lField
      G.pdField = Q.pdField
      G.psField = Q.psField
      G.rField = Q.rField
      G.sField = Q.sField
      G.srField = Q.srField
      G.tField = Q.tField
      G.uhField = Q.uhField
      G.ulField = Q.ulField
      SELF.ShowFields()
    SELF.MethodEnd()
    SELF.critSect.Release()
!----------------------------------------------------------------------------------------------------------------
jcFieldClass.Get       PROCEDURE(ASTRING FieldName)                   !Read Queue BaseAny on FieldName, return true on successfull read
MethodName                EQUATE('Get')
Prototype                 EQUATE('(ASTRING FieldName)')
Response                  BYTE

  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:Get)
      SELF.critSect.Wait()
      CLEAR(SELF.Q)
?     ASSERT(~SELF.Q &=NULL,'Queue QBase not initialized')     
      !SELF.SetPairQ(SELF.Q,SELF.G)
      SELF.Q.Structure = SELF.GetStructure()
      SELF.Q.FieldName = FieldName
      GET(SELF.Q,SELF.Q.Structure,SELF.Q.FieldName)
      IF ERROR() THEN
        Response = 1  
      ELSE 
        SELF.Debug.ShowCurrentMethodValue('Q.Type',SELF.Q.Type)
        Response = 2
      END
    SELF.MethodEnd()
    EXECUTE Response
      RETURN jcBases::Error
      RETURN SELF.GetData()
    END 
!----------------------------------------------------------------------------------------------------------------
jcFieldClass.WhatIs      PROCEDURE(ASTRING FieldName)                  
MethodName            EQUATE('WhatIs')
Prototype             EQUATE('(ASTRING FieldName)')
Response              ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:WhatIs)
      SELF.critSect.Wait()
      CLEAR(SELF.Q)
?     ASSERT(~SELF.Q &=NULL,'Queue QBase not initialized')     
      !SELF.SetPairQ(SELF.Q,SELF.G)
      SELF.Q.Structure = SELF.GetStructure()
      SELF.Q.FieldName = FieldName
      GET(SELF.Q,SELF.Q.Structure,SELF.Q.FieldName)
      IF ERROR() THEN
        Response = jcBases::Error
      ELSE 
!        SELF.G = SELF.Q
        SELF.Debug.ShowCurrentMethodValue('Q.Type',SELF.Q.Type)
        Response = SELF.FieldTypeIs(SELF.Q.Type)
      END
      SELF.critSect.Release()
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!----------------------------------------------------------------------------------------------------------------
jcFieldClass.GetData    PROCEDURE()
MethodName            EQUATE('GetData')
Prototype             EQUATE('()')
Response              ANY
TypeCase              ASTRING
TypeTemp              ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:GetData)
      SELF.ShowFields()
    !TypeCase = SELF.PrepareType(Type)
      SELF.Debug.ShowValue('Type',SELF.PrepareType(SELF.Q.Type))
    SELF.MethodEnd()
    SELF.critSect.Release()
      CASE SELF.PrepareType(SELF.Q.Type)    
      OF jc:BYTE;    RETURN SELF.Q.bField
      OF jc:SHORT;   RETURN SELF.Q.hField
      OF jc:USHORT;  RETURN SELF.Q.uhField
      OF jc:LONG;    RETURN SELF.Q.lField 
      OF jc:ULONG;   RETURN SELF.Q.ulField
      OF jc:REAL;    RETURN SELF.Q.rField
      OF jc:SREAL;   RETURN SELF.Q.srField
      OF jc:STRING;  RETURN SELF.Q.sField
      OF jc:CSTRING; RETURN SELF.Q.csField
      OF jc:PSTRING; RETURN SELF.Q.psField
      OF jc:DECIMAL; RETURN SELF.Q.dField
      OF jc:PDECIMAL;RETURN SELF.Q.pdField
      OF jc:DATE;    RETURN SELF.Q.dtField
      OF jc:TIME;    RETURN SELF.Q.tField
      OF jc:BFLOAT4; RETURN SELF.Q.bf4Field
      OF jc:BFLOAT8; RETURN SELF.Q.bf8Field
      ELSE
        Response = TypeCase  & _WrongFieldType & SELF.GetMethodName()
        RETURN Response
      END      
!----------------------------------------------------------------------------------------------------------------------  
jcFieldClass.GetSize    PROCEDURE(ASTRING FieldName)
MethodName            EQUATE('GetSize')
Prototype             EQUATE('(ASTRING FieldName)')
Response              LONG
TypeCase              ASTRING
TypeTemp              ASTRING

  CODE
    SELF.critSect.Wait()
    SELF.ShowFields()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:GetSize)
      !TypeCase = SELF.PrepareType(Type)
      CASE SELF.PrepareType(SELF.Q.Type)    
      OF jc:BYTE;    Response = SIZE(SELF.Q.bField)
      OF jc:SHORT;   Response = SIZE(SELF.Q.hField)
      OF jc:USHORT;  Response = SIZE(SELF.Q.uhField)
      OF jc:LONG;    Response = SIZE(SELF.Q.lField)
      OF jc:ULONG;   Response = SIZE(SELF.Q.ulField)
      OF jc:REAL;    Response = SIZE(SELF.Q.rField)
      OF jc:SREAL;   Response = SIZE(SELF.Q.srField)
      OF jc:STRING;  Response = SIZE(SELF.Q.sField)
      OF jc:CSTRING; Response = SIZE(SELF.Q.csField)
      OF jc:PSTRING; Response = SIZE(SELF.Q.psField)
      OF jc:DECIMAL; Response = SIZE(SELF.Q.dField)
      OF jc:PDECIMAL;Response = SIZE(SELF.Q.pdField)
      OF jc:DATE;    Response = SIZE(SELF.Q.dtField)
      OF jc:TIME;    Response = SIZE(SELF.Q.tField)
      OF jc:BFLOAT4; Response = SIZE(SELF.Q.bf4Field)
      OF jc:BFLOAT8; Response = SIZE(SELF.Q.bf8Field)
      ELSE
        Response = TypeCase  & _WrongFieldType & SELF.GetMethodName()        
      END      
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!----------------------------------------------------------------------------------------------------------------------  
jcFieldClass.FieldTypeIs   PROCEDURE(ASTRING Type)
MethodName                EQUATE('FieldTypeIs')
Prototype                 EQUATE('(ASTRING Type)')
Response                  ASTRING
TypeCase                  ASTRING
  CODE
    !SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:FieldTypeIs)
      !TypeCase = SELF.PrepareType(Type)
    SELF.MethodEnd()
      CASE SELF.PrepareType(Type)    
      OF jc:BYTE;    RETURN SELF.Is(SELF.Q.bField)
      OF jc:SHORT;   RETURN SELF.Is(SELF.Q.hField)
      OF jc:USHORT;  RETURN SELF.Is(SELF.Q.uhField)
      OF jc:LONG;    RETURN SELF.Is(SELF.Q.lField)
      OF jc:ULONG;   RETURN SELF.Is(SELF.Q.ulField)
      OF jc:REAL;    RETURN SELF.Is(SELF.Q.rField)
      OF jc:SREAL;   RETURN SELF.Is(SELF.Q.srField)
      OF jc:STRING;  RETURN SELF.Is(SELF.Q.sField)
      OF jc:CSTRING; RETURN SELF.Is(SELF.Q.csField)
      OF jc:PSTRING; RETURN SELF.Is(SELF.Q.psField)
      OF jc:DECIMAL; RETURN SELF.Is(SELF.Q.dField)
      OF jc:PDECIMAL;RETURN SELF.Is(SELF.Q.pdField)
      OF jc:DATE;    RETURN SELF.Is(SELF.Q.dtField)
      OF jc:TIME;    RETURN SELF.Is(SELF.Q.tField)
      OF jc:BFLOAT4; RETURN SELF.Is(SELF.Q.bf4Field)
      OF jc:BFLOAT8; RETURN SELF.Is(SELF.Q.bf8Field)
      ELSE
        Response = TypeCase & _WrongFieldType & SELF.GetMethodName()
        RETURN Response
      END      
    
!----------------------------------------------------------------------------------------------------------------------  
jcFieldClass.PrepareType    PROCEDURE (ASTRING Type)
MethodName                EQUATE('PrepareType')
Prototype                 EQUATE('(ASTRING Type)')
Response                  ASTRING
TypeCase                  ASTRING
TypeTemp                  ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:PrepareType)
      TypeCase = Type
      IF INSTRING(jc:CSTRING,TypeCase,1,1) THEN TypeTemp = jc:CSTRING
      ELSIF INSTRING(jc:PSTRING,TypeCase,1,1) THEN TypeTemp = jc:PSTRING
      ELSIF INSTRING(jc:STRING,TypeCase,1,1) THEN TypeTemp = jc:STRING
      ELSIF INSTRING(jc:PDECIMAL,TypeCase,1,1) THEN TypeTemp = jc:PDECIMAL
      ELSIF INSTRING(jc:DECIMAL,TypeCase,1,1) THEN TypeTemp = jc:DECIMAL
      ELSE TypeTemp = TypeCase.
      TypeCase = UPPER(TypeTemp)
      SELF.Debug.ShowValue('TypeCase',TypeCase)
    SELF.MethodEnd()
    SELF.critSect.Wait()
    RETURN TypeCase
!----------------------------------------------------------------------------------------------------------------------  
jcFieldClass.GetString  PROCEDURE (? Field)
MethodName                EQUATE('GetString')
Prototype                 EQUATE('(? Field)')
Response                  ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:GetString)
      Response = Field
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!----------------------------------------------------------------------------------------------------------------------  
jcFieldClass.Set        PROCEDURE(ASTRING FieldName,? Value)
MethodName                EQUATE('Set')
Prototype                 EQUATE('(ASTRING FieldName,? Value))')
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:Set)
       SELF.Update(FieldName,Value)
    SELF.MethodEnd()
    SELF.critSect.Release()
!----------------------------------------------------------------------------------------------------------------------  
jcFieldClass.Update   PROCEDURE(ASTRING FieldName,? ValueReplacement) !Replace the Value of the read FieldName and Value Queue Record
MethodName              EQUATE('Update')
Prototype               EQUATE('(ASTRING FieldName,ASTRING ValueReplacement)')
TypeCase                ASTRING
TypeTemp                ASTRING
Response                BOOL
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:Update)
      SELF.critSect.Wait()
      CLEAR(SELF.Q)
      IF SELF.Get(FieldName) THEN 
!        SELF.SetPairQ(SELF.Q,SELF.G)
        !TypeCase = SELF.PrepareType(SELF.Q.Type)
        SELF.Q.Structure = SELF.GetStructure()
        SELF.Q.FieldName = FieldName 
        SELF.Q.Value = ValueReplacement
        CASE SELF.PrepareType(SELF.Q.Type)    
        OF jc:BYTE
          SELF.Q.bField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.bField,SELF.Q.Format)
        OF jc:SHORT
          SELF.Q.hField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.hField,SELF.Q.Format)
        OF jc:USHORT
          SELF.Q.uhField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.uhField,SELF.Q.Format)
        OF jc:LONG
          SELF.Q.lField = SELF.Q.Value 
          SELF.Q.FormatedField = FORMAT(SELF.Q.lField,SELF.Q.Format)
        OF jc:ULONG
          SELF.Q.ulField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.ulField,SELF.Q.Format)
        OF jc:REAL
          SELF.Q.rField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.rField,SELF.Q.Format)
        OF jc:SREAL    
          SELF.Q.srField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.srField,SELF.Q.Format)
        OF jc:STRING
          SELF.Q.sField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.sField,SELF.Q.Format)
        OF jc:CSTRING
          SELF.Q.csField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.csField,SELF.Q.Format)
        OF jc:PSTRING
          SELF.Q.psField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.psField,SELF.Q.Format)
        OF jc:DECIMAL
          SELF.Q.dField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.dField,SELF.Q.Format)
        OF jc:PDECIMAL
          SELF.Q.pdField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.pdField,SELF.Q.Format)
        OF jc:DATE
          SELF.Q.dtField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.dtField,SELF.Q.Format)
        OF jc:TIME
          SELF.Q.tField = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.tField,SELF.Q.Format)
        OF jc:BFLOAT4
          SELF.Q.bf4Field = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.bf4Field,SELF.Q.Format)
        OF jc:BFLOAT8
          SELF.Q.bf8Field = SELF.Q.Value
          SELF.Q.FormatedField = FORMAT(SELF.Q.bf8Field,SELF.Q.Format)
        ELSE
          Response = TypeCase & _WrongFieldType & SELF.GetMethodName()
        END      
        PUT(SELF.Q)
        Response = TRUE
      ELSE
        Response = FALSE
      END
      SELF.critSect.Release()
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!----------------------------------------------------------------------------------------------------------------
jcFieldClass.Update   PROCEDURE(ASTRING ValueReplacement) !Replace the Value of the current Queue Record
MethodName            EQUATE('Update')
Prototype             EQUATE('(ASTRING ValueReplacement)')
TypeCase              ASTRING
TypeTemp              ASTRING
Response              BOOL
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:Update2)
      SELF.critSect.Wait()
      SELF.Debug.See('Before assignment')
      SELF.ShowFields()
      !TypeCase = SELF.PrepareType(SELF.Q.Type)
!      SELF.SetPairQ(SELF.Q,SELF.G)
      SELF.Q.Value = ValueReplacement
      SELF.Q.FormatedField = FORMAT(SELF.Q.Value,SELF.Q.Format)
      CASE SELF.PrepareType(SELF.Q.Type)    
      OF jc:BYTE;     SELF.Q.bField = SELF.Q.Value
      OF jc:SHORT;    SELF.Q.hField = SELF.Q.Value
      OF jc:USHORT;   SELF.Q.uhField = SELF.Q.Value
      OF jc:LONG;     SELF.Q.lField = SELF.Q.Value 
      OF jc:ULONG;    SELF.Q.ulField = SELF.Q.Value
      OF jc:REAL;     SELF.Q.rField = SELF.Q.Value
      OF jc:SREAL;    SELF.Q.srField = SELF.Q.Value
      OF jc:STRING;   SELF.Q.sField = SELF.Q.Value
      OF jc:CSTRING;  SELF.Q.csField = SELF.Q.Value
      OF jc:PSTRING;  SELF.Q.psField = SELF.Q.Value
      OF jc:DECIMAL;  SELF.Q.dField = SELF.Q.Value
      OF jc:PDECIMAL; SELF.Q.pdField = SELF.Q.Value
      OF jc:DATE;     SELF.Q.dtField = SELF.Q.Value
      OF jc:TIME;     SELF.Q.tField = SELF.Q.Value
      OF jc:BFLOAT4;  SELF.Q.bf4Field = SELF.Q.Value
      OF jc:BFLOAT8;  SELF.Q.bf8Field = SELF.Q.Value
      ELSE
        Response = TypeCase & _WrongFieldType & SELF.GetMethodName()
      END      
      PUT(SELF.Q)
      IF ERROR() THEN
        Response = FALSE
      ELSE
        Response = TRUE
      END
      SELF.critSect.Release()
      SELF.Debug.See('After assignment')
      SELF.ShowFields()
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
!----------------------------------------------------------------------------------------------------------------
jcFieldClass.Delete    PROCEDURE (ASTRING FieldName)
MethodName                EQUATE('Delete')
Prototype                 EQUATE('(ASTRING FieldName)')
Response                  BOOL
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDebugShow:Delete)
      SELF.critSect.Wait()
      CLEAR(SELF.Q)
      SELF.Q.Structure = SELF.GetStructure()
      SELF.Q.FieldName = FieldName
      GET(SELF.Q,SELF.Q.Structure,SELF.Q.FieldName)
      IF ERROR() THEN
        Response = FALSE
      ELSE
        DELETE(SELF.Q)
        Response = TRUE
      END  
      DO ShowResponse
      SELF.critSect.Release()
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
ShowResponse        ROUTINE
  IF Response = TRUE
    SELF.Debug.ShowValue('Field is deleted')
  ELSE
    SELF.Debug.ShowValue('Field is NOT deleted')
  END
!----------------------------------------------------------------------------------------------------------------
jcFieldClass.SetTypeOnly       PROCEDURE(BOOL Type)          !IF type is to true then CSTRING, STRING or STRING[] will return only the field type CSTRING STRING Otherwise CSTRING(Length) STRING(Length)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    SELF.TypeOnly = Type   
!----------------------------------------------------------------------------------------------------------------
jcFieldClass.GetTypeOnly    PROCEDURE
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN SELF.TypeOnly
!----------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*FILE Field)          !Confirm if the field type is a FILE or not, if true then return 'FILE'
Fields                EQUATE(jc:FILE)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*KEY Field)           !Confirm if the field type is a KEY or not, if true then return 'KEY'
Fields                EQUATE(jc:KEY)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields    
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*WINDOW Field)        !Confirm if the field type is a WINDOW or not, if true then return 'WINDOW'
Fields                EQUATE(jc:WINDOW)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*BLOB Field)          !Confirm if the field type is a BLOB or not, if true then return 'BLOB'
Fields                EQUATE(jc:BLOB)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*VIEW Field)          !Confirm if the field type is a VIEW or not, if true then return 'VIEW'
Fields                EQUATE(jc:VIEW)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*REPORT Field)          !Confirm if the field type is a VIEW or not, if true then return 'VIEW'
Fields                EQUATE(jc:REPORT)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*ANY Field)           !Confirm if the field type is a ANY or not, if true then return 'ANY'
Fields                EQUATE(jc:ANY)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields 
!-----------------------------------------------------------------------------------------------------------------------------------

jcFieldClass.Is       PROCEDURE(*ASTRING Field)       !Confirm if the field type is a ASTRING or not, if true then return 'ASTRING'
Fields                EQUATE(jc:ASTRING)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*BFLOAT4 Field)       !Confirm if the field type is a BFLOAT4 or not
Fields                EQUATE(jc:BFLOAT4)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*BFLOAT8 Field)       !Confirm if the field type is a BFLOAT8 or not
Fields                EQUATE(jc:BFLOAT8)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*BYTE Field)          !Confirm if the field type is a BYTE or not
Fields                EQUATE(jc:BYTE)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*CSTRING Field)       !Confirm if the field type is a CSTRING or not
Fields                EQUATE(jc:CSTRING)
Response              ASTRING
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    IF SELF.GetTypeOnly() THEN
      Response = Fields
    ELSE
      Response = Fields & '(' & SIZE(Field) & ')'
    END
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*DATE Field)          !Confirm if the field type is a DATE or not
Fields                EQUATE(jc:DATE)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*DECIMAL Field)       !Confirm if the field type is a DECIMAL or not
Fields                EQUATE(jc:DECIMAL)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*GROUP G)             !Confirm if the field type is a GROUP or not
Fields                EQUATE(jc:GROUP)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*QUEUE Q)             !Confirm if the field type is a GROUP or not
Fields                EQUATE(jc:QUEUE)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*LONG Field)          !Confirm if the field type is a LONG or not
Fields                EQUATE(jc:LONG)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*PDECIMAL Field)      !Confirm if the field type is a PDECIMAL or not
Fields                EQUATE(jc:PDECIMAL)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*PSTRING Field)       !Confirm if the field type is a PSTRING or not
Fields                EQUATE(jc:PSTRING)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*REAL Field)          !Confirm if the field type is a REAL or not
Fields                EQUATE(jc:REAL)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*SHORT Field)         !Confirm if the field type is a SHORT or not
Fields                EQUATE(jc:SHORT)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
!jcFieldClass.Is       PROCEDURE(*SIGNED Field)        !Confirm if the field type is a SIGNED or not
!Fields              EQUATE('SIGNED')
!  CODE
!    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*SREAL Field)         !Confirm if the field type is a SREAL or not
Fields                EQUATE(jc:SREAL)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*STRING Field)        !Confirm if the field type is a STRING or not
Fields                EQUATE(jc:STRING)
Response              ASTRING
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    IF SELF.GetTypeOnly() THEN
      Response = Fields
    ELSE
      Response = Fields & '(' & SIZE(Field) & ')'
    END
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*TIME Field)          !Confirm if the field type is a TIME or not
Fields                EQUATE(jc:TIME)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*ULONG Field)         !Confirm if the field type is a ULONG or not
Fields                EQUATE(jc:ULONG)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
!jcFieldClass.Is       PROCEDURE(*UNSIGNED Field)      !Confirm if the field type is a UNSIGNED or not
!Fields              EQUATE('UNSIGNED')
!  CODE
!    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldClass.Is       PROCEDURE(*USHORT Field)        !Confirm if the field type is a USHORT or not
Fields                EQUATE(jc:USHORT)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
!-----------------------------------------------------------------------------------------------------------------------------------
!FieldsArray CLASS
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(ANY[] Field)         !Confirm if the field type is a ANY or not
Fields                EQUATE(jcDIM:Any)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*ASTRING[] Field)    !Confirm if the field type is a ASTRING or not
Fields                EQUATE(jcDIM:ASTRING)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*BFLOAT4[] Field)    !Confirm if the field type is a BFLOAT4 or not
Fields                EQUATE(jcDIM:BFLOAT4)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*BFLOAT8[] Field)    !Confirm if the field type is a BFLOAT8 or not
Fields                EQUATE(jcDIM:BFLOAT8)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*BYTE[] Field)       !Confirm if the field type is a BYTE or not
Fields                EQUATE(jcDIM:BYTE)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*CSTRING[] Field)    !Confirm if the field type is a CSTRING or not
Fields                EQUATE(jcDIM:CSTRING)
Response              ASTRING
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    Response = Fields & '(' & SIZE(Field) & ')'
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*DATE[] Field)       !Confirm if the field type is a DATE or not
Fields                EQUATE(jcDIM:DATE)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*DECIMAL[] Field)    !Confirm if the field type is a DECIMAL or not
Fields                EQUATE(jcDIM:DECIMAL)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*GROUP[] G)          !Confirm if the field type is a GROUP or not
Fields                EQUATE(jcDIM:GROUP)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*LONG[] Field)       !Confirm if the field type is a LONG or not
Fields                EQUATE(jcDIM:LONG)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*PDECIMAL[] Field)   !Confirm if the field type is a PDECIMAL or not
Fields                EQUATE(jcDIM:PDECIMAL)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*PSTRING[] Field)    !Confirm if the field type is a PSTRING or not
Fields                EQUATE(jcDIM:PSTRING)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*REAL[] Field)       !Confirm if the field type is a REAL or not
Fields                EQUATE(jcDIM:REAL)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*SHORT[] Field)      !Confirm if the field type is a SHORT or not
Fields                EQUATE(jcDIM:SHORT)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*SREAL[] Field)      !Confirm if the field type is a SREAL or not
Fields                EQUATE(jcDIM:SREAL)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*STRING[] Field)     !Confirm if the field type is a STRING or not
Fields                EQUATE(jcDIM:STRING)
Response              ASTRING
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    IF SELF.GetTypeOnly() THEN
      Response = Fields
    ELSE
      Response = Fields & '(' & SIZE(Field) & ')'
    END
    RETURN Response
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*TIME[] Field)       !Confirm if the field type is a TIME or not
Fields                EQUATE(jcDIM:TIME)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*ULONG[] Field)      !Confirm if the field type is a ULONG or not
Fields                EQUATE(jcDIM:ULONG)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldArray.Is   PROCEDURE(*USHORT[] Field)     !Confirm if the field type is a USHORT or not
Fields                EQUATE(jcDIM:USHORT)
critProc              CriticalProcedure
  CODE
    critProc.Init(SELF.critSect)
    RETURN Fields
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
!FieldDataManager CLASS
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldDataManager.Construct    PROCEDURE 

  CODE
    SELF.QD &= NEW(QFieldsData)    
?   ASSERT(~SELF.QD &= NULL,'jcFieldClass.QD not initialized properly to the queue QFieldsData')    
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldDataManager.Destruct PROCEDURE 

  CODE
    FREE(SELF.QD)
    DISPOSE(SELF.QD)
!-----------------------------------------------------------------------------------------------------------------------------------   
jcFieldDataManager.AddData  PROCEDURE (QFields Q)
MethodName                    EQUATE('AddData')
Prototype                     EQUATE('(QFields Q)')
Fields                        ASTRING
Index                         LONG
FieldsID                      LONG
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDDebugShow:AddData)
      CLEAR(SELF.QD)
      SELF.Debug.ShowCurrentMethodValue('GetStructure()',SELF.GetStructure())
      SELF.Debug.Loops('LOOP i# = 1 TO RECORDS(Q)',)
        FieldsID = 0
        LOOP Index = 1 TO RECORDS(Q)
          GET(Q,Index)
          IF Q.Structure = SELF.GetStructure() THEN
            FieldsID += 1
            SELF.QD.RecordRow[FieldsID] = Q
            SELF.Debug.ShowCurrentMethodValue('QD.RecordRow[' & FieldsID & '].Value',SELF.QD.RecordRow[FieldsID].Value)
            SELF.Debug.ShowValue(Q.FieldName,SELF.QD.RecordRow[FieldsID].Value)
            SELF.QD.NumberOfFields = FieldsID
          END
        END
      SELF.Debug.Fin()
      !SELF.Debug.ShowCurrentMethodValue('QD.RecordRow',SELF.QD.RecordRow)
      ADD(SELF.QD)
    SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldDataManager.UpdateData   PROCEDURE (QFields Q)
MethodName                        EQUATE('UpdateData')
Prototype                         EQUATE('(QFields Q)')
Response                          BOOL
Fields                            ASTRING
Index                             LONG
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDDebugShow:UpdateData)
      CLEAR(SELF.QD)
      LOOP Index= 1 TO RECORDS(Q)
        GET(Q,Index)
        IF Q.Structure = SELF.GetStructure() THEN
          SELF.QD.RecordRow[Index] = Q
        END
      END
      GET(SELF.QD,SELF.QD.RecordRow[Index])
      IF ERROR() THEN
        MESSAGE('Record do not exist')
      ELSE
        PUT(SELF.QD)
      END
    SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldDataManager.DeleteData   PROCEDURE (QFields Q)
MethodName                        EQUATE('DeleteData')
Prototype                         EQUATE('(QFields Q)')
Response                          BOOL
Fields                            ASTRING
Index                             LONG
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDDebugShow:DeleteData)
      CLEAR(SELF.QD)
      LOOP Index = 1 TO RECORDS(Q)
        GET(Q,Index)
        IF Q.Structure = SELF.GetStructure() THEN
          SELF.QD.RecordRow[Index] =  Q
        END
      END
      GET(SELF.QD,SELF.QD.RecordRow[Index])
      IF ERROR() THEN
        MESSAGE('Record do not exist')
      ELSE
        DELETE(SELF.QD)
      END
    SELF.MethodEnd()
!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldDataManager.GetHeaderColumns    PROCEDURE()
MethodName                                EQUATE('GetHeaderColumns')
Prototype                                 EQUATE('()')
Response                                  ASTRING
HeaderColumns                             ASTRING
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDDebugShow:GetHeaderColumns)
      DO GetHeaderColumns
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response

GetHeaderColumns             ROUTINE
  LOOP i# = 1 TO RECORDS(SELF.Q)
    GET(SELF.Q,i#)
    IF SELF.Q.Structure = SELF.GetStructure() THEN
      Response = CLIP(Response) & ' ' & FORMAT(SELF.Get(SELF.Q.FieldName),SELF.GetSize(SELF.Q.FieldName))
    END
  END

!-----------------------------------------------------------------------------------------------------------------------------------
jcFieldDataManager.ShowFieldDataQueue   PROCEDURE()
MethodName                                EQUATE('ShowFieldDataQueue')
Prototype                                 EQUATE('()')
ColumnRow                                 ASTRING
Index                                     LONG
NodeAction                                BOOL
FieldID                                  LONG
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDDebugShow:ShowFieldDataQueue)
      Index = 0
      DO HeaderColumns
      LOOP Index = 1 TO RECORDS(SELF.QD)
        GET(SELF.QD,index)
!!        SELF.Debug.ShowValue('Number of Node records',RECORDS(SELF.QD.RecordRow))
        DO ColumnsRow
       END
    SELF.MethodEnd()
HeaderColumns       ROUTINE
  SELF.Debug.ShowLine()
  CLEAR(ColumnRow)
  GET(SELF.QD,1)
  FieldID = 1
  LOOP SELF.QD.NumberOfFields TIMES
    ColumnRow = CLIP(ColumnRow) & ' ' & CLIP(SELF.QD.RecordRow[FieldID].FieldName) 
    SELF.Debug.ShowValue(SELF.QD.RecordRow[FieldID].FieldName,SELF.QD.RecordRow[FieldID].FormatedField,_Show)
    FieldID += 1
  END
  SELF.Debug.See(ColumnRow)
  SELF.Debug.ShowLine()
ColumnsRow          ROUTINE
  FieldID = 1
  CLEAR(ColumnRow)
  LOOP SELF.QD.NumberOfFields TIMES
    ColumnRow = CLIP(ColumnRow) & ' ' & CLIP(SELF.QD.RecordRow[FieldID].FormatedField) !SELF.Get(SELF.QD.RecordRow[IndexNode].FieldName)
   ! ColumnRow = CLIP(ColumnRow) & ' ' & CLIP(SELF.Get(SELF.QD.RecordRow[FieldID].FieldName,FieldID))
    SELF.Debug.ShowValue(SELF.QD.RecordRow[FieldID].FieldName,SELF.QD.RecordRow[FieldID].FormatedField,_Show)
    FieldID += 1
  END
  SELF.Debug.See(ColumnRow)
!-----------------------------------------------------------------------------------------------------------------------------------  
jcFieldDataManager.Get  PROCEDURE(ASTRING FieldName,USHORT FieldID)
MethodName                EQUATE('Get')
Prototype                 EQUATE('(ASTRING FieldName,USHORT FieldID)')
Response                  ANY
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDDebugShow:Get)
      SELF.critSect.Wait()
      DO ShowParameters
      !SELF.SetCurrentFieldID(FieldID)
      !SELF.Q = SELF.QD.RecordRow[SELF.GetCurrentFieldID()]
      CLEAR(SELF.Q)
      SELF.Q = SELF.QD.RecordRow[FieldID]
      GET(SELF.Q,SELF.Q.Structure,SELF.Q.FieldName)
      IF ERROR() THEN
        SELF.Debug.See('The definition do not exist')
        Response = jcBases::Error
      ELSE
        SELF.Debug.See('The field definition is found')
        SELF.UpdateDefinition()
        Response = SELF.Get(FieldName)
        SELF.Debug.ShowValue('FieldName value according to its type',Response)
      END
      SELF.critSect.Release()
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN Response
ShowParameters      ROUTINE
  SELF.Debug.Routines('ShowParameter',_Show)
    SELF.Debug.ShowValue('FieldName',FieldName)
    SELF.Debug.ShowValue('FieldID',FieldID)
  SELF.Debug.Fin()
!-----------------------------------------------------------------------------------------------------------------------------------  
jcFieldDataManager.SetCurrentFieldID  PROCEDURE(USHORT FieldID)
MethodName                EQUATE('SetCurrentFieldID')
Prototype                 EQUATE('(USHORT FieldID)')
Response                  SHORT
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDDebugShow:SetCurrentFieldID)
      SELF.critSect.Wait()
      SELF.CurrentFieldID = FieldID
      SELF.Debug.ShowCurrentMethodValue('CurrentFieldID',SELF.CurrentFieldID)
      SELF.critSect.Release()
    SELF.MethodEnd()
    SELF.critSect.Release()
!-----------------------------------------------------------------------------------------------------------------------------------  
jcFieldDataManager.GetCurrentFieldID  PROCEDURE()
MethodName                EQUATE('GetCurrentFieldID')
Prototype                 EQUATE('(),USHORT')
Response                  SHORT
  CODE
    SELF.critSect.Wait()
    SELF.MethodStart(MethodName,Prototype,jcFieldDDebugShow:GetCurrentFieldID)
      SELF.Debug.ShowCurrentMethodValue('CurrentFieldID',SELF.CurrentFieldID)
    SELF.MethodEnd()
    SELF.critSect.Release()
    RETURN SELF.CurrentFieldID
!-----------------------------------------------------------------------------------------------------------------------------------      