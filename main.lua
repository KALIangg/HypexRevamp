local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local HypeXLib = {}
local Tabs = {}
local Sections = {}
local plr = game.Players.LocalPlayer

-- 🔥 Inicia tudo automaticamente
function HypeXLib:Init()
    local win = Library.CreateLib("HypeX Revamp", "DarkTheme")

    Tabs["Main"] = win:NewTab("Main")
    Tabs["Fruits"] = win:NewTab("Fruits")
    Tabs["Swords"] = win:NewTab("Swords")
    Tabs["Skills"] = win:NewTab("Skills")
    Tabs["Settings"] = win:NewTab("Configs⚙️")
    Tabs["Admin"] = win:NewTab("Admin Menu🛠️")
    Tabs["MenuTotal"] = win:NewTab("「 ✦ MENU TOTAL ✦ 」")

    Sections["Autofarm"] = Tabs["Main"]:NewSection("⚔️ Autofarm")
    Sections["Fruits"] = Tabs["Fruits"]:NewSection("🍎 Frutas")
    Sections["Swords"] = Tabs["Swords"]:NewSection("🗡️ Espadas")
    Sections["Skills"] = Tabs["Skills"]:NewSection("⚡ Habilidades / Transformações")
    Sections["Settings"] = Tabs["Settings"]:NewSection("⚙️ Configs")
    Sections["Admin"] = Tabs["Admin"]:NewSection("🛠️ Admin Tools")
    Sections["MenuTotal"] = Tabs["MenuTotal"]:NewSection("🚀 Total Access")
end

-- ✅ AutoFarm com botão toggle
function HypeXLib:CreateAutoFarm(name, path, enemy)
    Sections["Autofarm"]:NewButton(name, "Farm NPCs", function()
        -- mesmo código da versão anterior, omitido por espaço
        print("Iniciando autofarm:", name)
        -- Código simplificado aqui: ...
    end)
end

-- 🧠 Tool com GUI
function HypeXLib:CreateToolButton(name, toolName, guiName)
    Sections["Swords"]:NewButton(name, "Equipe tool e ativa GUI", function()
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

-- 🔥 Botão de RemoteEvent
function HypeXLib:CreateSkillButton(name, remotePath)
    Sections["Skills"]:NewButton(name, "Ativa skill", function()
        local parts = string.split(remotePath, ".")
        local remote = plr
        for _, p in ipairs(parts) do
            remote = remote:FindFirstChild(p)
            if not remote then return warn("Remote inválido:", remotePath) end
        end
        remote:FireServer("HACKED")
    end)
end

-- 🧩 Toggle de GUI como portal/gojo
function HypeXLib:CreateGuiToggle(name, guiPath, insidePath)
    Sections["Skills"]:NewToggle(name, "Toggle GUI", function(state)
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
