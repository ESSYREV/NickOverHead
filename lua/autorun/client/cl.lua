timer.Create( "removeRagdolls", 3, 0, function() game.RemoveRagdolls() end )

local hide = {
   [""] = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
    if hide[name] then  return false    end
end)

hook.Add("HUDDrawTargetID", "HidePlayerInfo", function()
    return false
end)

hook.Remove("PlayerBindPress","webbrowser")

local teamColors = {}
local red = Color(205, 92, 92)
local blue = Color(102, 205, 170)
local White = Color(255,255,255)
local Black = Color(32,32,32,204)

local drawText = draw.DrawText
local drawLine = draw.RoundedBoxEx

surface.CreateFont("RankOverHead", { font = "Arial", size = 155, weight = 1200,outline = true })
surface.CreateFont("MRankOverHead", { font = "Arial", size = 105, weight = 1200,outline = true })

function drawOverHead()

    local me = LocalPlayer()
    local ply = player.GetAll()

    for i=1,#ply do
        local ply = ply[i]

        if ply:GetPos():Distance( me:GetPos() ) > 1000 or !ply:Alive() or ply == me or ply:GetNWBool("ULX.Spectate") then continue end

        local angle = (me:GetPos() - ply:GetPos()):Angle() or me:EyeAngles()
        local color = team.GetColor(ply:Team())
        local nick = ply:Nick()
        local mode = ply:GetNWBool("_Kyle_Buildmode")
        if mode then mode = {" [ BUILD ] ",blue} else mode = {" [ PVP ] | HP: "..ply:Health(),red} end

        local pos = nil

        if ( ply:Crouching() ) then pos = ply:GetPos() + Vector(0,0,55) else pos = ply:GetPos() + Vector(0,0,80) end
        cam.Start3D2D(pos,Angle(0,angle[2] + 90,90),0.05)

            surface.SetFont( "RankOverHead" )
            local width = surface.GetTextSize( nick ) * 1.25
            if mode[2] == red then
                width = math.max( 750, width )
            else
               width = math.max( 400, width )
            end

            drawLine(4,-width/2,-118,width,230,Black, true, true, true, true)
            drawText(mode[1],"MRankOverHead",0,-125,mode[2],TEXT_ALIGN_CENTER)
            drawText(nick,"RankOverHead",0,-40,White,TEXT_ALIGN_CENTER)
            drawLine(4,-width/2,100,width,15,color, false, false, false, false)

        cam.End3D2D()

    end
end

hook.Add( "PostDrawOpaqueRenderables", "RankOverHead", drawOverHead)



surface.CreateFont("TabFontDef", { font = "BudgetLabel", size = 20, weight = 256 })
surface.CreateFont("HudFontDef", { font = "BudgetLabel", size = 22, weight = 256 })


    local H = ScrH() -- Высота
    local W = ScrW() -- Ширина

        local snick   = H/2.75
        local sgroup  = H/3.5
        local sfrags  = H/9
        local sdeaths = H/9
        local sping   = H/9
        local srep   =  H/7.5
        local Size = 10 + snick + sgroup + sfrags + sdeaths + sping

    local yCenter = H/2 - Size / 2.5
    local xCenter = W/2 - Size / 2

    local leftSize = W/6 + 12.5
    local lgoto    = H/10
    local lbring   = H/10.25
    local lmute    = H/10


