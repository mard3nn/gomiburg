local PANEL = {}
local curent_panel 
local red_select = Color(246,246,248)

local function MakeLabelClickable(lbl)
    if not IsValid(lbl) then return end
    lbl:SetMouseInputEnabled(true)
    function lbl:OnMousePressed(mouseCode)
        if mouseCode == MOUSE_LEFT and self.DoClick then
            self:DoClick()
        end
    end
end

local function OpenStandaloneContent(drawFunc)
    if not isfunction(drawFunc) then return end

    hg = hg or {}
    if IsValid(hg.StandaloneEscPanel) then
        hg.StandaloneEscPanel:Remove()
    end

    local panel = vgui.Create("EditablePanel")
    panel:SetSize(ScrW(), ScrH())
    panel:SetPos(0, 0)
    panel:SetMouseInputEnabled(true)
    panel:SetKeyboardInputEnabled(true)
    panel:MakePopup()

    function panel:OnKeyCodePressed(keyCode)
        if keyCode == KEY_ESCAPE then
            self:Remove()
        end
    end

    function panel:OnRemove()
        if hg then
            hg.StandaloneEscPanel = nil
        end
        gui.EnableScreenClicker(false)
    end

    hg.StandaloneEscPanel = panel
    gui.EnableScreenClicker(true)
    drawFunc(panel)
end

local Selects = {
    {Title = "Continue", Func = function(luaMenu) luaMenu:Close() end},
    {Title = "Main Menu", Func = function(luaMenu) gui.ActivateGameUI() luaMenu:Close() end},
    {Title = "Discord", Func = function(luaMenu)
        luaMenu:Close()
        gui.OpenURL("https://discord.gg/z46YTDyk6F")
    end},
    {Title = "Traitor Role",
    GamemodeOnly = true,
    CreatedFunc = function(self, parent, luaMenu)
        local btn = vgui.Create( "DLabel", self )
        btn:SetText( "SOE" )
        MakeLabelClickable(btn)
        btn:SetContentAlignment(5)
        btn:SetFont( "ZCity_Small" )
        btn:SetTall( ScreenScale( 15 ) )
        btn:Dock(TOP)
        btn:DockMargin(ScreenScale(20),ScreenScale(10),0,0)
        btn:SetTextColor(Color(255,255,255))
        btn:InvalidateParent()
        btn.RColor = Color(225, 225, 225, 0)
        btn.WColor = Color(225, 225, 225, 255)
        btn.x = btn:GetX()

        function btn:DoClick()
            luaMenu:Close()
            hg.SelectPlayerRole(nil, "soe")
        end
    
        local selfa = self
        function btn:Think()
            self.HoverLerp = selfa.HoverLerp
            self.HoverLerp2 = LerpFT(0.2, self.HoverLerp2 or 0, self:IsHovered() and 1 or 0)
                
            self:SetTextColor(self.RColor:Lerp(self.WColor:Lerp(red_select, self.HoverLerp2), self.HoverLerp))
            self:SetX(self.x + ScreenScaleH(40) + self.HoverLerp * ScreenScaleH(50))
        end

        local btn = vgui.Create( "DLabel", btn )
        btn:SetText( "STD" )
        MakeLabelClickable(btn)
        btn:SetContentAlignment(5)
        btn:SetFont( "ZCity_Small" )
        btn:SetTall( ScreenScale( 15 ) )
        btn:Dock(TOP)
        btn:DockMargin(0,ScreenScale(2),0,0)
        btn:SetTextColor(Color(255,255,255))
        btn:InvalidateParent()
        btn.RColor = Color(225, 225, 225, 0)
        btn.WColor = Color(225, 225, 225, 255)
        btn.x = btn:GetX()

        function btn:DoClick()
            luaMenu:Close()
            hg.SelectPlayerRole(nil, "standard")
        end
    
        function btn:Think()
            self.HoverLerp = selfa.HoverLerp
            self.HoverLerp2 = LerpFT(0.2, self.HoverLerp2 or 0, self:IsHovered() and 1 or 0)
    
            self:SetTextColor(self.RColor:Lerp(self.WColor:Lerp(red_select, self.HoverLerp2), self.HoverLerp))
            self:SetX(self.x + ScreenScaleH(35))
        end
    end,
    Func = function(luaMenu)
        
    end,
    },
    {Title = "Achievments", Func = function(luaMenu)
        luaMenu:Close()
        timer.Simple(0, function()
            OpenStandaloneContent(hg.DrawAchievmentsMenu)
        end)
    end},
    {Title = "Settings", Func = function(luaMenu)
        luaMenu:Close()
        timer.Simple(0, function()
            OpenStandaloneContent(hg.DrawSettings)
        end)
    end},
    {Title = "Appearance", Func = function(luaMenu)
        luaMenu:Close()
        timer.Simple(0, function()
            OpenStandaloneContent(function(panel)
                if hg and hg.CreateApperanceMenu then
                    hg.CreateApperanceMenu(panel)
                end
            end)
        end)
    end},
    {Title = "Disconnect", Func = function(luaMenu) RunConsoleCommand("disconnect") end},
}

