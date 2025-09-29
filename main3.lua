-- HypeX Library - Informant.wtf Style
local HypeXLib = {}

-- Configurações globais
getgenv().HypeXConfig = {
    Name = "HypeX Remake",
    Version = "2.0.0",
    Discord = "discord.gg/hypex"
}

getgenv().HypeXFlags = {}

-- Sistema de cores
HypeXLib.colors = {
    background = Color3.fromRGB(30, 30, 35),
    header = Color3.fromRGB(25, 25, 30),
    accent = Color3.fromRGB(0, 162, 255),
    text = Color3.fromRGB(220, 220, 220),
    success = Color3.fromRGB(80, 255, 80),
    error = Color3.fromRGB(255, 80, 80),
    risky = Color3.fromRGB(255, 100, 100)
}

-- Elementos da UI
HypeXLib.elements = {}
HypeXLib.tabs = {}
HypeXLib.sections = {}

-- Função utilitária para criar elementos
function HypeXLib:CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        if property ~= "Parent" then
            element[property] = value
        end
    end
    if properties.Parent then
        element.Parent = properties.Parent
    end
    return element
end

-- Sistema de notificações
function HypeXLib:SendNotification(title, message, duration)
    duration = duration or 5
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration
        })
    end)
end

-- =============================================
-- SISTEMA DE JANELA PRINCIPAL
-- =============================================

function HypeXLib:Init()
    local window = {}
    
    -- ScreenGui principal
    window.screenGui = self:CreateElement("ScreenGui", {
        Name = "HypeXUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Frame principal
    window.mainFrame = self:CreateElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 600),
        Position = UDim2.new(0.1, 0, 0.1, 0),
        BackgroundColor3 = self.colors.background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = window.screenGui
    })
    
    -- Barra de título
    window.titleBar = self:CreateElement("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.colors.header,
        BorderSizePixel = 0,
        Parent = window.mainFrame
    })
    
    -- Título
    window.title = self:CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0.1, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "HypeX Remake 🔰",
        TextColor3 = self.colors.text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = window.titleBar
    })
    
    -- Container das abas
    window.tabContainer = self:CreateElement("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        Parent = window.mainFrame
    })
    
    -- Área de conteúdo
    window.contentArea = self:CreateElement("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 100),
        BackgroundTransparency = 1,
        Parent = window.mainFrame
    })
    
    -- Criar abas principais
    local tabNames = {
        "Main", "🍎 Fruits", "🗡️ Swords", "🗡️ Gui Swords", 
        "⚡ Skills", "⚙️ Configs", "🛠️ Admin", "「 ✦ MENU TOTAL ✦ 」"
    }
    
    for i, tabName in ipairs(tabNames) do
        local tab = self:CreateTab(tabName, window.tabContainer, i, #tabNames)
        window.tabs[tabName] = tab
    end
    
    -- Sistema de arrastar
    self:MakeDraggable(window.mainFrame, window.titleBar)
    
    -- Tecla de toggle (F5)
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F5 then
            window.screenGui.Enabled = not window.screenGui.Enabled
        end
    end)
    
    window.screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    self.window = window
    
    self:SendNotification("HypeX Remake", "Interface carregada! F5 para abrir/fechar", 5)
end

