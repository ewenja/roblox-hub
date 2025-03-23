print("Executor Name: ", getexecutorname and getexecutorname() or "未知執行器")

-- 檢查 HTTP 請求函數
local function getHttpRequest()
    if syn and syn.request then
        return syn.request, "synapse z"
    elseif request then
        return request, "velocity"  -- 強制設為 velocity（小寫）
    elseif http_request then
        return http_request, "velocity"
    elseif fluxus and fluxus.request then
        return fluxus.request, "fluxus"
    end
    error("未檢測到支持的 HTTP 請求函數，請使用支援的執行器")
end

-- 獲取 HTTP 請求函數與 User-Agent
local httpRequest, injectorName = getHttpRequest()

-- 發送請求
local success, scriptResponse = pcall(function()
    return httpRequest({
        Url = "https://haihai.hihihub.workers.dev/",
        Method = "GET",
        Headers = {
            ["User-Agent"] = injectorName, -- 使用允許的 user-agent
            ["X-Auth-Token"] = "EWE",
            ["Referer"] = "https://roblox.com",
            ["Origin"] = "https://roblox.com"
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

-- 安全性檢查
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
