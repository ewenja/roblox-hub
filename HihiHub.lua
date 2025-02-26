print("Executor Name: ", getexecutorname())
local function getHttpRequest()
    if syn and syn.request then
        return syn.request, "Synapse Z"
    elseif getexecutorname then
        local executor = getexecutorname():lower() -- 轉換為小寫，方便比較
        if executor == "swift" then
            return request, "Swift"
        elseif executor == "awp" then  -- AWP.GG 回傳的是 "AWP"
            if request then
                return request, "AWP"
            elseif http_request then
                return http_request, "AWP"
            else
                error("AWP 不支持 request 或 http_request")
            end
        elseif executor:find("Velocity 0.2.4") then -- 適配 Sonar (Velocity)
            if request then
                return request, "Velocity 0.2.4"
            elseif http_request then
                return http_request, "Velocity 0.2.4"
            else
                error("Velocity (Sonar) 不支持 request 或 http_request")
            end
        end
    end
    error("未檢測到支持的 HTTP 請求函數，請使用 Swift、Synapse Z、AWP.GG 或 Velocity 0.2.4")
end

local httpRequest, injectorName = getHttpRequest()

-- 發送請求到伺服器
local scriptResponse = httpRequest({
    Url = "https://haihai.hihihub.workers.dev/",
    Method = "GET",
    Headers = {
        ["User-Agent"] = injectorName,
        ["X-Auth-Token"] = "EWE"
    }
})

-- 檢查伺服器返回的狀態
if scriptResponse.StatusCode == 200 then
    -- 檢查伺服器返回的腳本內容
    if not scriptResponse.Body or scriptResponse.Body == "" then
        error("伺服器返回的腳本內容為空！")
    end

    -- 加載並執行伺服器返回的腳本
    local scriptFunction, loadError = loadstring(scriptResponse.Body)
    if not scriptFunction then
        error("腳本加載失敗：" .. tostring(loadError))
    end

    local success, execError = pcall(scriptFunction)
    if not success then
        error("腳本執行失敗：" .. tostring(execError))
    end
else
    error("伺服器返回錯誤狀態：" .. scriptResponse.StatusCode)
end
