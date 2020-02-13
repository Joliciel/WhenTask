            SECTION('Fetching jcField jcDebugShow INI file')

            !jcDebugShow:MainSource.SubSource = 1 is Show for programmer represented by the equate _Show
            !jcDebugShow:MainSource.SubSource = 0 is Hide for programmer represented by the equate _Hide

         INCLUDE('jcFieldShowOptions.inc'),ONCE

         OMIT('_jcFieldShowVariablesOnFetching_',_SelectjcFieldVariablesShow_)

         !Section jcFieldClass
         jcFieldDebugShow:Construct = _Show
         jcFieldDebugShow:Construct = GETINI('jcFieldClass','jcFieldDebugShow:Construct',jcFieldDebugShow:Construct,'.\jcFieldShow.INI')
         jcFieldDebugShow:Destruct = _Show
         jcFieldDebugShow:Destruct = GETINI('jcFieldClass','jcFieldDebugShow:Destruct',jcFieldDebugShow:Destruct,'.\jcFieldShow.INI')
         jcFieldDebugShow:Init = _Show
         jcFieldDebugShow:Init = GETINI('jcFieldClass','jcFieldDebugShow:Init',jcFieldDebugShow:Init,'.\jcFieldShow.INI')
         jcFieldDebugShow:Kill = _Show
         jcFieldDebugShow:Kill = GETINI('jcFieldClass','jcFieldDebugShow:Kill',jcFieldDebugShow:Kill,'.\jcFieldShow.INI')
         jcFieldDebugShow:MethodStart = _Show
         jcFieldDebugShow:MethodStart = GETINI('jcFieldClass','jcFieldDebugShow:MethodStart',jcFieldDebugShow:MethodStart,'.\jcFieldShow.INI')
         jcFieldDebugShow:MethodEnd = _Show
         jcFieldDebugShow:MethodEnd = GETINI('jcFieldClass','jcFieldDebugShow:MethodEnd',jcFieldDebugShow:MethodEnd,'.\jcFieldShow.INI')
         jcFieldDebugShow:PrepareType = _Show
         jcFieldDebugShow:PrepareType = GETINI('jcFieldClass','jcFieldDebugShow:PrepareType',jcFieldDebugShow:PrepareType,'.\jcFieldShow.INI')
         jcFieldDebugShow:ShowFields = _Show
         jcFieldDebugShow:ShowFields = GETINI('jcFieldClass','jcFieldDebugShow:ShowFields',jcFieldDebugShow:ShowFields,'.\jcFieldShow.INI')
         jcFieldDebugShow:CreateStructure = _Show
         jcFieldDebugShow:CreateStructure = GETINI('jcFieldClass','jcFieldDebugShow:CreateStructure',jcFieldDebugShow:CreateStructure,'.\jcFieldShow.INI')
         jcFieldDebugShow:SetStructure = _Show
         jcFieldDebugShow:SetStructure = GETINI('jcFieldClass','jcFieldDebugShow:SetStructure',jcFieldDebugShow:SetStructure,'.\jcFieldShow.INI')
         jcFieldDebugShow:GetStructure = _Show
         jcFieldDebugShow:GetStructure = GETINI('jcFieldClass','jcFieldDebugShow:GetStructure',jcFieldDebugShow:GetStructure,'.\jcFieldShow.INI')
         jcFieldDebugShow:CreateField = _Show
         jcFieldDebugShow:CreateField = GETINI('jcFieldClass','jcFieldDebugShow:CreateField',jcFieldDebugShow:CreateField,'.\jcFieldShow.INI')
         jcFieldDebugShow:SetField = _Show
         jcFieldDebugShow:SetField = GETINI('jcFieldClass','jcFieldDebugShow:SetField',jcFieldDebugShow:SetField,'.\jcFieldShow.INI')
         jcFieldDebugShow:Set = _Show
         jcFieldDebugShow:Set = GETINI('jcFieldClass','jcFieldDebugShow:Set',jcFieldDebugShow:Set,'.\jcFieldShow.INI')
         jcFieldDebugShow:UpdateDefinition = _Show
         jcFieldDebugShow:UpdateDefinition = GETINI('jcFieldClass','jcFieldDebugShow:UpdateDefinition',jcFieldDebugShow:UpdateDefinition,'.\jcFieldShow.INI')
         jcFieldDebugShow:SetPairQ = _Show
         jcFieldDebugShow:SetPairQ = GETINI('jcFieldClass','jcFieldDebugShow:SetPairQ',jcFieldDebugShow:SetPairQ,'.\jcFieldShow.INI')
         jcFieldDebugShow:SetPairG = _Show
         jcFieldDebugShow:SetPairG = GETINI('jcFieldClass','jcFieldDebugShow:SetPairG',jcFieldDebugShow:SetPairG,'.\jcFieldShow.INI')
         jcFieldDebugShow:Add = _Show
         jcFieldDebugShow:Add = GETINI('jcFieldClass','jcFieldDebugShow:Add',jcFieldDebugShow:Add,'.\jcFieldShow.INI')
         jcFieldDebugShow:Add = _Show
         jcFieldDebugShow:Add = GETINI('jcFieldClass','jcFieldDebugShow:Add',jcFieldDebugShow:Add,'.\jcFieldShow.INI')
         jcFieldDebugShow:Get = _Show
         jcFieldDebugShow:Get = GETINI('jcFieldClass','jcFieldDebugShow:Get',jcFieldDebugShow:Get,'.\jcFieldShow.INI')
         jcFieldDebugShow:WhatIs = _Show
         jcFieldDebugShow:WhatIs = GETINI('jcFieldClass','jcFieldDebugShow:WhatIs',jcFieldDebugShow:WhatIs,'.\jcFieldShow.INI')
         jcFieldDebugShow:FieldTypeIs = _Show
         jcFieldDebugShow:FieldTypeIs = GETINI('jcFieldClass','jcFieldDebugShow:FieldTypeIs',jcFieldDebugShow:FieldTypeIs,'.\jcFieldShow.INI')
         jcFieldDebugShow:GetData = _Show
         jcFieldDebugShow:GetData = GETINI('jcFieldClass','jcFieldDebugShow:GetData',jcFieldDebugShow:GetData,'.\jcFieldShow.INI')
         jcFieldDebugShow:GetSize = _Show
         jcFieldDebugShow:GetSize = GETINI('jcFieldClass','jcFieldDebugShow:GetSize',jcFieldDebugShow:GetSize,'.\jcFieldShow.INI')
         jcFieldDebugShow:Update = _Show
         jcFieldDebugShow:Update = GETINI('jcFieldClass','jcFieldDebugShow:Update',jcFieldDebugShow:Update,'.\jcFieldShow.INI')
         jcFieldDebugShow:Update = _Show
         jcFieldDebugShow:Update = GETINI('jcFieldClass','jcFieldDebugShow:Update',jcFieldDebugShow:Update,'.\jcFieldShow.INI')
         jcFieldDebugShow:Delete = _Show
         jcFieldDebugShow:Delete = GETINI('jcFieldClass','jcFieldDebugShow:Delete',jcFieldDebugShow:Delete,'.\jcFieldShow.INI')
         jcFieldDebugShow:GetString = _Show
         jcFieldDebugShow:GetString = GETINI('jcFieldClass','jcFieldDebugShow:GetString',jcFieldDebugShow:GetString,'.\jcFieldShow.INI')
         jcFieldDebugShow:SetTypeOnly = _Show
         jcFieldDebugShow:SetTypeOnly = GETINI('jcFieldClass','jcFieldDebugShow:SetTypeOnly',jcFieldDebugShow:SetTypeOnly,'.\jcFieldShow.INI')
         jcFieldDebugShow:GetTypeOnly = _Show
         jcFieldDebugShow:GetTypeOnly = GETINI('jcFieldClass','jcFieldDebugShow:GetTypeOnly',jcFieldDebugShow:GetTypeOnly,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         jcFieldDebugShow:Is = _Show
         jcFieldDebugShow:Is = GETINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is,'.\jcFieldShow.INI')
         !Section jcFieldArray
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         jcFieldADebugShow:Is = _Show
         jcFieldADebugShow:Is = GETINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is,'.\jcFieldShow.INI')
         !Section jcFieldDataManager
         jcFieldDDebugShow:Construct = _Show
         jcFieldDDebugShow:Construct = GETINI('jcFieldDataManager','jcFieldDDebugShow:Construct',jcFieldDDebugShow:Construct,'.\jcFieldShow.INI')
         jcFieldDDebugShow:Destruct = _Show
         jcFieldDDebugShow:Destruct = GETINI('jcFieldDataManager','jcFieldDDebugShow:Destruct',jcFieldDDebugShow:Destruct,'.\jcFieldShow.INI')
         jcFieldDDebugShow:AddData = _Show
         jcFieldDDebugShow:AddData = GETINI('jcFieldDataManager','jcFieldDDebugShow:AddData',jcFieldDDebugShow:AddData,'.\jcFieldShow.INI')
         jcFieldDDebugShow:Get = _Show
         jcFieldDDebugShow:Get = GETINI('jcFieldDataManager','jcFieldDDebugShow:Get',jcFieldDDebugShow:Get,'.\jcFieldShow.INI')
         jcFieldDDebugShow:SetCurrentFieldID = _Show
         jcFieldDDebugShow:SetCurrentFieldID = GETINI('jcFieldDataManager','jcFieldDDebugShow:SetCurrentFieldID',jcFieldDDebugShow:SetCurrentFieldID,'.\jcFieldShow.INI')
         jcFieldDDebugShow:GetCurrentFieldID = _Show
         jcFieldDDebugShow:GetCurrentFieldID = GETINI('jcFieldDataManager','jcFieldDDebugShow:GetCurrentFieldID',jcFieldDDebugShow:GetCurrentFieldID,'.\jcFieldShow.INI')
         jcFieldDDebugShow:DeleteData = _Show
         jcFieldDDebugShow:DeleteData = GETINI('jcFieldDataManager','jcFieldDDebugShow:DeleteData',jcFieldDDebugShow:DeleteData,'.\jcFieldShow.INI')
         jcFieldDDebugShow:UpdateData = _Show
         jcFieldDDebugShow:UpdateData = GETINI('jcFieldDataManager','jcFieldDDebugShow:UpdateData',jcFieldDDebugShow:UpdateData,'.\jcFieldShow.INI')
         jcFieldDDebugShow:GetHeaderColumns = _Show
         jcFieldDDebugShow:GetHeaderColumns = GETINI('jcFieldDataManager','jcFieldDDebugShow:GetHeaderColumns',jcFieldDDebugShow:GetHeaderColumns,'.\jcFieldShow.INI')
         jcFieldDDebugShow:ShowFieldDataQueue = _Show
         jcFieldDDebugShow:ShowFieldDataQueue = GETINI('jcFieldDataManager','jcFieldDDebugShow:ShowFieldDataQueue',jcFieldDDebugShow:ShowFieldDataQueue,'.\jcFieldShow.INI')
         !Section jcFieldManager
         jcFieldMDebugShow:Construct = _Show
         jcFieldMDebugShow:Construct = GETINI('jcFieldManager','jcFieldMDebugShow:Construct',jcFieldMDebugShow:Construct,'.\jcFieldShow.INI')
         jcFieldMDebugShow:Destruct = _Show
         jcFieldMDebugShow:Destruct = GETINI('jcFieldManager','jcFieldMDebugShow:Destruct',jcFieldMDebugShow:Destruct,'.\jcFieldShow.INI')
         jcFieldMDebugShow:Init = _Show
         jcFieldMDebugShow:Init = GETINI('jcFieldManager','jcFieldMDebugShow:Init',jcFieldMDebugShow:Init,'.\jcFieldShow.INI')
         jcFieldMDebugShow:Kill = _Show
         jcFieldMDebugShow:Kill = GETINI('jcFieldManager','jcFieldMDebugShow:Kill',jcFieldMDebugShow:Kill,'.\jcFieldShow.INI')
         jcFieldMDebugShow:MethodStart = _Show
         jcFieldMDebugShow:MethodStart = GETINI('jcFieldManager','jcFieldMDebugShow:MethodStart',jcFieldMDebugShow:MethodStart,'.\jcFieldShow.INI')
         jcFieldMDebugShow:MethodEnd = _Show
         jcFieldMDebugShow:MethodEnd = GETINI('jcFieldManager','jcFieldMDebugShow:MethodEnd',jcFieldMDebugShow:MethodEnd,'.\jcFieldShow.INI')
         jcFieldMDebugShow:SetIndexField = _Show
         jcFieldMDebugShow:SetIndexField = GETINI('jcFieldManager','jcFieldMDebugShow:SetIndexField',jcFieldMDebugShow:SetIndexField,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetIndexField = _Show
         jcFieldMDebugShow:GetIndexField = GETINI('jcFieldManager','jcFieldMDebugShow:GetIndexField',jcFieldMDebugShow:GetIndexField,'.\jcFieldShow.INI')
         jcFieldMDebugShow:SetColumnIndex = _Show
         jcFieldMDebugShow:SetColumnIndex = GETINI('jcFieldManager','jcFieldMDebugShow:SetColumnIndex',jcFieldMDebugShow:SetColumnIndex,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetColumnIndex = _Show
         jcFieldMDebugShow:GetColumnIndex = GETINI('jcFieldManager','jcFieldMDebugShow:GetColumnIndex',jcFieldMDebugShow:GetColumnIndex,'.\jcFieldShow.INI')
         jcFieldMDebugShow:SetColumnIndexLength = _Show
         jcFieldMDebugShow:SetColumnIndexLength = GETINI('jcFieldManager','jcFieldMDebugShow:SetColumnIndexLength',jcFieldMDebugShow:SetColumnIndexLength,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetColumnIndexLength = _Show
         jcFieldMDebugShow:GetColumnIndexLength = GETINI('jcFieldManager','jcFieldMDebugShow:GetColumnIndexLength',jcFieldMDebugShow:GetColumnIndexLength,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetIndex = _Show
         jcFieldMDebugShow:GetIndex = GETINI('jcFieldManager','jcFieldMDebugShow:GetIndex',jcFieldMDebugShow:GetIndex,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetIndex = _Show
         jcFieldMDebugShow:GetIndex = GETINI('jcFieldManager','jcFieldMDebugShow:GetIndex',jcFieldMDebugShow:GetIndex,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetName = _Show
         jcFieldMDebugShow:GetName = GETINI('jcFieldManager','jcFieldMDebugShow:GetName',jcFieldMDebugShow:GetName,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetName = _Show
         jcFieldMDebugShow:GetName = GETINI('jcFieldManager','jcFieldMDebugShow:GetName',jcFieldMDebugShow:GetName,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetData = _Show
         jcFieldMDebugShow:GetData = GETINI('jcFieldManager','jcFieldMDebugShow:GetData',jcFieldMDebugShow:GetData,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetData = _Show
         jcFieldMDebugShow:GetData = GETINI('jcFieldManager','jcFieldMDebugShow:GetData',jcFieldMDebugShow:GetData,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetFields = _Show
         jcFieldMDebugShow:GetFields = GETINI('jcFieldManager','jcFieldMDebugShow:GetFields',jcFieldMDebugShow:GetFields,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetFields = _Show
         jcFieldMDebugShow:GetFields = GETINI('jcFieldManager','jcFieldMDebugShow:GetFields',jcFieldMDebugShow:GetFields,'.\jcFieldShow.INI')
         jcFieldMDebugShow:SetFieldsFormat = _Show
         jcFieldMDebugShow:SetFieldsFormat = GETINI('jcFieldManager','jcFieldMDebugShow:SetFieldsFormat',jcFieldMDebugShow:SetFieldsFormat,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetFieldsFormat = _Show
         jcFieldMDebugShow:GetFieldsFormat = GETINI('jcFieldManager','jcFieldMDebugShow:GetFieldsFormat',jcFieldMDebugShow:GetFieldsFormat,'.\jcFieldShow.INI')
         jcFieldMDebugShow:SetFieldsFormatLimit = _Show
         jcFieldMDebugShow:SetFieldsFormatLimit = GETINI('jcFieldManager','jcFieldMDebugShow:SetFieldsFormatLimit',jcFieldMDebugShow:SetFieldsFormatLimit,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetFieldsFormatLimit = _Show
         jcFieldMDebugShow:GetFieldsFormatLimit = GETINI('jcFieldManager','jcFieldMDebugShow:GetFieldsFormatLimit',jcFieldMDebugShow:GetFieldsFormatLimit,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetARecordFromQueue = _Show
         jcFieldMDebugShow:GetARecordFromQueue = GETINI('jcFieldManager','jcFieldMDebugShow:GetARecordFromQueue',jcFieldMDebugShow:GetARecordFromQueue,'.\jcFieldShow.INI')
         jcFieldMDebugShow:CalculateColumnsSet = _Show
         jcFieldMDebugShow:CalculateColumnsSet = GETINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsSet',jcFieldMDebugShow:CalculateColumnsSet,'.\jcFieldShow.INI')
         jcFieldMDebugShow:CalculateColumnsSet = _Show
         jcFieldMDebugShow:CalculateColumnsSet = GETINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsSet',jcFieldMDebugShow:CalculateColumnsSet,'.\jcFieldShow.INI')
         jcFieldMDebugShow:CalculateColumnsSet = _Show
         jcFieldMDebugShow:CalculateColumnsSet = GETINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsSet',jcFieldMDebugShow:CalculateColumnsSet,'.\jcFieldShow.INI')
         jcFieldMDebugShow:CalculateColumnsSet = _Show
         jcFieldMDebugShow:CalculateColumnsSet = GETINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsSet',jcFieldMDebugShow:CalculateColumnsSet,'.\jcFieldShow.INI')
         jcFieldMDebugShow:CalculateColumnsSet = _Show
         jcFieldMDebugShow:CalculateColumnsSet = GETINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsSet',jcFieldMDebugShow:CalculateColumnsSet,'.\jcFieldShow.INI')
         jcFieldMDebugShow:CalculateColumnsRow = _Show
         jcFieldMDebugShow:CalculateColumnsRow = GETINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsRow',jcFieldMDebugShow:CalculateColumnsRow,'.\jcFieldShow.INI')
         jcFieldMDebugShow:CalculateColumnsRow = _Show
         jcFieldMDebugShow:CalculateColumnsRow = GETINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsRow',jcFieldMDebugShow:CalculateColumnsRow,'.\jcFieldShow.INI')
         jcFieldMDebugShow:CalculateColumnsRow = _Show
         jcFieldMDebugShow:CalculateColumnsRow = GETINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsRow',jcFieldMDebugShow:CalculateColumnsRow,'.\jcFieldShow.INI')
         jcFieldMDebugShow:CalculateColumnsRow = _Show
         jcFieldMDebugShow:CalculateColumnsRow = GETINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsRow',jcFieldMDebugShow:CalculateColumnsRow,'.\jcFieldShow.INI')
         jcFieldMDebugShow:SetColumnsSize = _Show
         jcFieldMDebugShow:SetColumnsSize = GETINI('jcFieldManager','jcFieldMDebugShow:SetColumnsSize',jcFieldMDebugShow:SetColumnsSize,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetColumnsSize = _Show
         jcFieldMDebugShow:GetColumnsSize = GETINI('jcFieldManager','jcFieldMDebugShow:GetColumnsSize',jcFieldMDebugShow:GetColumnsSize,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetNumberOfColumns = _Show
         jcFieldMDebugShow:GetNumberOfColumns = GETINI('jcFieldManager','jcFieldMDebugShow:GetNumberOfColumns',jcFieldMDebugShow:GetNumberOfColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetNumberOfColumns = _Show
         jcFieldMDebugShow:GetNumberOfColumns = GETINI('jcFieldManager','jcFieldMDebugShow:GetNumberOfColumns',jcFieldMDebugShow:GetNumberOfColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetHeaderColumns = _Show
         jcFieldMDebugShow:GetHeaderColumns = GETINI('jcFieldManager','jcFieldMDebugShow:GetHeaderColumns',jcFieldMDebugShow:GetHeaderColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetHeaderColumns = _Show
         jcFieldMDebugShow:GetHeaderColumns = GETINI('jcFieldManager','jcFieldMDebugShow:GetHeaderColumns',jcFieldMDebugShow:GetHeaderColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetHeaderColumns = _Show
         jcFieldMDebugShow:GetHeaderColumns = GETINI('jcFieldManager','jcFieldMDebugShow:GetHeaderColumns',jcFieldMDebugShow:GetHeaderColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetHeaderColumns = _Show
         jcFieldMDebugShow:GetHeaderColumns = GETINI('jcFieldManager','jcFieldMDebugShow:GetHeaderColumns',jcFieldMDebugShow:GetHeaderColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:ShowColumns = _Show
         jcFieldMDebugShow:ShowColumns = GETINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:ShowColumns = _Show
         jcFieldMDebugShow:ShowColumns = GETINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:ShowColumns = _Show
         jcFieldMDebugShow:ShowColumns = GETINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:ShowColumns = _Show
         jcFieldMDebugShow:ShowColumns = GETINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:ShowColumns = _Show
         jcFieldMDebugShow:ShowColumns = GETINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:ShowColumns = _Show
         jcFieldMDebugShow:ShowColumns = GETINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:ShowColumns = _Show
         jcFieldMDebugShow:ShowColumns = GETINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns,'.\jcFieldShow.INI')
         jcFieldMDebugShow:GetStringFormatLength = _Show
         jcFieldMDebugShow:GetStringFormatLength = GETINI('jcFieldManager','jcFieldMDebugShow:GetStringFormatLength',jcFieldMDebugShow:GetStringFormatLength,'.\jcFieldShow.INI')
         jcFieldMDebugShow:EmbedShow = _Show
         jcFieldMDebugShow:EmbedShow = GETINI('jcFieldManager','jcFieldMDebugShow:EmbedShow',jcFieldMDebugShow:EmbedShow,'.\jcFieldShow.INI')
         jcFieldMDebugShow:ShowQueue = _Show
         jcFieldMDebugShow:ShowQueue = GETINI('jcFieldManager','jcFieldMDebugShow:ShowQueue',jcFieldMDebugShow:ShowQueue,'.\jcFieldShow.INI')
         jcFieldMDebugShow:ShowQueue = _Show
         jcFieldMDebugShow:ShowQueue = GETINI('jcFieldManager','jcFieldMDebugShow:ShowQueue',jcFieldMDebugShow:ShowQueue,'.\jcFieldShow.INI')
         jcFieldMDebugShow:ShowQueue = _Show
         jcFieldMDebugShow:ShowQueue = GETINI('jcFieldManager','jcFieldMDebugShow:ShowQueue',jcFieldMDebugShow:ShowQueue,'.\jcFieldShow.INI')
         jcFieldMDebugShow:AddDataLog = _Show
         jcFieldMDebugShow:AddDataLog = GETINI('jcFieldManager','jcFieldMDebugShow:AddDataLog',jcFieldMDebugShow:AddDataLog,'.\jcFieldShow.INI')
         jcFieldMDebugShow:PrintLog = _Show
         jcFieldMDebugShow:PrintLog = GETINI('jcFieldManager','jcFieldMDebugShow:PrintLog',jcFieldMDebugShow:PrintLog,'.\jcFieldShow.INI')
         jcFieldMDebugShow:PrintQ = _Show
         jcFieldMDebugShow:PrintQ = GETINI('jcFieldManager','jcFieldMDebugShow:PrintQ',jcFieldMDebugShow:PrintQ,'.\jcFieldShow.INI')
_jcFieldShowVariablesOnFetching_


            SECTION('Updating jcField jcDebugShow INI file')

         OMIT('_jcFieldShowVariablesOnUpdating_',_SelectjcFieldVariablesShow_)

         !Section jcFieldClass
         PUTINI('jcFieldClass','jcFieldDebugShow:Construct',jcFieldDebugShow:Construct)
         PUTINI('jcFieldClass','jcFieldDebugShow:Destruct',jcFieldDebugShow:Destruct)
         PUTINI('jcFieldClass','jcFieldDebugShow:Init',jcFieldDebugShow:Init)
         PUTINI('jcFieldClass','jcFieldDebugShow:Kill',jcFieldDebugShow:Kill)
         PUTINI('jcFieldClass','jcFieldDebugShow:MethodStart',jcFieldDebugShow:MethodStart)
         PUTINI('jcFieldClass','jcFieldDebugShow:MethodEnd',jcFieldDebugShow:MethodEnd)
         PUTINI('jcFieldClass','jcFieldDebugShow:PrepareType',jcFieldDebugShow:PrepareType)
         PUTINI('jcFieldClass','jcFieldDebugShow:ShowFields',jcFieldDebugShow:ShowFields)
         PUTINI('jcFieldClass','jcFieldDebugShow:CreateStructure',jcFieldDebugShow:CreateStructure)
         PUTINI('jcFieldClass','jcFieldDebugShow:SetStructure',jcFieldDebugShow:SetStructure)
         PUTINI('jcFieldClass','jcFieldDebugShow:GetStructure',jcFieldDebugShow:GetStructure)
         PUTINI('jcFieldClass','jcFieldDebugShow:CreateField',jcFieldDebugShow:CreateField)
         PUTINI('jcFieldClass','jcFieldDebugShow:SetField',jcFieldDebugShow:SetField)
         PUTINI('jcFieldClass','jcFieldDebugShow:Set',jcFieldDebugShow:Set)
         PUTINI('jcFieldClass','jcFieldDebugShow:UpdateDefinition',jcFieldDebugShow:UpdateDefinition)
         PUTINI('jcFieldClass','jcFieldDebugShow:SetPairQ',jcFieldDebugShow:SetPairQ)
         PUTINI('jcFieldClass','jcFieldDebugShow:SetPairG',jcFieldDebugShow:SetPairG)
         PUTINI('jcFieldClass','jcFieldDebugShow:Add',jcFieldDebugShow:Add)
         PUTINI('jcFieldClass','jcFieldDebugShow:Add',jcFieldDebugShow:Add)
         PUTINI('jcFieldClass','jcFieldDebugShow:Get',jcFieldDebugShow:Get)
         PUTINI('jcFieldClass','jcFieldDebugShow:WhatIs',jcFieldDebugShow:WhatIs)
         PUTINI('jcFieldClass','jcFieldDebugShow:FieldTypeIs',jcFieldDebugShow:FieldTypeIs)
         PUTINI('jcFieldClass','jcFieldDebugShow:GetData',jcFieldDebugShow:GetData)
         PUTINI('jcFieldClass','jcFieldDebugShow:GetSize',jcFieldDebugShow:GetSize)
         PUTINI('jcFieldClass','jcFieldDebugShow:Update',jcFieldDebugShow:Update)
         PUTINI('jcFieldClass','jcFieldDebugShow:Update',jcFieldDebugShow:Update)
         PUTINI('jcFieldClass','jcFieldDebugShow:Delete',jcFieldDebugShow:Delete)
         PUTINI('jcFieldClass','jcFieldDebugShow:GetString',jcFieldDebugShow:GetString)
         PUTINI('jcFieldClass','jcFieldDebugShow:SetTypeOnly',jcFieldDebugShow:SetTypeOnly)
         PUTINI('jcFieldClass','jcFieldDebugShow:GetTypeOnly',jcFieldDebugShow:GetTypeOnly)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         PUTINI('jcFieldClass','jcFieldDebugShow:Is',jcFieldDebugShow:Is)
         !Section jcFieldArray
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         PUTINI('jcFieldArray','jcFieldADebugShow:Is',jcFieldADebugShow:Is)
         !Section jcFieldDataManager
         PUTINI('jcFieldDataManager','jcFieldDDebugShow:Construct',jcFieldDDebugShow:Construct)
         PUTINI('jcFieldDataManager','jcFieldDDebugShow:Destruct',jcFieldDDebugShow:Destruct)
         PUTINI('jcFieldDataManager','jcFieldDDebugShow:AddData',jcFieldDDebugShow:AddData)
         PUTINI('jcFieldDataManager','jcFieldDDebugShow:Get',jcFieldDDebugShow:Get)
         PUTINI('jcFieldDataManager','jcFieldDDebugShow:SetCurrentFieldID',jcFieldDDebugShow:SetCurrentFieldID)
         PUTINI('jcFieldDataManager','jcFieldDDebugShow:GetCurrentFieldID',jcFieldDDebugShow:GetCurrentFieldID)
         PUTINI('jcFieldDataManager','jcFieldDDebugShow:DeleteData',jcFieldDDebugShow:DeleteData)
         PUTINI('jcFieldDataManager','jcFieldDDebugShow:UpdateData',jcFieldDDebugShow:UpdateData)
         PUTINI('jcFieldDataManager','jcFieldDDebugShow:GetHeaderColumns',jcFieldDDebugShow:GetHeaderColumns)
         PUTINI('jcFieldDataManager','jcFieldDDebugShow:ShowFieldDataQueue',jcFieldDDebugShow:ShowFieldDataQueue)
         !Section jcFieldManager
         PUTINI('jcFieldManager','jcFieldMDebugShow:Construct',jcFieldMDebugShow:Construct)
         PUTINI('jcFieldManager','jcFieldMDebugShow:Destruct',jcFieldMDebugShow:Destruct)
         PUTINI('jcFieldManager','jcFieldMDebugShow:Init',jcFieldMDebugShow:Init)
         PUTINI('jcFieldManager','jcFieldMDebugShow:Kill',jcFieldMDebugShow:Kill)
         PUTINI('jcFieldManager','jcFieldMDebugShow:MethodStart',jcFieldMDebugShow:MethodStart)
         PUTINI('jcFieldManager','jcFieldMDebugShow:MethodEnd',jcFieldMDebugShow:MethodEnd)
         PUTINI('jcFieldManager','jcFieldMDebugShow:SetIndexField',jcFieldMDebugShow:SetIndexField)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetIndexField',jcFieldMDebugShow:GetIndexField)
         PUTINI('jcFieldManager','jcFieldMDebugShow:SetColumnIndex',jcFieldMDebugShow:SetColumnIndex)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetColumnIndex',jcFieldMDebugShow:GetColumnIndex)
         PUTINI('jcFieldManager','jcFieldMDebugShow:SetColumnIndexLength',jcFieldMDebugShow:SetColumnIndexLength)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetColumnIndexLength',jcFieldMDebugShow:GetColumnIndexLength)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetIndex',jcFieldMDebugShow:GetIndex)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetIndex',jcFieldMDebugShow:GetIndex)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetName',jcFieldMDebugShow:GetName)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetName',jcFieldMDebugShow:GetName)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetData',jcFieldMDebugShow:GetData)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetData',jcFieldMDebugShow:GetData)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetFields',jcFieldMDebugShow:GetFields)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetFields',jcFieldMDebugShow:GetFields)
         PUTINI('jcFieldManager','jcFieldMDebugShow:SetFieldsFormat',jcFieldMDebugShow:SetFieldsFormat)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetFieldsFormat',jcFieldMDebugShow:GetFieldsFormat)
         PUTINI('jcFieldManager','jcFieldMDebugShow:SetFieldsFormatLimit',jcFieldMDebugShow:SetFieldsFormatLimit)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetFieldsFormatLimit',jcFieldMDebugShow:GetFieldsFormatLimit)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetARecordFromQueue',jcFieldMDebugShow:GetARecordFromQueue)
         PUTINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsSet',jcFieldMDebugShow:CalculateColumnsSet)
         PUTINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsSet',jcFieldMDebugShow:CalculateColumnsSet)
         PUTINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsSet',jcFieldMDebugShow:CalculateColumnsSet)
         PUTINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsSet',jcFieldMDebugShow:CalculateColumnsSet)
         PUTINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsSet',jcFieldMDebugShow:CalculateColumnsSet)
         PUTINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsRow',jcFieldMDebugShow:CalculateColumnsRow)
         PUTINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsRow',jcFieldMDebugShow:CalculateColumnsRow)
         PUTINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsRow',jcFieldMDebugShow:CalculateColumnsRow)
         PUTINI('jcFieldManager','jcFieldMDebugShow:CalculateColumnsRow',jcFieldMDebugShow:CalculateColumnsRow)
         PUTINI('jcFieldManager','jcFieldMDebugShow:SetColumnsSize',jcFieldMDebugShow:SetColumnsSize)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetColumnsSize',jcFieldMDebugShow:GetColumnsSize)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetNumberOfColumns',jcFieldMDebugShow:GetNumberOfColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetNumberOfColumns',jcFieldMDebugShow:GetNumberOfColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetHeaderColumns',jcFieldMDebugShow:GetHeaderColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetHeaderColumns',jcFieldMDebugShow:GetHeaderColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetHeaderColumns',jcFieldMDebugShow:GetHeaderColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetHeaderColumns',jcFieldMDebugShow:GetHeaderColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:ShowColumns',jcFieldMDebugShow:ShowColumns)
         PUTINI('jcFieldManager','jcFieldMDebugShow:GetStringFormatLength',jcFieldMDebugShow:GetStringFormatLength)
         PUTINI('jcFieldManager','jcFieldMDebugShow:EmbedShow',jcFieldMDebugShow:EmbedShow)
         PUTINI('jcFieldManager','jcFieldMDebugShow:ShowQueue',jcFieldMDebugShow:ShowQueue)
         PUTINI('jcFieldManager','jcFieldMDebugShow:ShowQueue',jcFieldMDebugShow:ShowQueue)
         PUTINI('jcFieldManager','jcFieldMDebugShow:ShowQueue',jcFieldMDebugShow:ShowQueue)
         PUTINI('jcFieldManager','jcFieldMDebugShow:AddDataLog',jcFieldMDebugShow:AddDataLog)
         PUTINI('jcFieldManager','jcFieldMDebugShow:PrintLog',jcFieldMDebugShow:PrintLog)
         PUTINI('jcFieldManager','jcFieldMDebugShow:PrintQ',jcFieldMDebugShow:PrintQ)
_jcFieldShowVariablesOnUpdating_