local splasheh = {
   'РОДИЛСЯ БОБОМ',
    'ТУПИК ФУРРИ',
    'МОНКЕЙТОП ГОРБАТЫЙ',
    'Я СПАСТИЛ ЭТО',
    'o',
    'ЭЩКЕРП ФРОМ ТАРКОВ',
    'ОКИРО СКАЧАТЬ ЛИК',
    'ХОМИГРАД ЛУЧШЕ'
}

--print(string.upper('I wish you good health, Jason Statham'))
surface.CreateFont("ZC_MM_Title", {
    font = "Bahnschrift",
    size = ScreenScale(32),
    weight = 800,
    antialias = true
})
-- local Title = markup.Parse("error")

function PANEL:InitializeMarkup()
	local mapname = game.GetMap()
	local prefix = string.find(mapname, "_")
	if prefix then
		mapname = string.sub(mapname, prefix + 1)
	end
	local gm = splasheh[math.random(#splasheh)] .. " | " .. string.NiceName(mapname) 

    if hg.PluvTown.Active then
        local text = "<font=ZC_MM_Title><colour=170,170,170>PluvCity</colour></font>\n<font=ZCity_Tiny><colour=105,105,105>" .. gm .. "</colour></font>"

        self.SelectedPluv = table.Random(hg.PluvTown.PluvMats)

        return markup.Parse(text)
    end

    local text = "<font=ZC_MM_Title><colour=212,212,212>GOMICITY</colour></font>\n<font=ZCity_Tiny><colour=105,105,105>" .. gm .. "</colour></font>"
    return markup.Parse(text)
end

local color_red = Color(205,205,207,45)
local clr_gray = Color(99,75,75,25)
local clr_verygray = Color(11,11,39,183)

function PANEL:Init()
    self:SetAlpha(0)
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:SetTitle("")
    self:SetDraggable(false)
    self:SetBorder(false)
    self:SetColorBG(clr_verygray)
    self:SetDraggable(false)
    self:ShowCloseButton(false)
    curent_panel = nil
    self.Title, self.TitleShadow = self:InitializeMarkup()

    timer.Simple(0, function()
        if self.First then
            self:First()
        end
    end)

    self.lDock = vgui.Create("DPanel", self)
    local lDock = self.lDock
    lDock:SetZPos(10)
    lDock:SetSize(math.max(ScrW() * 0.18, 260), ScrH() * 0.56)
    lDock:SetPos(ScreenScale(20), ScrH() * 0.2)
    lDock:DockPadding(0, ScreenScaleH(85), 0, 0)
    lDock.Paint = function(this, w, h)
        self.Title:Draw(w * 0.5, 8, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 255, TEXT_ALIGN_CENTER)
    end

local function GetRandomPluvImage()
    local pluvImages = {
        "pluv/pluv.png",
        "pluv/pluv51.png",
        "pluv/pluvberet.png",
        "pluv/pluvboss.png",
        "pluv/pluvcry.png",
        "pluv/pluvdobro.png",
        "pluv/pluvfancy.jpg",
        "pluv/pluvgreen.png",
        "pluv/pluvicible.jpg",
        "pluv/pluvkid.jpg",
        "pluv/pluvmad.png",
        "pluv/pluvmajima.jpg",
        "pluv/pluvnerd.png",
        "pluv/pluvortego.jpg",
        "pluv/pluvred.png",
        "pluv/pluvsad.png",
        "pluv/pluvyakuza.jpg",
        "pluv/toosilly.png"
    }
    
    for i = 1, 10 do
        local pluvIdx = math.random(1, #pluvImages)
        local pluvPath = pluvImages[pluvIdx]
        local ok, pluvMat = pcall(Material, pluvPath)
        if ok and pluvMat and not pluvMat:IsError() then
            return pluvMat
        end
    end
    
    return nil
end

local pluvMat = GetRandomPluvImage()

if pluvMat then
    local pluvPanel = vgui.Create("DImage", self)
    pluvPanel:SetMaterial(pluvMat)
    local imgW, imgH = 512, 393
    local scale = math.min(ScrW() * 0.25 / imgW, ScrH() * 0.35 / imgH, 0.6)
    pluvPanel:SetSize(imgW * scale, imgH * scale)
    local panelX = ScrW() - pluvPanel:GetWide() - ScreenScale(50)
    local panelY = ScrH() * 0.35
    pluvPanel:SetPos(panelX, panelY)
    pluvPanel:SetZPos(-1)

    local mapname = game.GetMap()
    local prefix = string.find(mapname, "_")
    if prefix then
        mapname = string.sub(mapname, prefix + 1)
    end
    local splashehText = splasheh[math.random(#splasheh)] .. " | " .. string.NiceName(mapname)

    local pluvLabel = vgui.Create("DLabel", self)
    pluvLabel:SetText("Original Z-City:\ngithub.com/uzelezz123/Z-City")
    pluvLabel:SetFont("ZCity_Tiny")
    pluvLabel:SetTextColor(Color(105, 105, 105))
    pluvLabel:SetContentAlignment(5)
    pluvLabel:SizeToContents()
    pluvLabel:SetPos(panelX + (pluvPanel:GetWide() - pluvLabel:GetWide()) / 2, panelY + pluvPanel:GetTall() + ScreenScale(5))
    pluvLabel:SetZPos(-1)
end

    self.Buttons = {}
    for k, v in ipairs(Selects) do
        if v.GamemodeOnly and engine.ActiveGamemode() != "zcity" then continue end
        self:AddSelect(lDock, v.Title, v)
    end

    local buttonTall = ScreenScale(15)
    local buttonGap = ScreenScaleH(6)
    local topPadding = ScreenScaleH(85)
    local minTall = ScrH() * 0.56
    local needTall = topPadding + (#self.Buttons * (buttonTall + buttonGap)) + ScreenScaleH(12)
    local targetTall = math.min(ScrH() * 0.8, math.max(minTall, needTall))
    lDock:SetTall(targetTall)
    lDock:SetY(math.Clamp(ScrH() * 0.2, ScreenScaleH(10), ScrH() - targetTall - ScreenScaleH(10)))


    local bottomDock = vgui.Create("DPanel", self)
    bottomDock:SetVisible(false)
    bottomDock:SetSize(0, 0)
    bottomDock.Paint = function(this, w, h) end
    self.panelparrent = vgui.Create("DPanel", self)
    self.panelparrent:SetPos(0, 0)
    self.panelparrent:SetSize(ScrW(), ScrH())
    self.panelparrent.Paint = function(this, w, h) end
    
    local git = vgui.Create("DLabel", bottomDock)
    git:Dock(BOTTOM)
    git:DockMargin(ScreenScale(10), 0, 0, 0)
    git:SetFont("ZCity_Tiny")
    git:SetTextColor(clr_gray)
    git:SetText("GitHub: github.com/uzelezz123/Z-City")
    git:SetContentAlignment(4)
    MakeLabelClickable(git)
    git:SizeToContents()

    function git:DoClick()
        gui.OpenURL("https://github.com/uzelezz123/Z-City")
    end

    local version = vgui.Create("DLabel", bottomDock)
    version:Dock(BOTTOM)
    version:DockMargin(ScreenScale(10), 0, 0, 0)
    version:SetFont("ZCity_Tiny")
    version:SetTextColor(clr_gray)
    version:SetText(hg.Version)
    version:SetContentAlignment(4)
    version:SizeToContents()

    local zteam = vgui.Create("DLabel", bottomDock)
    zteam:Dock(BOTTOM)
    zteam:DockMargin(ScreenScale(10), 0, 0, 0)
    zteam:SetFont("ZCity_Tiny")
    zteam:SetTextColor(clr_gray)
    zteam:SetContentAlignment(4)
    zteam:SizeToContents()
end

function PANEL:First( ply )
    self:AlphaTo( 255, 0.1, 0, nil )
end

local gradient_d = surface.GetTextureID("vgui/gradient-d")
local gradient_r = surface.GetTextureID("vgui/gradient-u")
local gradient_l = surface.GetTextureID("vgui/gradient-l")

local xbars = 17
local ybars = 30
local sw, sh = ScrW(), ScrH()

local clr_1 = Color(95,95,105,45)
function PANEL:Paint(w,h)
    draw.RoundedBox( 0, 0, 0, w, h, self.ColorBG )

    surface.SetDrawColor(107, 107, 107, 20)
    for i = 1, (ybars + 1) do
        surface.DrawRect((sw / ybars) * i - (CurTime() * 30 % (sw / ybars)), 0, ScreenScale(1), sh)
    end
    for i = 1, (xbars + 1) do
        surface.DrawRect(0, (sh / xbars) * (i - 1) + (CurTime() * 30 % (sh / xbars)), sw, ScreenScale(1))
    end

    surface.SetDrawColor( self.ColorBG )
    surface.SetTexture( gradient_l )
    surface.DrawTexturedRect(0,0,w,h)
    surface.SetDrawColor( clr_1 )
    surface.SetTexture( gradient_d )
    surface.DrawTexturedRect(0,0,w,h)
end

function PANEL:AddSelect( pParent, strTitle, tbl )
    local id = #self.Buttons + 1
    self.Buttons[id] = vgui.Create( "DLabel", pParent )
    local btn = self.Buttons[id]
    btn:SetText( strTitle )
    MakeLabelClickable(btn)
    btn:SetContentAlignment(5)
    btn:SetFont( "ZCity_Small" )
    btn:SetTall( ScreenScale( 15 ) )
    btn:Dock(TOP)
    btn:DockMargin(0, ScreenScaleH(6), 0, 0)
    btn.Func = tbl.Func
    btn.HoveredFunc = tbl.HoveredFunc
    local luaMenu = self 
    if tbl.CreatedFunc then tbl.CreatedFunc(btn, self, luaMenu) end
    btn.RColor = Color(190,190,190)
    function btn:DoClick()
        -- ,kz РѕРїС‚РёРјРёР·РёСЂРѕРІР°С‚СЊ РЅР°РґРѕ, РЅРѕ РёРґС‘С‚ РѕС€РёР±РєР°(РєСЌС€РёСЂРѕРІР°С‚СЊ Р±С‹ luaMenu.panelparrent РІРјРµСЃС‚Рѕ РІС‹Р·РѕРІР° РµРіРѕ РєР°Р¶РґС‹Р№ СЂР°Р·)
        if curent_panel == string.lower(strTitle) then
			for i = 1, 3 do
				surface.PlaySound("shitty/tap_release.wav")
			end
            luaMenu.panelparrent:AlphaTo(0,0.2,0,function()
                luaMenu.panelparrent:Remove()
                luaMenu.panelparrent = nil
                luaMenu.panelparrent = vgui.Create("DPanel", luaMenu)
                
                luaMenu.panelparrent:SetPos(some_coordinates_x, 0)
                luaMenu.panelparrent:SetSize(some_size_x, some_size_y)
                luaMenu.panelparrent.Paint = function(this, w, h) end
                --btn.Func(luaMenu,luaMenu.panelparrent)
                curent_panel = nil
            end)
            return 
        end
        some_size_x = luaMenu.panelparrent:GetWide()
        some_size_y = luaMenu.panelparrent:GetTall()
        some_coordinates_x = luaMenu.panelparrent:GetX()
        luaMenu.panelparrent:AlphaTo(0,0.2,0,function()
            luaMenu.panelparrent:Remove()
            luaMenu.panelparrent = nil
            luaMenu.panelparrent = vgui.Create("DPanel", luaMenu)
            
            luaMenu.panelparrent:SetPos(some_coordinates_x, 0)
            luaMenu.panelparrent:SetSize(some_size_x, some_size_y)
            luaMenu.panelparrent.Paint = function(this, w, h) end
            btn.Func(luaMenu,luaMenu.panelparrent)
            curent_panel = string.lower(strTitle)
        end)
		for i = 1, 3 do
			surface.PlaySound("shitty/tap_depress.wav")
		end
    end

    function btn:Think()
        self.HoverLerp = LerpFT(0.2, self.HoverLerp or 0, (self:IsHovered() or (IsValid(self:GetChild(0)) and self:GetChild(0):IsHovered()) or (IsValid(self:GetChild(0)) and IsValid(self:GetChild(0):GetChild(0)) and self:GetChild(0):GetChild(0):IsHovered())) and 1 or 0)

        local v = self.HoverLerp
        self:SetTextColor(self.RColor:Lerp(red_select, v))

        local targetText = (self:IsHovered()) and string.upper(strTitle) or strTitle
        local crw = self:GetText()

        if (crw ~= targetText) or (curent_panel == string.lower(strTitle)) then
            local ntxt = ""
            local will_text = (curent_panel == string.lower(strTitle) and strTitle ~= "Traitor Role") and "[ "..string.upper(strTitle).." ]" or strTitle
            for i = 1, #will_text do
                local char = will_text:sub(i, i)
                if i <= math.ceil(#will_text * v) then
                    ntxt = ntxt .. string.upper(char)
                else
                    ntxt = ntxt .. char
                end
            end
			if self:GetText() ~= ntxt then
				surface.PlaySound("shitty/tap-resonant.wav")
			end
            self:SetText(ntxt)
        end
        self:SetContentAlignment(5)
    end
end

function PANEL:Close()
    curent_panel = nil
    if IsValid(self.panelparrent) then
        self.panelparrent:Remove()
        self.panelparrent = nil
    end
    
    self:Stop()
    self:SetAlpha(0)
    self:Remove()
    MainMenu = nil
    gui.EnableScreenClicker(false)
    self:SetKeyboardInputEnabled(false)
    self:SetMouseInputEnabled(false)
end

function PANEL:OnKeyCodePressed(keyCode)
    if keyCode ~= KEY_ESCAPE then return end
    self:Close()
    MainMenu = nil
end

vgui.Register( "ZMainMenu", PANEL, "ZFrame")

hook.Add("OnPauseMenuShow","OpenMainMenu",function()
    if IsValid(zpan) then
        zpan:Close()
        zpan = nil
        return false
    end

    if hg and IsValid(hg.StandaloneEscPanel) then
        hg.StandaloneEscPanel:Remove()
        hg.StandaloneEscPanel = nil
        return false
    end

    local run = hook.Run("OnShowZCityPause")
    if run != nil then
        return run
    end

    if MainMenu and IsValid(MainMenu) then
        MainMenu:Close()
        MainMenu = nil
        return false
    end

    MainMenu = vgui.Create("ZMainMenu")
    MainMenu:MakePopup()
    MainMenu:SetMouseInputEnabled(true)
    MainMenu:SetKeyboardInputEnabled(true)
    gui.EnableScreenClicker(true)
    return false
end)
