--[[
    CREATED BY:
    https://store.rxscripts.xyz/

    JOIN DISCORD FOR MORE SCRIPTS:
    https://discord.gg/DHnjcW96an
--]]

Locales = {}

function Error(str, ...)
    if ... then
        print("^7(^1ERROR^7) "..string.format(str, ...).."^7")
    else
        print("^7(^1ERROR^7) "..str.."^7")
    end
end

function Success(str, ...)
    if ... then
        print("^7(^2SUCCESS^7) "..string.format(str, ...).."^7")
    else
        print("^7(^2SUCCESS^7) "..str.."^7")
    end
end

function _L(str, ...)
    if Locales[Config.Locale] ~= nil then
        if Locales[Config.Locale][str] ~= nil then
            if ... then
                return string.format(Locales[Config.Locale][str], ...)
            else
                return Locales[Config.Locale][str]
            end
        else
            return 'Translation ['..Config.Locale..']['..str..'] does not exist'
        end
    else
        return 'Locale ['..Config.Locale..'] does not exist'
    end
end

for k, v in pairs(Resources) do
    if GetResourceState(v.name) == 'started' then
        if k == 'QBTarget' and GetResourceState(Resources.OXTarget?.name) == 'started' then goto continue end

        if type(v) == 'table' then
            if v.export == 'all' then
                _G[k] = exports[v.name]
            elseif v.export then
                _G[k] = exports[v.name][v.export]()
            else
                _G[k] = true
            end
        end

        if not IgnoreScriptFoundLogs then
            Success("Initialized: "..v.name)
        end

        ::continue::
    end
end

if FM then
    Success("Initialized ^1" .. GetCurrentResourceName() .." ^7by ^1rxscripts.xyz")
else
    Error("No fmLib found for %s", GetCurrentResourceName())
    Error("Please install fmLib (https://github.com/meesvrh/fmLib/releases)")
    Error("Make sure to ensure fmLib in your server.cfg before this resource")
end

--[[
    SERVER SIDE CODE BELOW
--]]
if not IsDuplicityVersion() then return end

local function isVersionOlder(cVer, lVer)
    local cNums = {}
    local lNums = {}

    for num in cVer:gmatch("(%d+)") do
        cNums[#cNums + 1] = tonumber(num)
    end

    for num in lVer:gmatch("(%d+)") do
        lNums[#lNums + 1] = tonumber(num)
    end

    for i = 1, math.min(#cNums, #lNums) do
        if cNums[i] < lNums[i] then
            return true
        elseif cNums[i] > lNums[i] then
            return false
        end
    end

    return #cNums < #lNums
end

CreateThread(function()
    local resource = GetCurrentResourceName()
    local author = GetResourceMetadata(resource, 'author', 0)
    local repo = GetResourceMetadata(resource, 'repository', 0)
    local cVer = GetResourceMetadata(resource, 'version', 0)

    PerformHttpRequest(string.format('https://api.github.com/repos/%s/%s/releases/latest', author, repo), function(status, res)
        if status ~= 200 or not res then return FM.console.err('Unable to check for updates') end
        res = json.decode(res)

        if res.draft or res.prerelease or not res.tag_name then return end

        if isVersionOlder(cVer, res.tag_name) then
            FM.console.update(string.format("You're running an outdated version of %s (current version: %s)!", resource, cVer))
            FM.console.update(string.format("Download the latest version (%s) here: %s", res.tag_name, res.html_url))
            return
        else
            FM.console.suc(string.format('%s is up to date!', resource))
            return
        end
    end, 'GET')
end)