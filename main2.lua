-- =========================
-- 📚 HypeX Universal Library
-- Inspirado no estilo informant.wtf
-- =========================

local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local HypeXLib = {}
HypeXLib.Tabs = {}
HypeXLib.Sections = {}
HypeXLib.Player = game.Players.LocalPlayer

-- =========================
-- 🏗️ Inicialização
-- =========================
function HypeXLib:Init(title, theme)
    self.Window = Kavo.CreateLib(title or "HypeX Remake", theme or "DarkTheme")
end

-- =========================
-- 📑 Tabs & Sections
-- =========================
function HypeXLib:CreateTab(key, label)
    if not self.Window then error("⚠️ Lib não iniciada: chame :Init() antes") end
    self.Tabs[key] = self.Window:NewTab(label)
    return self.Tabs[key]
end

function HypeXLib:CreateSection(tabKey, secKey, label)
    local tab = self.Tabs[tabKey]
    if not tab then error("⚠️ Tab inexistente: " .. tostring(tabKey)) end
    self.Sections[secKey] = tab:NewSection(label)
    return self.Sections[secKey]
end

local function getSection(self, secKey)
    local sec = self.Sections[secKey]
    if not sec then warn("❌ Seção inválida:", secKey) end
    return sec
end

-- =========================
-- 🎮 Botões & Toggles
-- =========================
function HypeXLib:CreateButton(name, section, callback, desc)
    local sec = getSection(self, section)
    if not sec then return end
    sec:NewButton(name, desc or "Botão", callback)
end

function HypeXLib:CreateToggle(name, section, callback, desc)
    local sec = getSection(self, section)
    if not sec then return end
    sec:NewToggle(name, desc or "Toggle", function(state)
        callback(state)
    end)
end

-- =========================
-- ⚔️ AutoFarm
-- =========================
function HypeXLib:CreateAutoFarm(name, path, enemy, section)
    local sec = getSection(self, section)
    if not sec then return end
    sec:NewButton(name, "Farm NPCs", function()
        print("🚜 Iniciando AutoFarm:", name, path, enemy)
        -- mantém compatibilidade (código do farm vem de fora)
    end)
end

-- =========================
-- 🛠️ Tools / Gui / Skills
-- =========================
function HypeXLib:CreateToolButton(name, toolName, guiName, section)
    local sec = getSection(self, section)
    if not sec then return end
    sec:NewButton(name, "Equipe Tool e ativa GUI", function()
        local rs = game:GetService("ReplicatedStorage")
        local plr = self.Player

        -- limpa lixo
        for _, item in ipairs(plr.Backpack:GetChildren()) do
            if item.Name == toolName and not item:IsA("Tool") then item:Destroy() end
        end

        -- pega tool do ReplicatedStorage
        local tool = rs:FindFirstChild(toolName)
        if tool and tool:IsA("Tool") then
            if plr.Backpack:FindFirstChild(toolName) or plr.Character:FindFirstChild(toolName) then
                return warn("⚠️ Tool já equipada:", toolName)
            end
            local clone = tool:Clone()
            clone.Parent = plr.Backpack
            clone.Equipped:Connect(function()
                local gui = plr.PlayerGui:FindFirstChild(guiName)
                if gui then gui.Enabled = true end
            end)
            clone.Unequipped:Connect(function()
                local gui = plr.PlayerGui:FindFirstChild(guiName)
                if gui then gui.Enabled = false end
            end)
            print("✅ Tool clonada:", toolName)
        else
            warn("❌ Tool não encontrada:", toolName)
        end
    end)
end

function HypeXLib:CreateGuiToggle(name, guiPath, section, framePath)
    local sec = getSection(self, section)
    if not sec then return end
    sec:NewToggle(name, "Toggle GUI", function(state)
        local plr = self.Player
        local gui = plr
        for _, part in ipairs(string.split(guiPath, ".")) do
            gui = gui:FindFirstChild(part)
            if not gui then return warn("❌ GUI inválida:", guiPath) end
        end

        if gui:IsA("ScreenGui") then gui.Enabled = state
        elseif gui:IsA("Frame") then gui.Visible = state end

        if framePath then
            local frame = gui
            for _, part in ipairs(string.split(framePath, ".")) do
                frame = frame:FindFirstChild(part)
                if not frame then return warn("❌ Frame inválido:", framePath) end
            end
            if frame:IsA("Frame") or frame:IsA("TextLabel") then
                frame.Visible = state
            elseif frame:IsA("ScreenGui") then
                frame.Enabled = state
            end
        end
    end)
end

function HypeXLib:CreateSkillButton(name, remotePath, section)
    local sec = getSection(self, section)
    if not sec then return end
    sec:NewButton(name, "Ativa Skill", function()
        local remote = self.Player
        for _, part in ipairs(string.split(remotePath, ".")) do
            remote = remote:FindFirstChild(part)
            if not remote then return warn("❌ Remote inválido:", remotePath) end
        end
        remote:FireServer("HACKED")
    end)
end

-- =========================
-- 📡 Painel Standalone
-- =========================
function HypeXLib:CreateStandaloneServerPanel()
    local win = Kavo.CreateLib("📡 Painel Server", "DarkTheme")
    local tab = win:NewTab("Jogadores")
    local sec = tab:NewSection("📋 Lista de Players")
    local plr = self.Player

    local function getFollowable(char)
        return char:FindFirstChild("Humanoid") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
    end

    for _, target in ipairs(game.Players:GetPlayers()) do
        if target ~= plr then
            sec:NewLabel("👤 "..target.Name)
            sec:NewButton("👁️ Spectate "..target.Name, "", function()
                local sub = getFollowable(target.Character or {})
                if sub then workspace.CurrentCamera.CameraSubject = sub end
            end)
            sec:NewButton("📍 Ir até "..target.Name, "", function()
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                local thrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                if hrp and thrp then hrp.CFrame = thrp.CFrame + Vector3.new(2,0,2) end
            end)
        end
    end
end

return HypeXLib
