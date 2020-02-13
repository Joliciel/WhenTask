
    MEMBER
    
  INCLUDE('jcStack.inc'),ONCE
  INCLUDE('cwsynchm.inc'),ONCE
  INCLUDE('cwsynchc.inc'),ONCE
  
  

  MAP
       MODULE('ImpShell2')
         SendToDebug(*CSTRING),RAW,PASCAL,NAME('OutputDebugStringA')
         VerQueryValue(Long,Long,Long,Long),Bool,Raw,Pascal,Name('VerQueryValueA')
       END
Debug          PROCEDURE(STRING Info,SHORT SpaceMargin)
  END
  
DebugState   BOOL(FALSE)

!--------------------------------------------------------------------------------------------------------------------------------
! METHOD SECTION  
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.Construct                      PROCEDURE() !When the class is instantiated
  CODE
    SELF.critSect &= NewCriticalSection()
    SELF.q &= NEW(stackQueue)    
    SELF.s &= NEW(stackNode)
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.Destruct                       PROCEDURE() !When the class is destroyed
  CODE
    FREE(SELF.q)   
    DISPOSE(SELF.q)
    DISPOSE(SELF.s)
    SELF.critSect.Kill()   
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.Init                           PROCEDURE() !Initialized
critProc    CriticalProcedure
  CODE   
  critProc.Init(SELF.critSect)
  SELF.s.prevNode &= NULL  
  SELF.SetAssertState(1)
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.kill                           PROCEDURE() !Killing
critProc    CriticalProcedure
  CODE   
  critProc.Init(SELF.critSect)
  LOOP UNTIL SELF.isEmpty() 
    SELF.pop()
  END
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.isEmpty                        PROCEDURE()  !If the stack is empty
critProc    CriticalProcedure
  CODE   
  critProc.Init(SELF.critSect)
  RETURN CHOOSE(SELF.s.prevNode &= NULL,TRUE,FALSE)
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.outOfMemory                    PROCEDURE(stackNode t) !if out of memory 
critProc    CriticalProcedure
  CODE   
  critProc.Init(SELF.critSect)
  RETURN CHOOSE(t &= NULL,TRUE,FALSE)
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.push                           PROCEDURE(ANY Value) !Push the stack on top according to the the value 
t   &stackNode
  CODE
  Debug('[ START jcStackManager.push ]',20)
  SELF.critSect.Wait()
  t &= SELF.s
  t.index += 1
  Debug('Index = ', t.index)
  SELF.s &= NEW(stackNode)
? IF SELF.GetAssertState(0) THEN
?   ASSERT(~SELF.OutOfMemory(SELF.s),'Out of memory')
? END
  SELF.s.nodeVal = Value
  SELF.s.index = t.index
  Debug('SELF.s.Index = ',SELF.s.index)
  SELF.s.prevNode &= t
  SELF.stack(SELF.s)
  SELF.critSect.Release()
  Debug('[ END jcStackManager.push ]',20)
  RETURN TRUE
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.stack                          PROCEDURE(stackNode s) !stack the current node to the queue
critProc    CriticalProcedure
  CODE   
  critProc.Init(SELF.critSect)
  Debug('[ START jcStackManager.Stack ]',22)
  CLEAR(SELF.q)
  DO AssignToQueue
  Debug('SELF.q.Index ' & SELF.q.index,24)
  Debug('SELF.q.nodeVal ' & SELF.q.nodeVal,24)
  SELF.Add()
  Debug('[ END jcStackManager.Stack ]',22)
AssignToQueue       ROUTINE
  SELF.q.index = s.index
  SELF.q.nodeVal = s.nodeVal
  SELF.q.prevNode &= s.prevNode
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.add                            PROCEDURE() !Add to stackQueue prior to call the assignment must be done
critProc    CriticalProcedure
  CODE   
  critProc.Init(SELF.critSect)
  Debug('[ START jcStackManager.add ]',24)
  GET(SELF.q,SELF.q.index,SELF.q.nodeVal)
  IF ERROR() THEN 
    !DO AssignToQueue
    Debug('Stacking to stackQueue',26)
    ADD(SELF.q)
  END
  Debug('[ END jcStackManager.add ]',24)
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.pop                            PROCEDURE() !Returned to the previous node of stack
t           &stackNode
Response    BOOL
  CODE   
  SELF.critSect.Wait()
? IF SELF.GetAssertState(0) THEN    
?   ASSERT(~SELF.isEmpty(),'The stack pile is empty')
? END
  IF SELF.isEmpty() THEN
    Response = FALSE
  ELSE
    t &= SELF.s
    SELF.s &= t.prevNode
    DISPOSE(t)
    Response = TRUE
  END
  SELF.critSect.Release()
  RETURN Response
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.top                            PROCEDURE() !what's on the top of the stack
Response    ANY
  CODE
  SELF.critSect.Wait()
? IF SELF.GetAssertState(0) THEN
?   ASSERT(~SELF.isEmpty(),'The stack pile is empty')
? END
  IF SELF.isEmpty() THEN
    Response = FALSE
  ELSE
    Response = SELF.s.nodeVal
  END
  SELF.critSect.Release()
  RETURN Response
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.stackSum                       PROCEDURE() !What's the stack sum
t   &stackNode
critProc    CriticalProcedure
  CODE   
  critProc.Init(SELF.critSect)
  t &= SELF.s
  RETURN SELF.stackSum(t)
!--------------------------------------------------------------------------------------------------------------------------------
jcStackManager.stackSum                       PROCEDURE(stackNode t) !Calcululate the stack sum
critProc    CriticalProcedure
  CODE   
  critProc.Init(SELF.critSect)
  IF t &= NULL THEN RETURN 0.
  RETURN 1 + SELF.stackSum(t.prevNode)
!--------------------------------------------------------------------------------------------------------------------------------

!================================================================================================================================
! PROCEDURE SECTION
!================================================================================================================================
Debug        								  PROCEDURE(STRING Info,SHORT SpaceMargin)   !See the line of of info to DebugView
DebugAction		        BYTE
DebugInfo		        CSTRING(251)
  CODE
  DebugAction = DebugState
  DebugInfo = ALL(' ',SpaceMargin) & Info 
  IF DebugAction THEN
    SendToDebug(DebugInfo)
  END
