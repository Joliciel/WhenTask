            SECTION('Fetching jcLog jcDebugShow INI file')

            !jcDebugShow:MainSource.SubSource = 1 is Show for programmer represented by the equate _Show
            !jcDebugShow:MainSource.SubSource = 0 is Hide for programmer represented by the equate _Hide

         INCLUDE('jcLogShowOptions.inc'),ONCE

         OMIT('_jcLogShowVariablesOnFetching_',_SelectjcLogVariablesShow_)

         !Section jcLogManager
         jcLogDebugShow:ViewLogFile = _Show
         jcLogDebugShow:ViewLogFile = GETINI('jcLogManager','jcLogDebugShow:ViewLogFile',jcLogDebugShow:ViewLogFile,'.\jcLogShow.INI')
         jcLogDebugShow:Construct = _Show
         jcLogDebugShow:Construct = GETINI('jcLogManager','jcLogDebugShow:Construct',jcLogDebugShow:Construct,'.\jcLogShow.INI')
         jcLogDebugShow:Init = _Show
         jcLogDebugShow:Init = GETINI('jcLogManager','jcLogDebugShow:Init',jcLogDebugShow:Init,'.\jcLogShow.INI')
         jcLogDebugShow:Init = _Show
         jcLogDebugShow:Init = GETINI('jcLogManager','jcLogDebugShow:Init',jcLogDebugShow:Init,'.\jcLogShow.INI')
         jcLogDebugShow:PrepareClassName = _Show
         jcLogDebugShow:PrepareClassName = GETINI('jcLogManager','jcLogDebugShow:PrepareClassName',jcLogDebugShow:PrepareClassName,'.\jcLogShow.INI')
         jcLogDebugShow:Set = _Show
         jcLogDebugShow:Set = GETINI('jcLogManager','jcLogDebugShow:Set',jcLogDebugShow:Set,'.\jcLogShow.INI')
         jcLogDebugShow:Get = _Show
         jcLogDebugShow:Get = GETINI('jcLogManager','jcLogDebugShow:Get',jcLogDebugShow:Get,'.\jcLogShow.INI')
         jcLogDebugShow:SetFile = _Show
         jcLogDebugShow:SetFile = GETINI('jcLogManager','jcLogDebugShow:SetFile',jcLogDebugShow:SetFile,'.\jcLogShow.INI')
         jcLogDebugShow:SetFileServer = _Show
         jcLogDebugShow:SetFileServer = GETINI('jcLogManager','jcLogDebugShow:SetFileServer',jcLogDebugShow:SetFileServer,'.\jcLogShow.INI')
         jcLogDebugShow:OpenFile = _Show
         jcLogDebugShow:OpenFile = GETINI('jcLogManager','jcLogDebugShow:OpenFile',jcLogDebugShow:OpenFile,'.\jcLogShow.INI')
         jcLogDebugShow:CloseFile = _Show
         jcLogDebugShow:CloseFile = GETINI('jcLogManager','jcLogDebugShow:CloseFile',jcLogDebugShow:CloseFile,'.\jcLogShow.INI')
         jcLogDebugShow:Fetch = _Show
         jcLogDebugShow:Fetch = GETINI('jcLogManager','jcLogDebugShow:Fetch',jcLogDebugShow:Fetch,'.\jcLogShow.INI')
         jcLogDebugShow:Next = _Show
         jcLogDebugShow:Next = GETINI('jcLogManager','jcLogDebugShow:Next',jcLogDebugShow:Next,'.\jcLogShow.INI')
         jcLogDebugShow:GetRecord = _Show
         jcLogDebugShow:GetRecord = GETINI('jcLogManager','jcLogDebugShow:GetRecord',jcLogDebugShow:GetRecord,'.\jcLogShow.INI')
         jcLogDebugShow:EoF = _Show
         jcLogDebugShow:EoF = GETINI('jcLogManager','jcLogDebugShow:EoF',jcLogDebugShow:EoF,'.\jcLogShow.INI')
         jcLogDebugShow:GetFileLabel = _Show
         jcLogDebugShow:GetFileLabel = GETINI('jcLogManager','jcLogDebugShow:GetFileLabel',jcLogDebugShow:GetFileLabel,'.\jcLogShow.INI')
         jcLogDebugShow:SetPath = _Show
         jcLogDebugShow:SetPath = GETINI('jcLogManager','jcLogDebugShow:SetPath',jcLogDebugShow:SetPath,'.\jcLogShow.INI')
         jcLogDebugShow:GetPath = _Show
         jcLogDebugShow:GetPath = GETINI('jcLogManager','jcLogDebugShow:GetPath',jcLogDebugShow:GetPath,'.\jcLogShow.INI')
         jcLogDebugShow:SetExtension = _Show
         jcLogDebugShow:SetExtension = GETINI('jcLogManager','jcLogDebugShow:SetExtension',jcLogDebugShow:SetExtension,'.\jcLogShow.INI')
         jcLogDebugShow:GetExtension = _Show
         jcLogDebugShow:GetExtension = GETINI('jcLogManager','jcLogDebugShow:GetExtension',jcLogDebugShow:GetExtension,'.\jcLogShow.INI')
         jcLogDebugShow:SetLogFormatLimit = _Show
         jcLogDebugShow:SetLogFormatLimit = GETINI('jcLogManager','jcLogDebugShow:SetLogFormatLimit',jcLogDebugShow:SetLogFormatLimit,'.\jcLogShow.INI')
         jcLogDebugShow:GetLogFormatLimit = _Show
         jcLogDebugShow:GetLogFormatLimit = GETINI('jcLogManager','jcLogDebugShow:GetLogFormatLimit',jcLogDebugShow:GetLogFormatLimit,'.\jcLogShow.INI')
         jcLogDebugShow:SetLogFormat = _Show
         jcLogDebugShow:SetLogFormat = GETINI('jcLogManager','jcLogDebugShow:SetLogFormat',jcLogDebugShow:SetLogFormat,'.\jcLogShow.INI')
         jcLogDebugShow:GetLogFormat = _Show
         jcLogDebugShow:GetLogFormat = GETINI('jcLogManager','jcLogDebugShow:GetLogFormat',jcLogDebugShow:GetLogFormat,'.\jcLogShow.INI')
         jcLogDebugShow:SetLogFileName = _Show
         jcLogDebugShow:SetLogFileName = GETINI('jcLogManager','jcLogDebugShow:SetLogFileName',jcLogDebugShow:SetLogFileName,'.\jcLogShow.INI')
         jcLogDebugShow:GetLogFileName = _Show
         jcLogDebugShow:GetLogFileName = GETINI('jcLogManager','jcLogDebugShow:GetLogFileName',jcLogDebugShow:GetLogFileName,'.\jcLogShow.INI')
         jcLogDebugShow:ReadToQueue = _Show
         jcLogDebugShow:ReadToQueue = GETINI('jcLogManager','jcLogDebugShow:ReadToQueue',jcLogDebugShow:ReadToQueue,'.\jcLogShow.INI')
         jcLogDebugShow:ReadQueueToLogFile = _Show
         jcLogDebugShow:ReadQueueToLogFile = GETINI('jcLogManager','jcLogDebugShow:ReadQueueToLogFile',jcLogDebugShow:ReadQueueToLogFile,'.\jcLogShow.INI')
         jcLogDebugShow:SetDate = _Show
         jcLogDebugShow:SetDate = GETINI('jcLogManager','jcLogDebugShow:SetDate',jcLogDebugShow:SetDate,'.\jcLogShow.INI')
         jcLogDebugShow:GetDate = _Show
         jcLogDebugShow:GetDate = GETINI('jcLogManager','jcLogDebugShow:GetDate',jcLogDebugShow:GetDate,'.\jcLogShow.INI')
         jcLogDebugShow:SetTime = _Show
         jcLogDebugShow:SetTime = GETINI('jcLogManager','jcLogDebugShow:SetTime',jcLogDebugShow:SetTime,'.\jcLogShow.INI')
         jcLogDebugShow:GetTime = _Show
         jcLogDebugShow:GetTime = GETINI('jcLogManager','jcLogDebugShow:GetTime',jcLogDebugShow:GetTime,'.\jcLogShow.INI')
         jcLogDebugShow:SetSeparator = _Show
         jcLogDebugShow:SetSeparator = GETINI('jcLogManager','jcLogDebugShow:SetSeparator',jcLogDebugShow:SetSeparator,'.\jcLogShow.INI')
         jcLogDebugShow:GetSeparator = _Show
         jcLogDebugShow:GetSeparator = GETINI('jcLogManager','jcLogDebugShow:GetSeparator',jcLogDebugShow:GetSeparator,'.\jcLogShow.INI')
         jcLogDebugShow:VerifyDateFormat = _Show
         jcLogDebugShow:VerifyDateFormat = GETINI('jcLogManager','jcLogDebugShow:VerifyDateFormat',jcLogDebugShow:VerifyDateFormat,'.\jcLogShow.INI')
         jcLogDebugShow:PrepareDateFormat = _Show
         jcLogDebugShow:PrepareDateFormat = GETINI('jcLogManager','jcLogDebugShow:PrepareDateFormat',jcLogDebugShow:PrepareDateFormat,'.\jcLogShow.INI')
         jcLogDebugShow:SetDateFormat = _Show
         jcLogDebugShow:SetDateFormat = GETINI('jcLogManager','jcLogDebugShow:SetDateFormat',jcLogDebugShow:SetDateFormat,'.\jcLogShow.INI')
         jcLogDebugShow:GetDateFormat = _Show
         jcLogDebugShow:GetDateFormat = GETINI('jcLogManager','jcLogDebugShow:GetDateFormat',jcLogDebugShow:GetDateFormat,'.\jcLogShow.INI')
         jcLogDebugShow:VerifyTimeFormat = _Show
         jcLogDebugShow:VerifyTimeFormat = GETINI('jcLogManager','jcLogDebugShow:VerifyTimeFormat',jcLogDebugShow:VerifyTimeFormat,'.\jcLogShow.INI')
         jcLogDebugShow:PrepareTimeFormat = _Show
         jcLogDebugShow:PrepareTimeFormat = GETINI('jcLogManager','jcLogDebugShow:PrepareTimeFormat',jcLogDebugShow:PrepareTimeFormat,'.\jcLogShow.INI')
         jcLogDebugShow:SetTimeFormat = _Show
         jcLogDebugShow:SetTimeFormat = GETINI('jcLogManager','jcLogDebugShow:SetTimeFormat',jcLogDebugShow:SetTimeFormat,'.\jcLogShow.INI')
         jcLogDebugShow:GetTimeFormat = _Show
         jcLogDebugShow:GetTimeFormat = GETINI('jcLogManager','jcLogDebugShow:GetTimeFormat',jcLogDebugShow:GetTimeFormat,'.\jcLogShow.INI')
         jcLogDebugShow:SetLineNoFormat = _Show
         jcLogDebugShow:SetLineNoFormat = GETINI('jcLogManager','jcLogDebugShow:SetLineNoFormat',jcLogDebugShow:SetLineNoFormat,'.\jcLogShow.INI')
         jcLogDebugShow:GetLineNoFormat = _Show
         jcLogDebugShow:GetLineNoFormat = GETINI('jcLogManager','jcLogDebugShow:GetLineNoFormat',jcLogDebugShow:GetLineNoFormat,'.\jcLogShow.INI')
         jcLogDebugShow:SetLineFormatLimit = _Show
         jcLogDebugShow:SetLineFormatLimit = GETINI('jcLogManager','jcLogDebugShow:SetLineFormatLimit',jcLogDebugShow:SetLineFormatLimit,'.\jcLogShow.INI')
         jcLogDebugShow:GetLineFormatLimit = _Show
         jcLogDebugShow:GetLineFormatLimit = GETINI('jcLogManager','jcLogDebugShow:GetLineFormatLimit',jcLogDebugShow:GetLineFormatLimit,'.\jcLogShow.INI')
         jcLogDebugShow:SetLineFormat = _Show
         jcLogDebugShow:SetLineFormat = GETINI('jcLogManager','jcLogDebugShow:SetLineFormat',jcLogDebugShow:SetLineFormat,'.\jcLogShow.INI')
         jcLogDebugShow:GetLineFormat = _Show
         jcLogDebugShow:GetLineFormat = GETINI('jcLogManager','jcLogDebugShow:GetLineFormat',jcLogDebugShow:GetLineFormat,'.\jcLogShow.INI')
         jcLogDebugShow:SetLineNo = _Show
         jcLogDebugShow:SetLineNo = GETINI('jcLogManager','jcLogDebugShow:SetLineNo',jcLogDebugShow:SetLineNo,'.\jcLogShow.INI')
         jcLogDebugShow:GetLineNo = _Show
         jcLogDebugShow:GetLineNo = GETINI('jcLogManager','jcLogDebugShow:GetLineNo',jcLogDebugShow:GetLineNo,'.\jcLogShow.INI')
         jcLogDebugShow:SetLine = _Show
         jcLogDebugShow:SetLine = GETINI('jcLogManager','jcLogDebugShow:SetLine',jcLogDebugShow:SetLine,'.\jcLogShow.INI')
         jcLogDebugShow:AddLine = _Show
         jcLogDebugShow:AddLine = GETINI('jcLogManager','jcLogDebugShow:AddLine',jcLogDebugShow:AddLine,'.\jcLogShow.INI')
         jcLogDebugShow:Destruct = _Show
         jcLogDebugShow:Destruct = GETINI('jcLogManager','jcLogDebugShow:Destruct',jcLogDebugShow:Destruct,'.\jcLogShow.INI')
         jcLogDebugShow:Kill = _Show
         jcLogDebugShow:Kill = GETINI('jcLogManager','jcLogDebugShow:Kill',jcLogDebugShow:Kill,'.\jcLogShow.INI')
