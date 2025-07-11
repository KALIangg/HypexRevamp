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
    if not sec then
        warn("Seção inválida:", section)
        return
    end

    sec:NewButton(name, "Equipe Tool e ativa GUI", function()
        local rs = game:GetService("ReplicatedStorage")
        local plr = game.Players.LocalPlayer

        -- 🧹 LIMPA qualquer "DarkXQuake" que não for Tool do Backpack
        for _, item in ipairs(plr.Backpack:GetChildren()) do
            if item.Name == toolName and not item:IsA("Tool") then
                item:Destroy()
            end
        end

        -- ✅ Só pega TOOL de verdade do ReplicatedStorage
        local tool = nil
        for _, item in ipairs(rs:GetChildren()) do
            if item:IsA("Tool") and item.Name == toolName then
                tool = item
                break
            end
        end

        if tool then
            -- Já tem no backpack? Evita duplicação
            if plr.Backpack:FindFirstChild(toolName) or plr.Character:FindFirstChild(toolName) then
                warn("⚠️ Tool já está no inventário ou equipada:", toolName)
                return
            end

            local clone = tool:Clone()
            clone.Parent = plr.Backpack

            -- Conecta GUI apenas se Tool mesmo
            clone.Equipped:Connect(function()
                local gui = plr.PlayerGui:FindFirstChild(guiName)
                if gui then gui.Enabled = true end
            end)

            clone.Unequipped:Connect(function()
                local gui = plr.PlayerGui:FindFirstChild(guiName)
                if gui then gui.Enabled = false end
            end)

            print("✅ Tool clonada e equipada:", toolName)
        else
            warn("❌ Tool '"..toolName.."' não encontrada")
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
    local window = Library.CreateLib("📡 Painel Server (HypeX)", "DarkTheme")
    local tab = window:NewTab("Jogadores Online")
    local section = tab:NewSection("📋 Lista de Players")

    local plr = game.Players.LocalPlayer
    local crashLoops = {}

    local function getFollowablePart(char)
        return char:FindFirstChild("Humanoid") 
            or char:FindFirstChild("UpperTorso") 
            or char:FindFirstChild("Torso") 
            or char:FindFirstChild("Head")
    end

    local function refresh()
        -- Limpa antes
        if self.ServerPanelPlayers then
            for _, ui in pairs(self.ServerPanelPlayers) do
                if typeof(ui) == "table" and ui.Destroy then
                    pcall(function() ui:Destroy() end)
                end
            end
        end
        self.ServerPanelPlayers = {}

        for _, target in ipairs(game.Players:GetPlayers()) do
            if target ~= plr then
                local label = section:NewLabel("👤 "..target.Name)

                -- 👁️ Spectate
                local spectateBtn = section:NewButton("👁️ Spectate "..target.Name, "", function()
                    local char = target.Character
                    local cam = workspace.CurrentCamera
                    local subject = char and getFollowablePart(char)
                    if subject then
                        cam.CameraSubject = subject
                        print("✅ Espectando:", subject:GetFullName())
                    else
                        warn("❌ Nenhum ponto de espectar em", target.Name)
                    end
                end)

                -- 📍 Teleport
                local tpBtn = section:NewButton("📍 Ir até "..target.Name, "", function()
                    local myChar = plr.Character or plr.CharacterAdded:Wait()
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                    if myHRP and targetHRP then
                        myHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0, 2)
                        print("✅ TP para:", target.Name)
                    else
                        warn("❌ TP falhou - HRP ausente")
                    end
                end)

                -- 💥 Crashar + looptp até player
                local crashBtn = section:NewButton("💥 Crashar "..target.Name, "", function()
                    local remote = plr.PlayerGui:FindFirstChild("spirit3")
                        and plr.PlayerGui.spirit3:FindFirstChild("Frame")
                        and plr.PlayerGui.spirit3.Frame:FindFirstChild("sun")
                        and plr.PlayerGui.spirit3.Frame.sun:FindFirstChild("RemoteEvent")

                    if remote then
                        crashLoops[target.Name] = true
                        task.spawn(function()
                            local myChar = plr.Character or plr.CharacterAdded:Wait()
                            local myHRP = myChar:WaitForChild("HumanoidRootPart")
                            for i = 1, 300 do
                                if not crashLoops[target.Name] then break end
                                local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                                if myHRP and targetHRP then
                                    myHRP.CFrame = targetHRP.CFrame + Vector3.new(math.random(-1,1), 0, math.random(-1,1))
                                end
                                remote:FireServer()
                                task.wait(0.01)
                            end
                            crashLoops[target.Name] = false
                            print("✅ Crash finalizado:", target.Name)
                        end)
                    else
                        warn("❌ Remote de crash não localizado.")
                    end
                end)

                -- Salva pra limpar depois
                table.insert(self.ServerPanelPlayers, label)
                table.insert(self.ServerPanelPlayers, spectateBtn)
                table.insert(self.ServerPanelPlayers, tpBtn)
                table.insert(self.ServerPanelPlayers, crashBtn)
            end
        end
    end

    -- Auto atualizar
    game.Players.PlayerAdded:Connect(function()
        task.wait(0.3)
        refresh()
    end)

    game.Players.PlayerRemoving:Connect(function()
        task.wait(0.3)
        refresh()
    end)

    refresh()
end












return HypeXLib
