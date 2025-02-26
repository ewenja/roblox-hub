print("Executor Name: ", getexecutorname and getexecutorname() or "未知執行器")

-- 檢查 HTTP 請求函數
local function getHttpRequest()
    if syn and syn.request then
        return syn.request, "Synapse Z"
    elseif request then
        return request, "Generic Executor"
    elseif http_request then
        return http_request, "Generic Executor"
    elseif getexecutorname then
        local executor = getexecutorname():lower() -- 轉換為小寫
        if executor == "swift" then
            return request, "Swift"
        elseif executor == "awp" or executor:find("awp") then
            return request or http_request, "AWP"
        elseif executor:find("velocity") then
            return request or http_request, "Velocity 0.2.4"
        elseif executor:find("fluxus") then
            return fluxus.request, "Fluxus"
        elseif executor:find("electron") then
            return request or http_request, "Electron"
        elseif executor:find("sirhurt") then
            return request or http_request, "Sirhurt"
        end
    end
    error("未檢測到支持的 HTTP 請求函數，請使用 Swift、Synapse Z、AWP、Velocity、Fluxus 或 Electron")
end

-- 獲取 HTTP 請求函數
local httpRequest, injectorName = getHttpRequest()

-- 發送請求到伺服器
local success, scriptResponse = pcall(function()
    return httpRequest({
        Url = "https://haihai.hihihub.workers.dev/",
        Method = "GET",
        Headers = {
            ["User-Agent"] = injectorName,
            ["X-Auth-Token"] = "EWE"
        }
    })
end)

-- 確保請求成功
if not success or not scriptResponse or scriptResponse.StatusCode ~= 200 then
    error("伺服器請求失敗，狀態碼：" .. (scriptResponse and scriptResponse.StatusCode or "未知"))
end

-- 讀取伺服器回應的 Lua 腳本
if not scriptResponse.Body or scriptResponse.Body == "" then
    error("伺服器返回的腳本內容為空！")
end

-- 增強安全性：檢查腳本內容是否安全
local forbiddenKeywords = { "os.execute", "io.popen", "game:Shutdown", "getfenv", "setfenv" }
for _, keyword in pairs(forbiddenKeywords) do
    if string.find(scriptResponse.Body, keyword) then
        error("安全檢查失敗，腳本包含禁止函數：" .. keyword)
    end
end

-- 加載腳本
local scriptFunction, loadError = loadstring(scriptResponse.Body)
if not scriptFunction then
    error("腳本加載失敗：" .. tostring(loadError))
end

-- 執行腳本
local successExec, execError = pcall(scriptFunction)
if not successExec then
    error("腳本執行失敗：" .. tostring(execError))
end