-- Função para criar aba
function HypeXLib:CreateTab(name, parent, index, totalTabs)
    local tab = {}
    
    -- Botão da aba
    tab.button = self:CreateElement("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(1/totalTabs, -5, 0, 40),
        Position = UDim2.new((index-1)/totalTabs, 5*(index-1), 0, 0),
        BackgroundColor3 = self.colors.header,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = self.colors.text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = parent
    })
    
    -- Conteúdo da aba
    tab.content = self:CreateElement("Frame", {
        Name = name .. "Content",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.window.contentArea
    })
    
    -- Scrolling frame
    tab.scrollingFrame = self:CreateElement("ScrollingFrame", {
        Name = "ScrollingFrame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = tab.content
    })
    
    local uiListLayout = self:CreateElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = tab.scrollingFrame
    })
    
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end)
    
    tab.sections = {}
    
    -- Função para adicionar seção
    function tab:AddSection(name, side)
        local section = {}
        
        -- Frame da seção
        section.frame = HypeXLib:CreateElement("Frame", {
            Name = name .. "Section",
            Size = UDim2.new(1, -20, 0, 0),
            BackgroundTransparency = 1,
            LayoutOrder = #tab.sections + 1,
            Parent = tab.scrollingFrame
        })
        
        -- Título da seção
        section.title = HypeXLib:CreateElement("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = HypeXLib.colors.text,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = section.frame
        })
        
        -- Container de elementos
        section.container = HypeXLib:CreateElement("Frame", {
            Name = "Container",
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Parent = section.frame
        })
        
        local sectionListLayout = HypeXLib:CreateElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
            Parent = section.container
        })
        
        sectionListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            section.container.Size = UDim2.new(1, 0, 0, sectionListLayout.AbsoluteContentSize.Y)
            section.frame.Size = UDim2.new(1, 0, 0, sectionListLayout.AbsoluteContentSize.Y + 30)
        end)
        
        -- =============================================
        -- FUNÇÕES DOS ELEMENTOS DA SEÇÃO
        -- =============================================
        
        function section:AddButton(config)
            local button = {}
            
            -- Frame principal
            button.frame = HypeXLib:CreateElement("Frame", {
                Name = config.text .. "Button",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                BorderSizePixel = 0,
                LayoutOrder = #section.container:GetChildren(),
                Parent = section.container
            })
            
            -- Label
            local textColor = config.risky and HypeXLib.colors.risky or HypeXLib.colors.text
            button.label = HypeXLib:CreateElement("TextLabel", {
                Name = "Label",
                Size = UDim2.new(0.7, 0, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = config.text,
                TextColor3 = textColor,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = button.frame
            })
            
            -- Botão de ação
            button.actionButton = HypeXLib:CreateElement("TextButton", {
                Name = "ActionButton",
                Size = UDim2.new(0, 80, 0, 30),
                Position = UDim2.new(1, -90, 0.5, -15),
                BackgroundColor3 = HypeXLib.colors.accent,
                BorderSizePixel = 0,
                Text = "Executar",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                Parent = button.frame
            })
            
            -- Evento de clique
            button.actionButton.MouseButton1Click:Connect(function()
                if config.callback then
                    config.callback()
                end
            end)
            
            return button
        end
        
        function section:AddToggle(config)
            local toggle = {}
            toggle.value = config.enabled or false
            
            -- Frame principal
            toggle.frame = HypeXLib:CreateElement("Frame", {
                Name = config.text .. "Toggle",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                BorderSizePixel = 0,
                LayoutOrder = #section.container:GetChildren(),
                Parent = section.container
            })
            
            -- Label
            local textColor = config.risky and HypeXLib.colors.risky or HypeXLib.colors.text
            toggle.label = HypeXLib:CreateElement("TextLabel", {
                Name = "Label",
                Size = UDim2.new(0.7, 0, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = config.text,
                TextColor3 = textColor,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggle.frame
            })
            
            -- Container do toggle
            toggle.toggleContainer = HypeXLib:CreateElement("Frame", {
                Name = "ToggleContainer",
                Size = UDim2.new(0, 50, 0, 25),
                Position = UDim2.new(1, -60, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(60, 60, 65),
                BorderSizePixel = 0,
                Parent = toggle.frame
            })
            
            -- Botão do toggle
            toggle.toggleButton = HypeXLib:CreateElement("TextButton", {
                Name = "ToggleButton",
                Size = UDim2.new(0, 21, 0, 21),
                Position = toggle.value and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
                BackgroundColor3 = toggle.value and HypeXLib.colors.success or HypeXLib.colors.error,
                BorderSizePixel = 0,
                Text = "",
                Parent = toggle.toggleContainer
            })
            
            -- Área clicável
            toggle.clickArea = HypeXLib:CreateElement("TextButton", {
                Name = "ClickArea",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = toggle.frame
            })
            
            -- Função para atualizar visual
            function toggle:UpdateVisual()
                local newPosition = self.value and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                local newColor = self.value and HypeXLib.colors.success or HypeXLib.colors.error
                
                toggle.toggleButton.Position = newPosition
                toggle.toggleButton.BackgroundColor3 = newColor
            end
            
            -- Evento de clique
            toggle.clickArea.MouseButton1Click:Connect(function()
                toggle.value = not toggle.value
                toggle:UpdateVisual()
                if config.callback then
                    config.callback(toggle.value)
                end
            end)
            
            -- Inicializar visual
            toggle:UpdateVisual()
            
            return toggle
        end
        
        table.insert(tab.sections, section)
        return section
    end
    
    -- Evento de clique na aba
    tab.button.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(self.window.tabs) do
            otherTab.content.Visible = false
        end
        tab.content.Visible = true
    end)
    
    -- Primeira aba como padrão
    if index == 1 then
        tab.content.Visible = true
    end
    
    return tab
end

-- Sistema de arrastar
function HypeXLib:MakeDraggable(frame, handle)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- =============================================
-- FUNÇÕES ORIGINAIS ADAPTADAS
-- =============================================

function HypeXLib:CreateAutoFarm(name, path, enemy, sectionName)
    local section = self.window.tabs["Main"]:AddSection("⚔️ Autofarm")
    
    section:AddButton({
        text = name,
        callback = function()
            self:SendNotification("AutoFarm", "Iniciando: " .. name, 3)
            -- Lógica original do autofarm aqui
            print("AutoFarm iniciado:", name, path, enemy)
        end
    })
end

function HypeXLib:CreateToolButton(name, toolName, guiName, sectionName)
    local tab = self.window.tabs["🗡️ Swords"]
    if not tab then return end
    
    local section = tab:AddSection("🗡️ Espadas")
    
    section:AddButton({
        text = name,
        callback = function()
            local rs = game:GetService("ReplicatedStorage")
            local plr = game.Players.LocalPlayer

            -- Limpeza
            for _, item in ipairs(plr.Backpack:GetChildren()) do
                if item.Name == toolName and not item:IsA("Tool") then
                    item:Destroy()
                end
            end

            -- Buscar tool
            local tool = nil
            for _, item in ipairs(rs:GetChildren()) do
                if item:IsA("Tool") and item.Name == toolName then
                    tool = item
                    break
                end
            end

            if tool then
                if plr.Backpack:FindFirstChild(toolName) or plr.Character:FindFirstChild(toolName) then
                    self:SendNotification("Tool", "Já está equipada: " .. toolName, 3)
                    return
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

                self:SendNotification("Tool", "Equipada: " .. toolName, 3)
            else
                self:SendNotification("Tool", "Não encontrada: " .. toolName, 3)
            end
        end
    })
end

function HypeXLib:CreateSkillButton(name, remotePath, sectionName)
    local tab = self.window.tabs["⚡ Skills"]
    if not tab then return end
    
    local section = tab:AddSection("⚡ Habilidades")
    
    section:AddButton({
        text = name,
        callback = function()
            local plr = game.Players.LocalPlayer
            local parts = string.split(remotePath, ".")
            local remote = plr
            
            for _, p in ipairs(parts) do
                remote = remote:FindFirstChild(p)
                if not remote then 
                    self:SendNotification("Skill", "Remote não encontrado", 3)
                    return 
                end
            end
            
            remote:FireServer("HACKED")
            self:SendNotification("Skill", "Ativada: " .. name, 2)
        end
    })
end

function HypeXLib:CreateGuiToggle(name, guiPath, sectionName, framePath)
    local tab = self.window.tabs["🗡️ Gui Swords"]
    if not tab then return end
    
    local section = tab:AddSection("🗡️ GUI Swords")
    
    section:AddToggle({
        text = name,
        enabled = false,
        callback = function(state)
            local plr = game.Players.LocalPlayer
            local guiParts = string.split(guiPath, ".")
            local gui = plr

            for _, p in ipairs(guiParts) do
                gui = gui:FindFirstChild(p)
                if not gui then 
                    self:SendNotification("GUI", "Interface não encontrada", 3)
                    return 
                end
            end

            if gui:IsA("ScreenGui") then
                gui.Enabled = state
            elseif gui:IsA("Frame") then
                gui.Visible = state
            end

            if framePath then
                local frame = gui
                for _, p in ipairs(string.split(framePath, ".")) do
                    frame = frame:FindFirstChild(p)
                    if not frame then return end
                end
                if frame:IsA("Frame") then
                    frame.Visible = state
                end
            end

            self:SendNotification("GUI", name .. " " .. (state and "ativado" or "desativado"), 2)
        end
    })
end

function HypeXLib:CreateCustomButton(name, sectionName, callback)
    local tab = self.window.tabs[sectionName] or self.window.tabs["Main"]
    if not tab then return end
    
    local sectionNameClean = string.gsub(sectionName, "[^%a%s]", "") -- Remove emojis
    local section = tab:AddSection(sectionNameClean)
    
    section:AddButton({
        text = name,
        callback = callback
    })
end

function HypeXLib:CreateCustomToggle(name, sectionName, callback)
    local tab = self.window.tabs[sectionName] or self.window.tabs["Main"]
    if not tab then return end
    
    local sectionNameClean = string.gsub(sectionName, "[^%a%s]", "") -- Remove emojis
    local section = tab:AddSection(sectionNameClean)
    
    section:AddToggle({
        text = name,
        enabled = false,
        callback = callback
    })
end

-- Função do Menu Total (simplificada)
function HypeXLib:CreateStandaloneServerPanel()
    self:SendNotification("Menu Total", "Painel server carregado!", 3)
    -- Implementação completa seria similar à original
end

return HypeXLib