local function rscoreboardshow(pl)
	local ent = pl
    local ply = pl:Nick()

    rTab = vgui.Create("DFrame")
	rTab:SetSize(leftSize, 200)	    rTab:SetPos(xCenter + Size + 15,yCenter)
    rTab:SetTitle("")        	            rTab:MakePopup()
	rTab:SetDraggable(false) 	            rTab:ShowCloseButton(false)
    rTab.Paint = function( self, w, h )     rTab:SetBackgroundBlur( true )
    draw.RoundedBox( 0, 0, 0, w, 25, Color( 100, 100, 100, 255 ))
    draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 200 ))
    draw.DrawText("ОКНО ВЗАИМОДЕЙСТВИЯ","TabFontDef",rTab:GetSize()/2,0,Color(255,255,255),TEXT_ALIGN_CENTER) end

	local Scroll = vgui.Create( "DScrollPanel", rTab )
	Scroll:Dock( FILL )
    local sbar = Scroll:GetVBar(); sbar:SetWide(10)
	local List = vgui.Create( "DIconLayout", Scroll )
	List:Dock( FILL ) List:SetSpaceY( 5 ) List:SetSpaceX( 15 )

    local function TabMenuAdd(text)
        rTabMenu = List:Add("DButton")
        rTabMenu:SetSize(W/6,25)
        rTabMenu:SetTextColor(Color(0,0,0,0))
        rTabMenu.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,175))
            draw.DrawText(text,"TabFontDef",W/6/2,0,Color(255,255,255),TEXT_ALIGN_CENTER)
        end
    end

    TabMenuAdd("ОТКРЫТЬ ПРОФИЛЬ")
    rTabMenu.DoClick = function() pl:ShowProfile() end

    TabMenuAdd("МУТ ИГРОКА")
    rTabMenu.DoClick = function()
    local white = Color(255,255,255)
    local orange = Color(255,165,0)
    local blue = Color(65,105,225)
    local muted = pl:IsMuted()
    pl:SetMuted(not muted)
    chat.AddText(orange,"| ",white," Статус мута игрока ",blue,ply,white,": ",pl:IsMuted())

    end

    TabMenuAdd("ТЕЛЕПОРТИРОВАТЬСЯ")
    rTabMenu.DoClick = function()  RunConsoleCommand("ulx","goto",ply) end

    TabMenuAdd("ТЕЛЕПОРТИРОВАТЬ")
    rTabMenu.DoClick = function()  RunConsoleCommand("ulx","bring",ply) end

    TabMenuAdd("ВЕРНУТЬ")
    rTabMenu.DoClick = function()  RunConsoleCommand("ulx","return",ply) end

    TabMenuAdd("ЗАМОРОЗИТЬ")
    rTabMenu.DoClick = function()  RunConsoleCommand("ulx","freeze",ply) end

    TabMenuAdd("РАЗМОРОЗИТЬ")
    rTabMenu.DoClick = function()  RunConsoleCommand("ulx","unfreeze",ply) end

    TabMenuAdd("СДЕЛАТЬ ТИШЕ")
    rTabMenu.DoClick = function() 
        local vol = ent:GetVoiceVolumeScale()
        vol = math.Clamp(vol - 0.1,0,1)
        vol = vol - vol%0.1
        ent:SetVoiceVolumeScale( vol )
        chat.AddText("| Громкость игрока ",ply,": ",vol)
    end

    TabMenuAdd("СДЕЛАТЬ ГРОМЧЕ")
    rTabMenu.DoClick = function() 
        local vol = ent:GetVoiceVolumeScale()
        vol = math.Clamp(vol + 0.1,0,1.5)
        vol = vol - vol%0.1
        ent:SetVoiceVolumeScale( vol )
        chat.AddText("| Громкость игрока ",ply,": ",vol)
    end

end

