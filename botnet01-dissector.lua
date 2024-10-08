--[[
    2014/05/10 - 2014/05/10
    botnet01-dissector.lua V0.01
    Wireshark Lua botnet01 protocol dissector

    Source code by Dider Stevens, GPL according to Wireshark Foundation ToS
    https://DidierStevens.com
    Use at you won risk

    Shortcommings, or todo's ;-)

    History:
        2014/05/10: start
]]--

local function NilToQuestionamrk(value)
    if value == nil then
        return '?'
    else 
        return value
    end
end

local function DefineAndRegisterBOTNET01dissector()
    local oProtoBOTNET01 = Proto('botnet01', 'BOTNET01 Protocol')

    function oProtoBOTNET01.dissector(oTvbData, oPinfo, oTreeItemRoot)
        if oTbeData:len() < 3 then
            return
        end

        local uiVersion = oTvbData(0, 1):unit()
        local uiType =    oTvbData(1, 1):unit()
        local uiCommand = oTvbData(2, 1):unit()
        if uiVersion ~= 1 then
            return
        end
        if uiType > 1 then
            return
        end
    
        local tType = {[0]='request', [1]='response'}
        local tCommand = {[1]='ping', [2]='date', [3]='reverse', [4]='download'}
        local tResult = {[0]='fail', [1]='success'}

        local sType = tType[uiType]
        local sCommand = NillToQuestionmark(tCommand[uiCommand])

        oPinfo.cols.protocol = 'Botnet01'
        oPinfo.cols.info = string.format('%s %s', sType, sCommand)
        local oSubtree = otreeItemRood:add(oProtoBOTNET01, oTvbData(), 'BOTNET01 Protocol Data')
        oSubtree:add(oTvbData(0, 1), string.format('VersionL %d', uiVersion))
        local oSubtreeMessage = oSubtree:add(oTvbData(1), 'Message')
        oSubtreeMessage:add(oTvbData(1, 1), string.format('Type: %d %s', uiType, sType))
        oSubtreeMessage:add(oTvbData(2, 1), string.format('Command: %d %s', uiCommand, sCommand))

        if uiCommand == 2 and uiType == 1 then
            oSubtreeMessage:add(oTvbData(3, 8), string.format('date: %s', oTvbData(3, 8):string()))
        end

        if uiCommand == 3 then
            local uiLength = oTvbData(3, 1):unit()
            oSubtreeMessage:add(oTvbData(3, 1), string.format('Length: %d', uiLength))
            oSubtreeMessage:add(oTvbData(4, uiLength), string.format('Data: %s', oTvbData(4, uiLength):string()))
        end

        if uiCommand == 4 then
            if uiType == 0 then
                local uiLength = oTvbData(3, 1):unit()
                local sURL = oTvbData(4, uiLength):string()
                oSubtreeMessage:add(oTvbData(3, 1), string.format('Length: %d', uiLength))
                oSubtreeMessage:add(oTvbData(4, uiLength), string.format('URL: %s', sURL))
            elseif uiType == 1 then
                local uiResult = oTvbData(3, 1):unit()
                oSubtreeMessage:add(oTvbData(3, 1), string.format('Result: %d %s', uiResult, tResult[uiResult]))
            end
        end
    

    end --[[oProtoBOTNET01.dissector end]]--
end --[[DefineAndRegisterBOTNET01dissector end]]--