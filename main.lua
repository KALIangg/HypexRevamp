--[[  
✨ HypeXLib Revamp ✨
By LUA GOD 💻 Made for GitHub usage - Full Packed in one file
Uses Kavo UI Library (Auto-loaded)
--]]

-- 📦 Carrega a Kavo UI Lib diretamente da source oficial
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- 🪟 Cria a Janela Principal com Tema Dark
local Window = Library.CreateLib("HypeX Revamp", "DarkTheme")

-- 🗂️ Tabs do Menu
local Tab = Window:NewTab("Main")
local ADMTab = Window:NewTab("Admin Menu🛠️")
local SWTab = Window:NewTab("Swords")
local FTAB = Window:NewTab("Fruits")
local SGTab = Window:NewTab("Sword Skills")
local FGTab = Window:NewTab("Skills")
local PTAB = Window:NewTab("Server - FE")
local CTAB = Window:NewTab("Configs⚙️")
local OTAB = Window:NewTab("「 ✦ MENU TOTAL ✦ 」")

-- 📑 Seções
local SectionMain = Tab:NewSection("Options⚙️")
local SectionConf = CTAB:NewSection("Settings⚙️")
local SectionADM = ADMTab:NewSection("Admin - scripts & guis")
local SectionSW = SWTab:NewSection("Floppa Piece - Swords")
local SectionSWG = SGTab:NewSection("Swords")
local Section2 = FTAB:NewSection("Fruits")
local SectionO = OTAB:NewSection("「 ✦ MENU TOTAL ✦ 」")
local plr = game.Players.LocalPlayer


