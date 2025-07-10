local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local HypeXLib = {}
local Tabs = {}
local Sections = {}
local plr = game.Players.LocalPlayer

-- 🔥 Inicia e cria Tabs padrão
function HypeXLib:Init()
    local win = Library.CreateLib("HypeX Revamp", "DarkTheme")

    Tabs["Main"] = win:NewTab("Main")
    Tabs["Fruits"] = win:NewTab("🍎 Fruits")
    Tabs["Swords"] = win:NewTab("🗡️ Swords")
    Tabs["Swords"] = win:NewTab("🗡️ Gui Swords")
    Tabs["Skills"] = win:NewTab("Skills")
    Tabs["Settings"] = win:NewTab("⚙️ Configs")
    Tabs["Admin"] = win:NewTab("🛠️ Admin Menu")
    Tabs["MenuTotal"] = win:NewTab("「 ✦ MENU TOTAL ✦ 」")

    -- Seções padrão
    Sections["Autofarm"] = Tabs["Main"]:NewSection("⚔️ Autofarm")
    Sections["Fruits"] = Tabs["🍎 Fruits"]:NewSection("🍎 Frutas")
    Sections["Swords"] = Tabs["🗡️ Swords"]:NewSection("🗡️ Espadas")
    Sections["Swords"] = Tabs["🗡️ Gui Swords"]:NewSection("🗡️ Espadas")
    Sections["Skills"] = Tabs["Skills"]:NewSection("⚡ Habilidades / Transformações")
    Sections["Settings"] = Tabs["Settings"]:NewSection("⚙️ Configs")
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
function HypeXLib:CreateGuiToggle(name, guiPath, section, insidePath)
    local sec = Sections[section]
    if not sec then warn("Seção inválida:", section) return end

    sec:NewToggle(name, "Toggle GUI", function(state)
        local parts = string.split(guiPath, ".")
        local gui = plr
        for _, p in ipairs(parts) do
            gui = gui:FindFirstChild(p)
            if not gui then return warn("GUI inválida:", guiPath) end
        end

        gui.Enabled = state
        if insidePath then
            local inside = gui
            for _, p in ipairs(string.split(insidePath, ".")) do
                inside = inside:FindFirstChild(p)
            end
            if inside then
                inside.Visible = state
            end
        end
    end)
end

return HypeXLib
