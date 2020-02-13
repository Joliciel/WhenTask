# WhenTask
Trigger management for embed point WhenTask knowing WhosCalling, HasToDo and HasDone.
WhenTask project is a set of procedures to manage triggers for embeds points in an application. Knowing who’s calling, on tasks that HasToDo some actions and when tasks Has Done what to do. This permits to know who, what, when and why a task has to perform anywhere within an application according selected trigger; WhosCalling(Where), HasToDo(Where), HasDone(Where).

Excerpt from jcWhenTask.equ declarations files that describes in part the WhenTask concept.
!Used within QWhenTask assign to WhenTask BYTE field the main field of the queue
WhenTaskDefinition    ITEMIZE(1),PRE(WTDef) !WhenTaskDefinition holds all the different aspect of the WhenTask concept from the CodeArea to what an area will do.
CodeAreaSetDefinition   EQUATE !CodeAreaSet identifier definition that holds a code value set representationfrom WhenTaskSet   ITEMIZE,PRE(CAS) found in jcWhenTaskSet.equ file.
CurrentSetArea          EQUATE !CurrentSetArea identifier definition that holds a <br/>code value according to the CurrentCodeAreaSet<br/>or CurrentCodeArea representation set from<br/>WhenTaskSet   ITEMIZE,PRE(CAS)<br/>found in jcWhenTaskSet.equ file.
WhosCalling             EQUATE !WhosCalling identifier that holds the area (procedure or entity) coming from an area set (application, program, class or Data Multi Link Set).
HasToDO                 EQUATE !HasToDO identifier that holds the area (procedure or entity) coming from an area set (application, program, class, Data Multi Link Set).
TriggerOffHasToDO       EQUATE !TriggerHasToDO identifier that will trigger a switch to turn ON or OFF the HasToDO presently when ON it is validated in the SetHasDone() procedure. 
HasDone                 EQUATE !HasDone identifier that holds the area (procedure or entity) coming from an area set (application, program, class or Data Multi Link Set).
TriggerOffHasDone       EQUATE !TriggerHasDone identifier that will trigger a switch to turn ON or OFF the HasDone presently when ON it is validated in the SetHasToDO() procedure. 
                      END

jcWhenTask::Name:CodeAreaSetDefinition   EQUATE('Code Area Set Definition') !CodeAreaSet identifier definition that holds the name of the code value set representation from WhenTaskSet   ITEMIZE,PRE(CAS) found in jcWhenTaskSet.equ file.
jcWhenTask::Name:CurrentSetArea          EQUATE('Current Set Area')         !CurrentSetArea identifier definition that holds the name of the code value set representating<br/>CurrentCodeAreaSet or CurrentCodeArea from WhenTaskSet   ITEMIZE,PRE(CAS) found in jcWhenTaskSet.equ file.
jcWhenTask::Name:WhosCalling             EQUATE('Whos Calling')             !WhosCalling identifier that holds the area (procedure or entity) coming from an area set (application, program, class or Data Multi Link Set).
jcWhenTask::Name:HasToDO                 EQUATE('Has To Do')                !HasToDO identifier that holds the area (procedure or entity) coming from an area set (application, program, class, Data Multi Link Set).
jcWhenTask::Name:TriggerOffHasToDO       EQUATE('Trigger off Has To Do')    !TriggerHasToDO identifier that will trigger a switch to turn on or off the HasToDO presently it is validated in the SetHasDone() procedure. 
jcWhenTask::Name:HasDone                 EQUATE('Has Done')                 !HasDone identifier that holds the area (procedure or entity) coming from an area set (application, program, class or Data Multi Link Set).
jcWhenTask::Name:TriggerOffHasDone       EQUATE('Trigger off Has Done')     !TriggerHasDone identifier that will trigger a switch to turn on or off the HasDone presently it is validated in the SetHasToDO() procedure.<br/>Presently, in development.

