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







function HypeXLib:CreateTeleportPartButton(name, partPath, section, yOffset)
    local sec = Sections[section]
    if not sec then
        warn("❌ Seção inválida:", section)
        return
    end

    sec:NewButton(name, "Teleporta até a Part ou Model (REAL DEX MODE)", function()
        task.spawn(function()
            local parts = string.split(partPath, ".")
            local root

            -- 🔍 Detecta caminho raiz
            local first = parts[1]:lower()
            if first == "workspace" then
                root = workspace
            elseif first == "replicatedstorage" then
                root = game:GetService("ReplicatedStorage")
            elseif first == "players" then
                root = game:GetService("Players")
            elseif first == "lighting" then
                root = game:GetService("Lighting")
            elseif first == "startergui" then
                root = game:GetService("StarterGui")
            elseif first == "playergui" then
                root = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            else
                root = game
            end

            if root ~= game then
                table.remove(parts, 1)
            end

            -- Caminho até o objeto final
            local current = root
            for _, p in ipairs(parts) do
                current = current:FindFirstChild(p)
                if not current then
                    warn("❌ Parte do caminho inválida:", p, "(Path: " .. partPath .. ")")
                    return
                end
            end

            local targetCFrame

            if current:IsA("BasePart") then
                targetCFrame = current.CFrame

            elseif current:IsA("Model") then
                -- 🔍 Busca PrimaryPart ou HumanoidRootPart ou primeira BasePart
                local base = current.PrimaryPart
                    or current:FindFirstChild("HumanoidRootPart")
                    or current:FindFirstChildWhichIsA("BasePart", true) -- busca profundo

                if not base then
                    warn("❌ Model não contém nenhuma BasePart:", current:GetFullName())
                    return
                end

                targetCFrame = base.CFrame

            else
                warn("❌ Objeto final não é uma Part nem Model:", current:GetFullName())
                return
            end

            -- 🔁 Força região carregar se StreamingEnabled
            workspace.CurrentCamera.CFrame = targetCFrame
            task.wait(0.3)

            local plr = game.Players.LocalPlayer
            local char = plr.Character or plr.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")

            local offset = yOffset or 5
            hrp.CFrame = targetCFrame + Vector3.new(0, offset, 0)

            print("✅ Teleportado com sucesso para:", current:GetFullName())
        end)
    end)
end










return HypeXLib
