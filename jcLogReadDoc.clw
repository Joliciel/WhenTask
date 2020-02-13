
ManipulateReadDoc   PROCEDURE(BYTE Server,ASTRING ReadDocFile)

  CODE
    EXECUTE Server
      DO ReadDocAtBeginning
      DO ReadDocAtEnd
    END

ReadDocAtBeginning   ROUTINE
  FILE:DocFile = ReadDocFile
  ReadDoc.Init(DocFile,FILE:DocFile,,1)
  ReadDoc.ReadToQueue(Q,Q.String)
  ReadDoc.ViewLogFile()
  ReadDoc.CloseFile(DocFile)

ReadDocAtEnd        ROUTINE
  FILE:DocFile = ReadDocFile
  ReadDoc.Init(DocFile,FILE:DocFile,,1)
  ReadDoc.ReadQueueToLogFile(Q,Q.String)
  ReadDoc.CloseFile(DocFile)
  ReadDoc.Kill()

ManipulateReadInclude   PROCEDURE(STRING FileName,BYTE Server)
RecordRow                 ASTRING
WorkingFile               STRING(255)

  CODE
    DO PrepareWorkingFile
    EXECUTE Server
      DO ReadIncAtBeginning
      DO ReadIncAtEnd
    END

PrepareWorkingFile  ROUTINE  
  WorkingFile = 'Copy' & FileName
  COPY(FileName,WorkingFile)
  FILE:IncFile = WorkingFile

ReadIncAtBeginning  ROUTINE
  ReadInc.Init(IncFile,FILE:IncFile,,1)
  ReadInc.ReadToQueue(Qinc,Qinc.String,'INCLUDE')
  ReadInc.ViewLogFile()
  ReadInc.CloseFile(IncFile)

ReadIncAtEnd        ROUTINE
  ReadInc.Init(IncFile,FILE:IncFile,,1)
  ReadInc.ReadQueueToLogFile(QInc,QInc.String)
  ReadInc.CloseFile(IncFile)
  ReadInc.Kill()

  