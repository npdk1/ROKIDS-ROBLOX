-- =====================================
-- || SCRIPT MADE BY NPDK             ||
-- =====================================

print("=====================================")
print("|| ✅   SCRIPT MADE BY NPDK  ✅      ||")
print("|| 💸  HAVE A NICE DAY WITH MY SCRIPT!  💸 ||")
print("=====================================")

-- Biến cờ để kiểm tra xem yêu cầu đã được gửi chưa
local requestSent = false

-- Hàm phát hiện Level trong game GPO
local function getCurrentLevel()
    -- Truy cập vào Level trong PlayerGui
    local levelObject = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level

    -- Kiểm tra xem đối tượng Level có hợp lệ không
    if levelObject then
        -- Kiểm tra nếu Level là TextLabel hoặc TextBox để lấy giá trị
        if levelObject:IsA("TextLabel") or levelObject:IsA("TextBox") then
            -- Trích xuất cấp độ từ văn bản
            local text = levelObject.Text
            local currentLevel = tonumber(string.match(text, "%d+")) -- Trích xuất số cấp độ
            if currentLevel then
                return currentLevel -- Trả về giá trị cấp độ
            else
                print("Không thể trích xuất giá trị Level từ văn bản: " .. text)
                return 0
            end
        -- Kiểm tra nếu Level là một NumberValue hoặc IntValue
        elseif levelObject:IsA("NumberValue") or levelObject:IsA("IntValue") then
            return levelObject.Value -- Trả về giá trị cấp độ từ NumberValue hoặc IntValue
        else
            print("Đối tượng Level không phải là TextLabel, TextBox, hoặc NumberValue!")
            return 0
        end
    else
        print("Không tìm thấy đối tượng Level!")
        return 0
    end
end

-- Hàm gửi yêu cầu POST với ID người chơi
local function postRequest()
    local success, err = pcall(function()
        request({
            Url = 'http://localhost:5000/api/changeacc',
            Method = 'POST',
            Headers = {['content-type'] = 'application/json'},
            Body = game:GetService('HttpService'):JSONEncode({['id'] = tostring(game:GetService("Players").LocalPlayer.UserId)})
        })
    end)

    if success then
        print("[ Rokid Manager ] - Request Posted Successfully")
        requestSent = true -- Đánh dấu yêu cầu đã được gửi
    else
        print("[ Rokid Manager ] - Lỗi khi gửi yêu cầu: " .. tostring(err))
    end
end

-- Hàm kiểm tra Level và gửi yêu cầu khi đạt TargetLevel
local function checkLevel()
    local currentLevel = getCurrentLevel() -- Lấy Level hiện tại
    print("[Thông báo] Level hiện tại: " .. currentLevel)
    if currentLevel >= getgenv().TargetLevel then
        print("[Thông báo] Đạt đủ Level mục tiêu: " .. currentLevel)
        return true -- Trả về true khi đạt đủ Level
    else
        print("[Thông báo] Chưa đạt đủ Level! Hiện tại: " .. currentLevel)
        return false -- Trả về false nếu chưa đủ Level
    end
end

-- Kiểm tra Level liên tục và gửi yêu cầu khi đạt TargetLevel
while not requestSent do
    local isLevelEnough = checkLevel() -- Kiểm tra Level
    if isLevelEnough then
        postRequest() -- Gửi yêu cầu POST khi đạt đủ Level
    end
    wait(getgenv().Delay) -- Chờ trước khi kiểm tra lại
end
