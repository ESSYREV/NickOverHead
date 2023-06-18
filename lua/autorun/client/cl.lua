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
