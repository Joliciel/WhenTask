            SECTION('Fetching jcWhenTask jcDebugShow INI file')

            !jcDebugShow:MainSource.SubSource = 1 is Show for programmer represented by the equate _Show
            !jcDebugShow:MainSource.SubSource = 0 is Hide for programmer represented by the equate _Hide

         INCLUDE('jcWhenTaskShowOptions.inc'),ONCE

         OMIT('_jcWhenTaskShowVariablesOnFetching_',_SelectjcWhenTaskVariablesShow_)

         !Section jcWhenTaskClass
         jcWTDebugShow:Construct = _Show
         jcWTDebugShow:Construct = GETINI('jcWhenTaskClass','jcWTDebugShow:Construct',jcWTDebugShow:Construct,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:Destruct = _Show
         jcWTDebugShow:Destruct = GETINI('jcWhenTaskClass','jcWTDebugShow:Destruct',jcWTDebugShow:Destruct,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:Init = _Show
         jcWTDebugShow:Init = GETINI('jcWhenTaskClass','jcWTDebugShow:Init',jcWTDebugShow:Init,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:Kill = _Show
         jcWTDebugShow:Kill = GETINI('jcWhenTaskClass','jcWTDebugShow:Kill',jcWTDebugShow:Kill,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetWhenTask = _Show
         jcWTDebugShow:SetWhenTask = GETINI('jcWhenTaskClass','jcWTDebugShow:SetWhenTask',jcWTDebugShow:SetWhenTask,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetWhenTask = _Show
         jcWTDebugShow:GetWhenTask = GETINI('jcWhenTaskClass','jcWTDebugShow:GetWhenTask',jcWTDebugShow:GetWhenTask,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetWhenTaskName = _Show
         jcWTDebugShow:GetWhenTaskName = GETINI('jcWhenTaskClass','jcWTDebugShow:GetWhenTaskName',jcWTDebugShow:GetWhenTaskName,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:FetchWhenTaskNature = _Show
         jcWTDebugShow:FetchWhenTaskNature = GETINI('jcWhenTaskClass','jcWTDebugShow:FetchWhenTaskNature',jcWTDebugShow:FetchWhenTaskNature,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetState = _Show
         jcWTDebugShow:SetState = GETINI('jcWhenTaskClass','jcWTDebugShow:SetState',jcWTDebugShow:SetState,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetState = _Show
         jcWTDebugShow:GetState = GETINI('jcWhenTaskClass','jcWTDebugShow:GetState',jcWTDebugShow:GetState,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:DeleteWhenTask = _Show
         jcWTDebugShow:DeleteWhenTask = GETINI('jcWhenTaskClass','jcWTDebugShow:DeleteWhenTask',jcWTDebugShow:DeleteWhenTask,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:ClearWhenTask = _Show
         jcWTDebugShow:ClearWhenTask = GETINI('jcWhenTaskClass','jcWTDebugShow:ClearWhenTask',jcWTDebugShow:ClearWhenTask,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:Setsan = _Show
         jcWTDebugShow:Setsan = GETINI('jcWhenTaskClass','jcWTDebugShow:Setsan',jcWTDebugShow:Setsan,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:Getsan = _Show
         jcWTDebugShow:Getsan = GETINI('jcWhenTaskClass','jcWTDebugShow:Getsan',jcWTDebugShow:Getsan,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetsanSet = _Show
         jcWTDebugShow:SetsanSet = GETINI('jcWhenTaskClass','jcWTDebugShow:SetsanSet',jcWTDebugShow:SetsanSet,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetsanSet = _Show
         jcWTDebugShow:GetsanSet = GETINI('jcWhenTaskClass','jcWTDebugShow:GetsanSet',jcWTDebugShow:GetsanSet,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetsanArea = _Show
         jcWTDebugShow:SetsanArea = GETINI('jcWhenTaskClass','jcWTDebugShow:SetsanArea',jcWTDebugShow:SetsanArea,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetsanArea = _Show
         jcWTDebugShow:GetsanArea = GETINI('jcWhenTaskClass','jcWTDebugShow:GetsanArea',jcWTDebugShow:GetsanArea,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetCodeAreaSet = _Show
         jcWTDebugShow:SetCodeAreaSet = GETINI('jcWhenTaskClass','jcWTDebugShow:SetCodeAreaSet',jcWTDebugShow:SetCodeAreaSet,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetCodeAreaSet = _Show
         jcWTDebugShow:GetCodeAreaSet = GETINI('jcWhenTaskClass','jcWTDebugShow:GetCodeAreaSet',jcWTDebugShow:GetCodeAreaSet,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetCurrentWhenTaskDefinition = _Show
         jcWTDebugShow:SetCurrentWhenTaskDefinition = GETINI('jcWhenTaskClass','jcWTDebugShow:SetCurrentWhenTaskDefinition',jcWTDebugShow:SetCurrentWhenTaskDefinition,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetCurrentWhenTaskDefinition = _Show
         jcWTDebugShow:GetCurrentWhenTaskDefinition = GETINI('jcWhenTaskClass','jcWTDebugShow:GetCurrentWhenTaskDefinition',jcWTDebugShow:GetCurrentWhenTaskDefinition,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetCurrentCodeAreaSet = _Show
         jcWTDebugShow:SetCurrentCodeAreaSet = GETINI('jcWhenTaskClass','jcWTDebugShow:SetCurrentCodeAreaSet',jcWTDebugShow:SetCurrentCodeAreaSet,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetCurrentCodeAreaSet = _Show
         jcWTDebugShow:GetCurrentCodeAreaSet = GETINI('jcWhenTaskClass','jcWTDebugShow:GetCurrentCodeAreaSet',jcWTDebugShow:GetCurrentCodeAreaSet,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetCurrentCodeArea = _Show
         jcWTDebugShow:SetCurrentCodeArea = GETINI('jcWhenTaskClass','jcWTDebugShow:SetCurrentCodeArea',jcWTDebugShow:SetCurrentCodeArea,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetCurrentCodeArea = _Show
         jcWTDebugShow:GetCurrentCodeArea = GETINI('jcWhenTaskClass','jcWTDebugShow:GetCurrentCodeArea',jcWTDebugShow:GetCurrentCodeArea,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetWhosCalling = _Show
         jcWTDebugShow:SetWhosCalling = GETINI('jcWhenTaskClass','jcWTDebugShow:SetWhosCalling',jcWTDebugShow:SetWhosCalling,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetWhosCalling = _Show
         jcWTDebugShow:GetWhosCalling = GETINI('jcWhenTaskClass','jcWTDebugShow:GetWhosCalling',jcWTDebugShow:GetWhosCalling,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:ClearWhosCalling = _Show
         jcWTDebugShow:ClearWhosCalling = GETINI('jcWhenTaskClass','jcWTDebugShow:ClearWhosCalling',jcWTDebugShow:ClearWhosCalling,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetHasToDo = _Show
         jcWTDebugShow:SetHasToDo = GETINI('jcWhenTaskClass','jcWTDebugShow:SetHasToDo',jcWTDebugShow:SetHasToDo,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetHasToDo = _Show
         jcWTDebugShow:GetHasToDo = GETINI('jcWhenTaskClass','jcWTDebugShow:GetHasToDo',jcWTDebugShow:GetHasToDo,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:ClearHasToDo = _Show
         jcWTDebugShow:ClearHasToDo = GETINI('jcWhenTaskClass','jcWTDebugShow:ClearHasToDo',jcWTDebugShow:ClearHasToDo,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetTriggerOffHasToDO = _Show
         jcWTDebugShow:SetTriggerOffHasToDO = GETINI('jcWhenTaskClass','jcWTDebugShow:SetTriggerOffHasToDO',jcWTDebugShow:SetTriggerOffHasToDO,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetTriggerOffHasToDO = _Show
         jcWTDebugShow:GetTriggerOffHasToDO = GETINI('jcWhenTaskClass','jcWTDebugShow:GetTriggerOffHasToDO',jcWTDebugShow:GetTriggerOffHasToDO,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetHasDone = _Show
         jcWTDebugShow:SetHasDone = GETINI('jcWhenTaskClass','jcWTDebugShow:SetHasDone',jcWTDebugShow:SetHasDone,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetHasDone = _Show
         jcWTDebugShow:GetHasDone = GETINI('jcWhenTaskClass','jcWTDebugShow:GetHasDone',jcWTDebugShow:GetHasDone,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetTriggerOffHasDone = _Show
         jcWTDebugShow:SetTriggerOffHasDone = GETINI('jcWhenTaskClass','jcWTDebugShow:SetTriggerOffHasDone',jcWTDebugShow:SetTriggerOffHasDone,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetTriggerOffHasDone = _Show
         jcWTDebugShow:GetTriggerOffHasDone = GETINI('jcWhenTaskClass','jcWTDebugShow:GetTriggerOffHasDone',jcWTDebugShow:GetTriggerOffHasDone,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:ClearHasDone = _Show
         jcWTDebugShow:ClearHasDone = GETINI('jcWhenTaskClass','jcWTDebugShow:ClearHasDone',jcWTDebugShow:ClearHasDone,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:ShowValues = _Show
         jcWTDebugShow:ShowValues = GETINI('jcWhenTaskClass','jcWTDebugShow:ShowValues',jcWTDebugShow:ShowValues,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:ValidateArea = _Show
         jcWTDebugShow:ValidateArea = GETINI('jcWhenTaskClass','jcWTDebugShow:ValidateArea',jcWTDebugShow:ValidateArea,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:ValidateSet = _Show
         jcWTDebugShow:ValidateSet = GETINI('jcWhenTaskClass','jcWTDebugShow:ValidateSet',jcWTDebugShow:ValidateSet,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:SetMessageTrigger = _Show
         jcWTDebugShow:SetMessageTrigger = GETINI('jcWhenTaskClass','jcWTDebugShow:SetMessageTrigger',jcWTDebugShow:SetMessageTrigger,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:GetMessageTrigger = _Show
         jcWTDebugShow:GetMessageTrigger = GETINI('jcWhenTaskClass','jcWTDebugShow:GetMessageTrigger',jcWTDebugShow:GetMessageTrigger,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:ShowQsan = _Show
         jcWTDebugShow:ShowQsan = GETINI('jcWhenTaskClass','jcWTDebugShow:ShowQsan',jcWTDebugShow:ShowQsan,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:ShowQwt = _Show
         jcWTDebugShow:ShowQwt = GETINI('jcWhenTaskClass','jcWTDebugShow:ShowQwt',jcWTDebugShow:ShowQwt,'.\jcWhenTaskShow.INI')
         jcWTDebugShow:ShowWTD = _Show
         jcWTDebugShow:ShowWTD = GETINI('jcWhenTaskClass','jcWTDebugShow:ShowWTD',jcWTDebugShow:ShowWTD,'.\jcWhenTaskShow.INI')
_jcWhenTaskShowVariablesOnFetching_


            SECTION('Updating jcWhenTask jcDebugShow INI file')

         OMIT('_jcWhenTaskShowVariablesOnUpdating_',_SelectjcWhenTaskVariablesShow_)

         !Section jcWhenTaskClass
         PUTINI('jcWhenTaskClass','jcWTDebugShow:Construct',jcWTDebugShow:Construct)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:Destruct',jcWTDebugShow:Destruct)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:Init',jcWTDebugShow:Init)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:Kill',jcWTDebugShow:Kill)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetWhenTask',jcWTDebugShow:SetWhenTask)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetWhenTask',jcWTDebugShow:GetWhenTask)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetWhenTaskName',jcWTDebugShow:GetWhenTaskName)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:FetchWhenTaskNature',jcWTDebugShow:FetchWhenTaskNature)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetState',jcWTDebugShow:SetState)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetState',jcWTDebugShow:GetState)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:DeleteWhenTask',jcWTDebugShow:DeleteWhenTask)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:ClearWhenTask',jcWTDebugShow:ClearWhenTask)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:Setsan',jcWTDebugShow:Setsan)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:Getsan',jcWTDebugShow:Getsan)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetsanSet',jcWTDebugShow:SetsanSet)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetsanSet',jcWTDebugShow:GetsanSet)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetsanArea',jcWTDebugShow:SetsanArea)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetsanArea',jcWTDebugShow:GetsanArea)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetCodeAreaSet',jcWTDebugShow:SetCodeAreaSet)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetCodeAreaSet',jcWTDebugShow:GetCodeAreaSet)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetCurrentWhenTaskDefinition',jcWTDebugShow:SetCurrentWhenTaskDefinition)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetCurrentWhenTaskDefinition',jcWTDebugShow:GetCurrentWhenTaskDefinition)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetCurrentCodeAreaSet',jcWTDebugShow:SetCurrentCodeAreaSet)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetCurrentCodeAreaSet',jcWTDebugShow:GetCurrentCodeAreaSet)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetCurrentCodeArea',jcWTDebugShow:SetCurrentCodeArea)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetCurrentCodeArea',jcWTDebugShow:GetCurrentCodeArea)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetWhosCalling',jcWTDebugShow:SetWhosCalling)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetWhosCalling',jcWTDebugShow:GetWhosCalling)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:ClearWhosCalling',jcWTDebugShow:ClearWhosCalling)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetHasToDo',jcWTDebugShow:SetHasToDo)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetHasToDo',jcWTDebugShow:GetHasToDo)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:ClearHasToDo',jcWTDebugShow:ClearHasToDo)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetTriggerOffHasToDO',jcWTDebugShow:SetTriggerOffHasToDO)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetTriggerOffHasToDO',jcWTDebugShow:GetTriggerOffHasToDO)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetHasDone',jcWTDebugShow:SetHasDone)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetHasDone',jcWTDebugShow:GetHasDone)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetTriggerOffHasDone',jcWTDebugShow:SetTriggerOffHasDone)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetTriggerOffHasDone',jcWTDebugShow:GetTriggerOffHasDone)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:ClearHasDone',jcWTDebugShow:ClearHasDone)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:ShowValues',jcWTDebugShow:ShowValues)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:ValidateArea',jcWTDebugShow:ValidateArea)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:ValidateSet',jcWTDebugShow:ValidateSet)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:SetMessageTrigger',jcWTDebugShow:SetMessageTrigger)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:GetMessageTrigger',jcWTDebugShow:GetMessageTrigger)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:ShowQsan',jcWTDebugShow:ShowQsan)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:ShowQwt',jcWTDebugShow:ShowQwt)
         PUTINI('jcWhenTaskClass','jcWTDebugShow:ShowWTD',jcWTDebugShow:ShowWTD)
_jcWhenTaskShowVariablesOnUpdating_

