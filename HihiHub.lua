print("Executor Name: ", getexecutorname and getexecutorname() or "未知執行器")

local function getHttpRequest()
    if syn and syn.request then
        return syn.request, "Synapse Z"
    elseif getexecutorname then
        local executor = getexecutorname():lower() -- 轉換為小寫
        if executor == "swift" then
            return request, "Swift"
        elseif executor == "awp" then
            if request then
                return request, "AWP"
            elseif http_request then
                return http_request, "AWP"
            else
                error("AWP 不支援 request 或 http_request")
            end
        elseif executor:find("velocity") then
            if request then
                return request, "Velocity 0.2.4"
            elseif http_request then
                return http_request, "Velocity 0.2.4"
            else
                error("Velocity 不支援 request 或 http_request")
            end
        end
    end
    error("未檢測到支持的 HTTP 請求函數，請使用 Swift、Synapse Z、AWP 或 Velocity")
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

local scriptFunction, loadError = loadstring(scriptResponse.Body)
if not scriptFunction then
    error("腳本加載失敗：" .. tostring(loadError))
end

local successExec, execError = pcall(scriptFunction)
if not successExec then
    error("腳本執行失敗：" .. tostring(execError))
end
