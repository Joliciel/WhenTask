            SECTION('Fetching jcDebug jcDebugShow INI file')

            !jcDebugShow:MainSource.SubSource = 1 is Show for programmer represented by the equate _Show
            !jcDebugShow:MainSource.SubSource = 0 is Hide for programmer represented by the equate _Hide

         INCLUDE('jcDebugShowOptions.inc'),ONCE

         OMIT('_jcDebugShowVariablesOnFetching_',_SelectjcDebugVariablesShow_)

         !Section jcDebugManager
         jcDebugDebugShow:Construct = _Show
         jcDebugDebugShow:Construct = GETINI('jcDebugManager','jcDebugDebugShow:Construct',jcDebugDebugShow:Construct,'.\jcDebugShow.INI')
         jcDebugDebugShow:Destruct = _Show
         jcDebugDebugShow:Destruct = GETINI('jcDebugManager','jcDebugDebugShow:Destruct',jcDebugDebugShow:Destruct,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetFetch = _Show
         jcDebugDebugShow:SetFetch = GETINI('jcDebugManager','jcDebugDebugShow:SetFetch',jcDebugDebugShow:SetFetch,'.\jcDebugShow.INI')
         jcDebugDebugShow:Updating = _Show
         jcDebugDebugShow:Updating = GETINI('jcDebugManager','jcDebugDebugShow:Updating',jcDebugDebugShow:Updating,'.\jcDebugShow.INI')
         jcDebugDebugShow:CreateDebugManager = _Show
         jcDebugDebugShow:CreateDebugManager = GETINI('jcDebugManager','jcDebugDebugShow:CreateDebugManager',jcDebugDebugShow:CreateDebugManager,'.\jcDebugShow.INI')
         jcDebugDebugShow:PrepareClassName = _Show
         jcDebugDebugShow:PrepareClassName = GETINI('jcDebugManager','jcDebugDebugShow:PrepareClassName',jcDebugDebugShow:PrepareClassName,'.\jcDebugShow.INI')
         jcDebugDebugShow:PrepareClassName = _Show
         jcDebugDebugShow:PrepareClassName = GETINI('jcDebugManager','jcDebugDebugShow:PrepareClassName',jcDebugDebugShow:PrepareClassName,'.\jcDebugShow.INI')
         jcDebugDebugShow:Init = _Show
         jcDebugDebugShow:Init = GETINI('jcDebugManager','jcDebugDebugShow:Init',jcDebugDebugShow:Init,'.\jcDebugShow.INI')
         jcDebugDebugShow:Kill = _Show
         jcDebugDebugShow:Kill = GETINI('jcDebugManager','jcDebugDebugShow:Kill',jcDebugDebugShow:Kill,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetjustStarted = _Show
         jcDebugDebugShow:SetjustStarted = GETINI('jcDebugManager','jcDebugDebugShow:SetjustStarted',jcDebugDebugShow:SetjustStarted,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetjustStarted = _Show
         jcDebugDebugShow:GetjustStarted = GETINI('jcDebugManager','jcDebugDebugShow:GetjustStarted',jcDebugDebugShow:GetjustStarted,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetjustEnded = _Show
         jcDebugDebugShow:SetjustEnded = GETINI('jcDebugManager','jcDebugDebugShow:SetjustEnded',jcDebugDebugShow:SetjustEnded,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetjustEnded = _Show
         jcDebugDebugShow:GetjustEnded = GETINI('jcDebugManager','jcDebugDebugShow:GetjustEnded',jcDebugDebugShow:GetjustEnded,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetCurrentAreaType = _Show
         jcDebugDebugShow:SetCurrentAreaType = GETINI('jcDebugManager','jcDebugDebugShow:SetCurrentAreaType',jcDebugDebugShow:SetCurrentAreaType,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetCurrentAreaType = _Show
         jcDebugDebugShow:GetCurrentAreaType = GETINI('jcDebugManager','jcDebugDebugShow:GetCurrentAreaType',jcDebugDebugShow:GetCurrentAreaType,'.\jcDebugShow.INI')
         jcDebugDebugShow:Assign = _Show
         jcDebugDebugShow:Assign = GETINI('jcDebugManager','jcDebugDebugShow:Assign',jcDebugDebugShow:Assign,'.\jcDebugShow.INI')
         jcDebugDebugShow:CheckSpaceMargin = _Show
         jcDebugDebugShow:CheckSpaceMargin = GETINI('jcDebugManager','jcDebugDebugShow:CheckSpaceMargin',jcDebugDebugShow:CheckSpaceMargin,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetDebugState = _Show
         jcDebugDebugShow:GetDebugState = GETINI('jcDebugManager','jcDebugDebugShow:GetDebugState',jcDebugDebugShow:GetDebugState,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetRepetitionLength = _Show
         jcDebugDebugShow:GetRepetitionLength = GETINI('jcDebugManager','jcDebugDebugShow:GetRepetitionLength',jcDebugDebugShow:GetRepetitionLength,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetShowDebugQueueLine = _Show
         jcDebugDebugShow:GetShowDebugQueueLine = GETINI('jcDebugManager','jcDebugDebugShow:GetShowDebugQueueLine',jcDebugDebugShow:GetShowDebugQueueLine,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetLine = _Show
         jcDebugDebugShow:SetLine = GETINI('jcDebugManager','jcDebugDebugShow:SetLine',jcDebugDebugShow:SetLine,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetLine = _Show
         jcDebugDebugShow:GetLine = GETINI('jcDebugManager','jcDebugDebugShow:GetLine',jcDebugDebugShow:GetLine,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowLine = _Show
         jcDebugDebugShow:ShowLine = GETINI('jcDebugManager','jcDebugDebugShow:ShowLine',jcDebugDebugShow:ShowLine,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetShowDebugQueueRepetitionLength = _Show
         jcDebugDebugShow:GetShowDebugQueueRepetitionLength = GETINI('jcDebugManager','jcDebugDebugShow:GetShowDebugQueueRepetitionLength',jcDebugDebugShow:GetShowDebugQueueRepetitionLength,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetSeeVariablesRepetitionLength = _Show
         jcDebugDebugShow:GetSeeVariablesRepetitionLength = GETINI('jcDebugManager','jcDebugDebugShow:GetSeeVariablesRepetitionLength',jcDebugDebugShow:GetSeeVariablesRepetitionLength,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetRepetitionLength = _Show
         jcDebugDebugShow:SetRepetitionLength = GETINI('jcDebugManager','jcDebugDebugShow:SetRepetitionLength',jcDebugDebugShow:SetRepetitionLength,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetShowDebugQueueRepetitionLength = _Show
         jcDebugDebugShow:SetShowDebugQueueRepetitionLength = GETINI('jcDebugManager','jcDebugDebugShow:SetShowDebugQueueRepetitionLength',jcDebugDebugShow:SetShowDebugQueueRepetitionLength,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetSeeVariablesRepetitionLength = _Show
         jcDebugDebugShow:SetSeeVariablesRepetitionLength = GETINI('jcDebugManager','jcDebugDebugShow:SetSeeVariablesRepetitionLength',jcDebugDebugShow:SetSeeVariablesRepetitionLength,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetRepeatCharacterInVariable = _Show
         jcDebugDebugShow:SetRepeatCharacterInVariable = GETINI('jcDebugManager','jcDebugDebugShow:SetRepeatCharacterInVariable',jcDebugDebugShow:SetRepeatCharacterInVariable,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetRestoreDebugState = _Show
         jcDebugDebugShow:SetRestoreDebugState = GETINI('jcDebugManager','jcDebugDebugShow:SetRestoreDebugState',jcDebugDebugShow:SetRestoreDebugState,'.\jcDebugShow.INI')
         jcDebugDebugShow:CheckRestoreDebugState = _Show
         jcDebugDebugShow:CheckRestoreDebugState = GETINI('jcDebugManager','jcDebugDebugShow:CheckRestoreDebugState',jcDebugDebugShow:CheckRestoreDebugState,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetMargin = _Show
         jcDebugDebugShow:SetMargin = GETINI('jcDebugManager','jcDebugDebugShow:SetMargin',jcDebugDebugShow:SetMargin,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetDebugState = _Show
         jcDebugDebugShow:SetDebugState = GETINI('jcDebugManager','jcDebugDebugShow:SetDebugState',jcDebugDebugShow:SetDebugState,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetOverrideSpaceMargin = _Show
         jcDebugDebugShow:SetOverrideSpaceMargin = GETINI('jcDebugManager','jcDebugDebugShow:SetOverrideSpaceMargin',jcDebugDebugShow:SetOverrideSpaceMargin,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetOverrideSpaceMargin = _Show
         jcDebugDebugShow:GetOverrideSpaceMargin = GETINI('jcDebugManager','jcDebugDebugShow:GetOverrideSpaceMargin',jcDebugDebugShow:GetOverrideSpaceMargin,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetNumberSpaceMargin = _Show
         jcDebugDebugShow:SetNumberSpaceMargin = GETINI('jcDebugManager','jcDebugDebugShow:SetNumberSpaceMargin',jcDebugDebugShow:SetNumberSpaceMargin,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetNumberSpaceMargin = _Show
         jcDebugDebugShow:GetNumberSpaceMargin = GETINI('jcDebugManager','jcDebugDebugShow:GetNumberSpaceMargin',jcDebugDebugShow:GetNumberSpaceMargin,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetIndentSpaceMargin = _Show
         jcDebugDebugShow:SetIndentSpaceMargin = GETINI('jcDebugManager','jcDebugDebugShow:SetIndentSpaceMargin',jcDebugDebugShow:SetIndentSpaceMargin,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetIndentSpaceMargin = _Show
         jcDebugDebugShow:GetIndentSpaceMargin = GETINI('jcDebugManager','jcDebugDebugShow:GetIndentSpaceMargin',jcDebugDebugShow:GetIndentSpaceMargin,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetNote = _Show
         jcDebugDebugShow:SetNote = GETINI('jcDebugManager','jcDebugDebugShow:SetNote',jcDebugDebugShow:SetNote,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetNote = _Show
         jcDebugDebugShow:GetNote = GETINI('jcDebugManager','jcDebugDebugShow:GetNote',jcDebugDebugShow:GetNote,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetHeader = _Show
         jcDebugDebugShow:SetHeader = GETINI('jcDebugManager','jcDebugDebugShow:SetHeader',jcDebugDebugShow:SetHeader,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetHeader = _Show
         jcDebugDebugShow:GetHeader = GETINI('jcDebugManager','jcDebugDebugShow:GetHeader',jcDebugDebugShow:GetHeader,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetComment = _Show
         jcDebugDebugShow:SetComment = GETINI('jcDebugManager','jcDebugDebugShow:SetComment',jcDebugDebugShow:SetComment,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetComment = _Show
         jcDebugDebugShow:GetComment = GETINI('jcDebugManager','jcDebugDebugShow:GetComment',jcDebugDebugShow:GetComment,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetDescription = _Show
         jcDebugDebugShow:SetDescription = GETINI('jcDebugManager','jcDebugDebugShow:SetDescription',jcDebugDebugShow:SetDescription,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetDescription = _Show
         jcDebugDebugShow:GetDescription = GETINI('jcDebugManager','jcDebugDebugShow:GetDescription',jcDebugDebugShow:GetDescription,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetDoc = _Show
         jcDebugDebugShow:SetDoc = GETINI('jcDebugManager','jcDebugDebugShow:SetDoc',jcDebugDebugShow:SetDoc,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetDoc = _Show
         jcDebugDebugShow:GetDoc = GETINI('jcDebugManager','jcDebugDebugShow:GetDoc',jcDebugDebugShow:GetDoc,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetDocumentation = _Show
         jcDebugDebugShow:SetDocumentation = GETINI('jcDebugManager','jcDebugDebugShow:SetDocumentation',jcDebugDebugShow:SetDocumentation,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetDocumentation = _Show
         jcDebugDebugShow:GetDocumentation = GETINI('jcDebugManager','jcDebugDebugShow:GetDocumentation',jcDebugDebugShow:GetDocumentation,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetHelp = _Show
         jcDebugDebugShow:SetHelp = GETINI('jcDebugManager','jcDebugDebugShow:SetHelp',jcDebugDebugShow:SetHelp,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetHelp = _Show
         jcDebugDebugShow:GetHelp = GETINI('jcDebugManager','jcDebugDebugShow:GetHelp',jcDebugDebugShow:GetHelp,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetHelper = _Show
         jcDebugDebugShow:SetHelper = GETINI('jcDebugManager','jcDebugDebugShow:SetHelper',jcDebugDebugShow:SetHelper,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetHelper = _Show
         jcDebugDebugShow:GetHelper = GETINI('jcDebugManager','jcDebugDebugShow:GetHelper',jcDebugDebugShow:GetHelper,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetErreur = _Show
         jcDebugDebugShow:SetErreur = GETINI('jcDebugManager','jcDebugDebugShow:SetErreur',jcDebugDebugShow:SetErreur,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetErreur = _Show
         jcDebugDebugShow:GetErreur = GETINI('jcDebugManager','jcDebugDebugShow:GetErreur',jcDebugDebugShow:GetErreur,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetAssert = _Show
         jcDebugDebugShow:SetAssert = GETINI('jcDebugManager','jcDebugDebugShow:SetAssert',jcDebugDebugShow:SetAssert,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetAssert = _Show
         jcDebugDebugShow:GetAssert = GETINI('jcDebugManager','jcDebugDebugShow:GetAssert',jcDebugDebugShow:GetAssert,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetWarning = _Show
         jcDebugDebugShow:SetWarning = GETINI('jcDebugManager','jcDebugDebugShow:SetWarning',jcDebugDebugShow:SetWarning,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetWarning = _Show
         jcDebugDebugShow:GetWarning = GETINI('jcDebugManager','jcDebugDebugShow:GetWarning',jcDebugDebugShow:GetWarning,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetNotify = _Show
         jcDebugDebugShow:SetNotify = GETINI('jcDebugManager','jcDebugDebugShow:SetNotify',jcDebugDebugShow:SetNotify,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetNotify = _Show
         jcDebugDebugShow:GetNotify = GETINI('jcDebugManager','jcDebugDebugShow:GetNotify',jcDebugDebugShow:GetNotify,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetNotification = _Show
         jcDebugDebugShow:SetNotification = GETINI('jcDebugManager','jcDebugDebugShow:SetNotification',jcDebugDebugShow:SetNotification,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetNotification = _Show
         jcDebugDebugShow:GetNotification = GETINI('jcDebugManager','jcDebugDebugShow:GetNotification',jcDebugDebugShow:GetNotification,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetThread = _Show
         jcDebugDebugShow:SetThread = GETINI('jcDebugManager','jcDebugDebugShow:SetThread',jcDebugDebugShow:SetThread,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetThread = _Show
         jcDebugDebugShow:GetThread = GETINI('jcDebugManager','jcDebugDebugShow:GetThread',jcDebugDebugShow:GetThread,'.\jcDebugShow.INI')
         jcDebugDebugShow:Save = _Show
         jcDebugDebugShow:Save = GETINI('jcDebugManager','jcDebugDebugShow:Save',jcDebugDebugShow:Save,'.\jcDebugShow.INI')
         jcDebugDebugShow:Restore = _Show
         jcDebugDebugShow:Restore = GETINI('jcDebugManager','jcDebugDebugShow:Restore',jcDebugDebugShow:Restore,'.\jcDebugShow.INI')
         jcDebugDebugShow:Headers = _Show
         jcDebugDebugShow:Headers = GETINI('jcDebugManager','jcDebugDebugShow:Headers',jcDebugDebugShow:Headers,'.\jcDebugShow.INI')
         jcDebugDebugShow:Comments = _Show
         jcDebugDebugShow:Comments = GETINI('jcDebugManager','jcDebugDebugShow:Comments',jcDebugDebugShow:Comments,'.\jcDebugShow.INI')
         jcDebugDebugShow:Descriptions = _Show
         jcDebugDebugShow:Descriptions = GETINI('jcDebugManager','jcDebugDebugShow:Descriptions',jcDebugDebugShow:Descriptions,'.\jcDebugShow.INI')
         jcDebugDebugShow:Application = _Show
         jcDebugDebugShow:Application = GETINI('jcDebugManager','jcDebugDebugShow:Application',jcDebugDebugShow:Application,'.\jcDebugShow.INI')
         jcDebugDebugShow:Programme = _Show
         jcDebugDebugShow:Programme = GETINI('jcDebugManager','jcDebugDebugShow:Programme',jcDebugDebugShow:Programme,'.\jcDebugShow.INI')
         jcDebugDebugShow:Classe = _Show
         jcDebugDebugShow:Classe = GETINI('jcDebugManager','jcDebugDebugShow:Classe',jcDebugDebugShow:Classe,'.\jcDebugShow.INI')
         jcDebugDebugShow:MethodShow = _Show
         jcDebugDebugShow:MethodShow = GETINI('jcDebugManager','jcDebugDebugShow:MethodShow',jcDebugDebugShow:MethodShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:Method = _Show
         jcDebugDebugShow:Method = GETINI('jcDebugManager','jcDebugDebugShow:Method',jcDebugDebugShow:Method,'.\jcDebugShow.INI')
         jcDebugDebugShow:Proc = _Show
         jcDebugDebugShow:Proc = GETINI('jcDebugManager','jcDebugDebugShow:Proc',jcDebugDebugShow:Proc,'.\jcDebugShow.INI')
         jcDebugDebugShow:Note = _Show
         jcDebugDebugShow:Note = GETINI('jcDebugManager','jcDebugDebugShow:Note',jcDebugDebugShow:Note,'.\jcDebugShow.INI')
         jcDebugDebugShow:Doc = _Show
         jcDebugDebugShow:Doc = GETINI('jcDebugManager','jcDebugDebugShow:Doc',jcDebugDebugShow:Doc,'.\jcDebugShow.INI')
         jcDebugDebugShow:Documentation = _Show
         jcDebugDebugShow:Documentation = GETINI('jcDebugManager','jcDebugDebugShow:Documentation',jcDebugDebugShow:Documentation,'.\jcDebugShow.INI')
         jcDebugDebugShow:Help = _Show
         jcDebugDebugShow:Help = GETINI('jcDebugManager','jcDebugDebugShow:Help',jcDebugDebugShow:Help,'.\jcDebugShow.INI')
         jcDebugDebugShow:Helper = _Show
         jcDebugDebugShow:Helper = GETINI('jcDebugManager','jcDebugDebugShow:Helper',jcDebugDebugShow:Helper,'.\jcDebugShow.INI')
         jcDebugDebugShow:Routines = _Show
         jcDebugDebugShow:Routines = GETINI('jcDebugManager','jcDebugDebugShow:Routines',jcDebugDebugShow:Routines,'.\jcDebugShow.INI')
         jcDebugDebugShow:Codes = _Show
         jcDebugDebugShow:Codes = GETINI('jcDebugManager','jcDebugDebugShow:Codes',jcDebugDebugShow:Codes,'.\jcDebugShow.INI')
         jcDebugDebugShow:Embed = _Show
         jcDebugDebugShow:Embed = GETINI('jcDebugManager','jcDebugDebugShow:Embed',jcDebugDebugShow:Embed,'.\jcDebugShow.INI')
         jcDebugDebugShow:EXECUTEs = _Show
         jcDebugDebugShow:EXECUTEs = GETINI('jcDebugManager','jcDebugDebugShow:EXECUTEs',jcDebugDebugShow:EXECUTEs,'.\jcDebugShow.INI')
         jcDebugDebugShow:BEGINs = _Show
         jcDebugDebugShow:BEGINs = GETINI('jcDebugManager','jcDebugDebugShow:BEGINs',jcDebugDebugShow:BEGINs,'.\jcDebugShow.INI')
         jcDebugDebugShow:CASEs = _Show
         jcDebugDebugShow:CASEs = GETINI('jcDebugManager','jcDebugDebugShow:CASEs',jcDebugDebugShow:CASEs,'.\jcDebugShow.INI')
         jcDebugDebugShow:OFs = _Show
         jcDebugDebugShow:OFs = GETINI('jcDebugManager','jcDebugDebugShow:OFs',jcDebugDebugShow:OFs,'.\jcDebugShow.INI')
         jcDebugDebugShow:Loops = _Show
         jcDebugDebugShow:Loops = GETINI('jcDebugManager','jcDebugDebugShow:Loops',jcDebugDebugShow:Loops,'.\jcDebugShow.INI')
         jcDebugDebugShow:IFs = _Show
         jcDebugDebugShow:IFs = GETINI('jcDebugManager','jcDebugDebugShow:IFs',jcDebugDebugShow:IFs,'.\jcDebugShow.INI')
         jcDebugDebugShow:IFOnTrue = _Show
         jcDebugDebugShow:IFOnTrue = GETINI('jcDebugManager','jcDebugDebugShow:IFOnTrue',jcDebugDebugShow:IFOnTrue,'.\jcDebugShow.INI')
         jcDebugDebugShow:IFOnFalse = _Show
         jcDebugDebugShow:IFOnFalse = GETINI('jcDebugManager','jcDebugDebugShow:IFOnFalse',jcDebugDebugShow:IFOnFalse,'.\jcDebugShow.INI')
         jcDebugDebugShow:SI = _Show
         jcDebugDebugShow:SI = GETINI('jcDebugManager','jcDebugDebugShow:SI',jcDebugDebugShow:SI,'.\jcDebugShow.INI')
         jcDebugDebugShow:SIOnTrue = _Show
         jcDebugDebugShow:SIOnTrue = GETINI('jcDebugManager','jcDebugDebugShow:SIOnTrue',jcDebugDebugShow:SIOnTrue,'.\jcDebugShow.INI')
         jcDebugDebugShow:SIOnFalse = _Show
         jcDebugDebugShow:SIOnFalse = GETINI('jcDebugManager','jcDebugDebugShow:SIOnFalse',jcDebugDebugShow:SIOnFalse,'.\jcDebugShow.INI')
         jcDebugDebugShow:Erreur = _Show
         jcDebugDebugShow:Erreur = GETINI('jcDebugManager','jcDebugDebugShow:Erreur',jcDebugDebugShow:Erreur,'.\jcDebugShow.INI')
         jcDebugDebugShow:Asserts = _Show
         jcDebugDebugShow:Asserts = GETINI('jcDebugManager','jcDebugDebugShow:Asserts',jcDebugDebugShow:Asserts,'.\jcDebugShow.INI')
         jcDebugDebugShow:Warning = _Show
         jcDebugDebugShow:Warning = GETINI('jcDebugManager','jcDebugDebugShow:Warning',jcDebugDebugShow:Warning,'.\jcDebugShow.INI')
         jcDebugDebugShow:Notify = _Show
         jcDebugDebugShow:Notify = GETINI('jcDebugManager','jcDebugDebugShow:Notify',jcDebugDebugShow:Notify,'.\jcDebugShow.INI')
         jcDebugDebugShow:Notification = _Show
         jcDebugDebugShow:Notification = GETINI('jcDebugManager','jcDebugDebugShow:Notification',jcDebugDebugShow:Notification,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowStart = _Show
         jcDebugDebugShow:ShowStart = GETINI('jcDebugManager','jcDebugDebugShow:ShowStart',jcDebugDebugShow:ShowStart,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowEnd = _Show
         jcDebugDebugShow:ShowEnd = GETINI('jcDebugManager','jcDebugDebugShow:ShowEnd',jcDebugDebugShow:ShowEnd,'.\jcDebugShow.INI')
         jcDebugDebugShow:SeeStart = _Show
         jcDebugDebugShow:SeeStart = GETINI('jcDebugManager','jcDebugDebugShow:SeeStart',jcDebugDebugShow:SeeStart,'.\jcDebugShow.INI')
         jcDebugDebugShow:SeeEnd = _Show
         jcDebugDebugShow:SeeEnd = GETINI('jcDebugManager','jcDebugDebugShow:SeeEnd',jcDebugDebugShow:SeeEnd,'.\jcDebugShow.INI')
         jcDebugDebugShow:See = _Show
         jcDebugDebugShow:See = GETINI('jcDebugManager','jcDebugDebugShow:See',jcDebugDebugShow:See,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowLocalDebug = _Show
         jcDebugDebugShow:ShowLocalDebug = GETINI('jcDebugManager','jcDebugDebugShow:ShowLocalDebug',jcDebugDebugShow:ShowLocalDebug,'.\jcDebugShow.INI')
         jcDebugDebugShow:Show = _Show
         jcDebugDebugShow:Show = GETINI('jcDebugManager','jcDebugDebugShow:Show',jcDebugDebugShow:Show,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowHeader = _Show
         jcDebugDebugShow:ShowHeader = GETINI('jcDebugManager','jcDebugDebugShow:ShowHeader',jcDebugDebugShow:ShowHeader,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetShowingCurrentMethodValue = _Show
         jcDebugDebugShow:SetShowingCurrentMethodValue = GETINI('jcDebugManager','jcDebugDebugShow:SetShowingCurrentMethodValue',jcDebugDebugShow:SetShowingCurrentMethodValue,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetShowingCurrentMethodValue = _Show
         jcDebugDebugShow:GetShowingCurrentMethodValue = GETINI('jcDebugManager','jcDebugDebugShow:GetShowingCurrentMethodValue',jcDebugDebugShow:GetShowingCurrentMethodValue,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowCurrentMethodValue = _Show
         jcDebugDebugShow:ShowCurrentMethodValue = GETINI('jcDebugManager','jcDebugDebugShow:ShowCurrentMethodValue',jcDebugDebugShow:ShowCurrentMethodValue,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetRespectingAreaShow = _Show
         jcDebugDebugShow:SetRespectingAreaShow = GETINI('jcDebugManager','jcDebugDebugShow:SetRespectingAreaShow',jcDebugDebugShow:SetRespectingAreaShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetRespectingAreaShow = _Show
         jcDebugDebugShow:GetRespectingAreaShow = GETINI('jcDebugManager','jcDebugDebugShow:GetRespectingAreaShow',jcDebugDebugShow:GetRespectingAreaShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowValue = _Show
         jcDebugDebugShow:ShowValue = GETINI('jcDebugManager','jcDebugDebugShow:ShowValue',jcDebugDebugShow:ShowValue,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowValueDetail = _Show
         jcDebugDebugShow:ShowValueDetail = GETINI('jcDebugManager','jcDebugDebugShow:ShowValueDetail',jcDebugDebugShow:ShowValueDetail,'.\jcDebugShow.INI')
         jcDebugDebugShow:SeeVariables = _Show
         jcDebugDebugShow:SeeVariables = GETINI('jcDebugManager','jcDebugDebugShow:SeeVariables',jcDebugDebugShow:SeeVariables,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowDebugQueue = _Show
         jcDebugDebugShow:ShowDebugQueue = GETINI('jcDebugManager','jcDebugDebugShow:ShowDebugQueue',jcDebugDebugShow:ShowDebugQueue,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowClassQueue = _Show
         jcDebugDebugShow:ShowClassQueue = GETINI('jcDebugManager','jcDebugDebugShow:ShowClassQueue',jcDebugDebugShow:ShowClassQueue,'.\jcDebugShow.INI')
         jcDebugDebugShow:PrepareShow = _Show
         jcDebugDebugShow:PrepareShow = GETINI('jcDebugManager','jcDebugDebugShow:PrepareShow',jcDebugDebugShow:PrepareShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetShow = _Show
         jcDebugDebugShow:SetShow = GETINI('jcDebugManager','jcDebugDebugShow:SetShow',jcDebugDebugShow:SetShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetShow = _Show
         jcDebugDebugShow:GetShow = GETINI('jcDebugManager','jcDebugDebugShow:GetShow',jcDebugDebugShow:GetShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetShowWhat = _Show
         jcDebugDebugShow:SetShowWhat = GETINI('jcDebugManager','jcDebugDebugShow:SetShowWhat',jcDebugDebugShow:SetShowWhat,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetShowWhat = _Show
         jcDebugDebugShow:GetShowWhat = GETINI('jcDebugManager','jcDebugDebugShow:GetShowWhat',jcDebugDebugShow:GetShowWhat,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetShowWhom = _Show
         jcDebugDebugShow:SetShowWhom = GETINI('jcDebugManager','jcDebugDebugShow:SetShowWhom',jcDebugDebugShow:SetShowWhom,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetShowWhom = _Show
         jcDebugDebugShow:GetShowWhom = GETINI('jcDebugManager','jcDebugDebugShow:GetShowWhom',jcDebugDebugShow:GetShowWhom,'.\jcDebugShow.INI')
         jcDebugDebugShow:Halt = _Show
         jcDebugDebugShow:Halt = GETINI('jcDebugManager','jcDebugDebugShow:Halt',jcDebugDebugShow:Halt,'.\jcDebugShow.INI')
         jcDebugDebugShow:Fin = _Show
         jcDebugDebugShow:Fin = GETINI('jcDebugManager','jcDebugDebugShow:Fin',jcDebugDebugShow:Fin,'.\jcDebugShow.INI')
         jcDebugDebugShow:Fin = _Show
         jcDebugDebugShow:Fin = GETINI('jcDebugManager','jcDebugDebugShow:Fin',jcDebugDebugShow:Fin,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetCurrentShow = _Show
         jcDebugDebugShow:SetCurrentShow = GETINI('jcDebugManager','jcDebugDebugShow:SetCurrentShow',jcDebugDebugShow:SetCurrentShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetCurrentShow = _Show
         jcDebugDebugShow:GetCurrentShow = GETINI('jcDebugManager','jcDebugDebugShow:GetCurrentShow',jcDebugDebugShow:GetCurrentShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetSelectiveShow = _Show
         jcDebugDebugShow:SetSelectiveShow = GETINI('jcDebugManager','jcDebugDebugShow:SetSelectiveShow',jcDebugDebugShow:SetSelectiveShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetSelectiveShow = _Show
         jcDebugDebugShow:SetSelectiveShow = GETINI('jcDebugManager','jcDebugDebugShow:SetSelectiveShow',jcDebugDebugShow:SetSelectiveShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetSelectShow = _Show
         jcDebugDebugShow:SetSelectShow = GETINI('jcDebugManager','jcDebugDebugShow:SetSelectShow',jcDebugDebugShow:SetSelectShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:CheckSelectiveShow = _Show
         jcDebugDebugShow:CheckSelectiveShow = GETINI('jcDebugManager','jcDebugDebugShow:CheckSelectiveShow',jcDebugDebugShow:CheckSelectiveShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetSelectiveShow = _Show
         jcDebugDebugShow:GetSelectiveShow = GETINI('jcDebugManager','jcDebugDebugShow:GetSelectiveShow',jcDebugDebugShow:GetSelectiveShow,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetValueRepresentation = _Show
         jcDebugDebugShow:GetValueRepresentation = GETINI('jcDebugManager','jcDebugDebugShow:GetValueRepresentation',jcDebugDebugShow:GetValueRepresentation,'.\jcDebugShow.INI')
         jcDebugDebugShow:Beeping = _Show
         jcDebugDebugShow:Beeping = GETINI('jcDebugManager','jcDebugDebugShow:Beeping',jcDebugDebugShow:Beeping,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowQ = _Show
         jcDebugDebugShow:ShowQ = GETINI('jcDebugManager','jcDebugDebugShow:ShowQ',jcDebugDebugShow:ShowQ,'.\jcDebugShow.INI')
         jcDebugDebugShow:ShowQRecordRow = _Show
         jcDebugDebugShow:ShowQRecordRow = GETINI('jcDebugManager','jcDebugDebugShow:ShowQRecordRow',jcDebugDebugShow:ShowQRecordRow,'.\jcDebugShow.INI')
         jcDebugDebugShow:ViewQ = _Show
         jcDebugDebugShow:ViewQ = GETINI('jcDebugManager','jcDebugDebugShow:ViewQ',jcDebugDebugShow:ViewQ,'.\jcDebugShow.INI')
         jcDebugDebugShow:RetenirEndroit = _Show
         jcDebugDebugShow:RetenirEndroit = GETINI('jcDebugManager','jcDebugDebugShow:RetenirEndroit',jcDebugDebugShow:RetenirEndroit,'.\jcDebugShow.INI')
         jcDebugDebugShow:RetainLocation = _Show
         jcDebugDebugShow:RetainLocation = GETINI('jcDebugManager','jcDebugDebugShow:RetainLocation',jcDebugDebugShow:RetainLocation,'.\jcDebugShow.INI')
         jcDebugDebugShow:SetShowValueToQDR = _Show
         jcDebugDebugShow:SetShowValueToQDR = GETINI('jcDebugManager','jcDebugDebugShow:SetShowValueToQDR',jcDebugDebugShow:SetShowValueToQDR,'.\jcDebugShow.INI')
         jcDebugDebugShow:GetShowValueToQDR = _Show
         jcDebugDebugShow:GetShowValueToQDR = GETINI('jcDebugManager','jcDebugDebugShow:GetShowValueToQDR',jcDebugDebugShow:GetShowValueToQDR,'.\jcDebugShow.INI')
         !Section jcDebugManager
_jcDebugShowVariablesOnFetching_


            SECTION('Updating jcDebug jcDebugShow INI file')

         OMIT('_jcDebugShowVariablesOnUpdating_',_SelectjcDebugVariablesShow_)

         !Section jcDebugManager
         PUTINI('jcDebugManager','jcDebugDebugShow:Construct',jcDebugDebugShow:Construct)
         PUTINI('jcDebugManager','jcDebugDebugShow:Destruct',jcDebugDebugShow:Destruct)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetFetch',jcDebugDebugShow:SetFetch)
         PUTINI('jcDebugManager','jcDebugDebugShow:Updating',jcDebugDebugShow:Updating)
         PUTINI('jcDebugManager','jcDebugDebugShow:CreateDebugManager',jcDebugDebugShow:CreateDebugManager)
         PUTINI('jcDebugManager','jcDebugDebugShow:PrepareClassName',jcDebugDebugShow:PrepareClassName)
         PUTINI('jcDebugManager','jcDebugDebugShow:PrepareClassName',jcDebugDebugShow:PrepareClassName)
         PUTINI('jcDebugManager','jcDebugDebugShow:Init',jcDebugDebugShow:Init)
         PUTINI('jcDebugManager','jcDebugDebugShow:Kill',jcDebugDebugShow:Kill)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetjustStarted',jcDebugDebugShow:SetjustStarted)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetjustStarted',jcDebugDebugShow:GetjustStarted)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetjustEnded',jcDebugDebugShow:SetjustEnded)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetjustEnded',jcDebugDebugShow:GetjustEnded)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetCurrentAreaType',jcDebugDebugShow:SetCurrentAreaType)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetCurrentAreaType',jcDebugDebugShow:GetCurrentAreaType)
         PUTINI('jcDebugManager','jcDebugDebugShow:Assign',jcDebugDebugShow:Assign)
         PUTINI('jcDebugManager','jcDebugDebugShow:CheckSpaceMargin',jcDebugDebugShow:CheckSpaceMargin)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetDebugState',jcDebugDebugShow:GetDebugState)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetRepetitionLength',jcDebugDebugShow:GetRepetitionLength)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetShowDebugQueueLine',jcDebugDebugShow:GetShowDebugQueueLine)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetLine',jcDebugDebugShow:SetLine)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetLine',jcDebugDebugShow:GetLine)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowLine',jcDebugDebugShow:ShowLine)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetShowDebugQueueRepetitionLength',jcDebugDebugShow:GetShowDebugQueueRepetitionLength)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetSeeVariablesRepetitionLength',jcDebugDebugShow:GetSeeVariablesRepetitionLength)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetRepetitionLength',jcDebugDebugShow:SetRepetitionLength)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetShowDebugQueueRepetitionLength',jcDebugDebugShow:SetShowDebugQueueRepetitionLength)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetSeeVariablesRepetitionLength',jcDebugDebugShow:SetSeeVariablesRepetitionLength)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetRepeatCharacterInVariable',jcDebugDebugShow:SetRepeatCharacterInVariable)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetRestoreDebugState',jcDebugDebugShow:SetRestoreDebugState)
         PUTINI('jcDebugManager','jcDebugDebugShow:CheckRestoreDebugState',jcDebugDebugShow:CheckRestoreDebugState)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetMargin',jcDebugDebugShow:SetMargin)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetDebugState',jcDebugDebugShow:SetDebugState)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetOverrideSpaceMargin',jcDebugDebugShow:SetOverrideSpaceMargin)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetOverrideSpaceMargin',jcDebugDebugShow:GetOverrideSpaceMargin)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetNumberSpaceMargin',jcDebugDebugShow:SetNumberSpaceMargin)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetNumberSpaceMargin',jcDebugDebugShow:GetNumberSpaceMargin)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetIndentSpaceMargin',jcDebugDebugShow:SetIndentSpaceMargin)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetIndentSpaceMargin',jcDebugDebugShow:GetIndentSpaceMargin)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetNote',jcDebugDebugShow:SetNote)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetNote',jcDebugDebugShow:GetNote)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetHeader',jcDebugDebugShow:SetHeader)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetHeader',jcDebugDebugShow:GetHeader)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetComment',jcDebugDebugShow:SetComment)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetComment',jcDebugDebugShow:GetComment)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetDescription',jcDebugDebugShow:SetDescription)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetDescription',jcDebugDebugShow:GetDescription)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetDoc',jcDebugDebugShow:SetDoc)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetDoc',jcDebugDebugShow:GetDoc)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetDocumentation',jcDebugDebugShow:SetDocumentation)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetDocumentation',jcDebugDebugShow:GetDocumentation)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetHelp',jcDebugDebugShow:SetHelp)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetHelp',jcDebugDebugShow:GetHelp)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetHelper',jcDebugDebugShow:SetHelper)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetHelper',jcDebugDebugShow:GetHelper)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetErreur',jcDebugDebugShow:SetErreur)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetErreur',jcDebugDebugShow:GetErreur)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetAssert',jcDebugDebugShow:SetAssert)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetAssert',jcDebugDebugShow:GetAssert)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetWarning',jcDebugDebugShow:SetWarning)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetWarning',jcDebugDebugShow:GetWarning)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetNotify',jcDebugDebugShow:SetNotify)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetNotify',jcDebugDebugShow:GetNotify)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetNotification',jcDebugDebugShow:SetNotification)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetNotification',jcDebugDebugShow:GetNotification)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetThread',jcDebugDebugShow:SetThread)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetThread',jcDebugDebugShow:GetThread)
         PUTINI('jcDebugManager','jcDebugDebugShow:Save',jcDebugDebugShow:Save)
         PUTINI('jcDebugManager','jcDebugDebugShow:Restore',jcDebugDebugShow:Restore)
         PUTINI('jcDebugManager','jcDebugDebugShow:Headers',jcDebugDebugShow:Headers)
         PUTINI('jcDebugManager','jcDebugDebugShow:Comments',jcDebugDebugShow:Comments)
         PUTINI('jcDebugManager','jcDebugDebugShow:Descriptions',jcDebugDebugShow:Descriptions)
         PUTINI('jcDebugManager','jcDebugDebugShow:Application',jcDebugDebugShow:Application)
         PUTINI('jcDebugManager','jcDebugDebugShow:Programme',jcDebugDebugShow:Programme)
         PUTINI('jcDebugManager','jcDebugDebugShow:Classe',jcDebugDebugShow:Classe)
         PUTINI('jcDebugManager','jcDebugDebugShow:MethodShow',jcDebugDebugShow:MethodShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:Method',jcDebugDebugShow:Method)
         PUTINI('jcDebugManager','jcDebugDebugShow:Proc',jcDebugDebugShow:Proc)
         PUTINI('jcDebugManager','jcDebugDebugShow:Note',jcDebugDebugShow:Note)
         PUTINI('jcDebugManager','jcDebugDebugShow:Doc',jcDebugDebugShow:Doc)
         PUTINI('jcDebugManager','jcDebugDebugShow:Documentation',jcDebugDebugShow:Documentation)
         PUTINI('jcDebugManager','jcDebugDebugShow:Help',jcDebugDebugShow:Help)
         PUTINI('jcDebugManager','jcDebugDebugShow:Helper',jcDebugDebugShow:Helper)
         PUTINI('jcDebugManager','jcDebugDebugShow:Routines',jcDebugDebugShow:Routines)
         PUTINI('jcDebugManager','jcDebugDebugShow:Codes',jcDebugDebugShow:Codes)
         PUTINI('jcDebugManager','jcDebugDebugShow:Embed',jcDebugDebugShow:Embed)
         PUTINI('jcDebugManager','jcDebugDebugShow:EXECUTEs',jcDebugDebugShow:EXECUTEs)
         PUTINI('jcDebugManager','jcDebugDebugShow:BEGINs',jcDebugDebugShow:BEGINs)
         PUTINI('jcDebugManager','jcDebugDebugShow:CASEs',jcDebugDebugShow:CASEs)
         PUTINI('jcDebugManager','jcDebugDebugShow:OFs',jcDebugDebugShow:OFs)
         PUTINI('jcDebugManager','jcDebugDebugShow:Loops',jcDebugDebugShow:Loops)
         PUTINI('jcDebugManager','jcDebugDebugShow:IFs',jcDebugDebugShow:IFs)
         PUTINI('jcDebugManager','jcDebugDebugShow:IFOnTrue',jcDebugDebugShow:IFOnTrue)
         PUTINI('jcDebugManager','jcDebugDebugShow:IFOnFalse',jcDebugDebugShow:IFOnFalse)
         PUTINI('jcDebugManager','jcDebugDebugShow:SI',jcDebugDebugShow:SI)
         PUTINI('jcDebugManager','jcDebugDebugShow:SIOnTrue',jcDebugDebugShow:SIOnTrue)
         PUTINI('jcDebugManager','jcDebugDebugShow:SIOnFalse',jcDebugDebugShow:SIOnFalse)
         PUTINI('jcDebugManager','jcDebugDebugShow:Erreur',jcDebugDebugShow:Erreur)
         PUTINI('jcDebugManager','jcDebugDebugShow:Asserts',jcDebugDebugShow:Asserts)
         PUTINI('jcDebugManager','jcDebugDebugShow:Warning',jcDebugDebugShow:Warning)
         PUTINI('jcDebugManager','jcDebugDebugShow:Notify',jcDebugDebugShow:Notify)
         PUTINI('jcDebugManager','jcDebugDebugShow:Notification',jcDebugDebugShow:Notification)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowStart',jcDebugDebugShow:ShowStart)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowEnd',jcDebugDebugShow:ShowEnd)
         PUTINI('jcDebugManager','jcDebugDebugShow:SeeStart',jcDebugDebugShow:SeeStart)
         PUTINI('jcDebugManager','jcDebugDebugShow:SeeEnd',jcDebugDebugShow:SeeEnd)
         PUTINI('jcDebugManager','jcDebugDebugShow:See',jcDebugDebugShow:See)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowLocalDebug',jcDebugDebugShow:ShowLocalDebug)
         PUTINI('jcDebugManager','jcDebugDebugShow:Show',jcDebugDebugShow:Show)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowHeader',jcDebugDebugShow:ShowHeader)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetShowingCurrentMethodValue',jcDebugDebugShow:SetShowingCurrentMethodValue)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetShowingCurrentMethodValue',jcDebugDebugShow:GetShowingCurrentMethodValue)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowCurrentMethodValue',jcDebugDebugShow:ShowCurrentMethodValue)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetRespectingAreaShow',jcDebugDebugShow:SetRespectingAreaShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetRespectingAreaShow',jcDebugDebugShow:GetRespectingAreaShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowValue',jcDebugDebugShow:ShowValue)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowValueDetail',jcDebugDebugShow:ShowValueDetail)
         PUTINI('jcDebugManager','jcDebugDebugShow:SeeVariables',jcDebugDebugShow:SeeVariables)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowDebugQueue',jcDebugDebugShow:ShowDebugQueue)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowClassQueue',jcDebugDebugShow:ShowClassQueue)
         PUTINI('jcDebugManager','jcDebugDebugShow:PrepareShow',jcDebugDebugShow:PrepareShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetShow',jcDebugDebugShow:SetShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetShow',jcDebugDebugShow:GetShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetShowWhat',jcDebugDebugShow:SetShowWhat)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetShowWhat',jcDebugDebugShow:GetShowWhat)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetShowWhom',jcDebugDebugShow:SetShowWhom)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetShowWhom',jcDebugDebugShow:GetShowWhom)
         PUTINI('jcDebugManager','jcDebugDebugShow:Halt',jcDebugDebugShow:Halt)
         PUTINI('jcDebugManager','jcDebugDebugShow:Fin',jcDebugDebugShow:Fin)
         PUTINI('jcDebugManager','jcDebugDebugShow:Fin',jcDebugDebugShow:Fin)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetCurrentShow',jcDebugDebugShow:SetCurrentShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetCurrentShow',jcDebugDebugShow:GetCurrentShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetSelectiveShow',jcDebugDebugShow:SetSelectiveShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetSelectiveShow',jcDebugDebugShow:SetSelectiveShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetSelectShow',jcDebugDebugShow:SetSelectShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:CheckSelectiveShow',jcDebugDebugShow:CheckSelectiveShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetSelectiveShow',jcDebugDebugShow:GetSelectiveShow)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetValueRepresentation',jcDebugDebugShow:GetValueRepresentation)
         PUTINI('jcDebugManager','jcDebugDebugShow:Beeping',jcDebugDebugShow:Beeping)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowQ',jcDebugDebugShow:ShowQ)
         PUTINI('jcDebugManager','jcDebugDebugShow:ShowQRecordRow',jcDebugDebugShow:ShowQRecordRow)
         PUTINI('jcDebugManager','jcDebugDebugShow:ViewQ',jcDebugDebugShow:ViewQ)
         PUTINI('jcDebugManager','jcDebugDebugShow:RetenirEndroit',jcDebugDebugShow:RetenirEndroit)
         PUTINI('jcDebugManager','jcDebugDebugShow:RetainLocation',jcDebugDebugShow:RetainLocation)
         PUTINI('jcDebugManager','jcDebugDebugShow:SetShowValueToQDR',jcDebugDebugShow:SetShowValueToQDR)
         PUTINI('jcDebugManager','jcDebugDebugShow:GetShowValueToQDR',jcDebugDebugShow:GetShowValueToQDR)
         !Section jcDebugManager
_jcDebugShowVariablesOnUpdating_