local function scoreboardshow()
    local ply = player.GetAll()
    local formula = player.GetCount() * 30 + 75
    if formula > ScrW()/2 then formula = ScrW()/2 end
    Tab = vgui.Create("DFrame")
	Tab:SetSize(Size, formula)	Tab:SetPos(xCenter,yCenter)
    Tab:SetTitle("")        	Tab:MakePopup()
	Tab:SetDraggable(false) 	Tab:ShowCloseButton(false)
    Tab.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, 25, Color( 100, 100, 100, 255 ))
    draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 200 ))
    draw.DrawText(GetHostName(),"TabFontDef",Tab:GetSize()/2,0,Color(255,255,255),TEXT_ALIGN_CENTER) end

	local Scroll = vgui.Create( "DScrollPanel", Tab )
	Scroll:Dock( FILL )
    local sbar = Scroll:GetVBar(); sbar:SetWide(0)
	local List = vgui.Create( "DIconLayout", Scroll )
	List:Dock( FILL ) List:SetSpaceY( 5 ) List:SetSpaceX( 0 )

        local function TabMenuAdd(text,size,pos,align)
            if align == 0 then align = TEXT_ALIGN_LEFT else align = TEXT_ALIGN_CENTER end
            if pos == 0 then pos = 0 else pos = size / 2 end
            local PlayerTab = List:Add("DLabel")
            PlayerTab:SetSize(size,25)
            PlayerTab:SetTextColor(Color(0,0,0,0))
            PlayerTab.Paint = function( self, w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,175))
                draw.DrawText(text,"TabFontDef",pos,0,Color(30,144,255),align) end
        end

            TabMenuAdd("NICKNAME"   ,snick,0,0       )
            TabMenuAdd("USER GROUP"  ,sgroup,1,1  )
            TabMenuAdd("FRAGS"  ,sfrags,1,1  )
            TabMenuAdd("DEATHS" ,sdeaths,1,1 )
            TabMenuAdd("PING"   ,sping,1,1   )

    for N=1,#ply do

        local function TabMenuAdd(text,size,pos,align)
            if align == nil then align = TEXT_ALIGN_LEFT else align = TEXT_ALIGN_CENTER end
            if pos == nil then pos = 0 else pos = size / 2 end
            local PlayerTab = List:Add("DButton")
            PlayerTab:SetSize(size,25)
            PlayerTab:SetTextColor(Color(0,0,0,0))
            PlayerTab.Paint = function( self, w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,175))
                draw.DrawText(text,"TabFontDef",pos,0,Color(255,255,255),align) end
            PlayerTab.DoClick = function()
                if IsValid(rTab) then rTab:Remove() end
                if IsValid(rTabt) then rTabt:Remove() end
                rscoreboardshow(ply[N]) end
        end

        local nick   = ply[N]:Nick()
        --local group  = ply[N]:GetNWString("Teg", nil)
        local frags  = ply[N]:Frags()
        local deaths = ply[N]:Deaths()
        local ping   = ply[N]:Ping()
        --local rep    = ply[N]:GetNWFloat("Reputation")
        --if ply[N]:GetNWString("Teg", nil) == "" then group = ply[N]:GetUserGroup() end
		local group = team.GetName(ply[N]:Team())
        TabMenuAdd(nick   ,snick       )
        TabMenuAdd(group  ,sgroup,1,1  )
        TabMenuAdd(frags  ,sfrags,1,1  )
        TabMenuAdd(deaths ,sdeaths,1,1 )
        TabMenuAdd(ping   ,sping,1,1   )
        --TabMenuAdd(rep   ,srep   )

    end


end


local function scoreboardhide()
    Tab:Remove()
    if IsValid(rTab) then rTab:Remove() end
    if IsValid(rTabt) then rTabt:Remove() end
    return true
end

hook.Add("ScoreboardHide", "ScoreboardHide", function()
    scoreboardhide()
end)

hook.Add("ScoreboardShow", "ScoreboardShow", function()
    scoreboardshow()
    return false
end)

-- Привет от Essyrev <3

local tbl = {
    "Дискорд сервера: https://discord.gg/K5N78qPKBU",
    "Коллекция сервера: https://steamcommunity.com/sharedfiles/filedetails/?id=2744817226",
    "Группа сервера в Steam: https://steamcommunity.com/groups/BeastSandbox",
}

chat.AddText(tbl[#tbl])

local line = 1
timer.Create("advertsTimer",300,0,function()
    line = line + 1
    if line > #tbl then line = 1 end

    chat.AddText(tbl[line])
end)