-- ⚔️ Função de criação de autofarm com botão
local function createAutoFarm(nomeDoBotao, caminhoFolder, nomeDosAlvos)
    SectionMain:NewButton(nomeDoBotao, "Farma automaticamente todos os npcs", function()
        -- 🌟 Criação da GUI
        local ScreenGui = Instance.new("ScreenGui")
        local ActivateButton = Instance.new("TextButton")
        local DeactivateButton = Instance.new("TextButton")

        ScreenGui.Parent = plr:WaitForChild("PlayerGui")

        ActivateButton.Size = UDim2.new(0, 200, 0, 50)
        ActivateButton.Position = UDim2.new(0.5, -100, 0.5, -60)
        ActivateButton.Text = "Ativar Autofarm"
        ActivateButton.Parent = ScreenGui

        DeactivateButton.Size = UDim2.new(0, 200, 0, 50)
        DeactivateButton.Position = UDim2.new(0.5, -100, 0.5, 0)
        DeactivateButton.Text = "Desativar Autofarm"
        DeactivateButton.Parent = ScreenGui
        DeactivateButton.Visible = false

        -- ⚙️ Variáveis de controle
        local autofarmActive = false
        local teleporting = false
        local clickConnection

        -- 🧭 Teleporte até o alvo
        local function toTargetWait(targetModel)
            local destinationPosition
            if targetModel:IsA("Model") then
                destinationPosition = targetModel.PrimaryPart and targetModel.PrimaryPart.Position
                if not destinationPosition and targetModel:FindFirstChild("HumanoidRootPart") then
                    destinationPosition = targetModel.HumanoidRootPart.Position
                end
            elseif targetModel:IsA("BasePart") then
                destinationPosition = targetModel.Position
            end

            if not destinationPosition then
                warn("Destino inválido!")
                return
            end

            local playerRoot = plr.Character:WaitForChild("HumanoidRootPart")
            local distance = (destinationPosition - playerRoot.Position).Magnitude
            local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

            local tween = game:GetService("TweenService"):Create(
                playerRoot,
                tweenInfo,
                {CFrame = CFrame.new(destinationPosition)}
            )
            tween:Play()
            tween.Completed:Wait()
        end

        -- 🔁 Teleporte em loop
        local function teleportToAllTargets()
            teleporting = true
            while teleporting do
                local targets = {}
                local folder = game.Workspace
                for part in string.gmatch(caminhoFolder, "[^%.]+") do
                    folder = folder:FindFirstChild(part)
                    if not folder then
                        warn("Caminho não encontrado:", caminhoFolder)
                        return
                    end
                end

                for _, obj in ipairs(folder:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == nomeDosAlvos then
                        table.insert(targets, obj)
                    end
                end

                if #targets == 0 then
                    warn("Nenhum alvo encontrado!")
                    return
                end

                for _, target in ipairs(targets) do
                    if not teleporting then return end
                    toTargetWait(target)
                    wait(1)
                end
            end
        end

        -- 🖱️ Ativa autoclick
        local function equipAndAutoClick()
            clickConnection = game:GetService("RunService").RenderStepped:Connect(function()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end

        -- 🎮 Botões
        ActivateButton.MouseButton1Click:Connect(function()
            if autofarmActive then return end
            autofarmActive = true
            DeactivateButton.Visible = true
            ActivateButton.Visible = false

            spawn(function() teleportToAllTargets() end)
            equipAndAutoClick()
        end)

        DeactivateButton.MouseButton1Click:Connect(function()
            if not autofarmActive then return end
            autofarmActive = false
            DeactivateButton.Visible = false
            ActivateButton.Visible = true

            teleporting = false
            if clickConnection then clickConnection:Disconnect() end
        end)
    end)
end


local function createToolButton(section, nomeBotao, nomeDaTool, nomeDaGui)
    section:NewButton(nomeBotao, "Equipe a tool e habilita a GUI", function()
        local tool
        for _, item in pairs(game.ReplicatedStorage:GetChildren()) do
            if item.Name == nomeDaTool and item:IsA("Tool") then
                tool = item
                break
            end
        end

        if tool then
            local clone = tool:Clone()
            clone.Parent = plr.Backpack

            clone.Equipped:Connect(function()
                plr.PlayerGui[nomeDaGui].Enabled = true
            end)

            clone.Unequipped:Connect(function()
                plr.PlayerGui[nomeDaGui].Enabled = false
            end)
        else
            warn(nomeDaTool .. " não encontrada no ReplicatedStorage!")
        end
    end)
end


SectionADM:NewToggle("Admin Panel", "Admin Painel - HYPE", function(state)
    if state then
        print("Adm Toggle On")
        plr.PlayerGui.AdminPanelByFloppa.Frame.Visible = true
    else
        print("Adm Toggle Off")
        plr.PlayerGui.AdminPanelByFloppa.Frame.Visible = false
    end
end)



local function MenuTotalExecute()
    local Window2 = Library.CreateLib("✦ MENU TOTAL ✦", "DarkTheme")

    local StatTab = Window2:NewTab("Status")
    local Tab2 = Window2:NewTab("Hacking Tools🛠️")
    local ItemsTab = Window2:NewTab("Items - FE🛠️")
    local ADMTab2 = Window2:NewTab("Admin💻")
    local ConfTab = Window2:NewTab("Configs⚙️")

    StatTab:NewSection("Script Status: 🟠In Dev")
    Tab2:NewSection("Scripting Tools")
    ItemsTab:NewSection("Items -- Admin / Secret")
    ADMTab2:NewSection("Admin funcs🛠️")
    ConfTab:NewSection("Settings⚙️")
end


SectionO:NewButton("--- Acessar Menu Total ---", "Confirma tua identidade pra acessar o menu total.", function()
    print("Tentativa de acessar o Menu Total.")
    
    if plr.Name == "BLadeMANDRAKE" then
        MenuTotalExecute()
        print("╔═════════════════════════════════════════╗")
        print("「 ✦ MENU TOTAL ✦ 」Executado e funcionando.")
        warn("✦ MENU TOTAL ✦ Versão: 1.011124 | Feito Por Hypex")
        print("A user logged in:")
        warn(plr.Name)
        print("╚═════════════════════════════════════════╝")
    else
        print("Jogador Não reconhecido: ativando modo proteção em 5 segundos")
        for i = 5, 1, -1 do
            wait(1)
            print(i)
        end
        while true do
            print("PROTEGENDO SISTEMA!")
        end
    end
end)

---------- REMOTE EVENTS ACTIVATION ----------

Section:NewButton("Yoru Slash", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.awakenyoru2.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)




Section:NewButton("Bolt", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.rubber5ndv2.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)





Section:NewButton("Gear 5", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.rubber5ndv2.Frame.gear5.RemoteEvent
    evento:FireServer("HACKED")
end)





Section:NewButton("Mochi buzzcut", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.donut3.Frame.smash4.RemoteEvent
    evento:FireServer("HACKED")
end)





Section:NewToggle("Portal Teleport", "Transform / Skill", function(state)

    local EnableP = game:GetService("Players").LocalPlayer.PlayerGui.portal2
    local FrameOff = game:GetService("Players").LocalPlayer.PlayerGui.portal2.Frame
    local Teleport = game:GetService("Players").LocalPlayer.PlayerGui.portal2.teleport

    ---- SETS ----
    if state then
        EnableP.Enabled = true
        FrameOff.Visible = false
        Teleport.Visible = true
    else
        EnableP.Enabled = false
        FrameOff.Visible = true
    end


end)





Section:NewButton("Conqueror haki", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.Conquers.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)




Section:NewButton("Mui Zoan", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.mui.Frame.zoan.RemoteEvent
    evento:FireServer("HACKED")
end)



Section:NewButton("Leopard Zoan", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.leopard2.Frame.zoan.RemoteEvent
    evento:FireServer("HACKED")
end)




Section:NewButton("Leopard Z", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.leopard2.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)




Section:NewButton("Baryon Mode", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.baryon.Frame.transform.RemoteEvent
    evento:FireServer("HACKED")
end)




Section:NewButton("Wind Rasengan", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.baryon.Frame.smash2.RemoteEvent
    evento:FireServer("HACKED")
end)




Section:NewButton("Love Transform", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.Love.Frame.f.RemoteEvent
    evento:FireServer("HACKED")
end)



Section:NewButton("Love C", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.Love.Frame.smash3.RemoteEvent
    evento:FireServer("HACKED")
end)




Section:NewButton("Naruto Uzucrack", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.sosp.Frame.zoan.RemoteEvent
    evento:FireServer("HACKED")
end)





Section:NewButton("Bijuu dama", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.sosp.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)






Section:NewToggle("Gojo", "Transform / Skill", function(state)

    local GojoSet = game:GetService("Players").LocalPlayer.PlayerGui.gojo
    local plrN = plr.Name

    ---- SETS ----
    if state then
        
        GojoSet.Enabled = true
        print("Gojo was been enabled by: " .. plrN)
    else

        GojoSet.Enabled = false
        
    end


end)





Section:NewButton("Mink skill", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.RaceV4Mink.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)






Section:NewButton("Tsunami", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.RaceV4Fish.Frame.smash3.RemoteEvent
    evento:FireServer("HACKED")
end)






Section:NewButton("Ghoul beam", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.RaceV4Ghoul.Frame.smash3.RemoteEvent
    evento:FireServer("HACKED")
end)






Section:NewButton("Angels Statue", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.RaceV4Sky.Frame.smash2.RemoteEvent
    evento:FireServer("HACKED")
end)






Section:NewButton("God of death", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.ShadowDagger.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)



Section:NewButton("Escanor Tatsumaki", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.Escanor.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)





Section:NewButton("FTK Rush", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.ftkskills.Frame.smash2.RemoteEvent
    evento:FireServer("HACKED")
end)



Section:NewButton("Soccer", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.soccer.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)



Section:NewButton("Cursed Tornado", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.AwakenedCursedDualKatana.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)



Section:NewButton("Mech", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.mech.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)




Section:NewButton("Boxing Z", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.Boxing.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)



Section:NewButton("Dismantle", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.sukuna.Frame.smash2.RemoteEvent
    evento:FireServer("HACKED")
end)



Section:NewButton("Fox", "Transform / Skill", function()

    local plr = game:GetService("Players").LocalPlayer
    local evento = plr.PlayerGui.fox.Frame.smash.RemoteEvent
    evento:FireServer("HACKED")
end)