_jcLogShowVariablesOnFetching_


            SECTION('Updating jcLog jcDebugShow INI file')

         OMIT('_jcLogShowVariablesOnUpdating_',_SelectjcLogVariablesShow_)

         !Section jcLogManager
         PUTINI('jcLogManager','jcLogDebugShow:ViewLogFile',jcLogDebugShow:ViewLogFile)
         PUTINI('jcLogManager','jcLogDebugShow:Construct',jcLogDebugShow:Construct)
         PUTINI('jcLogManager','jcLogDebugShow:Init',jcLogDebugShow:Init)
         PUTINI('jcLogManager','jcLogDebugShow:Init',jcLogDebugShow:Init)
         PUTINI('jcLogManager','jcLogDebugShow:PrepareClassName',jcLogDebugShow:PrepareClassName)
         PUTINI('jcLogManager','jcLogDebugShow:Set',jcLogDebugShow:Set)
         PUTINI('jcLogManager','jcLogDebugShow:Get',jcLogDebugShow:Get)
         PUTINI('jcLogManager','jcLogDebugShow:SetFile',jcLogDebugShow:SetFile)
         PUTINI('jcLogManager','jcLogDebugShow:SetFileServer',jcLogDebugShow:SetFileServer)
         PUTINI('jcLogManager','jcLogDebugShow:OpenFile',jcLogDebugShow:OpenFile)
         PUTINI('jcLogManager','jcLogDebugShow:CloseFile',jcLogDebugShow:CloseFile)
         PUTINI('jcLogManager','jcLogDebugShow:Fetch',jcLogDebugShow:Fetch)
         PUTINI('jcLogManager','jcLogDebugShow:Next',jcLogDebugShow:Next)
         PUTINI('jcLogManager','jcLogDebugShow:GetRecord',jcLogDebugShow:GetRecord)
         PUTINI('jcLogManager','jcLogDebugShow:EoF',jcLogDebugShow:EoF)
         PUTINI('jcLogManager','jcLogDebugShow:GetFileLabel',jcLogDebugShow:GetFileLabel)
         PUTINI('jcLogManager','jcLogDebugShow:SetPath',jcLogDebugShow:SetPath)
         PUTINI('jcLogManager','jcLogDebugShow:GetPath',jcLogDebugShow:GetPath)
         PUTINI('jcLogManager','jcLogDebugShow:SetExtension',jcLogDebugShow:SetExtension)
         PUTINI('jcLogManager','jcLogDebugShow:GetExtension',jcLogDebugShow:GetExtension)
         PUTINI('jcLogManager','jcLogDebugShow:SetLogFormatLimit',jcLogDebugShow:SetLogFormatLimit)
         PUTINI('jcLogManager','jcLogDebugShow:GetLogFormatLimit',jcLogDebugShow:GetLogFormatLimit)
         PUTINI('jcLogManager','jcLogDebugShow:SetLogFormat',jcLogDebugShow:SetLogFormat)
         PUTINI('jcLogManager','jcLogDebugShow:GetLogFormat',jcLogDebugShow:GetLogFormat)
         PUTINI('jcLogManager','jcLogDebugShow:SetLogFileName',jcLogDebugShow:SetLogFileName)
         PUTINI('jcLogManager','jcLogDebugShow:GetLogFileName',jcLogDebugShow:GetLogFileName)
         PUTINI('jcLogManager','jcLogDebugShow:ReadToQueue',jcLogDebugShow:ReadToQueue)
         PUTINI('jcLogManager','jcLogDebugShow:ReadQueueToLogFile',jcLogDebugShow:ReadQueueToLogFile)
         PUTINI('jcLogManager','jcLogDebugShow:SetDate',jcLogDebugShow:SetDate)
         PUTINI('jcLogManager','jcLogDebugShow:GetDate',jcLogDebugShow:GetDate)
         PUTINI('jcLogManager','jcLogDebugShow:SetTime',jcLogDebugShow:SetTime)
         PUTINI('jcLogManager','jcLogDebugShow:GetTime',jcLogDebugShow:GetTime)
         PUTINI('jcLogManager','jcLogDebugShow:SetSeparator',jcLogDebugShow:SetSeparator)
         PUTINI('jcLogManager','jcLogDebugShow:GetSeparator',jcLogDebugShow:GetSeparator)
         PUTINI('jcLogManager','jcLogDebugShow:VerifyDateFormat',jcLogDebugShow:VerifyDateFormat)
         PUTINI('jcLogManager','jcLogDebugShow:PrepareDateFormat',jcLogDebugShow:PrepareDateFormat)
         PUTINI('jcLogManager','jcLogDebugShow:SetDateFormat',jcLogDebugShow:SetDateFormat)
         PUTINI('jcLogManager','jcLogDebugShow:GetDateFormat',jcLogDebugShow:GetDateFormat)
         PUTINI('jcLogManager','jcLogDebugShow:VerifyTimeFormat',jcLogDebugShow:VerifyTimeFormat)
         PUTINI('jcLogManager','jcLogDebugShow:PrepareTimeFormat',jcLogDebugShow:PrepareTimeFormat)
         PUTINI('jcLogManager','jcLogDebugShow:SetTimeFormat',jcLogDebugShow:SetTimeFormat)
         PUTINI('jcLogManager','jcLogDebugShow:GetTimeFormat',jcLogDebugShow:GetTimeFormat)
         PUTINI('jcLogManager','jcLogDebugShow:SetLineNoFormat',jcLogDebugShow:SetLineNoFormat)
         PUTINI('jcLogManager','jcLogDebugShow:GetLineNoFormat',jcLogDebugShow:GetLineNoFormat)
         PUTINI('jcLogManager','jcLogDebugShow:SetLineFormatLimit',jcLogDebugShow:SetLineFormatLimit)
         PUTINI('jcLogManager','jcLogDebugShow:GetLineFormatLimit',jcLogDebugShow:GetLineFormatLimit)
         PUTINI('jcLogManager','jcLogDebugShow:SetLineFormat',jcLogDebugShow:SetLineFormat)
         PUTINI('jcLogManager','jcLogDebugShow:GetLineFormat',jcLogDebugShow:GetLineFormat)
         PUTINI('jcLogManager','jcLogDebugShow:SetLineNo',jcLogDebugShow:SetLineNo)
         PUTINI('jcLogManager','jcLogDebugShow:GetLineNo',jcLogDebugShow:GetLineNo)
         PUTINI('jcLogManager','jcLogDebugShow:SetLine',jcLogDebugShow:SetLine)
         PUTINI('jcLogManager','jcLogDebugShow:AddLine',jcLogDebugShow:AddLine)
         PUTINI('jcLogManager','jcLogDebugShow:Destruct',jcLogDebugShow:Destruct)
         PUTINI('jcLogManager','jcLogDebugShow:Kill',jcLogDebugShow:Kill)
_jcLogShowVariablesOnUpdating_

