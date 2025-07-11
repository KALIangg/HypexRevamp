local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local HypeXLib = {}
local Tabs = {}
local Sections = {}
local plr = game.Players.LocalPlayer

-- 🔥 Inicia e cria Tabs padrão
function HypeXLib:Init()
    local win = Library.CreateLib("HypeX Revamp", "DarkTheme")

    -- Tabs (sem emojis nos índices)
    Tabs["Main"] = win:NewTab("Main")
    Tabs["Fruits"] = win:NewTab("🍎 Fruits")
    Tabs["Swords"] = win:NewTab("🗡️ Swords")
    Tabs["GuiSwords"] = win:NewTab("🗡️ Gui Swords")
    Tabs["Skills"] = win:NewTab("⚡ Skills")
    Tabs["Settings"] = win:NewTab("⚙️ Configs")
    Tabs["Admin"] = win:NewTab("🛠️ Admin Menu")
    Tabs["ServerPanel"] = win:NewTab("👥 Painel Server")
    Tabs["MenuTotal"] = win:NewTab("「 ✦ MENU TOTAL ✦ 」")

    -- Sections (sem emojis nos índices, mas com emojis no nome exibido)
    Sections["Autofarm"] = Tabs["Main"]:NewSection("⚔️ Autofarm")
    Sections["Fruits"] = Tabs["Fruits"]:NewSection("🍎 Frutas")
    Sections["Swords"] = Tabs["Swords"]:NewSection("🗡️ Espadas")
    Sections["GuiSwords"] = Tabs["GuiSwords"]:NewSection("🗡️ Espadas com GUI")
    Sections["Skills"] = Tabs["Skills"]:NewSection("⚡ Habilidades / Transformações")
    Sections["Settings"] = Tabs["Settings"]:NewSection("⚙️ Configurações")
    Sections["Admin"] = Tabs["Admin"]:NewSection("🛠️ Admin Tools")
    Sections["ServerPanelMain"] = Tabs["ServerPanel"]:NewSection("🔧 Controles Fixos")
    Sections["ServerPanelList"] = Tabs["ServerPanel"]:NewSection("📋 Jogadores Online")
    Sections["MenuTotal"] = Tabs["MenuTotal"]:NewSection("🚀 Total Access")
end


-- ✅ AutoFarm com seção
function HypeXLib:CreateAutoFarm(name, path, enemy, section)
    local sec = Sections[section]
    if not sec then warn("Seção inválida:", section) return end

    sec:NewButton(name, "Farm NPCs", function()
        print("Iniciando autofarm:", name)
        -- código omitido por espaço
    end)
end

-- 🧠 Tool com GUI por seção
function HypeXLib:CreateToolButton(name, toolName, guiName, section)
    local sec = Sections[section]
    if not sec then warn("Seção inválida:", section) return end

    sec:NewButton(name, "Equipe tool e ativa GUI", function()
        local tool = game.ReplicatedStorage:FindFirstChild(toolName)
        if tool then
            local clone = tool:Clone()
            clone.Parent = plr.Backpack
            clone.Equipped:Connect(function()
                plr.PlayerGui[guiName].Enabled = true
            end)
            clone.Unequipped:Connect(function()
                plr.PlayerGui[guiName].Enabled = false
            end)
        else
            warn("Tool não encontrada:", toolName)
        end
    end)
end

-- 🔥 RemoteEvent por seção
function HypeXLib:CreateSkillButton(name, remotePath, section)
    local sec = Sections[section]
    if not sec then warn("Seção inválida:", section) return end

    sec:NewButton(name, "Ativa skill", function()
        local parts = string.split(remotePath, ".")
        local remote = plr
        for _, p in ipairs(parts) do
            remote = remote:FindFirstChild(p)
            if not remote then return warn("Remote inválido:", remotePath) end
        end
        remote:FireServer("HACKED")
    end)
end

-- 👁️ GUI Toggle por seção
function HypeXLib:CreateGuiToggle(name, guiPath, section, framePath)
    local sec = Sections[section]
    if not sec then warn("Seção inválida:", section) return end

    sec:NewToggle(name, "Toggle GUI", function(state)
        local plr = game.Players.LocalPlayer
        local guiParts = string.split(guiPath, ".")
        local gui = plr

        for _, p in ipairs(guiParts) do
            gui = gui:FindFirstChild(p)
            if not gui then warn("GUI inválida:", guiPath) return end
        end

        -- 🔁 Ativa GUI principal se existir Enabled
        if gui:IsA("ScreenGui") or gui:IsA("BillboardGui") then
            if gui:FindFirstChildOfClass("Frame") then
                gui.Enabled = state
            end
        elseif gui:IsA("Frame") then
            gui.Visible = state
        end

        -- 🔁 Se passar um frame específico, ativa ele também
        if framePath then
            local frame = gui
            for _, p in ipairs(string.split(framePath, ".")) do
                frame = frame:FindFirstChild(p)
                if not frame then warn("Frame inválido:", framePath) return end
            end
            if frame:IsA("Frame") or frame:IsA("TextLabel") then
                frame.Visible = state
            elseif frame:IsA("ScreenGui") then
                frame.Enabled = state
            end
        end
    end)
end



function HypeXLib:CreateCustomButton(name, section, callback)
    local sec = Sections[section]
    if not sec then warn("Seção inválida:", section) return end

    sec:NewButton(name, "Botão customizado", callback)
end

function HypeXLib:CreateCustomToggle(name, section, callback)
    local sec = Sections[section]
    if not sec then warn("Seção inválida:", section) return end

    sec:NewToggle(name, "Toggle customizado", function(state)
        callback(state)
    end)
end







function HypeXLib:CreateServerPanel()
    local sec = Sections["ServerPanelList"]
    if not sec then warn("❌ Seção não encontrada.") return end

    -- Se já existe uma GUI de lista, destrói só ela
    if self.ServerPlayersFrame and self.ServerPlayersFrame.Destroy then
        self.ServerPlayersFrame:Destroy()
    end

    -- Cria container isolado pra lista
    local container = Instance.new("Frame")
    container.Name = "ServerPlayersList"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = sec.Container

    self.ServerPlayersFrame = container

    local plr = game.Players.LocalPlayer
    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 5)
    UIList.Parent = container

    for _, target in ipairs(game.Players:GetPlayers()) do
        if target ~= plr then
            local lbl = Instance.new("TextLabel", container)
            lbl.Size = UDim2.new(1, 0, 0, 20)
            lbl.BackgroundTransparency = 1
            lbl.Text = "👤 "..target.Name
            lbl.TextColor3 = Color3.new(1,1,1)
            lbl.Font = Enum.Font.SourceSans
            lbl.TextSize = 18

            local btn = Instance.new("TextButton", container)
            btn.Size = UDim2.new(1, 0, 0, 20)
            btn.Text = "📍 Ir até "..target.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 16
            btn.MouseButton1Click:Connect(function()
                local char = plr.Character or plr.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                if hrp and targetHRP then
                    hrp.CFrame = targetHRP.CFrame + Vector3.new(3, 0, 3)
                end
            end)
        end
    end
end














return HypeXLib
