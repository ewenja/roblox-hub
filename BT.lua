-- 印出目前使用的執行器名稱
print("Executor Name:", getexecutorname and getexecutorname() or "未知執行器")

-- 嘗試獲取 HTTP 請求函數與執行器名稱
if syn and syn.request then
    return syn.request, "synapse z"
elseif getexecutorname and getexecutorname():lower():find("visual") and http_request then
    return http_request, "visual"
elseif fluxus and fluxus.request then
    return fluxus.request, "fluxus"
elseif request then
    return request, "velocity"
elseif http_request then
    return http_request, "velocity"
end
    error("未偵測到支援的 HTTP 請求函數，請使用 Synapse、Fluxus 或 Velocity。")
end

-- 初始化請求
local httpRequest, executorName = getHttpRequest()

-- 向伺服器發送請求以獲取腳本
local success, response = pcall(function()
    return httpRequest({
        Url = "https://ewe.hihihub.workers.dev/",
        Method = "GET",
        Headers = {
            ["User-Agent"] = executorName,
            ["X-Auth-Token"] = "EWE",
            ["Referer"] = "https://roblox.com",
            ["Origin"] = "https://roblox.com"
        }
    })
end)

-- 檢查請求是否成功
if not success or not response or response.StatusCode ~= 200 then
    error("請求失敗，狀態碼：" .. (response and response.StatusCode or "未知"))
end

-- 檢查返回內容
local body = response.Body
if not body or body == "" then
    error("伺服器返回空腳本")
end

-- 安全性掃描：避免危險函數
local forbidden = { "os.execute", "io.popen", "game:Shutdown", "getfenv", "setfenv" }
for _, word in pairs(forbidden) do
    if string.find(body, word) then
        error("腳本中包含禁止函數：" .. word)
    end
end

-- 嘗試加載並執行返回的腳本
local scriptFunc, loadErr = loadstring(body)
if not scriptFunc then
    error("腳本加載失敗：" .. tostring(loadErr))
end

local execSuccess, execErr = pcall(scriptFunc)
if not execSuccess then
    error("腳本執行失敗：" .. tostring(execErr))
end
