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
