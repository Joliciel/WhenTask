!ABCIncludeFile(Joliciel)
ReadDoc             jcLogManager
ReadInc             jcLogManager

FILE:DocFile        STRING(255)
FILE:IncFile        STRING(255)

_DoNothing          EQUATE(0)
_Read               EQUATE(1)
_Write              EQUATE(2)

_Beginning          EQUATE(1)
_End                EQUATE(2)


InputDocFile        EQUATE('c:\Dev\Docs\DMLDevDoc.txt')
OutputDocFile       EQUATE('c:\Dev\Docs\DMLDevDocLog.txt')


DocFile             FILE,DRIVER('ASCII'),NAME(FILE:DocFile),CREATE !,THREAD
Record                RECORD
Line                    STRING(2000)
                      END
                    END

IncFile             FILE,DRIVER('ASCII'),NAME(FILE:IncFile),CREATE !,THREAD
Record                RECORD
Line                    STRING(2000)
                      END
                    END

Q                   QUEUE
String                ASTRING
                    END

QInc                QUEUE
String                ASTRING
                    END
