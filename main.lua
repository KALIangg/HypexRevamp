local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local HypeXLib = {}
local Tabs = {}
local Sections = {}
local plr = game.Players.LocalPlayer

-- 🔥 Inicia e cria Tabs padrão
function HypeXLib:Init()
    local win = Library.CreateLib("HypeX Remake", "DarkTheme")

    -- Tabs (sem emojis nos índices)
    Tabs["Main"] = win:NewTab("Main")
    Tabs["Fruits"] = win:NewTab("🍎 Fruits")
    Tabs["Swords"] = win:NewTab("🗡️ Swords")
    Tabs["GuiSwords"] = win:NewTab("🗡️ Gui Swords")
    Tabs["Skills"] = win:NewTab("⚡ Skills")
    Tabs["Settings"] = win:NewTab("⚙️ Configs")
    Tabs["Admin"] = win:NewTab("🛠️ Admin Menu")
    Tabs["MenuTotal"] = win:NewTab("「 ✦ MENU TOTAL ✦ 」")

    -- Sections (sem emojis nos índices, mas com emojis no nome exibido)
    Sections["Autofarm"] = Tabs["Main"]:NewSection("⚔️ Autofarm")
    Sections["Fruits"] = Tabs["Fruits"]:NewSection("🍎 Frutas")
    Sections["Swords"] = Tabs["Swords"]:NewSection("🗡️ Espadas")
    Sections["GuiSwords"] = Tabs["GuiSwords"]:NewSection("🗡️ Espadas com GUI")
    Sections["Skills"] = Tabs["Skills"]:NewSection("⚡ Habilidades / Transformações")
    Sections["Settings"] = Tabs["Settings"]:NewSection("⚙️ Configurações")
    Sections["Admin"] = Tabs["Admin"]:NewSection("🛠️ Admin Tools")
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







function HypeXLib:CreateStandaloneServerPanel()
    -- Cria nova janela separada
    local window = Library.CreateLib("📡 Painel Server (HypeX)", "DarkTheme")
    local panelTab = window:NewTab("Jogadores Online")
    local section = panelTab:NewSection("📋 Players")

    local plr = game.Players.LocalPlayer

    local function populate()
        -- limpa se já tiver
        if self.ServerPanelPlayers then
            for _, v in pairs(self.ServerPanelPlayers) do
                if typeof(v) == "table" and v.Destroy then
                    pcall(function() v:Destroy() end)
                end
            end
        end
        self.ServerPanelPlayers = {}

        for _, target in ipairs(game.Players:GetPlayers()) do
            if target ~= plr then
                local lbl = section:NewLabel("👤 "..target.Name)

                local spectateBtn = section:NewButton("👁️ Spectate "..target.Name, "", function()
                    workspace.CurrentCamera.CameraSubject = target.Character and target.Character:FindFirstChildWhichIsA("Humanoid") or target.Character
                end)

                local tpBtn = section:NewButton("📍 Ir até "..target.Name, "", function()
                    local myChar = plr.Character or plr.CharacterAdded:Wait()
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")

                    if myHRP and targetHRP then
                        myHRP.CFrame = targetHRP.CFrame + Vector3.new(3, 0, 3)
                    end
                end)

                local crashBtn = section:NewButton("💥 Crashar "..target.Name, "", function()
                    local remote = plr.PlayerGui:FindFirstChild("spirit3")
                        and plr.PlayerGui.spirit3:FindFirstChild("Frame")
                        and plr.PlayerGui.spirit3.Frame:FindFirstChild("sun")
                        and plr.PlayerGui.spirit3.Frame.sun:FindFirstChild("RemoteEvent")

                    if remote then
                        task.spawn(function()
                            for i = 1, 300 do
                                remote:FireServer()
                                task.wait(0.01)
                            end
                        end)
                    end
                end)

                -- Salva pra limpar
                table.insert(self.ServerPanelPlayers, lbl)
                table.insert(self.ServerPanelPlayers, spectateBtn)
                table.insert(self.ServerPanelPlayers, tpBtn)
                table.insert(self.ServerPanelPlayers, crashBtn)
            end
        end
    end

    populate()

    -- Atualização automática
    game.Players.PlayerAdded:Connect(function()
        task.wait(0.3)
        populate()
    end)

    game.Players.PlayerRemoving:Connect(function()
        task.wait(0.3)
        populate()
    end)
end
















return HypeXLib
