!ABCIncludeFile(Joliciel)
	INCLUDE('jcClassProjectOptions.inc'),ONCE
!
!Modify Joliciel 2012
!Stack class

OMIT('_EndOfInclude_',_jcStackManager_)
_jcStackManager_ EQUATE(1);

!To use the following class
! 1. Need to create the list of fields to stack in a group 
!StackGroup 	GROUP
!Field1           <DataType> 
!Field2           <DataType> 
!Field3           <DataType> 
!Field4           <DataType> 
!				END
! 2. Instantiate or Inherite the StackManager class or Reference
!     For Example
!Stack      jcStackManager
!  OR
!Stack      CLASS(jcStackManager)
!xyz          PROCEDURE
!           END
! OR 
!Stack  &jcStackManager
! 3. The stack manager must be initialized with Init() method. If the reference is used the Stack must Stack &= jcStackManager
! 4. Make the assignment to the property variables from the GroupStructure through the StackNode Class instance
!    Which is the s reference of the stackNode found within the StackManager class
!     For exemple under instantiation before we must push() the stack and after assign to the current stack the values. 
!     The push() statement may also be called after the group assignment. Actually this is better. 
!             Stack.Push()
!             Stack.s.Entity = Loc:Entity
!             Stack.s.Language = Loc:Language
!             Stack.s.Link = Loc:Link
!             Stack.s.Element = Loc:Element
! 5. When we want to go back to the previous stack we must pop() the stack to the previous node
!  Stack.Pop()
!  Loc:Entity = SELF.s.Entity
!  Loc:Language = SELF.s.Language
!  Loc:Link = SELF.S.Link
!  Loc:Element = SELF.s.Element
! 6. When we have finish to use the stackManager instance we must kill() it
! 7. Utility methods are 
!        isEmpty if there's any stack left 
!        isOutOfMemory if there's still memory
!        StackSum return the number of stack       
! 8. Resumy
!           Stack.Init()
!			StackGroup.Fields assignment
!			StackGroup.Field1 = SomeData
!			StackGroup.Field3 = SomeData
!           Stack.Push(StackGroup)
!           Stack.Pop()
!			IF NOT Stack.isEmpty()
!			  StackGroup = Stack.top()
!			END
!           Kill()
! 9. between the Init() and Kill() we can use isEmpty() isOutOfMemory() and StackSum() methods to verify        
        


  INCLUDE('jcBase.inc'),ONCE
  INCLUDE('jcStackWhenTask.equ'),ONCE

    !INCLUDE('jcStack.inc'),ONCE

jcStack::Index  EQUATE('INDEX')

stackNode   CLASS(),TYPE
index         LONG
nodeVal       ANY
prevNode      &stackNode
            END

stackQueue  QUEUE(),TYPE
index         LONG
nodeVal       ANY
prevNode      &stackNode
            END

            
jcStackManager  CLASS(jcBase),TYPE,MODULE('jcStack.clw'),LINK('jcStack.clw',_JCLinkMode_),DLL(_JCDllMode_)
!Properties and references
s                 &stackNode                  !Reference to the stackNode class
q                 &stackQueue                 !Reference to the stackQueue table
qString           ASTRING
!Methods 
Init              PROCEDURE (),VIRTUAL        !initilized the stack manager class
Kill              PROCEDURE ()                !Killing the stack manager class instances
isEmpty           PROCEDURE (),BYTE           !Do the stack is still in memory
outOfMemory       PROCEDURE (stackNode t),BYTE  !Are we out of memory
push              PROCEDURE (ANY Value),BYTE,PROC  !Push the stack on top with the parameter value
pop               PROCEDURE (),BYTE,PROC      !Pop the stack back to the previous node
top               PROCEDURE (),ANY,PROC       !What's on the top of the stack
stackSum          PROCEDURE (),LONG              !What's the stack sum
stackSum          PROCEDURE (stackNode t),LONG  !Calculate the stack sum
stack             PROCEDURE (stackNode s)     !stack the current node to the stackQueue
add               PROCEDURE (),VIRTUAL        !add to the stackQueue assignment must be done previously

!Protected
Construct         PROCEDURE (),PROTECTED      !Construct the stack manager class instance
Destruct          PROCEDURE (),PROTECTED      !Destroy the stack manager class instance
                END 

_EndOfInclude_ 

